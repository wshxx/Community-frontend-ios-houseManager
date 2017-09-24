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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        setupView()
        setupNav()
    }
    
    func setupNav() {

        self.title = "能耗统计"
    }
    
    func setupView() {
        let webView = UIWebView()
        webView.frame = CGRect(x: 0, y: 64, width: self.view.bounds.size.width, height: self.view.bounds.size.height-64)
        webView.isOpaque = false
        webView.scalesPageToFit = true
        self.view.addSubview(webView)
        
//        analysis/device/statistics
        webView.loadRequest(URLRequest.init(url: URL.init(string: "\(XHWLHttpURL)/analysis/device/realData")!))
    }

}
