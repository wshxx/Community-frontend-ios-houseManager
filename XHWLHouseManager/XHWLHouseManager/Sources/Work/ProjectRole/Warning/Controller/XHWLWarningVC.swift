//
//  XHWLWarningVC.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/9.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLWarningVC: XHWLBaseVC, XHWLNetworkDelegate {

    var warningView:XHWLWarningView!
    var dataSource:NSMutableArray = NSMutableArray()
    var dataAry:NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let data = UserDefaults.standard.object(forKey: "projectList")
        let deviceData = UserDefaults.standard.object(forKey: "deviceList")
        if data == nil || deviceData == nil {
            self.navigationController?.popViewController(animated: true)
        } else {
            setupView()
            onLoadHistoryData()
            onLoadCurrentData()
            self.title = "设备报警"
        }
    }
    
    func onLoadCurrentData() {
        
        let data:NSData = UserDefaults.standard.object(forKey: "projectList") as! NSData
        let array:NSArray = XHWLProjectModel.mj_objectArray(withKeyValuesArray: data.mj_JSONObject())
        if array.count > 0 {
            
            let data:NSData = UserDefaults.standard.object(forKey: "user") as! NSData
            let userModel:XHWLUserModel = XHWLUserModel.mj_object(withKeyValues: data.mj_JSONObject())
            
            let projectData:NSData = UserDefaults.standard.object(forKey: "project") as! NSData// 项目
            let projectModel:XHWLProjectModel = XHWLProjectModel.mj_object(withKeyValues: projectData.mj_JSONObject())
            
            let params:[String:Any] = ["ProjectCode":projectModel.code, // 项目编号
                "Cycle":"30000", // 日期 getCurrentDate()
                "token":userModel.wyAccount.token,
                ]
            
            XHWLNetwork.shared.postNewAlerClick(params as NSDictionary, self)
        } else {
            "您当前无项目".ext_debugPrintAndHint()
        }
    }
    
    func getCurrentDate()->String {
        let date = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyy-MM-dd"
        let time = timeFormatter.string(from: date)
        
        return time
    }
    
    func onLoadHistoryData() {
        
        let data:NSData = UserDefaults.standard.object(forKey: "projectList") as! NSData
        let array:NSArray = XHWLProjectModel.mj_objectArray(withKeyValuesArray: data.mj_JSONObject())
        if array.count > 0 {
            
            let data:NSData = UserDefaults.standard.object(forKey: "user") as! NSData
            let userModel:XHWLUserModel = XHWLUserModel.mj_object(withKeyValues: data.mj_JSONObject())
            
            let deviceData:NSData = UserDefaults.standard.object(forKey: "deviceList") as! NSData
            let deviceList:NSArray = XHWLDeviceModel.mj_objectArray(withKeyValuesArray: deviceData.mj_JSONObject())
            
            let projectData:NSData = UserDefaults.standard.object(forKey: "project") as! NSData// 项目
            let projectModel:XHWLUserModel = XHWLUserModel.mj_object(withKeyValues: projectData.mj_JSONObject())
        
        let model:XHWLDeviceModel = deviceList[0] as! XHWLDeviceModel
        let params:[String:Any] = ["ProjectCode":projectModel.code, // 项目编号
            "DeviceID":model.DeviceID, // 设备id
            "Date":getCurrentDate(), // 日期
            "token":userModel.wyAccount.token,
            ]
        
        XHWLNetwork.shared.postHistoryAlerClick(params as NSDictionary, self)
        }else {
            "您当前无项目".ext_debugPrintAndHint()
        }
    }
    
    // MARK: - XHWLNetworkDelegate
    
    func requestSuccess(_ requestKey:NSInteger, _ response:[String : AnyObject]) {
//        历史告警
        if response["result"] is NSNull {
            return
        }
        
        if requestKey == XHWLRequestKeyID.XHWL_HISTORYALER.rawValue {
            let array = response["result"] as! NSArray
            dataSource = XHWLWarningModel.mj_objectArray(withKeyValuesArray: array)
            self.warningView.dataSource = NSMutableArray()
            self.warningView.dataSource.addObjects(from: dataSource as! [Any])
            self.warningView.tableView.reloadData()
        }
        else if requestKey == XHWLRequestKeyID.XHWL_NEWALER.rawValue {
  
            let array = response["result"] as! NSArray
            dataAry = XHWLWarningModel.mj_objectArray(withKeyValuesArray: array)
            self.warningView.dataAry = NSMutableArray()
            self.warningView.dataAry.addObjects(from: dataAry as! [Any])
            self.warningView.tableView.reloadData()
        }

    }
    
    func requestFail(_ requestKey:NSInteger, _ error:NSError) {
        
    }
    
    func setupView() {
        
        let showImg:UIImage = UIImage(named:"menu_bg")!
        warningView = XHWLWarningView()
        warningView.bounds = CGRect(x:0, y:0, width:Screen_width-20, height:Screen_height-160)
//        warningView.bounds = CGRect(x:0, y:0, width:338, height:68+showImg.size.height)
        warningView.center = CGPoint(x:self.view.frame.size.width/2.0, y:self.view.frame.size.height/2.0)
        warningView.clickCell = {[weak self] isHistory, index in
            
            let vc:XHWLHistoryDetailVC = XHWLHistoryDetailVC()
            vc.isHistory = isHistory
            if isHistory {
                 vc.warningModel = self?.dataSource[index] as! XHWLWarningModel
            } else {
                 vc.warningModel = self?.dataAry[index] as! XHWLWarningModel
            }
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        self.view.addSubview(warningView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
