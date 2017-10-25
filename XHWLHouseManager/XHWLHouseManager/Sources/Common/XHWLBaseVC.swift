//
//  XHWLBaseVC.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/16.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLBaseVC: UIViewController {

    var bgImg:UIImageView!
//    var internetConnectionIndicator:InternetViewIndicator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.startMonitoringInternet()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        
        initNav()
        
        
        //        if #available(iOS 10.0, *) {
        //            self.tabBarItem.badgeColor = UIColor.orange
        //        } else {
        //            // Fallback on earlier versions
        //        }
        //
        //        self.tabBarItem.badgeValue = "1234";
        //        self.rt_disableInteractivePop = false
    }
    
    func initNav() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"scan_back"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(onBack))
        
        bgImg = UIImageView()
        bgImg.frame = self.view.bounds
        bgImg.image = UIImage(named:"home_bg")
        self.view.addSubview(bgImg)
    }
    
    func onBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        navigationController?.delegate = self
        self.navigationController?.navigationBar.isHidden = false
        // 禁用返回手势
        //        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        //        if ([ respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        //            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        //        }
    }
    
    //    - (void)a
    //    {
    //    [self.rt_navigationController pushViewController:[[UIViewController alloc] init]
    //    animated:YES
    //    complete:^(BOOL finished) {
    //    [self.rt_navigationController removeViewController:self]; // 移除当前控制器
    //    }];
    //    }

    

//    deinit {
//        self.conn.stopNotifier()
//        NotificationCenter.default.removeObserver(self, name: kReachabilityChangedNotification, object: nil)
//
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
