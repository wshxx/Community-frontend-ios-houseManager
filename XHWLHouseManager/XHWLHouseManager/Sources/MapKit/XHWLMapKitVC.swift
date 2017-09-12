//
//  XHWLMapKitVC.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/7.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit
import MapKit

class XHWLMapKitVC: UIViewController , BMKMapViewDelegate {

    var _mapView: BMKMapView?
    var enableCustomMap = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let topHeight = (self.navigationController?.navigationBar.frame.height)! + UIApplication.shared.statusBarFrame.height
        
        _mapView = BMKMapView(frame: CGRect(x: 0, y: topHeight, width: self.view.frame.width, height: self.view.frame.height - topHeight))
        /// logo位置，默认BMKLogoPositionLeftBottom
        _mapView?.logoPosition = BMKLogoPositionLeftBottom
        _mapView?.mapType = UInt(BMKMapTypeStandard)     /// 当前地图类型，可设定为标准地图、卫星地图
        _mapView?.showMapScaleBar = true /// 设定是否显式比例尺
        /// 当前地图的经纬度范围，设定的该范围可能会被调整为适合地图窗口显示的范围
//        _mapView?.region = BMKCoordinateRegionMake(CLLocationCoordinate2DMake(34, 34), BMKCoordinateSpanMake(23, 23))
        /// 限制地图的显示范围（地图状态改变时，该范围不会在地图显示范围外。设置成功后，会调整地图显示该范围）
//        _mapView?.limitMapRegion = BMKCoordinateRegionMake(CLLocationCoordinate2DMake(34, 34), BMKCoordinateSpanMake(23, 23))
        
        /// 指南针的位置，设定坐标以BMKMapView左上角为原点，向右向下增长
//        _mapView?.compassPosition = 30.0
    
        
        /// 当前地图的中心点，改变该值时，地图的比例尺级别不会发生变化
//        _mapView?.centerCoordinate = CLLocationCoordin ate2DMake(23, 23)
        
        /// 地图比例尺级别，在手机上当前可使用的级别为3-21级
//        _mapView?.zoomLevel = 3
        
        /// 地图的自定义最小比例尺级别
//        _mapView?.minZoomLevel = 3
        /// 地图的自定义最大比例尺级别
//         _mapView?.maxZoomLevel = 20
        
        /// 地图旋转角度，在手机上当前可使用的范围为－180～180度
//        _mapView?.rotation = 120
        
        
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
//        
//        
//        /// 比例尺的位置，设定坐标以BMKMapView左上角为原点，向右向下增长
//        _mapView?.mapScaleBarPosition = CGPoint(x: 0, y: 0)
        
       
        
        
        
        ///双击手势放大地图时, 设置为YES, 地图中心点移动至点击处; 设置为NO，地图中心点不变；默认为YES;
//        @property(nonatomic, getter=isChangeCenterWithDoubleTouchPointEnabled) BOOL ChangeCenterWithDoubleTouchPointEnabled;
        ///若isLockedToScreen为false，拖动地图时annotation会跟随移动。 支持标注锁定在屏幕固定位置
        

        self.view.addSubview(_mapView!)

        
        addCustomGesture()//添加自定义手势
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        BMKMapView.enableCustomMapStyle(enableCustomMap)
        _mapView?.viewWillAppear()
        _mapView?.delegate = self
        
        stickAnnotation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        BMKMapView.enableCustomMapStyle(false)//消失时，关闭个性化地图
        _mapView?.viewWillDisappear()
        _mapView?.delegate = nil
        
    }
    
    // 添加大头针
    func stickAnnotation() {
        // 添加一个PointAnnotation
        let annotation: BMKPointAnnotation = BMKPointAnnotation()
        let coor:CLLocationCoordinate2D = CLLocationCoordinate2DMake(39.915, 116.404)
        annotation.coordinate = coor
        annotation.title = "这里是北京"
        _mapView?.addAnnotation(annotation)
    }

    
    // 移除大头针
    func removeAnnotation() {
//        if (annotation != nil) {
//            _mapView?.removeAnnotation(annotation)
//        }
    }
    
    // BMKMapViewDelegate
    func mapView(_ mapView: BMKMapView!, viewFor annotation: BMKAnnotation!) -> BMKAnnotationView! {
        
        if annotation is BMKPointAnnotation {
            let newAnnotationView:BMKPinAnnotationView = BMKPinAnnotationView.init(annotation: annotation, reuseIdentifier: "myAnnotation")
            newAnnotationView.pinColor = UInt(BMKPinAnnotationColorPurple)
            newAnnotationView.animatesDrop = true// 设置该标注点动画显示
            return newAnnotationView
        }
        return nil
    }
    
    // MARK: - BMKMapViewDelegate
    
    /**
     *地图初始化完毕时会调用此接口
     *@param mapview 地图View
     */
    func mapViewDidFinishLoading(_ mapView: BMKMapView!) {
        let alertVC = UIAlertController(title: "", message: "BMKMapView控件初始化完成", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "知道了", style: .cancel, handler: nil)
        alertVC.addAction(alertAction)
        self .present(alertVC, animated: true, completion: nil)
    }
    
    // MARK: - 添加自定义手势 （若不自定义手势，不需要下面的代码）
    func addCustomGesture() {
        /*
         *注意：
         *添加自定义手势时，必须设置UIGestureRecognizer的cancelsTouchesInView 和 delaysTouchesEnded 属性设置为false，否则影响地图内部的手势处理
         */
        let tapGesturee = UITapGestureRecognizer(target: self, action: #selector(XHWLMapKitVC.handleSingleTap(_:)))
        tapGesturee.cancelsTouchesInView = false
        tapGesturee.delaysTouchesEnded = false
        self.view.addGestureRecognizer(tapGesturee)
    }
    
    func handleSingleTap(_ tap: UITapGestureRecognizer) {
        NSLog("custom single tap handle")
    }
}
