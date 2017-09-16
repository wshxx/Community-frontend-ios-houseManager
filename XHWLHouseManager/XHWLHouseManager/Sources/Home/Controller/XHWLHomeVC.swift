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

class XHWLHomeVC: XHWLBaseVC, XHWLScanTestVCDelegate , XHWLHomeViewDelegate{ // XHWLScanVCDelegate,
    
    var btn:UIButton!
    
    var menuView : XHWLMenuView!
    var homeView:XHWLHomeView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNav()
        setupView()
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
        }
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
        
        menuView = XHWLMenuView(frame:CGRect(x:0, y:0, width:313, height:453))
        menuView.center = CGPoint(x:self.view.bounds.size.width/2.0, y:self.view.bounds.size.height/2.0)
        menuView.isHidden = true
        self.view.addSubview(menuView)
        
        homeView = XHWLHomeView(frame: CGRect(x:10, y:64, width:self.view.bounds.size.width-20, height:self.view.bounds.height-200))
        homeView.delegate = self
        self.view.addSubview(homeView)
    }

    // 打开菜单
    func onOpenMenu() {
        UIView.animate(withDuration: 0.3) {
            self.menuView.isHidden = !self.menuView.isHidden
            self.homeView.isHidden = !self.homeView.isHidden
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
    
    func returnResultString(strResult:String, block:((_ isSuccess:Bool)->Void))  {
        print("\(strResult)")
        
        let dict:NSDictionary = strResult.dictionaryWithJSON()
        let utid:String = dict["utid"] as! String
        
        
        if utid.compare("XHWL").rawValue == 0 {
            block(true)
            
            let type:String = dict["type"] as! String
            let code:String = dict["code"] as! String
            
            let data:NSData = UserDefaults.standard.object(forKey: "user") as! NSData
            let userModel:XHWLUserModel = XHWLUserModel.mj_object(withKeyValues: data.mj_JSONObject())
            
            let params:NSArray = [type, code, userModel.wyAccount.token]
            
            XHWLHttpTool.sharedInstance.getHttpTool(url: "wyBusiness/qrcode", parameters: params, success: { (response) in
                
                let errorCode:NSInteger = response["errorCode"] as! NSInteger
                if errorCode == 200 {
                    "扫描成功".ext_debugPrintAndHint()
                    let result:NSDictionary = response["result"] as! NSDictionary
                    
                    let scanModel:XHWLScanModel = XHWLScanModel.mj_object(withKeyValues: result)
                    
                    print("\(scanModel.name), \(scanModel.code)")
                    
                    let vc:XHWLScanResultVC = XHWLScanResultVC()
                    vc.scanModel = scanModel
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
            }, failture: { (error) in
                
            })
            
        } else {
            block(false)
        }
    }
    
    // MARK: - XHWLHomeViewDelegate
    // 蓝牙开门
    func onHomeViewWithOpenBluetooth(_ homeView:XHWLHomeView)
    {
        // 天气
        let vc = XHWLLocationVC()
        //            let vc:XHWLPedometerVC = XHWLPedometerVC()
        //            let vc = CMPedometerViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // 远程开门
    func onHomeViewWithOpenNetwork(_ homeView:XHWLHomeView) {
        
    }
    
    // 蓝牙绑卡
    func onHomeViewWithBindCard(_ homeView:XHWLHomeView) {
        let vc:XHWLBluetoothOpenVC = XHWLBluetoothOpenVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
