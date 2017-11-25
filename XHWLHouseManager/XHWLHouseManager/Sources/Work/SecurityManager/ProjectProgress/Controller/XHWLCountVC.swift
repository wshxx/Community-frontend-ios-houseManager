//
//  XHWLCountVC.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/10.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLCountVC: XHWLBaseVC {
    
    var warningView:XHWLCountView!
    var dataAry:NSMutableArray! = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        self.title = "巡更进度"
        setupView()
    }
    
    func onLoadData() {

        let data:NSData = UserDefaults.standard.object(forKey: "user") as! NSData
        let userModel:XHWLUserModel = XHWLUserModel.mj_object(withKeyValues: data.mj_JSONObject())

        XHWLNetwork.shared.getRealProgressClick([userModel.wyAccount.token] as NSArray, self)
    }
    
    func setupView() {
        
        warningView = XHWLCountView(frame:CGRect.zero)
        warningView.bounds = CGRect(x:0, y:0, width:Screen_width*13/16.0, height:Screen_height*2/3.0)
        warningView.center = CGPoint(x:self.view.frame.size.width/2.0, y:self.view.frame.size.height/2.0)
        warningView.dismissBlock = {[weak self] index in
            let vc:XHWLProgressDetailVC = XHWLProgressDetailVC()
            let model:XHWLRealProgressModel = self?.dataAry[index] as! XHWLRealProgressModel
            vc.userId = model.userId
            vc.name = model.nickname
            vc.progress = model.progress
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        self.view.addSubview(warningView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - XHWLNetworkDelegate

extension XHWLCountVC: XHWLNetworkDelegate {

    func requestSuccess(_ requestKey:NSInteger, _ response:[String : AnyObject]) {
        
        if requestKey == XHWLRequestKeyID.XHWL_REALPROGRESS.rawValue {
            
            dataAry = XHWLRealProgressModel.mj_objectArray(withKeyValuesArray:response["result"]!["progressList"] as! NSArray)
            warningView.dataAry = NSMutableArray()
            warningView.dataAry.addObjects(from: dataAry as! [Any])
            warningView.tableView.reloadData()
        }
    }
    
    func requestFail(_ requestKey:NSInteger, _ error:NSError) {
        
    }
}


