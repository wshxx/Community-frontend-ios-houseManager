//
//  XHWLWorkVC.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/5.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLWorkVC: UIViewController, XHWLScanTestVCDelegate {

    var menuView : XHWLMenuView!
    var bgImg:UIImageView!
    var dataAry:NSMutableArray!
    var btn:UIButton!
    var warningView:XHWLScanResultView!
    var homeView:XHWLHomeView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.orange
        self.rt_disableInteractivePop = true
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"home_menu"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(onOpenMenu))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"home_scan"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(onScan))
        
        dataAry = NSMutableArray()
        let array :NSArray = [["name":"设备地址：", "content":"中海华庭正门扶手电梯1号", "isHiddenEdit": true],
                              ["name":"编码信息：", "content":"AJ0098737", "isHiddenEdit": true],
                              ["name":"最后修改时间：", "content":"1000kg", "isHiddenEdit":true],
                              ["name":"当前状态：", "content":"正常", "isHiddenEdit": true]]
        dataAry = XHWLMenuModel.mj_objectArray(withKeyValuesArray: array)

        setupView()
        
        btn = createNavHeadView()
        self.navigationItem.titleView = btn
    }
    
    func createNavHeadView() -> UIButton {
        let btn:UIButton = UIButton()
        btn.frame = CGRect(x:0, y:0, width:100, height:200)
        btn.setTitle("中海物联科技有限公司", for: UIControlState.normal)
        btn.setTitleColor(UIColor.white, for: UIControlState.normal)
        btn.setImage(UIImage(named:"home_switch"), for: UIControlState.normal)
        btn.titleLabel?.font = font_14
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -14, bottom: 0, right: 0)
        btn.addTarget(self, action: #selector(onCreateNavHeadView), for: UIControlEvents.touchUpInside)
        
        return btn
    }
    
    func onCreateNavHeadView() {
        
        let array:NSArray = ["sdfsd", "sdf"]
        let headView:XHWLNavHeadView = XHWLNavHeadView(frame:CGRect.zero, array:array)
        let window:UIWindow = UIApplication.shared.keyWindow!
        
//        [waak btn]
        weak var weakSelf = self
        
        headView.dismissBlock = { [weak headView] index in
            print("\(index)")
            if index != -1 {
               weakSelf?.updateNavTitle(array[index] as! String)
            }
            headView?.removeFromSuperview()
        }
        headView.frame = UIScreen.main.bounds
        window.addSubview(headView)
    }
    
    func updateNavTitle(_ title:String) {
        btn?.setTitle(title, for: UIControlState.normal)
        self.navigationItem.titleView = btn
    }
    
    func setupView() {
        
        bgImg = UIImageView()
        bgImg.frame = self.view.bounds
        bgImg.image = UIImage(named:"xhwl_bg")
        self.view.addSubview(bgImg)
        
        menuView = XHWLMenuView(frame:CGRect(x:0, y:0, width:313, height:453))
        menuView.center = CGPoint(x:self.view.bounds.size.width/2.0, y:self.view.bounds.size.height/2.0)
        menuView.isHidden = true
        self.view.addSubview(menuView)
        
        
        let array:NSArray = ["安防事件", "在线定位", "进度查看", "数据", "访客记录", "异常放行", "一键开门", "远程开门"]
        homeView = XHWLHomeView(frame: CGRect.zero, array: array)
        homeView.frame = CGRect(x:10, y:64, width:self.view.bounds.size.width-20, height:self.view.bounds.height-200)
        homeView.dismissBlock = { index in
            switch index {
            case 0:
                let vc:XHWLSafeProtectionVC = XHWLSafeProtectionVC()
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case 1:
                let vc:XHWLMapKitVC = XHWLMapKitVC()
//                let vc:XHWLRegistrationDetailVC = XHWLRegistrationDetailVC()
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case 2:
                 let vc:XHWLCountVC = XHWLCountVC()
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case 3:
                let vc:XHWLWaterVC = XHWLWaterVC() //
                self.navigationController?.pushViewController(vc, animated: true)

                break
            case 4:
                let vc:XHWLRegistrationVC = XHWLRegistrationVC() // 访客记录
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case 5:
                let vc:XHWLAbnormalPassVC = XHWLAbnormalPassVC()
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case 6:
                let vc: XHWLWarningVC = XHWLWarningVC() // 设备报警
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case 7:
                let vc:XHWLCheckVC = XHWLCheckVC() // 访客登记
                self.navigationController?.pushViewController(vc, animated: true)
                
            default: break
                
            }
        }
        self.view.addSubview(homeView)
//        ["访客登记", "一键开门", "远程开门"]
//        ["设备报警", "供配电", "给排水", "设备统计", "能耗统计", "一键开门", "远程开门"]
        
        setupScanResult()
    }
    
    func setupScanResult() {
        let image:UIImage = UIImage(named:"warning_bg")!
        warningView = XHWLScanResultView()
        warningView.bounds = CGRect(x:0, y:0, width:image.size.width, height:image.size.height)
        warningView.center = CGPoint(x:self.view.frame.size.width/2.0, y:self.view.frame.size.height/2.0)
        warningView.isHidden = true
        warningView.btnBlock = { [weak warningView] index in
            if index == 0 {
                warningView?.isHidden = true
            } else {
                let vc:XHWLIssueReportVC = XHWLIssueReportVC()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        warningView.createArray(array: dataAry)
        self.view.addSubview(warningView)
    }
    
    // 打开菜单
    func onOpenMenu() {
//        XHWLTipView.shared.showSuccess(successText: "提示成功！")
        
        UIView.animate(withDuration: 0.3) {
            self.menuView.isHidden = !self.menuView.isHidden
            self.homeView.isHidden = !self.homeView.isHidden
        }
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
//                    {
//                                "utid":"XHWL",
//                                "type":"equipment",
//                                "code":"eq01"
//                }
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
                
                    self.navigationController?.popViewController(animated: true)
                    self.warningView.isHidden = false
                }
                
            }, failture: { (error) in
                
            })
            
        } else {
            block(false)
        }
        //        let index = strResult.index(strResult.startIndex, offsetBy: 6)
        //        let headStr:String = strResult.substring(to: index)
        
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
////        let vc:XHWLSearchVC = XHWLSearchVC()
////        self.navigationController?.pushViewController(vc, animated: true)
//        
//        // 天气
//        let vc = XHWLLocationVC()
//        //            let vc:XHWLPedometerVC = XHWLPedometerVC()
//        //            let vc = CMPedometerViewController()
//        
//        
//        self.navigationController?.pushViewController(vc, animated: true)
//
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
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
