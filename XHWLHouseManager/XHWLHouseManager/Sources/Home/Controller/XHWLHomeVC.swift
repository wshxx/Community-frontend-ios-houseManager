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
import CoreBluetooth

class XHWLHomeVC: XHWLBaseVC, XHWLScanTestVCDelegate , XHWLHomeViewDelegate, XHWLNetworkDelegate, CBCentralManagerDelegate {
    
    var btn:UIButton!
    
//    var menuView : XHWLMenuView!
    var homeView:XHWLHomeView!
    var block:(Bool)->() = {param in  }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNav()
        setupView()
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UserDefaults.standard.bool(forKey: "isLeadFirst") == false {
            XHWLLeadingView.showLeadingView()
            UserDefaults.standard.set(true, forKey:"isLeadFirst")
            UserDefaults.standard.synchronize()
        }
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
    
    //MARK: -2.检查设备自身（中心设备）支持的蓝牙状态
    // CBCentralManagerDelegate的代理方法
    
    /// 本地设备状态
    ///
    /// - Parameter central: 中心者对象
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown:
            print("CBCentralManager state:", "unknown")
            break
        case .resetting:
            print("CBCentralManager state:", "resetting")
            break
        case .unsupported:
            print("CBCentralManager state:", "unsupported")
            break
        case .unauthorized:
            print("CBCentralManager state:", "unauthorized")
            break
        case .poweredOff:
            print("CBCentralManager state:", "power off")
            //            AlertMessage.showAlertMessage(vc: self, alertMessage: "请打开蓝牙！", duration: 1)
            break
        case .poweredOn:
            //暂时跳到云对讲
            let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "bluetoothVC")
            self.navigationController?.pushViewController(vc, animated: true)
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "bluetoothVC")
//            self.present(vc!, animated: true)
            break
        }
        
    }
    
    func onCreateNavHeadView() {
        
        let data:NSData = UserDefaults.standard.object(forKey: "projectList") as! NSData
        let array:NSArray = XHWLProjectModel.mj_objectArray(withKeyValuesArray: data.mj_JSONObject())
        
        let headView:XHWLNavHeadView = XHWLNavHeadView(frame:CGRect.zero, array:array)
        let window:UIWindow = UIApplication.shared.keyWindow!
        
        //        [waak btn]
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
        
//        menuView = XHWLMenuView(frame:CGRect(x:0, y:0, width:Screen_width*13/16.0, height:Screen_height*2/3.0))
//        menuView.center = CGPoint(x:self.view.bounds.size.width/2.0, y:self.view.bounds.size.height/2.0)
//        menuView.isHidden = true
//        self.view.addSubview(menuView)
        
        homeView = XHWLHomeView(frame: CGRect(x:10, y:64, width:self.view.bounds.size.width-20, height:self.view.bounds.height-200))
        homeView.delegate = self
        self.view.addSubview(homeView)
    }

    // 打开菜单
    func onOpenMenu() {
        UIView.animate(withDuration: 0.3) {
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
     "code":"xxxxx"
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
    
    
    // MARK: - XHWLNetworkDelegate
    
    func requestSuccess(_ requestKey:NSInteger, _ response:[String : AnyObject]) {
        
        if requestKey == XHWLRequestKeyID.XHWL_OPENDOOR.rawValue {
            let dict = response["result"] as! NSDictionary
            let model:XHWLUnitModel = XHWLUnitModel.mj_object(withKeyValues: dict)
            
            print("\(model.address) = \(model.yzId)")
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
    
    // MARK: - XHWLHomeViewDelegate
    // 蓝牙开门
    func onHomeViewWithOpenBluetooth(_ homeView:XHWLHomeView)
    {
        // 天气
//        let vc = XHWLLocationVC()
        //            let vc:XHWLPedometerVC = XHWLPedometerVC()
        //            let vc = CMPedometerViewController()
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // 远程开门
    func onHomeViewWithOpenNetwork(_ homeView:XHWLHomeView) {
        
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ChooseDistrictVC")
        self.present(vc, animated: true, completion: nil)
//        self.navigationController?.pushViewController(vc, animated: true)
//        loadData()
    }
    
    var central: CBCentralManager!
    // 蓝牙绑卡
    func onHomeViewWithBindCard(_ homeView:XHWLHomeView) {
//        let vc:XHWLBluetoothOpenVC = XHWLBluetoothOpenVC()
        //初始化本地中心设备对象
        central = CBCentralManager.init(delegate: self, queue: nil)

        
        
    }
    
    
    func loadData() {
        
        let data:NSData = UserDefaults.standard.object(forKey: "user") as! NSData
        let userModel:XHWLUserModel = XHWLUserModel.mj_object(withKeyValues: data.mj_JSONObject())
        
        let params:[String:Any] = ["reqId":"DaMen2", // 请求代码
            "upid":"DaMen2", // 项目唯一编号
            "doorId":"83886523", // 门ID
            ]
        
        XHWLNetwork.shared.postOpenDoorClick(params as NSDictionary, self)
    }
        
       

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
