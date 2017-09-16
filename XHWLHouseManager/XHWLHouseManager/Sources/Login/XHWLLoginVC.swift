//
//  XHWLLoginVC.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/8/30.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit
import Alamofire

class XHWLLoginVC: UIViewController , XHWLTransitionViewDelegate {
//
//    var progressHUD:XHMLProgressHUD!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
                
       setupView()
        
//        progressHUD = XHMLProgressHUD.init(frame: CGRect(x:(Screen_width-100)/2.0, y:(Screen_height-100)/2.0, width:100, height:100))
//        
//        let window:UIWindow = UIApplication.shared.keyWindow!
//        window.addSubview(progressHUD)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // 初始化界面
    func setupView() {
        let bgImageV:UIImageView = UIImageView(frame: self.view.bounds)
        bgImageV.image = UIImage(named: "home_bg")
        self.view.addSubview(bgImageV)
        
        let showV:XHWLTransitionView = XHWLTransitionView(frame: CGRect(x:0, y:0, width:349, height:299+90+60))
        showV.center = CGPoint(x: self.view.bounds.width/2.0, y: self.view.bounds.height/2.0-90/2.0)
        showV.delegate = self
        showV.funcBackBlock = {[weak showV] topStr,bottomStr in
        
//            self?.progressHUD.show()
            
            //睡眠1.9s，
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + TimeInterval(1.9)){
//                self?.progressHUD.hide()
//                "登陆成功".ext_debugPrintAndHint()
                self.onGotoHome(showV!)
            }
            
        }
        self.view.addSubview(showV)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onHiddenKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    
// MARK: - XHWLTransitionViewDelegate
    // 跳转到首页
    func onGotoHome(_ trianView:XHWLTransitionView) {
        
//        let vc = XHWLNavigationController(rootViewController:XHWLWorkVC())
//        self.present(vc, animated: true, completion: nil)
//        return
        
            
        
        
//        weak var weak_self:XHWLLoginVC?  = self
        //睡眠1.9s，
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + TimeInterval(1.9)){
           
            self.onTabbar()
      //      let v2 = XHWLNavigationController(rootViewController:XHWLWorkVC())
//            "登陆成功".ext_debugPrintAndHint()
      //      self.present(v2, animated: true, completion: nil)
//            weak_self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func onTabbar() {
        
        let tabbar: CYTabBarController = CYTabBarController()
        
        /**
         *  配置外观
         */
        CYTabBarConfig.shared().selectedTextColor = UIColor.orange
        //    [CYTabBarConfig shared].textColor = [UIColor blueColor];
        CYTabBarConfig.shared().backgroundColor = UIColor.clear
        CYTabBarConfig.shared().haveBorder = false
        CYTabBarConfig.shared().selectIndex = 1
        
//        self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        self.navigationBar.shadowImage = UIImage()
        
        
        /**
         *  style 1 (中间按钮突出 ， 设为按钮 , 底部有文字 ， 闲鱼)
         */
        let v1:RTContainerNavigationController = XHWLNavigationController(rootViewController:XHWLHomeVC())
        let v2:RTContainerNavigationController = XHWLNavigationController(rootViewController:XHWLWorkVC())
        tabbar.addChildController(v1, title: "首页", imageName: "tabbar_home", selectedImageName: "tabbar_home_sel")
        tabbar.addChildController(v2, title: "工作", imageName: "tabbar_work", selectedImageName: "tabbar_work_sel")
        
        //        [tabbar addCenterController:nil bulge:YES title:@"发布" imageName:@"post_normal" selectedImageName:@"post_normal"];
        
        //        tabBarController.viewControllers = [v1, v2]
        //
        //        UITabBar.appearance().barTintColor = UIColor.white
        //        //        图片和文字同时修改
        //        tabBarController.tabBar.tintColor = UIColor.orange
        //        //        UITabBar.appearance().tintColor = UIColor.orange
        //        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.red], for: UIControlState.normal)
        //        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.purple], for:.selected)
        
        self.present(tabbar, animated: true, completion: nil)
    }
    
    func onHiddenKeyboard() {
        self.view.endEditing(true)
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
