//
//  XHWLSafeGuardVC.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/11.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit
import ELPickerView

class XHWLSafeGuardVC: XHWLBaseVC {
    
    var warningView:XHWLSafeGuardView!
    var isAddPicture:Bool!
    var isFinished:Bool!
    var model:XHWLSafeProtectionModel! // 单号
    var backReloadBlock:()->(Void) = {param in }
    
    var actionArr:NSArray!
    var selectIndex:NSInteger! = 0
    var imageArray:NSMutableArray! = NSMutableArray()
    lazy var customPickerView: ELCustomPickerView<String> = {
        let pickerV = ELCustomPickerView<String>(pickerType: .singleComponent, items: [])
        
        pickerV.rightButton.setTitle("确定", for: .normal)
        pickerV.leftButton.setTitle("取消", for: .normal)
        pickerV.title.text = "分配给"
        pickerV.foregroundView.picker.backgroundColor = UIColor.white
        pickerV.rightButton.setTitleColor(UIColor.black, for: .normal)
        pickerV.leftButton.setTitleColor(UIColor.black, for: .normal)
        
        return pickerV
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        setupView()
        
        self.title = "安防事件详情"
        let baoBar = UIBarButtonItem.init(image: UIImage(named:"CloudEyes_picture"), style: .plain, target: self, action: #selector(onBaoClick))
        let devideBar = UIBarButtonItem.init(image: UIImage(named:"IssueReport_manager"), style: .plain, target: self, action: #selector(onDevideClick))
        self.navigationItem.rightBarButtonItems = [devideBar, baoBar]
    }
    
    // 报
    func onBaoClick() {
        
    }
    
    // 分配
    func onDevideClick() {
        customPickerView.items = ["黄浩婷", "张浩然", "徐柳飞", "阳城"]
        customPickerView.show(viewController: nil, animated: true)
        
        // 确定
        customPickerView.rightButtoTapHandler = { [weak self] (view, chosenIndex, chosenItem) in
            let hide = true
            let animated = true
            let str = "Did Tap Left Button. <Index: \(chosenIndex)> <chosenItem: \(chosenItem)> <Hide: \(hide)> <Animated: \(animated)>"
            //            self?.logLabel.text = str
            print(str)
            return (hide, animated)
        }
        // 取消
        customPickerView.leftButtoTapHandler = { [weak self] (view, chosenIndex, chosenItem) in
            let hide = true
            let animated = true
            let str = "Did Tap Left Button. <Index: \(chosenIndex)> <chosenItem: \(chosenItem)> <Hide: \(hide)> <Animated: \(animated)>"
            //            self?.logLabel.text = str
            print(str)
            return (hide, animated)
        }
    }
 
    func setupView() {

        warningView = XHWLSafeGuardView(frame:CGRect.zero, isFinished, model)
//        warningView.delegate = self
        warningView.bounds = CGRect(x:0, y:0, width:Screen_width*13/16.0, height:Screen_height*2/3.0)
        warningView.center = CGPoint(x:self.view.frame.size.width/2.0, y:self.view.frame.size.height/2.0)
//        warningView.submitBlock = { [weak self] text in
//            self?.submitClick(text)
//        }
        self.view.addSubview(warningView)
    }
    
    func submitClick(_ mark:String) {
        
        let imageDataAry = NSMutableArray()
        let imageNameAry = NSMutableArray()
        if imageArray.count > 0 {
            for i in 0..<imageArray.count {
                let imageData:Data = UIImageJPEGRepresentation(imageArray[i] as! UIImage, 0.5)!
//                let imageData:Data = UIImagePNGRepresentation(imageArray[i] as! UIImage)
                imageDataAry.add(imageData)
                
                imageNameAry.add("image_\(String(Date.getCurrentStamp())).png")
            }
        }
        else {
            "请上传图片".ext_debugPrintAndHint()
            return
        }
        
        let data:NSData = UserDefaults.standard.object(forKey: "user") as! NSData
        let dict:NSDictionary = data.mj_JSONObject() as! NSDictionary
        let userModel:XHWLUserModel = XHWLUserModel.mj_object(withKeyValues: dict)
        
        let param = ["token": userModel.wyAccount.token,
                     "manageRemarks": mark, // 否	处理备注
                    "code": model.appComplaint.code] // 是	工单号
        
        XHWLNetwork.shared.updateSafeGuardSubmitClick(param as NSDictionary, imageDataAry as! [Data], imageNameAry as! [String], self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK: - XHWLSafeGuardViewDelegate
extension XHWLSafeGuardVC: XHWLSafeGuardViewDelegate {
    
    func onSafeGuard(_ isAdd:Bool, _ index:NSInteger, _ isPictureAdd:Bool) {
        
        isAddPicture = isAdd
        selectIndex = index
        
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
}

// MARK: - UIImagePickerControllerDelegate
//extension XHWLSafeGuardVC: UIImagePickerControllerDelegate {
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        //查看info对象
//        print(info)
//        //获取选择的原图
//        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
//        //            imageView.image = image
//        if isAddPicture {
//            warningView.pickPhoto.onCreateImgView(image)
//            imageArray.add(image)
//        } else {
//            warningView.pickPhoto.onChangePicture(image)
//            imageArray[selectIndex] = image
//        }
//
//        //图片控制器退出
//        picker.dismiss(animated: true, completion: nil)
//    }
//}

// MARK: - XHWLNetworkDelegate

extension XHWLSafeGuardVC: XHWLNetworkDelegate {

    func requestSuccess(_ requestKey:NSInteger, _ response:[String : AnyObject]) {
        
        if requestKey == XHWLRequestKeyID.XHWL_SAFEGUARDSUBMIT.rawValue {
            
            self.backReloadBlock()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func requestFail(_ requestKey:NSInteger, _ error:NSError) {
        
    }
}

// MARK: - HZActionSheetDelegate
extension XHWLSafeGuardVC: HZActionSheetDelegate {

    func sheet(_ actionSheet: HZActionSheet!, click buttonIndex: Int) {
        if ((actionArr != nil) && buttonIndex >= actionArr.count) {
            
            return;
        }
        
        let string:String = actionArr[buttonIndex] as! String
        print("\(string)")
        
        if (buttonIndex == 0) {// @"退回"
            
//            openAlbum()
        } else if (buttonIndex == 1){ // "删除
            
//            openCamera()
        }
    }
    
    
    
    // 打开相机
    //    func openCamera() {
    //        //判断设置是否支持图片库
    //        if UIImagePickerController.isSourceTypeAvailable(.camera){
    //            //初始化图片控制器
    //            let picker = UIImagePickerController()
    //            //设置代理
    //            picker.delegate = self
    //            //指定图片控制器类型
    //            picker.sourceType = UIImagePickerControllerSourceType.camera
    //            //设置是否允许编辑
    //            //            picker.allowsEditing = editSwitch.on
    //            //弹出控制器，显示界面
    //            self.present(picker, animated: true, completion: nil)
    //        }else{
    //            print("读取相册错误")
    //        }
    //    }
    
    //打开相册
    //    func openAlbum(){
    //        //判断设置是否支持图片库
    //        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
    //            //初始化图片控制器
    //            let picker = UIImagePickerController()
    //            //设置代理
    //            picker.delegate = self
    //            //指定图片控制器类型
    //            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
    //            //设置是否允许编辑
    //            //            picker.allowsEditing = editSwitch.on
    //            //弹出控制器，显示界面
    //            self.present(picker, animated: true, completion: nil)
    //        }else{
    //            print("读取相册错误")
    //        }
    //    }
}







