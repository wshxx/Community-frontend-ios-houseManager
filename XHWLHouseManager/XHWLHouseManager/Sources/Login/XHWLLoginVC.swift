//
//  XHWLLoginVC.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/8/30.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit
import QuartzCore
import Alamofire

class XHWLLoginVC: UIViewController , XHWLTransitionViewDelegate {
//
//    var progressHUD:XHMLProgressHUD!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
       setupView()
        
        if UserDefaults.standard.bool(forKey: "isFirst") == false {
            var imageNameArr = Array<Any>()
            for i in 1..<3 {
                imageNameArr.append("\(i)")
            }
            
            self.view!.addSubview(CLNewFeatureView(imageNameArr: imageNameArr))
            UserDefaults.standard.set(true, forKey:"isFirst")
            UserDefaults.standard.synchronize()
        }
        
//        launchAnimation()
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
        
//        let showV:XHWLTransitionView = XHWLTransitionView(frame: CGRect(x:0, y:0, width:349, height:299+90+60))
//        showV.center = CGPoint(x: self.view.bounds.width/2.0, y: self.view.bounds.height/2.0-90/2.0)
        
        var showV:XHWLTransitionView //
        print("\(Screen_height)")
        if Screen_height > 667 {
            showV = XHWLTransitionView(frame: CGRect(x:0, y:0, width:Screen_width*7/8.0, height:299+90+60+40)) // 299+90+60
        } else if Screen_height > 568.0 {
            showV = XHWLTransitionView(frame: CGRect(x:0, y:0, width:Screen_width*7/8.0, height:299+90+60)) // 299+90+60
        } else if Screen_height > 480 {
            showV = XHWLTransitionView(frame: CGRect(x:0, y:0, width:Screen_width*7/8.0, height:Screen_height*5/7.0)) // 299+90+60
        } else {
            showV = XHWLTransitionView(frame: CGRect(x:0, y:0, width:Screen_width*7/8.0, height:Screen_height*6/7.0)) // 299+90+60
        }
        showV.center = CGPoint(x: self.view.bounds.width/2.0, y: self.view.bounds.height/2.0-90/2.0)
        showV.delegate = self
        showV.funcBackBlock = {[weak showV] topStr,bottomStr in
    
            self.onGotoHome(showV!)
        }
        self.view.addSubview(showV)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onHiddenKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    
// MARK: - XHWLTransitionViewDelegate
    // 跳转到首页
    func onGotoHome(_ trianView:XHWLTransitionView) {
        self.onTabbar()
    }
    
    func onTabbar() {
        
        let tabbar: CYTabBarController = CYTabBarController()
        
        /**
         *  配置外观
         */
        CYTabBarConfig.shared().selectedTextColor = color_51ebfd
        CYTabBarConfig.shared().textColor = UIColor.white
        CYTabBarConfig.shared().backgroundColor = UIColor.clear
        CYTabBarConfig.shared().haveBorder = false
        CYTabBarConfig.shared().selectIndex = 0
        
        
        /**
         *  style 1 (中间按钮突出 ， 设为按钮 , 底部有文字 ， 闲鱼)
         */
        let v1:RTContainerNavigationController = XHWLNavigationController(rootViewController:XHWLHomeVC())
        let v2:RTContainerNavigationController = XHWLNavigationController(rootViewController:XHWLWorkVC())
        tabbar.addChildController(v1, title: "首页", imageName: "tabbar_home", selectedImageName: "tabbar_home_sel")
        tabbar.addChildController(v2, title: "工作", imageName: "tabbar_work", selectedImageName: "tabbar_work_sel")
        
        // [tabbar addCenterController:nil bulge:YES title:@"发布" imageName:@"post_normal" selectedImageName:@"post_normal"];
        let window:UIWindow = UIApplication.shared.keyWindow!
        window.rootViewController = tabbar
        
//        let btn:CYButton = tabbar.tabbar.btnArr[1] as! CYButton
//        btn.setBackgroundImage(UIImage(named:"pin"), for: UIControlState.normal)
    }
    
    //闪烁效果。
    //    [myTest1.layer addAnimation:[self opacityForever_Animation:0.5] forKey:nil];
    
//    #pragma mark === 永久闪烁的动画 ======
//    func opacityForever_Animation(_ time:CGFloat) -> CABasicACnimation {
//        let animation:CABasicAnimation = CABasicAnimation.   [CABasicAnimation animationWithKeyPath:@"opacity"];//必须写opacity才行。
//        animation.fromValue = NSNumber. [NSNumber numberWithFloat:1.0f];
//        animation.toValue = [NSNumbernumberWithFloat:0.0f];//这是透明度。
//        animation.autoreverses = YES;
//        animation.duration = time;
//        animation.repeatCount = MAXFLOAT;
//        animation.removedOnCompletion = NO;
//        animation.fillMode = kCAFillModeForwards;
//        animation.timingFunction=[CAMediaTimingFunctionfunctionWithName:kCAMediaTimingFunctionEaseIn];///没有的话是均匀的动画。
//        return animation
//    }
    
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
