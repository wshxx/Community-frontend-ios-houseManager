//
//  XHWLProjectQualityVC.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/26.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLProjectQualityVC: XHWLBaseVC {

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
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"scan_back"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(onBack))
        
        self.title = "工程品质监控"
    }
    
    func setupView() {
        
        let webView = UIWebView()
//        webView.backgroundColor = UIColor.clear
        webView.frame = CGRect(x: 0, y: 64, width: self.view.bounds.size.width, height: self.view.bounds.size.height-64)
        webView.isOpaque = false
        webView.scalesPageToFit = true
        
        let url = "\(XHWLHttpURL)/analysis/projectQuality" //
        print("\(url)")
        webView.loadRequest(URLRequest.init(url: URL.init(string: url)!))
        self.view.addSubview(webView)
        
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
