//
//  XHWLIssueReportVC.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/11.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

//@nonobjc(HZActionSheetDelegate)
class XHWLIssueReportVC: UIViewController,  XHWLIssueReportViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, XHWLNetworkDelegate, UIActionSheetDelegate, HZActionSheetDelegate {
    
    var bgImg:UIImageView!
    var isAddPicture:Bool!
    var warningView:XHWLIssueReportView!
    var actionArr:NSArray!
    var scanModel:XHWLScanModel!
    var selectIndex:NSInteger! = 0
    var isPictureAdd:Bool! = true
    var imageArray:NSMutableArray! = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        setupView()
        
        self.title = "报事"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"scan_back"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(onBack))
        
        let data:NSData = UserDefaults.standard.object(forKey: "user") as! NSData
        let userModel:XHWLUserModel = XHWLUserModel.mj_object(withKeyValues: data.mj_JSONObject())
        // 安管主任拥有权限
        if userModel.wyAccount.wyRole.name.compare("安管主任").rawValue == 0 ||
            userModel.wyAccount.wyRole.name.compare("门岗").rawValue == 0 {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "记录", style: UIBarButtonItemStyle.plain, target: self, action: #selector(onIssueReportList))
        }
    }
    
    // 
    func onIssueReportList() {
//        let vc:XHWLIssueReportListVC = XHWLIssueReportListVC()
//        self.navigationController?.pushViewController(vc, animated: true)
        
        let vc:XHWLSafeProtectionVC = XHWLSafeProtectionVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        XHWLTipView.shared.remove()
    }
    
    func onBack(){
//        self.navigationController?.popViewController(animated: true)
        
        let vc:UIViewController = (self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)!-3])!
        self.navigationController?.popToViewController(vc, animated: true)
    }
    
    func setupView() {
        
        bgImg = UIImageView()
        bgImg.frame = self.view.bounds
        bgImg.image = UIImage(named:"home_bg")
        self.view.addSubview(bgImg)
        
        warningView = XHWLIssueReportView()
        warningView.scanModel = scanModel
        warningView.bounds = CGRect(x:0, y:0, width:Screen_width*13/16.0, height:Screen_height*2/3.0)
        warningView.center = CGPoint(x:self.view.frame.size.width/2.0, y:self.view.frame.size.height/2.0)
        warningView.delegate = self
        warningView.dismissBlock = { _ in
            self.navigationController?.popViewController(animated: true)
        }
        warningView.btnBlock = {type, inspectionPoint, remarks, urgency in
             self.onIssueReport(type, inspectionPoint, remarks, urgency)
        }
        self.view.addSubview(warningView)
    }
    
    // 报事
    func onIssueReport(_ type:String, _ inspectionPoint:String, _ remarks:String, _ urgency:String) {
        
//        接口备注：报事。涉及到文件图片上传，故提交数据时必须使用form表单提交
//        type	string	是	异常类型
//        inspectionPoint	string	是	巡检定点
//        urgency	string	是	紧急情况
//        equipmentCode	string	否	报事的设备编号
//        remarks	string	否	备注
//        token	string	是	用户登录token
        
        if type.isEmpty {
            "异常类型为空".ext_debugPrintAndHint()
            return
        }
        
        if  inspectionPoint.isEmpty {
            "巡检定点为空".ext_debugPrintAndHint()
            return
        }
        
        let imageDataAry = NSMutableArray()
        let imageNameAry = NSMutableArray()
        if imageArray.count > 0 {
            for i in 0..<imageArray.count {
                let imageData:Data = UIImagePNGRepresentation(imageArray[i] as! UIImage)! // UIImageJPEGRepresentation(imageArray[i] as! UIImage, 0.5)!
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
        let params:[String: String] = ["type":type,
                                       "inspectionPoint":inspectionPoint,
                                       "urgency":urgency,
                                       "equipmentCode":code,
                                       "remarks":remarks,
                                       "token":userModel.wyAccount.token]
        
        XHWLNetwork.shared.uploadImageClick(params as NSDictionary, imageDataAry as! [Data], imageNameAry as! [String], self)
    }
    
    
    // MARK: - XHWLNetworkDelegate
    
    func requestSuccess(_ requestKey:NSInteger, _ response:[String : AnyObject]) {
        
        //            self.progressHUD.hide()
        if response["state"] as! Bool{
            
            self.warningView.isHidden = true
            XHWLTipView.shared.showSuccess("报事提交成功")
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + TimeInterval(1.9)){
                let vc:UIViewController = (self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)!-4])!
                self.navigationController?.popToViewController(vc, animated: true)
            }
        } else {
            
            self.warningView.isHidden = true
            XHWLTipView.shared.showError("报事提交失败，请重新填写！")
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + TimeInterval(1.9)){
                XHWLTipView.shared.remove()
                self.warningView.isHidden = false
            }
            
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
    
    func requestFail(_ requestKey:NSInteger, _ error:NSError) {
        
    }

    func onSafeGuard(_ isAdd:Bool, _ index:NSInteger, _ isPictureAdd:Bool)
    {
        isAddPicture = isAdd
        selectIndex = index
        self.isPictureAdd = isPictureAdd
        
        if !isAdd && !isPictureAdd { // 删除某张图
            imageArray.removeObject(at: index)
        } else {
            actionArr = ["相册", "拍照"]
            let sheet:HZActionSheet = HZActionSheet.init(title: nil,
                                                         delegate: self,
                                                         cancelButtonTitle: "取消",
                                                         destructiveButtonIndexSet: nil,
                                                         otherButtonTitles: actionArr as! [Any]!)
            sheet.titleColor = UIColor.black
            sheet.show(in: self.view)
        }
    }

    
    
    // pragma mark  ActionSheetDelegate
    func sheet(_ actionSheet: HZActionSheet!, click buttonIndex: Int) {
        if ((actionArr != nil) && buttonIndex >= actionArr.count) {
            
            return;
        }
        
        let string:String = actionArr[buttonIndex] as! String
        print("\(string)")
        
        if (buttonIndex == 0) {
            
            openAlbum()
        } else if (buttonIndex == 1){
            
            openCarme()
        }
    }
    
    // 打开相机
    func openCarme() {
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
            print("读取相册错误")
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
    
    func openCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            
            //创建图片控制器
            let picker = UIImagePickerController()
            //设置代理
            picker.delegate = self
            //设置来源
            picker.sourceType = UIImagePickerControllerSourceType.camera
            //允许编辑
            picker.allowsEditing = true
            //打开相机
            self.present(picker, animated: true, completion: nil)
        }else{
            print("找不到相机")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        //查看info对象
        print(info)
        //获取选择的原图
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        //            imageView.image = image
        if isAddPicture {
            warningView.pickPhoto.onCreateImgView(image)
            imageArray.add(image)
        } else {
            warningView.pickPhoto.onChangePicture(image)
            imageArray[selectIndex] = image
        }
//        let type:String = (info[UIImagePickerControllerMediaType]as!String)
//        let imgData = UIImageJPEGRepresentation(self.headImg.image!,0.5)
        
        //图片控制器退出
        picker.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
