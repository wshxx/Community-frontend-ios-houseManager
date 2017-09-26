//
//  XHWLDeviceDetailVC.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/23.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLDeviceDetailVC: XHWLBaseVC {
    
    var topMenu:XHWLTopView!
    var warningView:XHWLCountView!
    var deviceModel:XHWLDeviceModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        setupView()
        setupNav()
    }
    
    func setupNav() {

        self.title = deviceModel.DeviceName
       
    }
    
    func requestFail(_ requestKey:NSInteger, _ error:NSError) {
        
    }
    
    func setupView() {
        let webView = UIWebView()
        webView.backgroundColor = UIColor.clear
        webView.frame = CGRect(x: 0, y: 64, width: self.view.bounds.size.width, height: self.view.bounds.size.height-64)
        webView.isOpaque = false
        webView.scalesPageToFit = true
        self.view.addSubview(webView)
        
        let projectData:NSData = UserDefaults.standard.object(forKey: "project") as! NSData// 项目
        let projectModel:XHWLProjectModel = XHWLProjectModel.mj_object(withKeyValues: projectData.mj_JSONObject())
        
        let url = "\(XHWLHttpURL)/analysis/device/realData/\(projectModel.code)/\(deviceModel.DeviceID)" // ProjectCode=201
        print("\(url)")
        webView.loadRequest(URLRequest.init(url: URL.init(string: url)!))
    }

}
