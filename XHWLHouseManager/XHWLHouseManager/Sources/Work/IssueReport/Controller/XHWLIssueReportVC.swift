//
//  XHWLIssueReportVC.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/11.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLIssueReportVC: UIViewController  , XHWLScanTestVCDelegate, XHWLIssueReportViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, XHWLNetworkDelegate {
    
    var bgImg:UIImageView!
    var isAddPicture:Bool!
    var warningView:XHWLIssueReportView!
    var scanModel:XHWLScanModel!
    var imageSel:UIImage!
    var imageSel2:UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        setupView()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"scan_back"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(onBack))
        
        let data:NSData = UserDefaults.standard.object(forKey: "user") as! NSData
        let userModel:XHWLUserModel = XHWLUserModel.mj_object(withKeyValues: data.mj_JSONObject())
        // 安管主任拥有权限
        if userModel.wyAccount.wyRole.name.compare("安管主任").rawValue == 0 {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "记录", style: UIBarButtonItemStyle.plain, target: self, action: #selector(onIssueReportList))
        }
    }
    
    // 
    func onIssueReportList() {
        let vc:XHWLIssueReportListVC = XHWLIssueReportListVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        XHWLTipView.shared.remove()
    }
    
    func onBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupView() {
        
        bgImg = UIImageView()
        bgImg.frame = self.view.bounds
        bgImg.image = UIImage(named:"home_bg")
        self.view.addSubview(bgImg)
        
        let showImg:UIImage = UIImage(named:"menu_bg")!
        warningView = XHWLIssueReportView()
        warningView.bounds = CGRect(x:0, y:0, width:showImg.size.width, height:showImg.size.height)
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
        
        let data:NSData = UserDefaults.standard.object(forKey: "user") as! NSData
        let userModel:XHWLUserModel = XHWLUserModel.mj_object(withKeyValues: data.mj_JSONObject())
        let params:[String: String] = ["type":type,
                                       "inspectionPoint":inspectionPoint,
                                       "urgency":urgency,
                                       "equipmentCode":scanModel.code,
                                       "remarks":remarks,
                                       "token":userModel.wyAccount.token]
        let url:String = "wyBusiness/complaint"
        
//        if topStr.isEmpty {
//            "您输入的工号为空".ext_debugPrintAndHint()
//            return
//        }
//        if bottomStr.isEmpty {
//            "您输入的密码为空".ext_debugPrintAndHint()
//            return
//        }
        
        //        self.progressHUD.show()
        let imageData:Data = UIImageJPEGRepresentation(imageSel, 0.5)!
        let imageData2:Data = UIImageJPEGRepresentation(imageSel2, 0.5)!
        
        XHWLNetwork.shared.uploadImageClick(params as NSDictionary, [imageData2], ["image3.png"], self)
    }
    
    
    // MARK: - XHWLNetworkDelegate
    
    func requestSuccess(_ requestKey:NSInteger, _ response:[String : AnyObject]) {
        
        //            self.progressHUD.hide()
        if response["state"] as! Bool{
            
            
            self.warningView.isHidden = true
            XHWLTipView.shared.showSuccess(successText: "报事提交成功")
            
            //  "登陆成功".ext_debugPrintAndHint()
            //登录成功
            /*      let wyUser:NSDictionary = response["result"]!["wyUser"] as! NSDictionary
             let projectList:NSArray = response["result"]!["projectList"] as! NSArray
             
             print("\(wyUser)")
             let userModel:XHWLUserModel = XHWLUserModel.mj_object(withKeyValues: wyUser)
             let data:NSData = userModel.mj_JSONData()! as NSData
             UserDefaults.standard.set(data, forKey: "user")
             
             //                let modelAry:NSArray = XHWLProjectModel.mj_objectArray(withKeyValuesArray: projectList)
             let modelData:NSData = projectList.mj_JSONData()! as NSData
             UserDefaults.standard.set(modelData, forKey: "projectList")
             UserDefaults.standard.synchronize()
             
             if userModel.wyAccount.isFirstLogin.compare("y").rawValue == 0 { // 重置密码
             //                    self.onLoginChangeReset()
             } else { // 跳到首页
             //                    self.delegate?.onGotoHome!(self)
             } */
        } else {
            XHWLTipView.shared.showSuccess(successText: "报事提交失败，请重新填写！")
            
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

    func onSafeGuard(_ isAdd:Bool)
    {
        isAddPicture = isAdd
        openAlbum()
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
    var i:NSInteger = 0
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        //查看info对象
        print(info)
        //获取选择的原图
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        //            imageView.image = image
        if isAddPicture {
            warningView.pickPhoto.onCreateImgView(image)
        } else {
            warningView.pickPhoto.onChangePicture(image)
        }
        
        if i%2 == 0 {
            imageSel2 = image
            i += 1
        } else {
            imageSel = image
            i += 1

        }
        
        //图片控制器退出
        picker.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
