//
//  XHWLSafeProtectionVC.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/12.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLSafeProtectionVC: XHWLBaseVC {
    
    var warningView:XHWLSafeProtectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.clear
        self.title = "安防事件"
        setupView()
        onLoadData()
    }

    func onLoadData() {

        guard let projectData:NSData = UserDefaults.standard.object(forKey: "project") as? NSData else {
            
            "当前无项目".ext_debugPrintAndHint()
            return
        }
        let projectModel:XHWLProjectModel = XHWLProjectModel.mj_object(withKeyValues: projectData.mj_JSONObject())
        
        let params:NSDictionary = ["projectCode":projectModel.projectCode, //   是    项目编号
            "pageSize":10, // 是    每页数量
            "pageNumber":1, //  是    第几页
            "status":2 // 否    报事状态； 1：待调度，2：待分配，3：待处理,4:待消项，5：已消项，6：重大事件
            ]
        XHWLNetwork.shared.postWarningListClick(params, self)
//        XHWLNetwork.shared.getReportListClick([userModel.wyAccount.token] as NSArray, self)
    }
    
    func setupView() {

        warningView = XHWLSafeProtectionView()
        warningView.bounds = CGRect(x:0, y:0, width:Screen_width-20, height:Screen_height-160)
        warningView.center = CGPoint(x:self.view.frame.size.width/2.0, y:self.view.frame.size.height/2.0)
        warningView.clickCell = {[weak warningView] index, row, model in
            
            let vc:XHWLSafeGuardVC = XHWLSafeGuardVC()
            vc.warningId = model.id
            vc.tagIndex = index
            vc.isFinished = !(index == 0)
            vc.backReloadBlock =  { _ in
                if (index == 0) {
                    
                    self.onLoadData()
                } else {
                    
                    warningView?.tableView.reloadData()
                }
            }
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

extension XHWLSafeProtectionVC: XHWLNetworkDelegate {

    func requestSuccess(_ requestKey:NSInteger, _ response:[String : AnyObject]) {
        
        print("\(response)")
        
        if requestKey == XHWLRequestKeyID.XHWL_WARNINGLIST.rawValue {
            let dealArray:NSArray = XHWLSafeProtectionModel.mj_objectArray(withKeyValuesArray:response["result"]!["warnings"] as! NSArray )
            
            self.warningView.dataAry = NSMutableArray()
            self.warningView.dataSource = NSMutableArray()
            self.warningView.dataAry.addObjects(from: dealArray as! [Any])
            self.warningView.dataSource.addObjects(from: dealArray as! [Any])
            self.warningView.tableView.reloadData()
        }
    }
    
    func requestFail(_ requestKey:NSInteger, _ error:NSError) {
        
    }
}


