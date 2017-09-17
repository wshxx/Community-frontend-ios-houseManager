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
        
        let array:NSArray = ["实时进度"]
        topMenu = XHWLTopView.init(frame: CGRect.zero)
        topMenu.createArray(array: array)
        topMenu.frame = CGRect(x:0, y:0, width:Screen_width-100, height:44)
        topMenu.center = CGPoint(x:Screen_width/2.0, y:22)
        self.navigationItem.titleView = topMenu
    }
    
    func setupView() {
        
        let showImg:UIImage = UIImage(named:"menu_bg")!
        warningView = XHWLCountView(frame:CGRect.zero, array:["", ""])
        warningView.bounds = CGRect(x:0, y:0, width:showImg.size.width, height:showImg.size.height)
        warningView.center = CGPoint(x:self.view.frame.size.width/2.0, y:self.view.frame.size.height/2.0)
        warningView.dismissBlock = { index in
            let vc:XHWLProgressDetailVC = XHWLProgressDetailVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        self.view.addSubview(warningView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
