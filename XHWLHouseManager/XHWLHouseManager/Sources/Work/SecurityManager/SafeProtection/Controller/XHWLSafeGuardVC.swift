//
//  XHWLSafeGuardVC.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/11.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLSafeGuardVC: XHWLBaseVC , XHWLScanTestVCDelegate, XHWLSafeGuardViewDelegate , UIImagePickerControllerDelegate, HZActionSheetDelegate, XHWLNetworkDelegate { // UINavigationControllerDelegate
    
//    var bgImg:UIImageView!
    var warningView:XHWLSafeGuardView!
    var isAddPicture:Bool!
    var isFinished:Bool!
    var model:XHWLSafeProtectionModel! // 单号
    var backReloadBlock:()->(Void) = {param in }
    
    var actionArr:NSArray!
    var selectIndex:NSInteger! = 0
    var imageArray:NSMutableArray! = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        setupView()
        
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"scan_back"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(onBack))
        self.title = "安防事件详情"
    }
    
//    func onBack(){
//        self.navigationController?.popViewController(animated: true)
//    }
    
    
    func setupView() {
        
//        bgImg = UIImageView()
//        bgImg.frame = self.view.bounds
//        bgImg.image = UIImage(named:"home_bg")
//        self.view.addSubview(bgImg)
        
        warningView = XHWLSafeGuardView(frame:CGRect.zero, isFinished, model)
        warningView.delegate = self
        warningView.bounds = CGRect(x:0, y:0, width:Screen_width*13/16.0, height:Screen_height*2/3.0)
        warningView.center = CGPoint(x:self.view.frame.size.width/2.0, y:self.view.frame.size.height/2.0)
        warningView.submitBlock = { [weak self] text in
            self?.submitClick(text)
        }
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
    
    // MARK: - XHWLNetworkDelegate
    
    func requestSuccess(_ requestKey:NSInteger, _ response:[String : AnyObject]) {
        
        if requestKey == XHWLRequestKeyID.XHWL_SAFEGUARDSUBMIT.rawValue {
            
            self.backReloadBlock()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func requestFail(_ requestKey:NSInteger, _ error:NSError) {
        
    }
    
    func onSafeGuard(_ isAdd:Bool, _ index:NSInteger, _ isPictureAdd:Bool)
    {
//        isAddPicture = isAdd
//        openAlbum()
        
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
    
    // pragma mark  ActionSheetDelegate
    func sheet(_ actionSheet: HZActionSheet!, click buttonIndex: Int) {
        if ((actionArr != nil) && buttonIndex >= actionArr.count) {
            
            return;
        }
        
        let string:String = actionArr[buttonIndex] as! String
        print("\(string)")
        
        if (buttonIndex == 0) {// @"退回"
            
            openAlbum()
        } else if (buttonIndex == 1){ // "删除
            
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
    
    //    func initImagePickerController()
    //    {
    //        self.imagePickerController = UIImagePickerController()
    //        self.imagePickerController.delegate = self
    //        // 设置是否可以管理已经存在的图片或者视频
    //        self.imagePickerController.allowsEditing = true
    //    }
    //
    //    func getImageFromPhotoLib(type:UIImagePickerControllerSourceType)
    //    {
    //        self.imagePickerController.sourceType = type
    //        //判断是否支持相册
    //        ifUIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
    //            self.present(self.imagePickerController, animated: true, completion:nil)
    //        }
    //    }
    //    [self getInstanceMethodList];
    //}
    //
    ////获取一个类的实例方法列表
    //- (void)getInstanceMethodList {
    //    unsigned int count;
    //    Method *methods = class_copyMethodList(NSClassFromString(@"HZActionSheet"), &count);
    //    for (int i =0; i < count; i++) {
    //        SEL name = method_getName(methods[i]);
    //
    //        NSLog(@"***实例方法名:%@",NSStringFromSelector(name));
    //        if ([NSStringFromSelector(name) isEqualToString:@"hideActionSheet"]) {
    //            [_sheet performSelector:name];
    //            break;
    //        }
    //    }
    //    free(methods);
    //    }
    
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
    
//    func openCamera(){
//        if UIImagePickerController.isSourceTypeAvailable(.camera){
//            
//            //创建图片控制器
//            let picker = UIImagePickerController()
//            //设置代理
//            picker.delegate = self
//            //设置来源
//            picker.sourceType = UIImagePickerControllerSourceType.camera
//            //允许编辑
//            picker.allowsEditing = true
//            //打开相机
//            self.present(picker, animated: true, completion: nil)
//        }else{
//            debugPrint("找不到相机")
//        }
//    }
//    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
//    {
//        //查看info对象
//        print(info)
//        //获取选择的原图
//        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
//        //            imageView.image = image
//        if isAddPicture {
//            warningView.pickPhoto.onCreateImgView(image)
//        } else {
//            warningView.pickPhoto.onChangePicture(image)
//        }
//        //图片控制器退出
//        picker.dismiss(animated: true, completion: nil)
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
