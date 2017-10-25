//
//  XHWLMapKitVC.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/7.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit
import MapKit

class XHWLMapKitVC: XHWLBaseVC , BMKMapViewDelegate, BMKLocationServiceDelegate, XHWLNetworkDelegate {

    var _mapView: BMKMapView!
    var enableCustomMap = true
    var subBgIV:UIImageView!
    var topView:XHWLMapKitTopView!
    var locationService:BMKLocationService!
    var coordinate:CLLocationCoordinate2D! // 我的当前位置
    var annotationArray:NSMutableArray! = NSMutableArray()
    var selectAllBtn:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        bgImg = UIImageView()
//        bgImg.frame = self.view.bounds
//        bgImg.image = UIImage(named:"home_bg")
//        self.view.addSubview(bgImg)
        
//        let topHeight = (self.navigationController?.navigationBar.frame.height)! + UIApplication.shared.statusBarFrame.height
        subBgIV = UIImageView(frame: CGRect(x:10, y:64+20, width:Screen_width-20, height:Screen_height-64-20-20))
        subBgIV.image = UIImage(named:"subview_bg")
        self.view.addSubview(subBgIV)
        
        self.title = "巡更定位"
//        self.navigationItem.leftBarButtonItem = UI BarButtonItem(image: UIImage(named:"scan_back"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(onBack))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"Patrol_switch"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(onSwitchClick))
        
