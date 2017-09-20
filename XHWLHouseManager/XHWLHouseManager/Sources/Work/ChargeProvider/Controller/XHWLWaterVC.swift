//
//  XHWLWaterVC.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/10.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLWaterVC: UIViewController, XHWLNetworkDelegate {
    
    var bgImg:UIImageView!
    var warningView:XHWLWaterView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        setupView()
        setupNav()
        onLoadNavParameData()
        onLoadRealData()
    }
    
    func setupNav() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"scan_back"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(onBack))
        self.title = "供配电"
        
    }

    func onBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func onLoadNavParameData() {
        
        let data:NSData = UserDefaults.standard.object(forKey: "user") as! NSData
        let userModel:XHWLUserModel = XHWLUserModel.mj_object(withKeyValues: data.mj_JSONObject())
        
        let params:[String:Any] = ["ProjectCode":"201", // 项目编号
            "token":userModel.wyAccount.token,
            ]
       
//       ?AccessToken=bd4f1ce1b544463094726ebc23a6c9f1
        
        XHWLNetwork.shared.postNavParameClick(params as NSDictionary, self)
    }
    
    func onLoadRealData() {
        
        let data:NSData = UserDefaults.standard.object(forKey: "user") as! NSData
        let userModel:XHWLUserModel = XHWLUserModel.mj_object(withKeyValues: data.mj_JSONObject())
        
        let deviceData:NSData = UserDefaults.standard.object(forKey: "deviceList") as! NSData
        let deviceList:NSArray = XHWLDeviceModel.mj_objectArray(withKeyValuesArray: deviceData.mj_JSONObject())
        let model:XHWLDeviceModel = deviceList[1] as! XHWLDeviceModel
        
        let params:[String:Any] = ["ProjectCode":"201", // 项目编号
            "DeviceID":model.DeviceID,
            "token":userModel.wyAccount.token
            ]
        
        XHWLNetwork.shared.postRealDataClick(params as NSDictionary, self)
    }
    
    // MARK: - XHWLNetworkDelegate
    
    func requestSuccess(_ requestKey:NSInteger, _ response:[String : AnyObject]) {

        if requestKey == XHWLRequestKeyID.XHWL_NAVPARAME.rawValue {
            let list:NSArray = response["result"] as! NSArray
            
            let array:NSArray = XHWLProjectModel.mj_objectArray(withKeyValuesArray: list.mj_JSONObject())
            
        } else if requestKey == XHWLRequestKeyID.XHWL_REALDATA.rawValue {
            let list:NSArray = response["result"] as! NSArray
            
            let array:NSArray = XHWLProjectModel.mj_objectArray(withKeyValuesArray: list.mj_JSONObject())
        }
    }
    
    func requestFail(_ requestKey:NSInteger, _ error:NSError) {
        
    }
    
    func setupView() {
        
        bgImg = UIImageView()
        bgImg.frame = self.view.bounds
        bgImg.image = UIImage(named:"home_bg")
        self.view.addSubview(bgImg)
        
        let showImg:UIImage = UIImage(named:"menu_bg")!
        warningView = XHWLWaterView()
        warningView.bounds = CGRect(x:0, y:0, width:338, height:68+showImg.size.height)
        warningView.center = CGPoint(x:self.view.frame.size.width/2.0, y:self.view.frame.size.height/2.0)
        warningView.clickCell = {index in
            
            let vc:XHWLHistoryDetailVC = XHWLHistoryDetailVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        self.view.addSubview(warningView)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
