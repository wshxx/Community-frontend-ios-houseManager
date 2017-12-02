//
//  AppDelegate.swift
//  XHWLHouseManager
//
//  Created by admin on 2017/8/30.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit
import Alamofire
//import CRecordInfo
import IQKeyboardManagerSwift

//Build Settings－－swift Compiler－－Objective-C Bridging Header内容为DemoApp/Bridging-Header.h，这个与Bridging-Header.h位置有关，从项目的根目录开始在objective-c Bridging Header选项里面写入Bridging-Header.h相对路径。

//AnyObject可以代表任何class类型的实例。
//Any可以表示任何类型，除了方法类型(function types)。

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate { // JPUSHRegisterDelegate

    var window: UIWindow?
    var _mapManager: BMKMapManager?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        #if DEBUG // 判断是否在测试环境下
            NBSAppAgent.start(withAppID: TYAppKey) // 听云
        #else
            NBSAppAgent.start(withAppID: TYAppKey) // 听云
        #endif

        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        UIScreen.main.brightness = 0.5
       
        IQKeyboardManager.sharedManager().enable = true
        configureMCU()              // 对接海康威视
        setupMapKit()               // 百度地图
        setupJPush(launchOptions)   // 极光推送
        loadNewVersionInfo()        // 获取新版本
        
        self.window?.backgroundColor = UIColor.white
        self.window = UIWindow(frame: UIScreen.main.bounds)
        setupView()
        
        if UserDefaults.standard.object(forKey: "user") == nil {
            let vc : XHWLLoginVC = XHWLLoginVC()
            self.window?.rootViewController = vc // UINavigationController(rootViewController: vc)
            self.window?.makeKeyAndVisible()
        } else {
            if UserDefaults.standard.object(forKey: "user") is String {
                let vc : XHWLLoginVC = XHWLLoginVC()
                self.window?.rootViewController = vc //UINavigationController(rootViewController: vc)
            } else {
                let data:NSData = UserDefaults.standard.object(forKey: "user") as! NSData
                let dict:NSDictionary = data.mj_JSONObject() as! NSDictionary
                let userModel:XHWLUserModel = XHWLUserModel.mj_object(withKeyValues: dict)
                if userModel.wyAccount.token == "" {
                    let vc : XHWLLoginVC = XHWLLoginVC()
                    self.window?.rootViewController = vc //UINavigationController(rootViewController: vc)
                    
                } else {
                    UserDefaults.standard.set(false, forKey: "isLogin")
                    UserDefaults.standard.synchronize()
                    onTabbar()
                }
            }
        }
        
        self.window?.makeKeyAndVisible()
        
        self.launchAnimation()
        
        UIApplication.shared.cancelAllLocalNotifications()
        
        // apn 内容获取：
//        let notification =  launchOptions![UIApplicationLaunchOptionsKey.remoteNotification]!
//        let remoteNotification:NSDictionary = launchOptions![UIApplicationLaunchOptionsKey.remoteNotification]! as! NSDictionary
//        print("\(notification)")
        
        return true
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        UIScreen.main.brightness = 0.5
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
        //        let controller:ViewController = self.window?.rootViewController as! ViewController
        //        controller.textView.text! += "进入后台 "
        //
        //        //如果已存在后台任务，先将其设为完成
        //        if self.backgroundTask != nil {
        //            application.endBackgroundTask(self.backgroundTask)
        //            self.backgroundTask = UIBackgroundTaskInvalid
        //        }
        //
        //        //如果要后台运行
        //        if controller.mySwitch.on {
        //            //注册后台任务
        //            self.backgroundTask = application.beginBackgroundTaskWithExpirationHandler({
        //                () -> Void in
        //                //如果没有调用endBackgroundTask，时间耗尽时应用程序将被终止
        //                application.endBackgroundTask(self.backgroundTask)
        //                self.backgroundTask = UIBackgroundTaskInvalid
        //            })
        //        }
        
        
        //        let index:NSInteger =  Int(UserDefaults.standard.integer(forKey: "safeProtectAlert"))
        //        JPUSHService.setBadge(index) // JPush服务器
        //        UIApplication.shared.applicationIconBadgeNumber = index
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        //        UIApplication.shared.applicationIconBadgeNumber = 0
        //        JPUSHService.resetBadge()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

extension AppDelegate: UIAlertViewDelegate {
    
}

extension AppDelegate {
    // 获取当前控制器
    func getCurrentVC() -> UIViewController {
        
        if self.window?.rootViewController is UINavigationController {
            return self.window?.rootViewController as! XHWLLoginVC
        }
        else if self.window?.rootViewController is CYTabBarController {
            let tabbar:CYTabBarController = self.window?.rootViewController as! CYTabBarController
            
            let selectNav = tabbar.viewControllers![tabbar.selectedIndex]
            
            print("\(selectNav)")
            
            if selectNav is XHWLNavigationController {
                let nav:XHWLNavigationController = selectNav as! XHWLNavigationController
                let vc:UIViewController = nav.topViewController as! UIViewController
                
                print("\(vc)")
                
                return vc
            }
            return UIViewController()
        }
        
        return UIViewController()
    }
    
    //播放启动画面动画
    func launchAnimation() {
        let statusBarOrientation = UIApplication.shared.statusBarOrientation
        
        
        if let img = splashImageForOrientation(orientation: statusBarOrientation,
                                               size: UIScreen.main.bounds.size) {
            //获取启动图片
            let launchImage = UIImage(named: img)
            let launchview = UIImageView(frame: UIScreen.main.bounds)
            launchview.image = launchImage
            //将图片添加到视图上
            //self.view.addSubview(launchview)
            let delegate = UIApplication.shared.delegate
            let mainWindow = delegate?.window
            mainWindow!!.addSubview(launchview)
            
            //播放动画效果，完毕后将其移除
            UIView.animate(withDuration: 1, delay: 1.5, options: .beginFromCurrentState,
                           animations: {
                            launchview.alpha = 0.0
                            launchview.layer.transform = CATransform3DScale(CATransform3DIdentity, 1.5, 1.5, 1.0)
            }) { (finished) in
                launchview.removeFromSuperview()
            }
        }
    }
    
    //获取启动图片名（根据设备方向和尺寸）
    func splashImageForOrientation(orientation: UIInterfaceOrientation, size: CGSize) -> String?{
        //获取设备尺寸和方向
        var viewSize = size
        var viewOrientation = "Portrait"
        
        if UIInterfaceOrientationIsLandscape(orientation) {
            viewSize = CGSize(width:size.height, height:size.width)
            viewOrientation = "Landscape"
        }
        
        //遍历资源库中的所有启动图片，找出符合条件的
        if let imagesDict = Bundle.main.infoDictionary  {
            if let imagesArray = imagesDict["UILaunchImages"] as? [[String: String]] {
                for dict in imagesArray {
                    if let sizeString = dict["UILaunchImageSize"],
                        let imageOrientation = dict["UILaunchImageOrientation"] {
                        let imageSize = CGSizeFromString(sizeString)
                        if imageSize.equalTo(viewSize)
                            && viewOrientation == imageOrientation {
                            if let imageName = dict["UILaunchImageName"] {
                                return imageName
                            }
                        }
                    }
                }
            }
        }
        
        return nil
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
        self.window?.rootViewController = tabbar
    }
    
    //json格式字符串转字典：
    func getDictionaryFromJSONString(_ jsonString:String) ->NSDictionary{
        
        let jsonData:Data = jsonString.data(using: .utf8)!
        
        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if dict != nil {
            return dict as! NSDictionary
        }
        return NSDictionary()
    }
    
    class func shared() ->AppDelegate {
        
        return UIApplication.shared.delegate as! AppDelegate
    }
}

// MARK: - 初始化
extension AppDelegate {
    func setupView() {
        let bgImg:UIImageView = UIImageView()
        bgImg.frame = UIScreen.main.bounds
        bgImg.image = UIImage(named:"home_bg")
        self.window?.addSubview(bgImg)
    }
    
    // 百度地图
    func setupMapKit() {
        
        // 要使用百度地图，请先启动BaiduMapManager
        _mapManager = BMKMapManager()
        
        /**
         *百度地图SDK所有接口均支持百度坐标（BD09）和国测局坐标（GCJ02），用此方法设置您使用的坐标类型.
         *默认是BD09（BMK_COORDTYPE_BD09LL）坐标.
         *如果需要使用GCJ02坐标，需要设置CoordinateType为：BMK_COORDTYPE_COMMON.
         */
        if BMKMapManager.setCoordinateTypeUsedInBaiduMapSDK(BMK_COORDTYPE_BD09LL) {
            NSLog("经纬度类型设置成功");
        } else {
            NSLog("经纬度类型设置失败");
        }
        // 如果要关注网络及授权验证事件，请设定generalDelegate参数
        let ret = _mapManager?.start(MapKitAK, generalDelegate: self)
        if ret == false {
            NSLog("manager start failed!")
        }
    }
    
    // 对接海康威视
    func configureMCU() {
        
        MCUVmsNetSDK.shareInstance().configMsp(withAddress: MSP_ADDRESS, port: MSP_PORT)
        
        //初始化SDK
        VP_InitSDK();
    }
}

// MARK: - BMKGeneralDelegate
extension AppDelegate: BMKGeneralDelegate {
    
    func onGetNetworkState(_ iError: Int32) {
        if (0 == iError) {
            NSLog("联网成功");
        }
        else{
            NSLog("联网失败，错误代码：Error\(iError)");
//            "网络连接失败".ext_debugPrintAndHint()
        }
    }
    
    func onGetPermissionState(_ iError: Int32) {
        if (0 == iError) {
            NSLog("授权成功");
        }
        else{
            NSLog("授权失败，错误代码：Error\(iError)");
//            "地图授权失败".ext_debugPrintAndHint()
        }
    }
}

// MARK: - ###########################  推送  #############################

extension AppDelegate : JPUSHRegisterDelegate {
    
    func setupJPush(_ launchOptions:[UIApplicationLaunchOptionsKey: Any]?) {
        //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
        let entity:JPUSHRegisterEntity = JPUSHRegisterEntity()
        entity.types = Int(UInt8(JPAuthorizationOptions.alert.rawValue) | UInt8(JPAuthorizationOptions.badge.rawValue) | UInt8(JPAuthorizationOptions.sound.rawValue))
        if (UIDevice.current.systemVersion as NSString).floatValue >= 8.0 {
            // 可以添加自定义categories
            // NSSet<UNNotificationCategory *> *categories for iOS10 or later
            // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
        }
        
        JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
        
        
        // Required
        // init Push
        // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
        // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
        JPUSHService.setup(withOption: launchOptions,
                           appKey: jPushAppKey,
                           channel: channel,
                           apsForProduction: apsForProduction) // 0 (默认值)表示采用的是开发证书，1 表示采用生产证书发布应用
        
        if (UIDevice.current.systemVersion as NSString).floatValue >= 9.0 &&
            (UIDevice.current.systemVersion as NSString).floatValue <= 10.3 {
            let defaultCenter:NotificationCenter = NotificationCenter.default
            defaultCenter.addObserver(self, selector: #selector(networkDidReceiveMessage), name: NSNotification.Name.jpfNetworkDidReceiveMessage, object: nil)
        }
        
//        JPUSHService.setDebugMode() //在application里面调用，设置开启 JPush 日志
//        JMessage.setDebugMode() //在application里面调用，设置开启 JMessage 日志
    }
    
    func networkDidReceiveMessage(_ notification:Notification) {
        
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        print("\(userInfo)")
        
        if (UserDefaults.standard.object(forKey: "user") != nil) &&
            !(UserDefaults.standard.object(forKey: "user") is String) {
//            let data:NSData = UserDefaults.standard.object(forKey: "user") as! NSData
//            let userModel:XHWLUserModel = XHWLUserModel.mj_object(withKeyValues: data.mj_JSONObject())
            
            let extras:NSDictionary = userInfo.value(forKey: "extras") as! NSDictionary
            
            let extrasAry:NSArray = extras.allKeys as NSArray
            let userInfoAry:NSArray = userInfo.allKeys as NSArray
            if extrasAry.contains("from") {
                if userInfoAry.contains("content") {  // 对讲推送
                    let content:NSDictionary = getDictionaryFromJSONString(userInfo.value(forKey: "content") as! String)
                    let keyAry:NSArray = content.allKeys as NSArray
                    if keyAry.contains("type") {
                        if (content["type"] as! String) == "in" {
                            let roomName:String = content["channelId"] as! String // "{\"channelId\":\"402848f45fc928c7015fd738ca1c0000\",\"type\":\"in\"}"; // 房间号
                            XHWLTalkManager.sharedInstance.onJoinRoom(roomName)  // 加入房间
                        } else {
                            XHWLTalkManager.sharedInstance.leaveChannel()
                        }
                    } else {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Talking"), object: (content["yzOperator"] as! String), userInfo: nil)
                    }
                }
            }
            else if extrasAry.contains("key") {
                let keyStr:String = extras["key"] as! String
                if keyStr == "complaint" { // 安防事件 后台时要给提示
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "safeProtectNC"), object: nil)
                } else { // 挤下线
                    JPUSHService.deleteAlias({ (iResCode, iAlias, seq) in
                        
                    }, seq: 0)
                    
                    // 退出
                    AlertMessage.showOneAlertMessage(vc: self.getCurrentVC(), alertMessage: (userInfo.value(forKey: "content") as! String), block: {
                        self.onSuccessLogout()
                    })
                }
            }
        }
    }
    
    // MARK: - 推送
    // 注册APNs成功并上报DeviceToken 启动注册token
    // 请在AppDelegate.m实现该回调方法并添加回调方法中的代码
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        //        let defaultCenter:NotificationCenter = NotificationCenter.default
        //        defaultCenter.addObserver(self, selector: #selector(networkDidReceiveMessage:), name: kJPFNetworkDidLoginNotification, object: nil)
        
        print("注册 DeviceToken 成功")
        print("registrationID = \(JPUSHService.registrationID())")
        /// Required - 注册 DeviceToken
        JPUSHService.registerDeviceToken(deviceToken)
    }
    
    // 实现注册APNs失败接口可选）
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("did Fail To Register For Remote Notifications With Error: \(error)")
    }
    
    // MARK: - JPUSHRegisterDelegate
    
    // iOS 10 Support  didReceiveNotificationResponse
    
    // MARK: - JPUSHRegisterDelegate
    @available(iOS 10.0, *)   // 前台展示 APNs 通知，
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        // Required
        let userInfo:NSDictionary  = notification.request.content.userInfo as NSDictionary
        print("\(userInfo)")
        if #available(iOS 10.0, *) {
            if(notification.request.trigger is UNPushNotificationTrigger) {
                JPUSHService.handleRemoteNotification(userInfo as! [AnyHashable : Any])
            }
        } else {
            // Fallback on earlier versions
        }
        
        print("\(userInfo)")
        if (userInfo.object(forKey: "msg") as! String) == "下线通知" {
            JPUSHService.deleteAlias({ (iResCode, iAlias, seq) in
                
            }, seq: 0)
            
//            (userInfo["key"] as! String).ext_debugPrintAndHint()
            // 退出
            AlertMessage.showOneAlertMessage(vc: self.getCurrentVC(), alertMessage: (userInfo.value(forKey: "key") as! String), block: {
                self.onSuccessLogout()
            })
        } else {
            let aps:NSDictionary = userInfo["aps"] as! NSDictionary
            "\(aps["alert"]!)".ext_debugPrintAndHint()
            if (UserDefaults.standard.object(forKey: "user") != nil) &&
                !(UserDefaults.standard.object(forKey: "user") is String) {
                let keyStr:String = userInfo["key"] as! String
                if keyStr == "complaint" { // 安防事件 后台时要给提示
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "safeProtectNC"), object: nil)
                }
            }
        }

        completionHandler(Int(UNNotificationPresentationOptions.alert.rawValue)) // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
    }
    
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        // Required
        let userInfo:NSDictionary = response.notification.request.content.userInfo as NSDictionary
        print("\(userInfo)")
        if(response.notification.request.trigger is UNPushNotificationTrigger) {
            JPUSHService.handleRemoteNotification(userInfo as! [AnyHashable : Any])
        }
        
        if (userInfo.object(forKey: "msg") as! String) == "下线通知" {
            JPUSHService.deleteAlias({ (iResCode, iAlias, seq) in
                
            }, seq: 0)
            
            (userInfo["key"] as! String).ext_debugPrintAndHint()
            // 退出
            AlertMessage.showOneAlertMessage(vc: self.getCurrentVC(), alertMessage: (userInfo.value(forKey: "key") as! String), block: {
                self.onSuccessLogout()
            })
        } else if (userInfo.object(forKey: "msg") as! String) == "对讲消息" {
            let content:NSDictionary = getDictionaryFromJSONString(userInfo.value(forKey: "key") as! String)
            let keyAry:NSArray = content.allKeys as NSArray
            if keyAry.contains("type") {
                if (content["type"] as! String) == "in" {
                    let roomName:String = content["channelId"] as! String // "{\"channelId\":\"402848f45fc928c7015fd738ca1c0000\",\"type\":\"in\"}"; // 房间号
                    XHWLTalkManager.sharedInstance.onJoinRoom(roomName)  // 加入房间
                } else {
                    XHWLTalkManager.sharedInstance.leaveChannel()
                }
            } else {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Talking"), object: (content["yzOperator"] as! String), userInfo: nil)
            }
        } else {
            let aps:NSDictionary = userInfo["aps"] as! NSDictionary
            "\(aps["alert"]!)".ext_debugPrintAndHint()
            if (UserDefaults.standard.object(forKey: "user") != nil) &&
                !(UserDefaults.standard.object(forKey: "user") is String) {
                let keyStr:String = userInfo["key"] as! String
                if keyStr == "complaint" { // 安防事件 后台时要给提示
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "safeProtectNC"), object: nil)
                }
            }
        }
        
        completionHandler();  // 系统要求执行这个方法
    }
    
    // ios 9 系统提示   在前台时调用。Backgroud Modes -> Remote notifications 后，
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        // Required, iOS 7 Support
        JPUSHService.handleRemoteNotification(userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
        print("\(userInfo)")
        
        if application.applicationState == UIApplicationState.active {
            // 代表从前台接受消息app
            let aps:NSDictionary = userInfo["aps"] as! NSDictionary
            if (userInfo["msg"] as! String) == "下线通知" {
                JPUSHService.deleteAlias({ (iResCode, iAlias, seq) in
                    
                }, seq: 0)
                
                (userInfo["key"] as! String).ext_debugPrintAndHint()
                
                // 退出
                AlertMessage.showOneAlertMessage(vc: self.getCurrentVC(), alertMessage: (userInfo["key"] as! String), block: {
                    self.onSuccessLogout()
                })
            } else {
                let aps:NSDictionary = userInfo["aps"] as! NSDictionary
                "\(aps["alert"]!)".ext_debugPrintAndHint()
                if (UserDefaults.standard.object(forKey: "user") != nil) &&
                    !(UserDefaults.standard.object(forKey: "user") is String) {
                    let keyStr:String = userInfo["key"] as! String
                    if keyStr == "complaint" { // 安防事件 后台时要给提示
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "safeProtectNC"), object: nil)
                    }
                }
            }
        }else{
            // 代表从后台接受消息后进入app
            //            UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        // Required,For systems with less than or equal to iOS6
        JPUSHService.handleRemoteNotification(userInfo)
        print("\(userInfo)")
    }
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        print("\(String(describing: notification.alertTitle)) = \(String(describing: notification.userInfo))")
    }
}

