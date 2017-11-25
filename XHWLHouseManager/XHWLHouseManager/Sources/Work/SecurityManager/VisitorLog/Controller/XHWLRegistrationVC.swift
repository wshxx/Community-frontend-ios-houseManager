//
//  XHWLRegistrationVC.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/10.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLRegistrationVC: XHWLBaseVC {

    var warningView:XHWLRegistrationView!
    var dataSource:NSMutableArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        setupView()
        onLoadVisitList()
    }
    
    func onLoadVisitList() {
        
        let data:NSData = UserDefaults.standard.object(forKey: "user") as! NSData
        let userModel:XHWLUserModel = XHWLUserModel.mj_object(withKeyValues: data.mj_JSONObject())
        
        XHWLNetwork.shared.getVisitListClick([userModel.wyAccount.token] as NSArray, self)
    }
    
    func setupView() {
        warningView = XHWLRegistrationView()
        warningView.bounds = CGRect(x:0, y:0, width:Screen_width*13/16.0, height:Screen_height*2/3.0)
        warningView.center = CGPoint(x:self.view.frame.size.width/2.0, y:self.view.frame.size.height/2.0)
        warningView.clickCell = {index in
            
            let vc:XHWLRegistrationDetailVC = XHWLRegistrationDetailVC()
            vc.visitorLogModel = self.dataSource[index] as! XHWLVisitLogModel
            self.navigationController?.pushViewController(vc, animated: true)
        }
        self.view.addSubview(warningView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - XHWLNetworkDelegate

extension XHWLRegistrationVC: XHWLNetworkDelegate {

    func requestSuccess(_ requestKey:NSInteger, _ response:[String : AnyObject]) {
        //        历史告警
        if response["result"] is NSNull {
            return
        }
        
        if requestKey == XHWLRequestKeyID.XHWL_VISITLIST.rawValue {
            let dict:NSDictionary = response["result"]! as! NSDictionary
            let array = dict["rows"] as! NSArray
            dataSource = NSMutableArray()
            dataSource = XHWLVisitLogModel.mj_objectArray(withKeyValuesArray: array)
            self.warningView.dataAry = NSMutableArray()
            self.warningView.dataAry.addObjects(from: dataSource as! [Any])
            self.warningView.tableView.reloadData()
        }
        
    }
    
    func requestFail(_ requestKey:NSInteger, _ error:NSError) {
        
    }
}


