//
//  XHWLSafeGuardVC.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/11.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLSafeGuardVC: UIViewController  , XHWLScanTestVCDelegate, XHWLSafeGuardViewDelegate , UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    var bgImg:UIImageView!
    var warningView:XHWLSafeGuardView!
    var isAddPicture:Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        setupView()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"xhwl_back"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(onBack))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"home_scan"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(onScan))
    }
    
    func onBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
    // 扫一扫
    func onScan() {
        let vc: XHWLScanTestVC = XHWLScanTestVC()
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setupView() {
        
        bgImg = UIImageView()
        bgImg.frame = self.view.bounds
        bgImg.image = UIImage(named:"xhwl_bg")
        self.view.addSubview(bgImg)
        
        let showImg:UIImage = UIImage(named:"menu_bg")!
        warningView = XHWLSafeGuardView()
        warningView.delegate = self
        warningView.bounds = CGRect(x:0, y:0, width:showImg.size.width, height:showImg.size.height)
        warningView.center = CGPoint(x:self.view.frame.size.width/2.0, y:self.view.frame.size.height/2.0)
        //        warningView.clickCell = {index in
        //
        //            let vc:XHWLHistoryDetailVC = XHWLHistoryDetailVC()
        //            self.navigationController?.pushViewController(vc, animated: true)
        //        }
        self.view.addSubview(warningView)
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
            debugPrint("找不到相机")
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
        } else {
            warningView.pickPhoto.onChangePicture(image)
        }
        //图片控制器退出
        picker.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