// MARK: - ###########################  XHWLNetworkDelegate  #############################

extension AppDelegate {
    
    func onLogout() {
        let data:NSData = UserDefaults.standard.object(forKey: "user") as! NSData
        let userModel:XHWLUserModel = XHWLUserModel.mj_object(withKeyValues: data.mj_JSONObject())
        
        XHWLNetwork.shared.getLogoutClick([userModel.wyAccount.token] as NSArray, self)
    }
    
    // 注销
    func regist() {
        
        UserDefaults.standard.set(false, forKey: "isLogin")
        UserDefaults.standard.synchronize()
        MCUVmsNetSDK.shareInstance().logoutMsp({ (object) in
            //            self.navigationController?.popViewController(animated: true)
        }) { (error) in
            
            print("注销失败")
        }
    }
    
    func onSuccessLogout() {
        self.regist()
        UserDefaults.standard.set("", forKey: "user")
        UserDefaults.standard.set("", forKey: "projectList")
        UserDefaults.standard.synchronize()
        
        JPUSHService.cleanTags({ (iResCode, iAlias, seq) in
            
        }, seq: 0)
        JPUSHService.deleteAlias({ (iResCode, iAlias, seq) in
            
        }, seq: 0)
        
        let window:UIWindow = UIApplication.shared.keyWindow!
        window.rootViewController = XHWLLoginVC()
    }
    
