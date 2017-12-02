//
//  XHWLIssueReportVC.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/11.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLIssueReportVC: XHWLBaseVC {
    
    var isAddPicture:Bool!
    var warningView:XHWLIssueReportView!
    var actionArr:NSArray!
    var scanModel:XHWLScanModel!
    var selectIndex:NSInteger! = 0
    var isVideo:Bool = false
//    var imageArray:NSMutableArray! = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        self.title = "报事"
        setupView()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        XHWLTipView.shared.remove()
    }
    
    func setupView() {

        warningView = XHWLIssueReportView()
        warningView.scanModel = scanModel
        warningView.bounds = CGRect(x:0, y:0, width:Screen_width*13/16.0, height:Screen_height*2/3.0)
        warningView.center = CGPoint(x:self.view.frame.size.width/2.0, y:self.view.frame.size.height/2.0)
        warningView.delegate = self
//        warningView.imageArray = imageArray
        warningView.dismissBlock = { _ in
            self.navigationController?.popViewController(animated: true)
        }
        warningView.btnBlock = {type, inspectionPoint, remarks, urgency, isManager in
            
            if isManager {
                self.onManagerReport(type, inspectionPoint, remarks, urgency)
                
            } else {
                self.onIssueReport(type, inspectionPoint, remarks, urgency)
            }
        }
        self.view.addSubview(warningView)
    }
    
    // 报事
    func onManagerReport(_ type:NSInteger, _ inspectionPoint:String, _ remarks:String, _ urgency:Bool) {
        
        self.warningView.isUserInteractionEnabled = false
        
        if  inspectionPoint.isEmpty {
            "巡检定点为空".ext_debugPrintAndHint()
            return
        }
        
        var imageStr = ""
        var videoStr = ""
        if warningView.imageArray.count > 0 {
            if isVideo {
                videoStr = warningView.imageArray.componentsJoined(by: ",")
            } else {
                imageStr = warningView.imageArray.componentsJoined(by: ",")
            }
        }
        else {
            "请上传图片或视频".ext_debugPrintAndHint()
            return
        }
        
//        var code:String = ""
//        if scanModel.type == "plant" {
//            let scanDataModel:XHWLScanDataModel = scanModel.plant
//            code = scanDataModel.code
//        } else if scanModel.type == "equipment" {
//            let scanDataModel:XHWLScanDataModel = scanModel.equipment
//            code = scanDataModel.code
//        }
        
        guard let projectData:NSData = UserDefaults.standard.object(forKey: "project") as? NSData else {
            
            "当前无项目".ext_debugPrintAndHint()
            return
        }
        let projectModel:XHWLProjectModel = XHWLProjectModel.mj_object(withKeyValues: projectData.mj_JSONObject())
        
        let data:NSData = UserDefaults.standard.object(forKey: "user") as! NSData
        let userModel:XHWLUserModel = XHWLUserModel.mj_object(withKeyValues: data.mj_JSONObject())
        
        let params:[String: Any] = [
            "token":userModel.wyAccount.token,
            "type":type, // 异常类型，1：安防，2：工程，3：环境，4：客服，5：业主
            "urgency":urgency, // 是否紧急
            "origin" : 2, // 1：小七当家，2：小七专家，3：优你家app,4:巡更app，5：云对讲
            "projectCode":projectModel.projectCode, // 项目编号
            "address":inspectionPoint, // 案发地址
            "image":imageStr, //图片路径; 与视频video二选一
            "video":videoStr, //视频路径； 与图片image二选一
            "wyAccount.id":userModel.wyAccount.id, // 否    物业账号id
            "remarks":remarks // 否    备注
        ]

        XHWLNetwork.shared.postAddWarningClick(params as NSDictionary, self)
    }
    
    // 报事
    func onIssueReport(_ type:NSInteger, _ inspectionPoint:String, _ remarks:String, _ urgency:Bool) {
        
//        接口备注：报事。涉及到文件图片上传，故提交数据时必须使用form表单提交
//        type	string	是	异常类型
//        inspectionPoint	string	是	巡检定点
//        urgency	string	是	紧急情况
//        equipmentCode	string	否	报事的设备编号
//        remarks	string	否	备注
//        token	string	是	用户登录token
        self.warningView.isUserInteractionEnabled = false
        
        
//        if type.isEmpty {
//            "异常类型为空".ext_debugPrintAndHint()
//            return
//        }
        
        if  inspectionPoint.isEmpty {
            "巡检定点为空".ext_debugPrintAndHint()
            return
        }
        
        let imageDataAry = NSMutableArray()
        let imageNameAry = NSMutableArray()
        if warningView.imageArray.count > 0 {
            for i in 0..<warningView.imageArray.count {
                let imageData:Data = UIImageJPEGRepresentation(warningView.imageArray[i] as! UIImage, 0.5)! // UIImagePNGRepresentation(imageArray[i] as! UIImage)! //
                imageDataAry.add(imageData)
                imageNameAry.add("image_\(i)\(String(Date.getCurrentStamp())).png")
            }
        }
         else {
            "请上传图片".ext_debugPrintAndHint()
            return
        }
        
        var code:String = ""
        if scanModel.type == "plant" {
            let scanDataModel:XHWLScanDataModel = scanModel.plant
            code = scanDataModel.code
        } else if scanModel.type == "equipment" {
            let scanDataModel:XHWLScanDataModel = scanModel.equipment
            code = scanDataModel.code
        }
        
        
        let data:NSData = UserDefaults.standard.object(forKey: "user") as! NSData
        let userModel:XHWLUserModel = XHWLUserModel.mj_object(withKeyValues: data.mj_JSONObject())
        let params:[String: String] = ["type":"\(type)",
                                       "inspectionPoint":inspectionPoint,
                                       "urgency":"\(urgency)",
                                       "equipmentCode":code,
                                       "remarks":remarks,
                                       "token":userModel.wyAccount.token]
        
        XHWLNetwork.shared.uploadImageClick(params as NSDictionary, imageDataAry as! [Data], imageNameAry as! [String], self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension XHWLIssueReportVC: XHWLIssueReportViewDelegate {
    func onSafeGuard(_ index:NSInteger, _ count:NSInteger) {
        
        print(" \(index) \(count)")
        selectIndex = index
        
        if index != -1 { // 删除某张图
            warningView.imageArray.removeObject(at: index)
        } else {
            if count == 0 {
                actionArr = ["相册", "拍照", "小视频"]
            } else {
                actionArr = ["相册", "拍照"]
            }
            
            let sheet:HZActionSheet = HZActionSheet.init(title: nil,
                                                         delegate: self,
                                                         cancelButtonTitle: "取消",
                                                         destructiveButtonIndexSet: nil,
                                                         otherButtonTitles: actionArr as! [Any]!)
            sheet.titleColor = UIColor.black
            sheet.show(in: self.view)
        }
    }
}

extension XHWLIssueReportVC: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        //查看info对象
        print(info)
        //获取选择的原图
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let imageData:Data = UIImageJPEGRepresentation(image, 0.5)!
        print("\(imageData)")
        // 上传到后台， 返回url
        XHWLNetwork.shared.uploadFileUploadClick(isVideo, [imageData as Data], self)
        
        //图片控制器退出
        picker.dismiss(animated: true, completion: nil)
    }
    
    func uploadShowImage(_ url:String) {
        warningView.pickPhoto.onCreateImgView(url, isVideo)
        warningView.imageArray.add(url)
    }
}

