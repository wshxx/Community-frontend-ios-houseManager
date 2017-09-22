//
//  XHWLSafeGuardDetailVC.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/11.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLSafeGuardDetailVC: UIViewController, XHWLScanTestVCDelegate{
    
    var bgImg:UIImageView!
    var backReloadBlock:()->() = {param in }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        setupView()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"scan_back"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(onBack))
        self.title = "详情"
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
        let warningView:XHWLSafeGuardDetailView = XHWLSafeGuardDetailView(frame: CGRect.zero, false)
        warningView.bounds = CGRect(x:0, y:0, width:showImg.size.width, height:showImg.size.height)
        warningView.center = CGPoint(x:self.view.frame.size.width/2.0, y:self.view.frame.size.height/2.0)
        warningView.backReloadBlock = { _ in
            self.backReloadBlock()
            self.navigationController?.popViewController(animated: true)

        }
        self.view.addSubview(warningView)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
