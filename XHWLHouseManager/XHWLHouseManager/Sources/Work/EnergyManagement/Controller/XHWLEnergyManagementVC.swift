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
    }
    
    func setupNav() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"scan_back"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(onBack))
        
        self.title = "能耗统计"
    }
    
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
