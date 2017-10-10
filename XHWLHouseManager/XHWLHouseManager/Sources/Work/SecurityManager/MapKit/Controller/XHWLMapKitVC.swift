//
//  XHWLMapKitVC.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/7.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit
import MapKit

class XHWLMapKitVC: UIViewController , BMKMapViewDelegate, BMKLocationServiceDelegate, XHWLNetworkDelegate {

    var _mapView: BMKMapView!
    var enableCustomMap = true
    var bgImg:UIImageView!
    var locationService:BMKLocationService!
    var coordinate:CLLocationCoordinate2D! // 我的当前位置
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bgImg = UIImageView()
        bgImg.frame = self.view.bounds
        bgImg.image = UIImage(named:"home_bg")
        self.view.addSubview(bgImg)
        
        self.title = "巡更定位"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"scan_back"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(onBack))
        
        setupMapKit()
        setupLocation()
        onLoadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        BMKMapView.enableCustomMapStyle(enableCustomMap)
        _mapView?.viewWillAppear()
        _mapView?.delegate = self
        locationService.delegate = self
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        locationService.delegate = self
        BMKMapView.enableCustomMapStyle(false)//消失时，关闭个性化地图
        _mapView?.viewWillDisappear()
        _mapView?.delegate = nil
        
    }
    
    func onLoadData() {
        
        let data:NSData = UserDefaults.standard.object(forKey: "user") as! NSData
        let userModel:XHWLUserModel = XHWLUserModel.mj_object(withKeyValues: data.mj_JSONObject())
        
        XHWLNetwork.shared.getMapkitClick([userModel.wyAccount.token] as NSArray, self)
    }
    
    // MARK: - XHWLNetworkDelegate
    
    func requestSuccess(_ requestKey:NSInteger, _ response:[String : AnyObject]) {
        
        if requestKey == XHWLRequestKeyID.XHWL_MAPKIT.rawValue {

            if response["result"] is NSNull {
                return
            }
            let dict:NSDictionary = response["result"] as! NSDictionary
            let dealArray:NSArray = XHWLMapKitModel.mj_objectArray(withKeyValuesArray:dict["collectNodes"] as! NSArray)
            
            for i in 0..<dealArray.count {
                let model:XHWLMapKitModel = dealArray[i] as! XHWLMapKitModel
                
                
                let coor:CLLocationCoordinate2D = CLLocationCoordinate2DMake(Double(model.latitude)!, Double(model.longitude)!)
                stickAnnotation(coor, model)
                
            }
            
        }
        
    }
    
    func requestFail(_ requestKey:NSInteger, _ error:NSError) {
        
    }
    
    // 添加大头针
    func stickAnnotation(_ coordinate:CLLocationCoordinate2D, _ model:XHWLMapKitModel) {
        // 添加一个PointAnnotation
        let annotation: BMKPointAnnotation = BMKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = model.nickname
        //        annotation.subtitle = "声明"
        _mapView?.addAnnotation(annotation)
    }
    
    // 移除大头针
    func removeAnnotation() {
        //        if (annotation != nil) {
        //            _mapView?.removeAnnotation(annotation)
        //        }
    }
    
    // MARK: - 初始化地图和定位
    func setupMapKit() {
        
        let topHeight = (self.navigationController?.navigationBar.frame.height)! + UIApplication.shared.statusBarFrame.height
        _mapView = BMKMapView(frame: CGRect(x: 0, y: topHeight, width: self.view.frame.width, height: self.view.frame.height - topHeight))
        /// logo位置，默认BMKLogoPositionLeftBottom
        _mapView?.logoPosition = BMKLogoPositionLeftBottom
        _mapView?.mapType = UInt(BMKMapTypeStandard)     /// 当前地图类型，可设定为标准地图、卫星地图
        _mapView?.showMapScaleBar = true /// 设定是否显式比例尺
        
        /// 限制地图的显示范围（地图状态改变时，该范围不会在地图显示范围外。设置成功后，会调整地图显示该范围）
//                _mapView?.limitMapRegion = BMKCoordinateRegionMake(CLLocationCoordinate2DMake(34, 34), BMKCoordinateSpanMake(23, 23))
        
        _mapView?.zoomLevel = 3 // 地图比例尺级别，在手机上当前可使用的级别为3-21级
        _mapView?.minZoomLevel = 3 // 地图的自定义最小比例尺级别
        _mapView?.maxZoomLevel = 20 /// 地图的自定义最大比例尺级别
        _mapView?.rotation = 120  /// 地图旋转角度，在手机上当前可使用的范围为－180～180度
        
        //        ///设定地图View能否支持所有手势操作
        //        _mapView?.gesturesEnabled = true
        //        ///设定地图View能否支持用户多点缩放(双指)
        //        _mapView?.isZoomEnabled = true
        //        ///设定地图View能否支持用户缩放(双击或双指单击)
        //        _mapView?.isZoomEnabledWithTap = true
        //        ///设定地图View能否支持用户移动地图
        //        _mapView?.isScrollEnabled = true
        //        ///设定地图View能否支持俯仰角
        //        _mapView?.isOverlookEnabled = true
        //        ///设定地图View能否支持旋转
        //        _mapView?.isRotateEnabled = true
        //
        //        /// 比例尺的位置，设定坐标以BMKMapView左上角为原点，向右向下增长
        //        _mapView?.mapScaleBarPosition = CGPoint(x: 0, y: 0)
        
        
        ///双击手势放大地图时, 设置为YES, 地图中心点移动至点击处; 设置为NO，地图中心点不变；默认为YES;
        //        @property(nonatomic, getter=isChangeCenterWithDoubleTouchPointEnabled) BOOL ChangeCenterWithDoubleTouchPointEnabled;
        ///若isLockedToScreen为false，拖动地图时annotation会跟随移动。 支持标注锁定在屏幕固定位置
        
        
        self.view.addSubview(_mapView!)
    }
    
    // MARK: -
    
    func setupLocation() {
        locationService = BMKLocationService()
        locationService.delegate = self
 
        //使用百度地图自带的定位功能
//        [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyBest];
//        [BMKLocationService setLocationDistanceFilter:100.f];
        
//        locationService.startMonitoringSignificantLocationChanges()
        
//        if BMKLocationService.l
//        if (![CLLocationManager locationServicesEnabled]) {
//
//            NSLog(@"定位服务当前可能尚未打开，请设置打开！");
//
//            return;
//
//        }
//
//        else {
//
//            NSLog(@"定位服务已开启");
//
//        }
//
//        //    如果没有授权则请求用户授权
//
//        if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
//
//            [locationMgr requestAlwaysAuthorization];
//
//            NSLog(@"请求用户授权");
//
//        }else
        
        
        locationService.startUserLocationService() // 开始定位
        _mapView.showsUserLocation = false//先关闭显示的定位图层
        _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
        _mapView.showsUserLocation = true//显示定位图层

    }
    
    func onBack(){
        self.navigationController?.popViewController(animated: true)
    }

    // MARK: - 定位服务代理
    
    /**
     *在将要启动定位时，会调用此函数
     */
    func willStartLocatingUser() {
        print("willStartLocatingUser");
    }
    
    
    /**
     *在停止定位后，会调用此函数
     */
    func didStopLocatingUser() {
        print("didStopLocatingUser")
    }
    
    /**
     *用户方向更新后，会调用此函数
     *@param userLocation 新的用户位置
     */
    func didUpdateUserHeading(_ userLocation: BMKUserLocation!) {
        print("heading is \(userLocation.heading)")
        _mapView.updateLocationData(userLocation)
    }
    
    /**
     *用户位置更新后，会调用此函数
     *@param userLocation 新的用户位置
     */
    func didUpdate(_ userLocation: BMKUserLocation!) {
        print("didUpdateUserLocation lat:\(userLocation.location.coordinate.latitude) lon:\(userLocation.location.coordinate.longitude)")
        _mapView.updateLocationData(userLocation)
     
        coordinate = userLocation.location.coordinate
        updateMapKit()
        locationService.stopUserLocationService()
    }
    
    // 更新地图显示
    func updateMapKit() {
        _mapView?.region = BMKCoordinateRegionMake(coordinate, BMKCoordinateSpanMake(0.1, 0.1))
        // 当前地图的中心点，改变该值时，地图的比例尺级别不会发生变化
        _mapView?.centerCoordinate = coordinate
//        stickAnnotation(coordinate)
        
//        BMKPointAnnotation
        
        let annotation: XHWLCustomAnnotation = XHWLCustomAnnotation()
        annotation.coordinate = coordinate
//                annotation.title = ""
        //        annotation.subtitle = "声明"
        _mapView?.addAnnotation(annotation)
        
        /// 限制地图的显示范围（地图状态改变时，该范围不会在地图显示范围外。设置成功后，会调整地图显示该范围）
        _mapView?.region = BMKCoordinateRegionMake(coordinate, BMKCoordinateSpanMake(0.001, 0.001))
    }
    
    /**
     *定位失败后，会调用此函数
     *@param error 错误号
     */
    func didFailToLocateUserWithError(_ error: Error!) {
        print("didFailToLocateUserWithError")
    }
    
    // MARK: - BMKGeoCodeSearchDelegate
    
    /**
     *返回地址信息搜索结果
     *@param searcher 搜索对象
     *@param result 搜索结BMKGeoCodeSearch果
     *@param error 错误号，@see BMKSearchErrorCode
     */
    func onGetGeoCodeResult(_ searcher: BMKGeoCodeSearch!, result: BMKGeoCodeResult!, errorCode error: BMKSearchErrorCode) {
        print("onGetGeoCodeResult error: \(error)")
        
        _mapView.removeAnnotations(_mapView.annotations)
        if error == BMK_SEARCH_NO_ERROR {
            let item = BMKPointAnnotation()
            item.coordinate = result.location
            item.title = result.address
            _mapView.addAnnotation(item)
            _mapView.centerCoordinate = result.location
            
            let showMessage = "纬度:\(item.coordinate.latitude)，经度:\(item.coordinate.longitude)"
            
            let alertView = UIAlertController(title: "正向地理编码", message: showMessage, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertView.addAction(okAction)
            self.present(alertView, animated: true, completion: nil)
        }
    }
    
    /**
     *返回反地理编码搜索结果
     *@param searcher 搜索对象
     *@param result 搜索结果
     *@param error 错误号，@see BMKSearchErrorCode
     */
    func onGetReverseGeoCodeResult(_ searcher: BMKGeoCodeSearch!, result: BMKReverseGeoCodeResult!, errorCode error: BMKSearchErrorCode) {
        print("onGetReverseGeoCodeResult error: \(error)")
        
        _mapView.removeAnnotations(_mapView.annotations)
        if error == BMK_SEARCH_NO_ERROR {
            let item = BMKPointAnnotation()
            item.coordinate = result.location
            item.title = result.address
            _mapView.addAnnotation(item)
            _mapView.centerCoordinate = result.location
            
//            CustomPointAnnotation
            
            let alertView = UIAlertController(title: "反向地理编码", message: result.address, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertView.addAction(okAction)
            self.present(alertView, animated: true, completion: nil)
        }
    }
    
    // MARK: - BMKMapViewDelegate
    
    /**
     *地图初始化完毕时会调用此接口
     *@param mapView 地图View
     */
    func mapViewDidFinishLoading(_ mapView: BMKMapView!) {
        // 打大头针
        print("地图加载完毕！")
    }
    
    /**
     *地图渲染完毕后会调用此接口
     *@param mapView 地图View
     */
    func mapViewDidFinishRendering(_ mapView: BMKMapView!) {
        
        print("地图渲染完毕！")
    }
    
    /**
     *根据anntation生成对应的View
     *@param mapView 地图View
     *@param annotation 指定的标注
     *@return 生成的标注View
     */
    func mapView(_ mapView: BMKMapView!, viewFor annotation: BMKAnnotation!) -> BMKAnnotationView! {
        // 动画标注
        if annotation is XHWLCustomAnnotation {
            let AnnotationViewID = "AnimatedAnnotationView"
            let annotationView = AnimatedAnnotationView(annotation: annotation, reuseIdentifier: AnnotationViewID)
            
            return annotationView
        } else if annotation is BMKPointAnnotation {
            print("\(annotation)")
            let AnnotationViewID = "OtherAnimatedAnnotationView"
            let annotationView = OtherAnimatedAnnotationView(annotation: annotation, reuseIdentifier: AnnotationViewID)
            
            return annotationView
        }
        
        return nil
    }
    
    /**
     *当mapView新添加annotation views时，调用此接口
     *@param mapView 地图View
     *@param views 新添加的annotation views
     */
    func mapView(_ mapView: BMKMapView!, didAddAnnotationViews views: [Any]!) {
        NSLog("didAddAnnotationViews")
    }
    
    /**
     *当选中一个annotation views时，调用此接口
     *@param mapView 地图View
     *@param views 选中的annotation views
     */
    func mapView(_ mapView: BMKMapView!, didSelect view: BMKAnnotationView!) {
        NSLog("选中了标注")
//        _shopCoor = view.annotation.coordinate;
    }
    
    /**
     *当取消选中一个annotation views时，调用此接口
     *@param mapView 地图View
     *@param views 取消选中的annotation views
     */
    func mapView(_ mapView: BMKMapView!, didDeselect view: BMKAnnotationView!) {
        NSLog("取消选中标注")
    }
    
    /**
     *拖动annotation view时，若view的状态发生变化，会调用此函数。ios3.2以后支持
     *@param mapView 地图View
     *@param view annotation view
     *@param newState 新状态
     *@param oldState 旧状态
     */
    func mapView(_ mapView: BMKMapView!, annotationView view: BMKAnnotationView!, didChangeDragState newState: UInt, fromOldState oldState: UInt) {
        NSLog("annotation view state change : \(oldState) : \(newState)")
    }
    
    /**
     *当点击annotation view弹出的泡泡时，调用此接口
     *@param mapView 地图View
     *@param view 泡泡所属的annotation view
     */
    func mapView(_ mapView: BMKMapView!, annotationViewForBubble view: BMKAnnotationView!) {
        NSLog("点击了泡泡")
        
//        MyBMKPointAnnotation *tt = (MyBMKPointAnnotation *)view.annotation;
//        if (tt.shopID) {
//            BusinessIfonUVC *BusinessIfonVC = [[BusinessIfonUVC alloc]init];
//            BusinessIfonVC.shopId = tt.shopID;
//            [self.navigationController pushViewController:BusinessIfonVC animated:YES];
//        }
    }
}
