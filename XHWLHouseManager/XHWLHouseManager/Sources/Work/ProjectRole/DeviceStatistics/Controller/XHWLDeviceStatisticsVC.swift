//
//  XHWLDeviceStatisticsVC.swift
//  XHWLHouseManager
//
//  Created by admin on 2017/9/16.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLDeviceStatisticsVC: XHWLBaseVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "设备统计"
        setupView()
    }
    
    func setupView() {
        let webView = UIWebView()
        webView.backgroundColor = UIColor.white
        webView.frame = CGRect(x: 0, y: 64, width: self.view.bounds.size.width, height: self.view.bounds.size.height-64)
        webView.isOpaque = false
        webView.scalesPageToFit = true
        self.view.addSubview(webView)
        
        if UserDefaults.standard.object(forKey: "project") != nil {
            let projectData:NSData = UserDefaults.standard.object(forKey: "project") as! NSData// 项目
            let projectModel:XHWLProjectModel = XHWLProjectModel.mj_object(withKeyValues: projectData.mj_JSONObject())
            let url = "\(XHWLHttpURL)/analysis/device/statistics/\(projectModel.code)" // ProjectCode=201
            print("\(url)")
            webView.loadRequest(URLRequest.init(url: URL.init(string: url)!))
        } else {
            "当前无项目".ext_debugPrintAndHint()
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