    // 获取新版本
    func loadNewVersionInfo() {
        
//        shareAppVersionAlert()
        
        // 上传到后台， 返回url
        XHWLNetwork.shared.postNewVersionClick(["type":"wyIOS"], self)
    }
    
    
    
    //判断是否需要提示更新App
    func shareAppVersionAlert() {
//        if !judgeNeedVersionUpdate() {
//            return
//        }
        
        //App内info.plist文件里面版本号
        let infoDict:NSDictionary = Bundle.main.infoDictionary! as NSDictionary
        let appVersion:String = infoDict["CFBundleShortVersionString"] as! String
        let bundleId:String = infoDict["CFBundleIdentifier"] as! String
        let urlString:String = "https://itunes.apple.com/cn/lookup?bundleid=\(bundleId)"
        //两种请求appStore最新版本app信息 通过bundleId与appleId判断
        //[NSString stringWithFormat:@"https://itunes.apple.com/cn/lookup?bundleid=%@", bundleId]
        //[NSString stringWithFormat:@"https://itunes.apple.com/cn/lookup?id=%@", appleid]
        let urlStr:URL = URL.init(string: urlString)!
        //创建请求体
        let urlRequest:URLRequest = URLRequest.init(url: urlStr)
        
        Alamofire.request(urlString, method: .get, parameters:nil, encoding: URLEncoding.default)
            .responseJSON { response in

                print("response:\(response)")
                

                switch response.result {
                case .success(let value):
                    
                    let dict:NSDictionary = value as! NSDictionary
                    let sourceArray:NSArray = dict["results"] as! NSArray
                    if sourceArray.count >= 1 {
                        //AppStore内最新App的版本号
                        let sourceDict:NSDictionary = sourceArray[0] as! NSDictionary
                        let newVersion:String = sourceDict["version"] as! String
                        if self.judgeNewVersion(newVersion, oldVersion: appVersion) {
                            
                            print("跳转到AppStore")
                            //跳转到AppStore，该App下载界面
                            UIApplication.shared.openURL(URL.init(string: sourceDict["trackViewUrl"] as! String)!)
                            
                            //                                                            UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示:\n您的App不是最新版本，请问是否更新" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                            //                                                            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"暂不更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            //                                                                //                    [alertVc dismissViewControllerAnimated:YES completion:nil];
                            //                                                                }];
                            //                                                            [alertVc addAction:action1];
                            //                                                            UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"去更新" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                            //                                                                //跳转到AppStore，该App下载界面
                            //                                                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:sourceDict[@"trackViewUrl"]]];
                            //                                                               }];
                            //                                                            [alertVc addAction:action2];
                            //                                                            [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:alertVc animated:YES completion:nil];
                        }
                    }

                case .failure(let error):
                    print("error:\(error)")

                    "请求失败！".ext_debugPrintAndHint()
                }
        }
    }
    
