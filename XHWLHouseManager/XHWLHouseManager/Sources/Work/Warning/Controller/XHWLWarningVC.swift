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
        
        setupView()
        onLoadHistoryData()
        onLoadCurrentData()
        self.title = "设备报警"
    }
    
    func onLoadCurrentData() {
        
        let data:NSData = UserDefaults.standard.object(forKey: "user") as! NSData
        let userModel:XHWLUserModel = XHWLUserModel.mj_object(withKeyValues: data.mj_JSONObject())

        let params:[String:Any] = ["ProjectCode":"10200", // 项目编号
            "Cycle":getCurrentDate(), // 日期
            "token":userModel.wyAccount.token,
            ]
        
        XHWLNetwork.shared.postNewAlerClick(params as NSDictionary, self)
    }
    
    func getCurrentDate()->String {
        let date = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyy-MM-dd"
        let time = timeFormatter.string(from: date)
        
        return time
    }
    
    func onLoadHistoryData() {

        let data:NSData = UserDefaults.standard.object(forKey: "user") as! NSData
        let userModel:XHWLUserModel = XHWLUserModel.mj_object(withKeyValues: data.mj_JSONObject())
        
        let deviceData:NSData = UserDefaults.standard.object(forKey: "deviceList") as! NSData
        let deviceList:NSArray = XHWLDeviceModel.mj_objectArray(withKeyValuesArray: deviceData.mj_JSONObject())
        
        let model:XHWLDeviceModel = deviceList[1] as! XHWLDeviceModel
        let params:[String:Any] = ["ProjectCode":"10200", // 项目编号
            "DeviceID":model.DeviceID, // 设备id
            "Date":getCurrentDate(), // 日期
            "token":userModel.wyAccount.token,
            ]
        
        XHWLNetwork.shared.postHistoryAlerClick(params as NSDictionary, self)
    }
    
    // MARK: - XHWLNetworkDelegate
    
    func requestSuccess(_ requestKey:NSInteger, _ response:[String : AnyObject]) {
//        历史告警
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
        warningView.bounds = CGRect(x:0, y:0, width:338, height:68+showImg.size.height)
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
