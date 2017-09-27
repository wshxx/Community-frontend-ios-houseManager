//
//  XHWLWorkVC.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/5.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLWorkVC: UIViewController, XHWLScanTestVCDelegate, XHWLNetworkDelegate{

//    var menuView : XHWLMenuView!
    var bgImg:UIImageView!
    var btn:UIButton!
    var homeView:XHWLWorkView!
    var block:(Bool)->() = {param in  }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.clear
        self.rt_disableInteractivePop = true
        
        setupView()
        setupNav()
    }
    
    func setupNav() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"home_menu"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(onOpenMenu))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"home_scan"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(onScan))
        
        btn = createNavHeadView()
        self.navigationItem.titleView = btn
    }
    
    func createNavHeadView() -> UIButton {
        let data:NSData = UserDefaults.standard.object(forKey: "projectList") as! NSData
        let array:NSArray = XHWLProjectModel.mj_objectArray(withKeyValuesArray: data.mj_JSONObject())
        var name:String!
        if array.count > 0{
            let model:XHWLProjectModel = array[0] as! XHWLProjectModel
            name = model.name
            
            let btn:UIButton = UIButton()
            btn.frame = CGRect(x:0, y:0, width:100, height:200)
            btn.setTitle(name, for: UIControlState.normal)
            btn.setTitleColor(UIColor.white, for: UIControlState.normal)
            btn.setImage(UIImage(named:"home_switch"), for: UIControlState.normal)
            btn.titleLabel?.font = font_14
            btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -14, bottom: 0, right: 0)
            btn.addTarget(self, action: #selector(onCreateNavHeadView), for: UIControlEvents.touchUpInside)
            
            return btn
        }
        
        return UIButton()
    }
    
    func onCreateNavHeadView() {
        
        let data:NSData = UserDefaults.standard.object(forKey: "projectList") as! NSData
        let array:NSArray = XHWLProjectModel.mj_objectArray(withKeyValuesArray: data.mj_JSONObject())
    
        let headView:XHWLNavHeadView = XHWLNavHeadView(frame:CGRect.zero, array:array)
        let window:UIWindow = UIApplication.shared.keyWindow!
        
        weak var weakSelf = self
        
        headView.dismissBlock = { [weak headView] index in
            print("\(index)")
            if index != -1 {
                let model:XHWLProjectModel = array[index] as! XHWLProjectModel
                weakSelf?.updateNavTitle(model.name)
                let projectData:NSData = model.mj_JSONData()! as NSData
                UserDefaults.standard.set(projectData, forKey: "project") // 项目
                UserDefaults.standard.synchronize()
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
        bgImg.image = UIImage(named:"home_bg")
        self.view.addSubview(bgImg)
        
//        menuView = XHWLMenuView(frame:CGRect(x:0, y:0, width:313, height:453))
        
//        menuView = XHWLMenuView(frame:CGRect(x:0, y:0, width:Screen_width*13/16.0, height:Screen_height*2/3.0))
//        menuView.center = CGPoint(x:self.view.bounds.size.width/2.0, y:self.view.bounds.size.height/2.0)
//        menuView.isHidden = true
//        self.view.addSubview(menuView)
//        let menuVc:XHWLMenuVC = XHWLMenuVC()
//        menuVc.view.frame = UIScreen.main.bounds
//        self.view.addSubview(menuVc.view)
//        self.addChildViewController(menuVc)
//        menuView = menuVc.view
//        menuView.isHidden = true
        
        let data:NSData = UserDefaults.standard.object(forKey: "user") as! NSData
        let userModel:XHWLUserModel = XHWLUserModel.mj_object(withKeyValues: data.mj_JSONObject())
        
        let array:NSMutableArray! = NSMutableArray()
        if userModel.wyAccount.wyRole.name.compare("安管主任").rawValue == 0 {
            array.addObjects(from: ["异常放行", "安防事件", "访客记录", "巡更定位", "巡更进度", "安环数据"])
        } else if userModel.wyAccount.wyRole.name.compare("门岗").rawValue == 0 {
            array.addObjects(from: ["访客登记"])
        } else if userModel.wyAccount.wyRole.name.compare("工程").rawValue == 0 {
            loadDeviceInfo()
            array.addObjects(from: ["设备报警", "设备监控", "能耗统计", "设备统计", "报警统计"])
        } else { // 项目经理
            array.addObjects(from:["安防事件", "设备报警", "异常抬杆", "巡更进度", "访客记录", "设备监控", "安防品质监控", "工程品质监控"])
        }
       
        homeView = XHWLWorkView(frame: CGRect.zero, array: array)
        var height = self.view.bounds.height-160
        if CGFloat(array.count*80) < height {
            height = CGFloat(array.count * 80)
        }
        homeView.bounds = CGRect(x:0, y:0, width:self.view.bounds.size.width-20, height:height)
        homeView.center = CGPoint(x:Screen_width/2.0, y:Screen_height/2.0)
        homeView.dismissBlock = { index in
            if userModel.wyAccount.wyRole.name.compare("安管主任").rawValue == 0 {
                self.onSafeGuardLeader(index)
            } else if userModel.wyAccount.wyRole.name.compare("门岗").rawValue == 0 {//安管人员
                self.onSafeGuard(index)
            } else if userModel.wyAccount.wyRole.name.compare("工程").rawValue == 0 {
                self.onProject(index)
            } else {
                self.onProjectManager(index)
            }
        }
        self.view.addSubview(homeView)
    }
    
    func onProjectManager(_ index:NSInteger) {
        switch index {
        case 0: //"安防事件"
            let vc:XHWLSafeProtectionVC = XHWLSafeProtectionVC()
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 1:// 设备报警
            let vc: XHWLWarningVC = XHWLWarningVC()
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 2: // "异常抬杆",
            let vc:XHWLAbnormalPassVC = XHWLAbnormalPassVC()
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 3: // "巡更进度",
            let vc:XHWLCountVC = XHWLCountVC()
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 4: // "访客记录",
            let vc:XHWLRegistrationVC = XHWLRegistrationVC() // 访客记录
            vc.title = "访客记录"
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 5:// "设备监控",
            let vc:XHWLWaterVC = XHWLWaterVC()
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 6: //  "安防品质监控"
            let vc:XHWLSecurityQualityVC = XHWLSecurityQualityVC()
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 7: //   "工程品质监控"
            let vc:XHWLProjectQualityVC = XHWLProjectQualityVC() //
            self.navigationController?.pushViewController(vc, animated: true)
            break
            
        default: break
            
        }
    }
    
    // 安管主任   "异常放行", "安防事件", "访客记录", "在线定位", "进度查看", "安环数据"
    func onSafeGuardLeader(_ index:NSInteger) {
        switch index {
        case 0: // "异常放行"
            let vc:XHWLAbnormalPassVC = XHWLAbnormalPassVC()
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 1: // "安防事件",
            let vc:XHWLSafeProtectionVC = XHWLSafeProtectionVC()
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 2: //  "访客记录",
            let vc:XHWLRegistrationVC = XHWLRegistrationVC() // 访客记录
            vc.title = "访客记录"
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 3:// "巡更定位",
            let vc:XHWLMapKitVC = XHWLMapKitVC()
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 4: // "巡更进度",
            let vc:XHWLCountVC = XHWLCountVC()
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 5: //  "数据",
            let vc:XHWLDataVC = XHWLDataVC() //
            self.navigationController?.pushViewController(vc, animated: true)
            break
            
        default: break
            
        }
    }
    
    // 工程
    func onProject(_ index:NSInteger) {
        switch index {
        case 0:// 设备报警
            let vc: XHWLWarningVC = XHWLWarningVC()
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 1: //"设备监控,
            
            let data:NSData = UserDefaults.standard.object(forKey: "projectList") as! NSData
            let array:NSArray = XHWLProjectModel.mj_objectArray(withKeyValuesArray: data.mj_JSONObject())
            if array.count > 0 {
                let vc:XHWLWaterVC = XHWLWaterVC()
                self.navigationController?.pushViewController(vc, animated: true)
            }else {
                "您当前无项目".ext_debugPrintAndHint()
            }
        case 2: // "能耗统计"
            let data:NSData = UserDefaults.standard.object(forKey: "projectList") as! NSData
            let array:NSArray = XHWLProjectModel.mj_objectArray(withKeyValuesArray: data.mj_JSONObject())
            if array.count > 0 {
                let vc:XHWLEnergyManagementVC = XHWLEnergyManagementVC()
                self.navigationController?.pushViewController(vc, animated: true)
            }else {
                "您当前无项目".ext_debugPrintAndHint()
            }
            break
        case 3:// "设备统计",
            let data:NSData = UserDefaults.standard.object(forKey: "projectList") as! NSData
            let array:NSArray = XHWLProjectModel.mj_objectArray(withKeyValuesArray: data.mj_JSONObject())
            if array.count > 0 {
                let vc:XHWLDeviceStatisticsVC = XHWLDeviceStatisticsVC()
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                "您当前无项目".ext_debugPrintAndHint()
            }
            break
        case 4://   报警统计

            let vc:XHWLAlertCountVC = XHWLAlertCountVC()
            self.navigationController?.pushViewController(vc, animated: true)
            break
        default: break
        }
    }
    
    // 安管人员
    func onSafeGuard(_ index:NSInteger) {
        switch index {
        case 0: // "访客登记"
            let vc:XHWLCheckVC = XHWLCheckVC() // 访客登记
            self.navigationController?.pushViewController(vc, animated: true)
            break
        default:
            break
        }
    }
    
    // 打开菜单
    func onOpenMenu() {
        UIView.animate(withDuration: 0.3) {
//            self.menuView.isHidden = false
//            self.menuView.isHidden = !self.menuView.isHidden
//            self.homeView.isHidden = !self.homeView.isHidden
            let vc:XHWLMenuVC = XHWLMenuVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
    // 扫一扫
    func onScan() {
        let vc: XHWLScanTestVC = XHWLScanTestVC()
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /**
     *  扫描代理的回调函数
     *
     设备二维码模板：
     {
     "utid":"XHWL",
     "type":"equipment",
     "code":"eq01"
     }
     园林绿植二维码模板：
     {
     "utid":"XHWL",
     "type":"plant",
     "code":"lb01"
     }
     *  @param strResult 返回的字符串
     */
    func returnResultString(strResult:String, block:@escaping ((_ isSuccess:Bool)->Void))
    {
        print("\(strResult)")
        self.block = block
        let dict:NSDictionary = strResult.dictionaryWithJSON()
        let utid:String = dict["utid"] as! String
        
        if utid.compare("XHWL").rawValue == 0 {
//            block(true)
            
            let type:String = dict["type"] as! String
            let code:String = dict["code"] as! String
            
            let data:NSData = UserDefaults.standard.object(forKey: "user") as! NSData
            let userModel:XHWLUserModel = XHWLUserModel.mj_object(withKeyValues: data.mj_JSONObject())
            
            let params:NSArray = [type, code, userModel.wyAccount.token]
            
            XHWLNetwork.shared.getScanCodeClick(params, self)
            
        } else {
            block(false)
        }
    }
    
    
    //    返回项目下所有设备信息
    func loadDeviceInfo() {
        let data:NSData = UserDefaults.standard.object(forKey: "projectList") as! NSData
        let array:NSArray = XHWLProjectModel.mj_objectArray(withKeyValuesArray: data.mj_JSONObject())
        if array.count > 0 {
            let data:NSData = UserDefaults.standard.object(forKey: "user") as! NSData
            let userModel:XHWLUserModel = XHWLUserModel.mj_object(withKeyValues: data.mj_JSONObject())
            
            let projectData:NSData = UserDefaults.standard.object(forKey: "project") as! NSData// 项目
            let projectModel:XHWLUserModel = XHWLUserModel.mj_object(withKeyValues: projectData.mj_JSONObject())
            
            let param = ["ProjectCode": projectModel.id, // 项目编号 201
                "token":userModel.wyAccount.token]
            
            XHWLNetwork.shared.postDeviceInfoClick(param as NSDictionary, self)
        } else {
            "您当前无项目".ext_debugPrintAndHint()
        }
    }
    
    // MARK: - XHWLNetworkDelegate
    
    func requestSuccess(_ requestKey:NSInteger, _ response:[String : AnyObject]) {
        
        if requestKey == XHWLRequestKeyID.XHWL_DEVICEINFO.rawValue {
            let list:NSArray = response["result"]!["rows"] as! NSArray
            
            let modelData:NSData = list.mj_JSONData()! as NSData
            UserDefaults.standard.set(modelData, forKey: "deviceList") // XHWLDeviceModel
            UserDefaults.standard.synchronize()
        } else {
            let errorCode:NSInteger = response["errorCode"] as! NSInteger
            if errorCode == 200 {
                block(true)
                "扫描成功".ext_debugPrintAndHint()
                let result:NSDictionary = response["result"] as! NSDictionary
                
                let scanModel:XHWLScanModel = XHWLScanModel.mj_object(withKeyValues: result)
                
                print("\(scanModel.type)")
                
                let vc:XHWLScanResultVC = XHWLScanResultVC()
                vc.scanModel = scanModel
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                
                let message:String = response["message"] as! String
                message.ext_debugPrintAndHint()
                block(false)
            }
        }
    }
    
    func requestFail(_ requestKey:NSInteger, _ error:NSError) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
//        menuView.updateData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
