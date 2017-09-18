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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        onLoadHistoryData()
        onLoadCurrentData()
    }
    
    func onLoadCurrentData() {
        
        let data:NSData = UserDefaults.standard.object(forKey: "user") as! NSData
        let userModel:XHWLUserModel = XHWLUserModel.mj_object(withKeyValues: data.mj_JSONObject())

        let params:[String:Any] = ["ProjectCode":"201", // 项目编号
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
        let params:[String:Any] = ["ProjectCode":"201", // 项目编号
            "DeviceID":model.DeviceID, // 设备id
            "Date":getCurrentDate(), // 日期
            "token":userModel.wyAccount.token,
            ]
        
        XHWLNetwork.shared.postHistoryAlerClick(params as NSDictionary, self)
        
        
        
       
//
//        //                dataAry = NSMutableArray()
//        let dataAry = XHWLWarningModel.mj_objectArray(withKeyValuesArray: array)
//
//        let array2:NSArray = [["name": "历史负载率过高告警当前值2.0%", "time":"2017.01.21 12:23:00", "content":"抵压配电房-4#变压器"],
//                              ["name": "历史负载率过高告警当前值2.0%", "time":"2017.01.21 12:23:00", "content":"抵压配电房-4#变压器"]
//        ]
//        
//        //                dataSource = NSMutableArray()
//        let dataSource = XHWLWarningModel.mj_objectArray(withKeyValuesArray: array2)
//        
//        self.warningView.dataAry.addObjects(from: dataAry as! [Any])
//        self.warningView.dataSource.addObjects(from: dataSource as! [Any])
//        
//        self.warningView.tableView.reloadData()
    }
    
    // MARK: - XHWLNetworkDelegate
    
    func requestSuccess(_ requestKey:NSInteger, _ response:[String : AnyObject]) {
//        历史告警
        if requestKey == XHWLRequestKeyID.XHWL_HISTORYALER.rawValue {
            
            let array2:NSArray = [["name": "历史负载率过高告警当前值2.0%", "time":"2017.01.21 12:23:00", "content":"抵压配电房-4#变压器"],
                                  ["name": "历史负载率过高告警当前值2.0%", "time":"2017.01.21 12:23:00", "content":"抵压配电房-4#变压器"]
            ]
            let dataSource = XHWLWarningModel.mj_objectArray(withKeyValuesArray: array2)
            self.warningView.dataSource.addObjects(from: dataSource as! [Any])
            self.warningView.tableView.reloadData()
        }
        else if requestKey == XHWLRequestKeyID.XHWL_NEWALER.rawValue {
            let array:NSArray = [["name": "负载率过高告警当前值2.0%", "time":"2017.01.21 12:23:00", "content":"抵压配电房-4#变压器"],
                                 ["name": "负载率过高告警当前值2.0%", "time":"2017.01.21 12:23:00", "content":"抵压配电房-4#变压器"]
            ]
            let dataSource = XHWLWarningModel.mj_objectArray(withKeyValuesArray: array)
            self.warningView.dataAry.addObjects(from: dataSource as! [Any])
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
        warningView.clickCell = {isHistory, index in
            
            let vc:XHWLHistoryDetailVC = XHWLHistoryDetailVC()
            vc.isHistory = isHistory
            self.navigationController?.pushViewController(vc, animated: true)
        }
        self.view.addSubview(warningView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