extension XHWLIssueReportVC: XHWLNetworkDelegate {
    
    
    // MARK: - XHWLNetworkDelegate
    
    func requestSuccess(_ requestKey:NSInteger, _ response:[String : AnyObject]) {
        
        if requestKey == XHWLRequestKeyID.XHWL_FILEUPLOAD.rawValue {
            if (response["errorCode"] as! NSInteger) == 200 {
                uploadShowImage(response["result"] as! String)
            }
        } else {
            self.view.isUserInteractionEnabled = true
            //            self.progressHUD.hide()
            if response["state"] as! Bool{
                self.warningView.isHidden = true
                XHWLTipView.shared.showSuccess("报事提交成功", {
                    let vc:UIViewController = (self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)!-4])!
                    self.navigationController?.popToViewController(vc, animated: true)
                    self.warningView.isUserInteractionEnabled = true
                } )
                
            } else {
                
                self.warningView.isHidden = true
                XHWLTipView.shared.showError("报事提交失败，请重新填写！", {
                    
                    self.warningView.isHidden = false
                    self.warningView.isUserInteractionEnabled = true
                })
                //登录失败
                switch(response["errorCode"] as! Int){
                case 11:
                    "用户名不存在".ext_debugPrintAndHint()
                    break
                default:
                    
                    let msg:String = response["message"] as! String
                    msg.ext_debugPrintAndHint()
                    break
                }
                
            }
        }
    }
    
    func requestFail(_ requestKey:NSInteger, _ error:NSError) {
        self.view.isUserInteractionEnabled = true
    }
}

extension XHWLIssueReportVC: XHWLMicroVideoVCDelegate {
    
    func touchUpDone(_ image: UIImage!, data: Data!) {
        // 上传到后台， 返回url
        XHWLNetwork.shared.uploadFileUploadClick(isVideo, [data as Data], self)
    }
}

extension XHWLIssueReportVC: UIActionSheetDelegate {
    // pragma mark  ActionSheetDelegate
    func sheet(_ actionSheet: HZActionSheet!, click buttonIndex: Int) {
        if ((actionArr != nil) && buttonIndex >= actionArr.count) {
            
            return;
        }
        
        let string:String = actionArr[buttonIndex] as! String
        print("\(string)")
        
        if buttonIndex == 0 {// @"退回"
            isVideo = false
            openAlbum()
        } else if buttonIndex == 1 { // "删除
            isVideo = false
            openCamera()
        } else if buttonIndex == 2 {
            isVideo = true
            let vc:XHWLMicroVideoVC = XHWLMicroVideoVC()
            vc.delegate = self
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    // 打开相机
    func openCamera() {
        //判断设置是否支持图片库
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            //初始化图片控制器
            let picker = UIImagePickerController()
            //设置代理
            picker.delegate = self
            //指定图片控制器类型
            picker.sourceType = UIImagePickerControllerSourceType.camera
            //设置是否允许编辑
            //            picker.allowsEditing = editSwitch.on
            //弹出控制器，显示界面
            self.present(picker, animated: true, completion: nil)
        }else{
            print("找不到相机")
        }
    }
    
    //打开相册
    func openAlbum(){
        //判断设置是否支持图片库
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            //初始化图片控制器
            let picker = UIImagePickerController()
            //设置代理
            picker.delegate = self
            //指定图片控制器类型
            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            //设置是否允许编辑
            //            picker.allowsEditing = editSwitch.on
            //弹出控制器，显示界面
            self.present(picker, animated: true, completion: nil)
        }else{
            print("读取相册错误")
        }
    }
    
}

extension XHWLIssueReportVC: HZActionSheetDelegate {
   
}



