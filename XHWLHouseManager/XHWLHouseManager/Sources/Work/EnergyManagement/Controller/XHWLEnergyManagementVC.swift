//
//  XHWLEnergyManagementVC.swift
//  XHWLHouseManager
//
//  Created by admin on 2017/9/16.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLEnergyManagementVC: XHWLBaseVC {

    var topMenu:XHWLTopView!
    var warningView:XHWLCountView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        setupView()
        setupNav()
        onLoadData()
    }
    
    func setupNav() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"scan_back"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(onBack))
        
        self.title = "能耗统计"
    }
    
    func onLoadData() {
//
        let webView = UIWebView()
        webView.frame = CGRect(x: 0, y: 64, width: self.view.bounds.size.width, height: self.view.bounds.size.height-64)
        webView.isOpaque = false
        webView.scalesPageToFit = true
        self.view.addSubview(webView)
        
        webView.loadRequest(URLRequest.init(url: URL.init(string: "\(XHWLHttpURL)/analysis/energy")!))
        
//        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[[NSBundle mainBundle] pathForResource:@"JZMNoNetwork" ofType:@"html"]]]];
        
        
//        let data:NSData = UserDefaults.standard.object(forKey: "user") as! NSData
//        let userModel:XHWLUserModel = XHWLUserModel.mj_object(withKeyValues: data.mj_JSONObject())
//        
//        XHWLNetwork.shared.getEnergyLoseClick([] as NSArray, self)
    }
    
    // MARK: - XHWLNetworkDelegate
    
//    func requestSuccess(_ requestKey:NSInteger, _ response:[String : AnyObject]) {
//        
//        if requestKey == XHWLRequestKeyID.XHWL_ENERGYLOSE.rawValue {
//            
////            dataAry = XHWLRealProgressModel.mj_objectArray(withKeyValuesArray:response["result"] as! NSArray)
////            warningView.dataAry = NSMutableArray()
////            warningView.dataAry.addObjects(from: dataAry as! [Any])
////            warningView.tableView.reloadData()
//            
//           
//        }
//        
//    }
//    
//    func requestFail(_ requestKey:NSInteger, _ error:NSError) {
//        
//    }
    
    func setupView() {
        
//        let showImg:UIImage = UIImage(named:"menu_bg")!
//        warningView = XHWLCountView(frame:CGRect.zero)
//        warningView.bounds = CGRect(x:0, y:0, width:showImg.size.width, height:showImg.size.height)
//        warningView.center = CGPoint(x:self.view.frame.size.width/2.0, y:self.view.frame.size.height/2.0)
//        warningView.dismissBlock = { index in
//            let vc:XHWLProgressDetailVC = XHWLProgressDetailVC()
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
//        self.view.addSubview(warningView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
