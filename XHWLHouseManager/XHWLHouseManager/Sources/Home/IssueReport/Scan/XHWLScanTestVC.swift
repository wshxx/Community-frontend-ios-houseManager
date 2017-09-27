//
//  XHWLScanTestVC.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/1.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit
import swiftScan

@objc protocol XHWLScanTestVCDelegate:NSObjectProtocol {
    @objc optional func returnResultString(strResult:String, block:((_ isSuccess:Bool)->Void));
}

class XHWLScanTestVC: UIViewController , XHWLScanVCDelegate{

    weak var delegate:XHWLScanTestVCDelegate?
    var bgImg:UIImageView!
    var vc: XHWLScanVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        self.navigationController?.navigationBar.isHidden = false
//        self.view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        bgImg = UIImageView()
        bgImg.frame = self.view.bounds
        bgImg.image = UIImage(named:"home_bg")
        self.view.addSubview(bgImg)
        
//        let img:UIImage = UIImage(named:"scan_title")!
//        let titleImg: UIImageView = UIImageView.init(image: img)
//        titleImg.image = img
//        self.navigationItem.titleView = titleImg
        
        self.title = "扫一扫"
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"scan_back"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(onBack))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"scan_photo"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(onSelectPicture))
    
        setupView()
    }
    
    func onBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func onSelectPicture() {
       
//        if ([LBXScanWrapper isGetPhotoPermission]) {
             vc.openPhotoAlbum()
//        } else {
//            [self showError:@"请到设置->隐私中开启本程序相册权限"];
//        }
    }

    
    func setupView() {
        
        //设置扫码区域参数设置
        var style : LBXScanViewStyle = LBXScanViewStyle()
        style.centerUpOffset = 44 // 矩形区域中心上移，默认中心点为屏幕中心点
        style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle.Inner //扫码框周围4个角的类型,设置为外挂式
        style.photoframeLineW = 3      // 扫码框周围4个角绘制的线条宽度
        style.photoframeAngleW = 19   // 扫码框周围4个角的宽度
        style.photoframeAngleH = 19   //扫码框周围4个角的高度
        style.colorAngle = UIColor.white
        style.colorRetangleLine = UIColor.clear
        style.anmiationStyle = LBXScanViewAnimationStyle.LineMove //扫码框内 动画类型 --线条上下移动
        style.animationImage = UIImage(named:"scan_light")  //线条上下移动图片
        
        //SubLBXScanViewController继承自LBXScanViewController
        //添加一些扫码或相册结果处理
        vc = XHWLScanVC()
        vc.scanStyle = style
        vc.scanDelegate = self
        vc.view.frame = CGRect(x:0, y:85, width:Screen_width, height:Screen_height-85)
        self.view.addSubview(vc.view)
        self.addChildViewController(vc)
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /**
     *  扫描代理的回调函数
     *
     *  @param strResult 返回的字符串
     */
    
    func returnResultString(strResult:String, block:((_ isSuccess:Bool)->Void))
    {
        print("\(strResult)")
        self.delegate?.returnResultString!(strResult: strResult, block: block)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
