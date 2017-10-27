//
//  XHWLWorkVC.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/5.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit
import TransitionAnimation
import TransitionTreasury

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
        
        NotificationCenter.default.addObserver(self, selector: #selector(onUpdateMessageCount), name:NSNotification.Name(rawValue: "safeProtectNC"), object: nil)

    }
    
//    updateBadge

    func setupNav() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"home_menu"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(onOpenMenu))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"home_scan"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(onScan))
        
        btn = createNavHeadView()
        self.navigationItem.titleView = btn
    }
    
    func createNavHeadView() -> UIButton {
        
        if UserDefaults.standard.object(forKey: "projectList") != nil {
            
            let data:NSData = UserDefaults.standard.object(forKey: "projectList") as! NSData
            let array:NSArray = XHWLProjectModel.mj_objectArray(withKeyValuesArray: data.mj_JSONObject())
            var name:String!
            if array.count > 0{
                
                if UserDefaults.standard.object(forKey: "project") != nil {
                    let projectSubData:NSData = UserDefaults.standard.object(forKey: "project") as! NSData// 项目
                    let model:XHWLProjectModel = XHWLProjectModel.mj_object(withKeyValues: projectSubData.mj_JSONObject())
                    
                    name = model.name
                } else {
                    let model:XHWLProjectModel = array[0] as! XHWLProjectModel
                    name = model.name
                    
                    let projectData:NSData = model.mj_JSONData()! as NSData
                    UserDefaults.standard.set(projectData, forKey: "project") // 项目
                    UserDefaults.standard.synchronize()
                }
 
                
                let btn:UIButton = UIButton()
                btn.frame = CGRect(x:0, y:0, width:120, height:200)
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
        
       // updateBadge()
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
        
        let data:NSData = UserDefaults.standard.object(forKey: "user") as! NSData
        let userModel:XHWLUserModel = XHWLUserModel.mj_object(withKeyValues: data.mj_JSONObject())
        
        let array:NSMutableArray! = NSMutableArray()
        if userModel.wyAccount.wyRole.name.compare("安管主任").rawValue == 0 {
            array.addObjects(from: ["异常放行", "安防事件", "访客记录", "巡更安全", "安环数据", "云瞳监控"])
        } else if userModel.wyAccount.wyRole.name.compare("门岗").rawValue == 0 {
            array.addObjects(from: ["访客登记"])
        } else if userModel.wyAccount.wyRole.name.compare("工程").rawValue == 0 {
            loadDeviceInfo()
            array.addObjects(from: ["设备报警", "设备监控", "能耗统计", "设备统计", "报警统计"])
        } else { // 项目经理
            loadDeviceInfo()
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
            let data = UserDefaults.standard.object(forKey: "projectList")
            let deviceData = UserDefaults.standard.object(forKey: "deviceList")
            if data == nil || deviceData == nil {
                "您当前无项目".ext_debugPrintAndHint()
            } else {
                let vc: XHWLWarningVC = XHWLWarningVC()
                self.navigationController?.pushViewController(vc, animated: true)
            }
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
        case 3:// "巡更定位", 巡更安全
            let vc:XHWLPatrolVC = XHWLPatrolVC()
//            let vc:XHWLMapKitVC = XHWLMapKitVC()
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 4: //  "数据",
            let vc:XHWLDataVC = XHWLDataVC() //
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 5: // 云瞳监控
            // 视频
            let vc = XHWLMcuListVC()
            self.navigationController?.pushViewController(vc, animated: true)
            
        default: break
            
        }
    }
    
    // 工程
    func onProject(_ index:NSInteger) {
        switch index {
        case 0:// 设备报警
            let data = UserDefaults.standard.object(forKey: "projectList")
            let deviceData = UserDefaults.standard.object(forKey: "deviceList")
            if data == nil || deviceData == nil {
                "您当前无项目".ext_debugPrintAndHint()
            } else {
                let vc: XHWLWarningVC = XHWLWarningVC()
                self.navigationController?.pushViewController(vc, animated: true)
            }
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
//            navigationController?.delegate = self as? UINavigationControllerDelegate // push/ pop
//            self.navigationController?.tr_pushViewController(vc, method: .page)
            navigationController?.pushViewController(vc, animated: true)
            
            break
        default:
            break
        }
    }
    
    // 打开菜单
    func onOpenMenu() {
        let vc:XHWLMenuVC = XHWLMenuVC()
        self.navigationController?.pushViewController(vc, animated: true)
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
        if dict.count > 0 {
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
        } else {
            block(false)
        }
    }

    //    返回项目下所有设备信息
    func loadDeviceInfo() {
        
        if UserDefaults.standard.object(forKey: "projectList") != nil {
            let data:NSData = UserDefaults.standard.object(forKey: "projectList") as! NSData
            let array:NSArray = XHWLProjectModel.mj_objectArray(withKeyValuesArray: data.mj_JSONObject())
            if array.count > 0 {
                let data:NSData = UserDefaults.standard.object(forKey: "user") as! NSData
                let userModel:XHWLUserModel = XHWLUserModel.mj_object(withKeyValues: data.mj_JSONObject())
                
                let projectData:NSData = UserDefaults.standard.object(forKey: "project") as! NSData// 项目
                let projectModel:XHWLUserModel = XHWLUserModel.mj_object(withKeyValues: projectData.mj_JSONObject())
                
                let param = ["ProjectCode": projectModel.code, // 项目编号 201
                            "token":userModel.wyAccount.token]
                
                XHWLNetwork.shared.postDeviceInfoClick(param as NSDictionary, self)
            } else {
                "您当前无项目".ext_debugPrintAndHint()
            }
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
        }
        else if requestKey == XHWLRequestKeyID.XHWL_MESSAGECOUNT.rawValue {
            
            let dict:NSDictionary = response["result"]!["count"] as! NSDictionary
            
            let data:NSData = UserDefaults.standard.object(forKey: "user") as! NSData
            let userModel:XHWLUserModel = XHWLUserModel.mj_object(withKeyValues: data.mj_JSONObject())
            
            if userModel.wyAccount.wyRole.name.compare("安管主任").rawValue == 0 {
                let securityNotDealNo:NSNumber = dict["securityNotDealNo"] as! NSNumber //未处理安防事件总数
//                let projectCycleAlarmAccount:NSNumber = dict["projectCycleAlarmAccount"] as! NSNumber //设备告警总数
                let outExceptionAccount:NSNumber = dict["outExceptionAccount"] as! NSNumber //停车场异常抬杆总数
                
                var security:Int = Int(securityNotDealNo)
                if Int(securityNotDealNo) > 8 {
                    security = 8
                }
                updateBadge(security, 0, Int(outExceptionAccount))
                
                let num:Int = Int(outExceptionAccount).advanced(by: security)
                JPUSHService.setBadge(num) // JPush服务器
                UIApplication.shared.applicationIconBadgeNumber = num
            } else if userModel.wyAccount.wyRole.name.compare("工程").rawValue == 0 {
                
                let projectCycleAlarmAccount:NSNumber = dict["projectCycleAlarmAccount"] as! NSNumber //设备告警总数
                
                updateBadge(0, Int(projectCycleAlarmAccount), 0)
                JPUSHService.setBadge(Int(projectCycleAlarmAccount)) // JPush服务器
                UIApplication.shared.applicationIconBadgeNumber = Int(projectCycleAlarmAccount)
            }
            else if userModel.wyAccount.wyRole.name.compare("项目经理").rawValue == 0 { // 项目经理
                let securityNotDealNo:NSNumber = dict["securityNotDealNo"] as! NSNumber //未处理安防事件总数
                let projectCycleAlarmAccount:NSNumber = dict["projectCycleAlarmAccount"] as! NSNumber //设备告警总数
                let outExceptionAccount:NSNumber = dict["outExceptionAccount"] as! NSNumber //停车场异常抬杆总数
                var security:Int = Int(securityNotDealNo)
                if Int(securityNotDealNo) > 8 {
                    security = 8
                }
                updateBadge(security, Int(projectCycleAlarmAccount), Int(outExceptionAccount))
                
                let num:Int = Int(outExceptionAccount).advanced(by:Int(projectCycleAlarmAccount).advanced(by: security))
                JPUSHService.setBadge(num) // JPush服务器
                UIApplication.shared.applicationIconBadgeNumber = num
            }
        }
        else if requestKey == XHWLRequestKeyID.XHWL_SCANCODE.rawValue {
            print("\(response)")
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
    
    func updateBadge(_ securityNotDealNo:NSInteger, _ projectCycleAlarmAccount:NSInteger, _ outExceptionAccount:NSInteger) {
        let data:NSData = UserDefaults.standard.object(forKey: "user") as! NSData
        let userModel:XHWLUserModel = XHWLUserModel.mj_object(withKeyValues: data.mj_JSONObject())
        
        if userModel.wyAccount.wyRole.name.compare("安管主任").rawValue == 0 {
            //            let index:NSInteger =  UserDefaults.standard.integer(forKey: "safeProtectAlert") as! NSInteger
            //            homeView.badgeArray = NSMutableArray.init(array: [0, index, 0, 0, 0, 0])
            homeView.badgeArray = NSMutableArray.init(array: [outExceptionAccount , securityNotDealNo, 0, 0, 0, 0, 0])
        } else if userModel.wyAccount.wyRole.name.compare("门岗").rawValue == 0 {
            homeView.badgeArray = NSMutableArray.init(array: [0])
        } else if userModel.wyAccount.wyRole.name.compare("工程").rawValue == 0 {
            homeView.badgeArray = NSMutableArray.init(array: [projectCycleAlarmAccount, 0, 0, 0, 0])
        } else if userModel.wyAccount.wyRole.name.compare("项目经理").rawValue == 0 { // 项目经理
            homeView.badgeArray = NSMutableArray.init(array: [securityNotDealNo, projectCycleAlarmAccount, outExceptionAccount, 0, 0, 0, 0, 0])
        }
        homeView.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
        
        setupNav()
        
        let data:NSData = UserDefaults.standard.object(forKey: "user") as! NSData
        let userModel:XHWLUserModel = XHWLUserModel.mj_object(withKeyValues: data.mj_JSONObject())
        
        if userModel.wyAccount.wyRole.name.compare("安管主任").rawValue == 0 ||
            userModel.wyAccount.wyRole.name.compare("工程").rawValue == 0 ||
            userModel.wyAccount.wyRole.name.compare("项目经理").rawValue == 0 {
            onUpdateMessageCount()
        }
    }
    
    func onUpdateMessageCount() {
        let data:NSData = UserDefaults.standard.object(forKey: "user") as! NSData
        let userModel:XHWLUserModel = XHWLUserModel.mj_object(withKeyValues: data.mj_JSONObject())
        
        XHWLNetwork.shared.getMessageCountClick([userModel.wyAccount.token], self)
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
