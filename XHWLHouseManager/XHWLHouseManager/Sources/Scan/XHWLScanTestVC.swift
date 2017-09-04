//
//  XHWLScanTestVC.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/1.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit
import swiftScan

class XHWLScanTestVC: UIViewController , XHWLScanVCDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = false
        self.view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        scanAction()
    }
//    #pragma mark - scan Action
    
    func scanAction() {
        //设置扫码区域参数设置
        var style : LBXScanViewStyle = LBXScanViewStyle()
        style.centerUpOffset = 44 // 矩形区域中心上移，默认中心点为屏幕中心点
        style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle.Outer //扫码框周围4个角的类型,设置为外挂式
        style.photoframeLineW = 3      // 扫码框周围4个角绘制的线条宽度
        style.photoframeAngleW = 12   // 扫码框周围4个角的宽度
        style.photoframeAngleH = 12   //扫码框周围4个角的高度
        style.colorAngle = mainColor
        style.colorRetangleLine = UIColor.clear
        style.anmiationStyle = LBXScanViewAnimationStyle.LineMove //扫码框内 动画类型 --线条上下移动
        style.animationImage = UIImage(named:"qrcode_scan_light")  //线条上下移动图片
        
        //SubLBXScanViewController继承自LBXScanViewController
        //添加一些扫码或相册结果处理
        let vc: XHWLScanVC = XHWLScanVC()
        vc.scanStyle = style
        vc.scanDelegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }

    
    /**
     *  扫描代理的回调函数
     *
     *  @param strResult 返回的字符串
     */
    
    func returnResultString(strResult:String, block:((_ isSuccess:Bool)->Void))
    {
        print("\(strResult)")
        
        let index = strResult.index(strResult.startIndex, offsetBy: 6)
        let headStr:String = strResult.substring(to: index)
        
        if (headStr == "userId") {
            block(true)
//            [self onAddStaff:userId];
            
        } else {
            block(false)
        }
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
