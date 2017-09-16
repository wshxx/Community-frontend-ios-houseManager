//
//  XHWLSafeProtectionVC.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/12.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLSafeProtectionVC: UIViewController {
    
    var bgImg:UIImageView!
    var topMenu:XHWLTopView!
    var warningView:XHWLSafeProtectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.clear
        setupView()
        setupNav()
    }

    
    func setupNav() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"scan_back"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(onBack))
        
        let array:NSArray = ["水泵房", "排污泵"]
        topMenu = XHWLTopView.init(frame: CGRect.zero)
        topMenu.createArray(array: array)
        topMenu.frame = CGRect(x:0, y:0, width:Screen_width-100, height:44)
        topMenu.center = CGPoint(x:Screen_width/2.0, y:22)
        topMenu.btnBlock = {[weak self] index in
            self?.warningView.selectIndex = index
            self?.warningView.tableView.reloadData()
        }
        self.navigationItem.titleView = topMenu
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
        warningView = XHWLSafeProtectionView()
        warningView.bounds = CGRect(x:0, y:0, width:showImg.size.width, height:showImg.size.height)
        warningView.center = CGPoint(x:self.view.frame.size.width/2.0, y:self.view.frame.size.height/2.0)
        warningView.clickCell = {index, row in
            
            if index == 0 {
                
                let vc:XHWLSafeGuardVC = XHWLSafeGuardVC()
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                
                let vc:XHWLSafeGuardVC = XHWLSafeGuardVC()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        self.view.addSubview(warningView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
