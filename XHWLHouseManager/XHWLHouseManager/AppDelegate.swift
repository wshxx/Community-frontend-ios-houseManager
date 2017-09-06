//
//  AppDelegate.swift
//  XHWLHouseManager
//
//  Created by admin on 2017/8/30.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit
//import CRecordInfo
import IQKeyboardManagerSwift

//Build Settings－－swift Compiler－－Objective-C Bridging Header内容为DemoApp/Bridging-Header.h，这个与Bridging-Header.h位置有关，从项目的根目录开始在objective-c Bridging Header选项里面写入Bridging-Header.h相对路径。

//AnyObject可以代表任何class类型的实例。
//Any可以表示任何类型，除了方法类型(function types)。

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window?.backgroundColor = UIColor.white
        
        IQKeyboardManager.sharedManager().enable = true
        configureMCU()      // 对接海康威视
        configureMapKit()   // 初始化百度地图
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let vc : XHWLLoginVC = XHWLLoginVC()
        self.window?.rootViewController = XHWLNavigationController(rootViewController: vc)
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    // 初始化百度地图
    func configureMapKit() {
        
        let mapManager:BMKMapManager = BMKMapManager()
        // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
        let ret:Bool  = mapManager.start(MapKitAK, generalDelegate: nil) // BMKGeneralDelegate
        if ret == false {
            print("manager start failed!")
        }
    }
    
    // 对接海康威视
    func configureMCU() {

        MCUVmsNetSDK.shareInstance().configMsp(withAddress: MSP_ADDRESS, port: MSP_PORT)
        
        //初始化SDK
        VP_InitSDK();
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

