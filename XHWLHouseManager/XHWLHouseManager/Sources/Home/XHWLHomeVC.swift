//
//  XHWLHomeVC.swift
//  XHWLHouseManager
//
//  Created by admin on 2017/8/30.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import Foundation

import UIKit
import swiftScan

class XHWLHomeVC: UIViewController, XHWLScanVCDelegate, XHWLScanTestVCDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.red
        
        if #available(iOS 10.0, *) {
            self.tabBarItem.badgeColor = UIColor.orange
        } else {
            // Fallback on earlier versions
        }
        self.tabBarItem.badgeValue = "1234";
        self.rt_disableInteractivePop = false
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"tabbar_1"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(onOpenMenu))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"tabbar_2"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(onScan))

        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 禁用返回手势
//        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
//        if ([ respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
//        }
    }
    
//    - (void)a
//    {
//    [self.rt_navigationController pushViewController:[[UIViewController alloc] init]
//    animated:YES
//    complete:^(BOOL finished) {
//    [self.rt_navigationController removeViewController:self]; // 移除当前控制器
//    }];
//    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 天气
        let vc = XHWLLocationVC()
        //            let vc:XHWLPedometerVC = XHWLPedometerVC()
        //            let vc = CMPedometerViewController()
        
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // 打开菜单
    func onOpenMenu() {
        // 视频
        let vc = XHWLMcuShowVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // 扫一扫
    func onScan() {

        
        //设置扫码区域参数设置
//        var style : LBXScanViewStyle = LBXScanViewStyle()
//        style.centerUpOffset = 44 // 矩形区域中心上移，默认中心点为屏幕中心点
//        style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle.Outer //扫码框周围4个角的类型,设置为外挂式
//        style.photoframeLineW = 3      // 扫码框周围4个角绘制的线条宽度
//        style.photoframeAngleW = 12   // 扫码框周围4个角的宽度
//        style.photoframeAngleH = 12   //扫码框周围4个角的高度
//        style.colorAngle = mainColor
//        style.colorRetangleLine = UIColor.clear
//        style.anmiationStyle = LBXScanViewAnimationStyle.LineMove //扫码框内 动画类型 --线条上下移动
//        style.animationImage = UIImage(named:"qrcode_scan_light")  //线条上下移动图片
//        
//        //SubLBXScanViewController继承自LBXScanViewController
//        //添加一些扫码或相册结果处理
//        let vc: XHWLScanVC = XHWLScanVC()
//        vc.scanStyle = style
//        vc.scanDelegate = self
        let vc: XHWLScanTestVC = XHWLScanTestVC()
        vc.delegate = self
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
        
        
        //        设备二维码模板：
        //            {
//                        "utid":"XHWL",
//                        "type":"equipment",
//                        "code":"TB0001"
        //        }
        //        园林绿植二维码模板：
//                    {
//                        "utid":"XHWL",
//                        "type":"plant",
//                        "code":"xxxxx"
//                }
        
        //        let dict : NSDictionary = strResult as! NSDictionary
        let dict:NSDictionary = strResult.dictionaryWithJSON()
        let utid:String = dict["utid"] as! String
        
        
        if utid.compare("XHWL").rawValue == 0 {
            block(true)
            
            let type:String = dict["type"] as! String
            let code:String = dict["code"] as! String
            
            let params:[String: String] = ["type" : type,
                                           "code" : code,
                                           "token" : "a4f0b1b4-7325-441c-87ef-d88728532dae",
                                           ]
            
//            http://localhost:8080/ssh/v1/appBusiness/qrcode/scan
            
            //            http://192.168.1.154:8080/v1/appBusiness/scan/qrcode
            
            XHWLHttpTool.sharedInstance.postHttpTool(url: "ssh/v1/appBusiness/qrcode/scan", parameters: params, success: { (response) in
                
                let errorCode:NSInteger = response["errorCode"] as! NSInteger
                if errorCode == 200 {
                    "扫描成功".ext_debugPrintAndHint()
                    let result:NSDictionary = response["result"] as! NSDictionary
                    
                    let scanModel:XHWLScanModel = XHWLScanModel.mj_object(withKeyValues: result)
                    
                    print("\(scanModel.name), \(scanModel.code)")
                }
                
            }, failture: { (error) in
                
            })
            
        } else {
            block(false)
        }
        //        let index = strResult.index(strResult.startIndex, offsetBy: 6)
        //        let headStr:String = strResult.substring(to: index)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
