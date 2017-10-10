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
class AppDelegate: UIResponder, UIApplicationDelegate, BMKGeneralDelegate , JPUSHRegisterDelegate, XHWLNetworkDelegate, UIAlertViewDelegate { // JPUSHRegisterDelegate

    var window: UIWindow?
    var _mapManager: BMKMapManager?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        UIScreen.main.brightness = 0.5
       
        IQKeyboardManager.sharedManager().enable = true
        configureMCU()      // 对接海康威视
        configureMapKit()   // 初始化百度地图
        setupMapKit()       // 百度地图
        setupJPush(launchOptions)
        
        self.window?.backgroundColor = UIColor.white
        self.window = UIWindow(frame: UIScreen.main.bounds)
//        [self configTestin];            // 蒲公英
        setupView()
        
        if UserDefaults.standard.object(forKey: "user") == nil {
            let vc : XHWLLoginVC = XHWLLoginVC()
            self.window?.rootViewController = UINavigationController(rootViewController: vc)
            self.window?.makeKeyAndVisible()
        } else {
            if UserDefaults.standard.object(forKey: "user") is String {
                let vc : XHWLLoginVC = XHWLLoginVC()
                self.window?.rootViewController = UINavigationController(rootViewController: vc)
            } else {
                let data:NSData = UserDefaults.standard.object(forKey: "user") as! NSData
                let dict:NSDictionary = data.mj_JSONObject() as! NSDictionary
                let userModel:XHWLUserModel = XHWLUserModel.mj_object(withKeyValues: dict)
                if userModel.wyAccount.token == "" {
                    let vc : XHWLLoginVC = XHWLLoginVC()
                    self.window?.rootViewController = UINavigationController(rootViewController: vc)
                    
                } else {
                    onTabbar()
                }
            }
        }
        
        JPUSHService.getAllTags({ (iResCode, iAlias, seq) in
            print("\(iAlias)")
        }, seq: 0)
        
        self.window?.makeKeyAndVisible()
        
        launchAnimation()
        
        return true
    }
    
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
    private func launchAnimation() {
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
    
    //播放启动画面动画
//    private func launchAnimation() {
//        //获取启动视图
//        let vc = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateViewController(withIdentifier: "launch")
//        let launchview = vc.view!
//        let delegate = UIApplication.shared.delegate
//        delegate?.window!!.addSubview(launchview)
//
//        //self.view.addSubview(launchview) //如果没有导航栏，直接添加到当前的view即可
//
//        //播放动画效果，完毕后将其移除
//        UIView.animate(withDuration: 1, delay: 1.5, options: .beginFromCurrentState,
//                       animations: {
//                        launchview.alpha = 0.0
//                        let transform = CATransform3DScale(CATransform3DIdentity, 1.5, 1.5, 1.0)
//                        launchview.layer.transform = transform
//        }) { (finished) in
//            launchview.removeFromSuperview()
//        }
//    }
    
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
    
    func setupView() {
        let bgImg:UIImageView = UIImageView()
        bgImg.frame = UIScreen.main.bounds
        bgImg.image = UIImage(named:"home_bg")
        self.window?.addSubview(bgImg)
    }
    
//    // 配置蒲公英
//    -(void)configTestin
//    {
//    //启动基本SDK
//    [[PgyManager sharedPgyManager] startManagerWithAppId:@"a186c57137749ff3f0d2e98067a138e5"];
//    //启动更新检查SDK
//    [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:@"a186c57137749ff3f0d2e98067a138e5"];
//    }
    
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
                           apsForProduction: true) // 0 (默认值)表示采用的是开发证书，1 表示采用生产证书发布应用
        
        if (UIDevice.current.systemVersion as NSString).floatValue >= 9.0 &&
            (UIDevice.current.systemVersion as NSString).floatValue <= 10.3 {
            let defaultCenter:NotificationCenter = NotificationCenter.default
            defaultCenter.addObserver(self, selector: #selector(networkDidReceiveMessage), name: NSNotification.Name.jpfNetworkDidReceiveMessage, object: nil)
        }
    }
    
    func networkDidReceiveMessage(_ notification:Notification) {
        
        let userInfo:NSDictionary = notification.userInfo as! NSDictionary
        print("\(userInfo)")
        
        if (UserDefaults.standard.object(forKey: "user") != nil) &&
            !(UserDefaults.standard.object(forKey: "user") is String) {
            let data:NSData = UserDefaults.standard.object(forKey: "user") as! NSData
            let userModel:XHWLUserModel = XHWLUserModel.mj_object(withKeyValues: data.mj_JSONObject())
//            if userModel.wyAccount.wyRole.name.compare("安管主任").rawValue == 0 {
            
                print("\(userInfo["key"])")
                let extras:NSDictionary = userInfo.value(forKey: "extras") as! NSDictionary
                let keyStr:String = extras["key"] as! String
                //                let keyDict:NSDictionary = self.getDictionaryFromJSONString(keyStr)
                if keyStr == "complaint" { // 安防事件 后台时要给提示
                    
//                    let index:NSInteger =  Int(UserDefaults.standard.integer(forKey: "safeProtectAlert")) + 1
//
//                    UserDefaults.standard.set(index, forKey: "safeProtectAlert")
//                    UserDefaults.standard.synchronize()
//
//                    UIApplication.shared.applicationIconBadgeNumber = index
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "safeProtectNC"), object: nil)
                    
                }
