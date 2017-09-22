//
//  XHWLCheckVC.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/10.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLCheckVC: UIViewController  , XHWLScanTestVCDelegate{
    
    var bgImg:UIImageView!
    var topMenu:XHWLTopView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        setupView()
        setupNav()
    }
    
    func setupNav() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"scan_back"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(onBack))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "记录", style: UIBarButtonItemStyle.plain, target: self, action: #selector(onRecordClick))
        
        self.title = "访客登记"
    }
    
    func onRecordClick() {
        
        let vc:XHWLRegistrationVC = XHWLRegistrationVC() // 访客记录
        vc.title = "登记记录"
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func onBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupView() {
        
        bgImg = UIImageView()
        bgImg.frame = self.view.bounds
        bgImg.image = UIImage(named:"home_bg")
        self.view.addSubview(bgImg)
        
        let showImg:UIImage = UIImage(named:"subview_bg")!
        let warningView:XHWLCheckListView = XHWLCheckListView()
        warningView.bounds = CGRect(x:0, y:0, width:showImg.size.width, height:showImg.size.height)
        warningView.center = CGPoint(x:self.view.frame.size.width/2.0, y:self.view.frame.size.height/2.0)
        warningView.btnBlock = {index in
            let vc:XHWLRegistrationVC = XHWLRegistrationVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        self.view.addSubview(warningView)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
