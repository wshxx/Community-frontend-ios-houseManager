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
//        onLoadData()
    }
    
    func onLoadData() {

        let data:NSData = UserDefaults.standard.object(forKey: "user") as! NSData
        let userModel:XHWLUserModel = XHWLUserModel.mj_object(withKeyValues: data.mj_JSONObject())
        
//        let url:String = "wyBusiness/iot/machine/alarmHistory"
        let params:[String:Any] = ["ProjectCode":"", // 项目编号
            "DeviceID":"", // 设备id
            "Date":"", // 日期
            "token":userModel.wyAccount.token,
            ]
        
        XHWLNetwork.shared.postHistoryAlerClick(params as NSDictionary, self)
        
        let array:NSArray = [["name": "负载率过高告警当前值2.0%", "time":"2017.01.21 12:23:00", "content":"抵压配电房-4#变压器"],
                             ["name": "负载率过高告警当前值2.0%", "time":"2017.01.21 12:23:00", "content":"抵压配电房-4#变压器"]
        ]
        
        //                dataAry = NSMutableArray()
        let dataAry = XHWLWarningModel.mj_objectArray(withKeyValuesArray: array)
        
        let array2:NSArray = [["name": "历史负载率过高告警当前值2.0%", "time":"2017.01.21 12:23:00", "content":"抵压配电房-4#变压器"],
                              ["name": "历史负载率过高告警当前值2.0%", "time":"2017.01.21 12:23:00", "content":"抵压配电房-4#变压器"]
        ]
        
        //                dataSource = NSMutableArray()
        let dataSource = XHWLWarningModel.mj_objectArray(withKeyValuesArray: array2)
        
        self.warningView.dataAry.addObjects(from: dataAry as! [Any])
        self.warningView.dataSource.addObjects(from: dataSource as! [Any])
        
        self.warningView.tableView.reloadData()
    }
    
    // MARK: - XHWLNetworkDelegate
    
    func requestSuccess(_ requestKey:NSInteger, _ response:[String : AnyObject]) {
        
        //            self.progressHUD.hide()
        if response["state"] as! Bool{
            "登陆成功".ext_debugPrintAndHint()
            
        } else {
            //登录失败
            switch(response["errorCode"] as! Int){
            case 11:
                "用户名不存在".ext_debugPrintAndHint()
                break
            default:
                
                let msg:String = response["message"] as! String
                msg.ext_debugPrintAndHint()
                break
            }
            
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