    //每天进行一次版本判断
    func judgeNeedVersionUpdate() -> Bool {
        let formatter:DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        //获取年-月-日
        let dateString:String = formatter.string(from: Date())
        guard let currentDate:String = UserDefaults.standard.object(forKey: "currentDate") as? String  else {
            return false
        }
        
        if currentDate == dateString {
            return false
        }
        UserDefaults.standard.set(dateString, forKey: "currentDate")
        
        return true
    }
    
    //判断当前app版本和AppStore最新app版本大小
    func judgeNewVersion(_ newVersion:String, oldVersion:String) -> Bool {
        let newArray:NSArray = newVersion.components(separatedBy: ".") as NSArray
        let oldArray:NSArray = oldVersion.components(separatedBy: ".") as NSArray
        for i in 0..<newArray.count {
            if (newArray[i] as! NSInteger) > (oldArray[i] as! NSInteger) {
                return true
            } else if (newArray[i] as! NSInteger) < (oldArray[i] as! NSInteger) {
                return false
            } else {
                
            }
        }
        return false
    }
}

// MARK: - XHWLNetworkDelegate
extension AppDelegate: XHWLNetworkDelegate {
    
    func requestSuccess(_ requestKey:NSInteger, _ response:[String : AnyObject]) {
        
        if requestKey == XHWLRequestKeyID.XHWL_LOGOUT.rawValue {
            
            onSuccessLogout()
        }
        else if requestKey == XHWLRequestKeyID.XHWL_NEWVERSION.rawValue {
//            createTime = 1510022947000;
//            description = "\U7269\U4e1a\U7aefIOS\U6700\U65b0\U7248\U672c\Uff1a\U66f4\U65b0\U5185\U5bb9****";
//            id = 402880415f946052015f9461a3340000;
//            isNewest = 1;
//            link = "<null>";
//            type = wyIOS;
//            versionNo = "0.11";
            if (response["errorCode"] as! NSInteger) == 200 {
                print("\(response)")
                
                let result:NSDictionary = response["result"] as! NSDictionary
                
                let currentVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
                if currentVersion != (result["versionNo"] as! String) {
                    
                    let currentVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
                    UserDefaults.standard.set(currentVersion, forKey:"versionCode")
                    UserDefaults.standard.synchronize()
                    
                    // 跳转到对应的appStore  https://itunes.apple.com/cn/app/小七专家/id1283925515?l=en&mt=8
                    print("跳转到AppStore")
                    //跳转到AppStore，该App下载界面
//                    UIApplication.shared.openURL(URL.init(string: "https://itunes.apple.com/cn/app/小七专家/id1283925515?l=en&mt=8")!)
                }
            }
        }
    }
    
    func requestFail(_ requestKey:NSInteger, _ error:NSError) {
        
    }
}