        setupMapKit()
        setupLocation()
        onLoadData()
        setupUI()
    }
    
    func onSwitchClick() {
        let vc:XHWLCountVC = XHWLCountVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setupUI() {
//        let topHeight = (self.navigationController?.navigationBar.frame.height)! + UIApplication.shared.statusBarFrame.height
        topView = XHWLMapKitTopView(frame:CGRect(x:10, y:64+30, width:Screen_width-20, height:100))
        self.view.addSubview(topView)
        
        selectAllBtn = UIButton()
        selectAllBtn.setTitleColor(UIColor.black, for: .normal)
        selectAllBtn.setTitle("显示巡更进度", for: .normal)
        selectAllBtn.setImage(UIImage(named:"Patrol_unSelected"), for: .normal)
        selectAllBtn.setImage(UIImage(named:"Patrol_selected"), for: .selected)
        selectAllBtn.titleLabel?.font = font_14
        selectAllBtn.setBackgroundImage(UIImage(named:"Patrol_white_bg"), for: .normal)
        selectAllBtn.setBackgroundImage(UIImage(named:"Patrol_white_bg"), for: .highlighted)
        selectAllBtn.addTarget(self, action: #selector(selectAllAnnotations), for: .touchUpInside)
        selectAllBtn?.frame = CGRect(x:Screen_width-120-20, y:Screen_height-80, width:120, height:30)
        self.view.addSubview(selectAllBtn)
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
            var dealArray:NSArray = XHWLMapKitModel.mj_objectArray(withKeyValuesArray:dict["collectNodes"] as! NSArray)
            
            annotationArray = NSMutableArray()
            _mapView.removeAnnotations(_mapView.annotations)
            _mapView.removeOverlays(_mapView.overlays)
           
            ////////
            let noDelAry:NSMutableArray = NSMutableArray()
            for j in 0..<4 {
                switch j {
                case 0:
                    let model:XHWLMapKitModel = XHWLMapKitModel()
                    model.latitude = "22.549329"
                    model.longitude = "113.959076"
                    model.nickname = "0"
                    noDelAry.add(model)
                case 1:
                    let model:XHWLMapKitModel = XHWLMapKitModel()
                    model.latitude = "22.649329"
                    model.longitude = "113.959076"
                    model.nickname = "1"
                    noDelAry.add(model)
                case 2:
                    let model:XHWLMapKitModel = XHWLMapKitModel()
                    model.latitude = "22.659329"
                    model.longitude = "113.859076"
                    model.nickname = "3"
                    noDelAry.add(model)
                case 3:
                    let model:XHWLMapKitModel = XHWLMapKitModel()
                    model.latitude = "22.549329"
                    model.longitude = "113.879076"
                    model.nickname = "2"
                    noDelAry.add(model)
                default:
                    break
                }
            }
            
            dealArray = noDelAry
            ///////

            for i in 0..<dealArray.count {
                let model:XHWLMapKitModel = dealArray[i] as! XHWLMapKitModel
                
                let coor:CLLocationCoordinate2D = CLLocationCoordinate2DMake(Double(model.latitude)!, Double(model.longitude)!)
                stickAnnotation(coor, model)
            }
            setupLine(dealArray)
        }
    }
    
    func setupLine(_ dealAry:NSArray) {// BMKMapPoint
        
        var tempPoints = Array(repeating: CLLocationCoordinate2DMake(0, 0), count: dealAry.count)

        for i in 0..<dealAry.count {
            let pointAnno:XHWLMapKitModel = dealAry[i] as! XHWLMapKitModel
            tempPoints[i].latitude = Double(pointAnno.latitude)!
            tempPoints[i].longitude = Double(pointAnno.longitude)!
        }
        
//        let polyLine = BMKPolygon(coordinates:&tempPoints, count: UInt(annotationArray.count))! // 多边形
        let polyLine = BMKPolyline(coordinates:&tempPoints, count: UInt(dealAry.count))
        
        // 添加路线 overlay
        _mapView.add(polyLine)
    }
    
    func requestFail(_ requestKey:NSInteger, _ error:NSError) {
        
    }
      
    // 添加大头针
    func stickAnnotation(_ coor:CLLocationCoordinate2D, _ model:XHWLMapKitModel) {
        // 添加一个PointAnnotation
        let annotation: XHWLCustomAnnotation = XHWLCustomAnnotation()
        annotation.coordinate = coor
        annotation.title = model.nickname
        annotation.type = 2
        _mapView?.addAnnotation(annotation)
        
        annotationArray.add(annotation)
    }
    
    // MARK: - 初始化地图和定位
    func setupMapKit() {
        
//        let topHeight = (self.navigationController?.navigationBar.frame.height)! + UIApplication.shared.statusBarFrame.height
//        _mapView = BMKMapView(frame: CGRect(x: 0, y: topHeight, width: self.view.frame.width, height: self.view.frame.height - topHeight))
       
        _mapView = BMKMapView(frame: CGRect(x:10+2, y:64+20+2, width:Screen_width-20-4, height:Screen_height-64-20-20-4))
        _mapView?.logoPosition = BMKLogoPositionLeftBottom  /// logo位置，默认BMKLogoPositionLeftBottom
        _mapView?.mapType = UInt(BMKMapTypeStandard)        /// 当前地图类型，可设定为标准地图、卫星地图
        _mapView?.showMapScaleBar = true /// 设定是否显式比例尺
        _mapView?.zoomLevel = 3         // 地图比例尺级别，在手机上当前可使用的级别为3-21级
        _mapView?.minZoomLevel = 3      // 地图的自定义最小比例尺级别
        _mapView?.maxZoomLevel = 20     /// 地图的自定义最大比例尺级别
        _mapView?.rotation = 120        /// 地图旋转角度，在手机上当前可使用的范围为－180～180度
   
        self.view.addSubview(_mapView!)
    }
    
    // MARK: -
    
    func setupLocation() {
        locationService = BMKLocationService()
        locationService.delegate = self
 
        locationService.startUserLocationService() // 开始定位
        _mapView.showsUserLocation = false//先关闭显示的定位图层
        _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
        _mapView.showsUserLocation = true//显示定位图层

    }
    
//    func onBack(){
//        self.navigationController?.popViewController(animated: true)
//    }

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

        let annotation: XHWLCustomAnnotation = XHWLCustomAnnotation()
        annotation.coordinate = coordinate
        annotation.type = 1
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
    
    //根据overlay生成对应的View
    func mapView(_ mapView: BMKMapView!, viewFor overlay: BMKOverlay!) -> BMKOverlayView! {
        if overlay is BMKPolyline {
            let polygonView:BMKPolylineView = BMKPolylineView.init(overlay: overlay)
            polygonView.fillColor = UIColor.blue
            polygonView.strokeColor = UIColor.blue
            polygonView.lineWidth = 3.0
            return polygonView
        }
        return nil
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
            let anno:XHWLCustomAnnotation = annotation as! XHWLCustomAnnotation
            if anno.type == 1 {
                let AnnotationViewID = "XHWLMeAnnotationView"
                let annotationView = XHWLMeAnnotationView(annotation: annotation, reuseIdentifier: AnnotationViewID)
                
                return annotationView
            } else if anno.type == 2 {
                
                let AnnotationViewID = "XHWLOtherAnnotationView"
                let annotationView = XHWLOtherAnnotationView(annotation: annotation, reuseIdentifier: AnnotationViewID)
                
                return annotationView
            }
        }
        
        return nil
    }
    
    func selectAllAnnotations() {
        for i in 0..<annotationArray.count {
            let anno:XHWLCustomAnnotation = annotationArray[i] as! XHWLCustomAnnotation
            _mapView.selectAnnotation(anno, animated: true)
        }
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