//            }
        }
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
        UIScreen.main.brightness = 0.5
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
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

    // MARK - BMKGeneralDelegate
    func onGetNetworkState(_ iError: Int32) {
        if (0 == iError) {
            NSLog("联网成功");
        }
        else{
            NSLog("联网失败，错误代码：Error\(iError)");
            "网络连接失败".ext_debugPrintAndHint()
        }
    }
    
    func onGetPermissionState(_ iError: Int32) {
        if (0 == iError) {
            NSLog("授权成功");
        }
        else{
            NSLog("授权失败，错误代码：Error\(iError)");
            "地图授权失败".ext_debugPrintAndHint()
        }
    }
    
    // MARK: - 推送
    // 注册APNs成功并上报DeviceToken 启动注册token
    // 请在AppDelegate.m实现该回调方法并添加回调方法中的代码
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        /// Required - 注册 DeviceToken
        JPUSHService.registerDeviceToken(deviceToken)
    }
    
    // 实现注册APNs失败接口可选）
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("did Fail To Register For Remote Notifications With Error: \(error)")
    }
    

    
    // MARK: - JPUSHRegisterDelegate
    
    // iOS 10 Support
    
    // MARK: - JPUSHRegisterDelegate
    @available(iOS 10.0, *)
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
        let aps:NSDictionary = userInfo["aps"] as! NSDictionary
        "\(aps["alert"]!)".ext_debugPrintAndHint()
        if (UserDefaults.standard.object(forKey: "user") != nil) &&
            !(UserDefaults.standard.object(forKey: "user") is String) {
            let keyStr:String = userInfo["key"] as! String
            if keyStr == "complaint" { // 安防事件 后台时要给提示
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "safeProtectNC"), object: nil)
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
        
        print("\(userInfo)")
        let aps:NSDictionary = userInfo["aps"] as! NSDictionary
        
        "\(aps["alert"]!)".ext_debugPrintAndHint()
        
        if (UserDefaults.standard.object(forKey: "user") != nil) &&
            !(UserDefaults.standard.object(forKey: "user") is String) {
                let keyStr:String = userInfo["key"] as! String
                if keyStr == "complaint" { // 安防事件 后台时要给提示
                
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "safeProtectNC"), object: nil)
                }
        }
        
        completionHandler();  // 系统要求执行这个方法
    }

    // ios 9 系统提示   在前台时调用
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        // Required, iOS 7 Support
        JPUSHService.handleRemoteNotification(userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
        print("\(userInfo)")
        let aps:NSDictionary = userInfo["aps"] as! NSDictionary
        "\(aps["alert"]!)".ext_debugPrintAndHint()
        
        if application.applicationState == UIApplicationState.active {
            // 代表从前台接受消息app
            
            if (UserDefaults.standard.object(forKey: "user") != nil) &&
                !(UserDefaults.standard.object(forKey: "user") is String) {
                let keyStr:String = userInfo["key"] as! String
                if keyStr == "complaint" { // 安防事件 后台时要给提示
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "safeProtectNC"), object: nil)
                }
            }
        }else{
            // 代表从后台接受消息后进入app
//            UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        }
        
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
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        // Required,For systems with less than or equal to iOS6
        JPUSHService.handleRemoteNotification(userInfo)
        print("\(userInfo)")
    }
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        print("\(notification.alertTitle) = \(notification.userInfo)")
    }

    class func shared() ->AppDelegate {
    
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func onLogout() {
        let data:NSData = UserDefaults.standard.object(forKey: "user") as! NSData
        let userModel:XHWLUserModel = XHWLUserModel.mj_object(withKeyValues: data.mj_JSONObject())
        
        XHWLNetwork.shared.getLogoutClick([userModel.wyAccount.token] as NSArray, self)
    }
    // MARK: - XHWLNetworkDelegate
    
    func requestSuccess(_ requestKey:NSInteger, _ response:[String : AnyObject]) {
        
        if requestKey == XHWLRequestKeyID.XHWL_LOGOUT.rawValue {
            
            UserDefaults.standard.set("", forKey: "user")
            UserDefaults.standard.set("", forKey: "projectList")
            UserDefaults.standard.synchronize()
            
            JPUSHService.cleanTags({ (iResCode, iAlias, seq) in
                
            }, seq: 0)
            
            let window:UIWindow = UIApplication.shared.keyWindow!
            window.rootViewController = XHWLLoginVC()
        }
    }
    
    func requestFail(_ requestKey:NSInteger, _ error:NSError) {
        
    }
}

