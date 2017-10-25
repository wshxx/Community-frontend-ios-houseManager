//
//  XHWLPatrolVC.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/10/24.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLPatrolVC: XHWLBaseVC , XHWLNetworkDelegate{

    var mapkitView:UIView!
    var countView:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        let topHeight = (self.navigationController?.navigationBar.frame.height)! + UIApplication.shared.statusBarFrame.height
//        subBgIV = UIImageView(frame: CGRect(x:10, y:topHeight+20, width:Screen_width-20, height:Screen_height-topHeight-20-20))
//        subBgIV.image = UIImage(named:"subview_bg")
//        self.view.addSubview(subBgIV)
        
        self.title = "巡更定位"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"Patro_switch_list"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(onSwitchClick))
        
//        let topHeight = (self.navigationController?.navigationBar.frame.height)! + UIApplication.shared.statusBarFrame.height
        
//        onLoadData()
        let mapkitVC:XHWLMapKitVC = XHWLMapKitVC()
        mapkitVC.view.frame = self.view.bounds
        mapkitVC.view.isHidden = false
        mapkitView = mapkitVC.view
        self.addChildViewController(mapkitVC)
        self.view.addSubview(mapkitVC.view)
        
        let countVC:XHWLCountVC = XHWLCountVC()
        countVC.view.frame = self.view.bounds
        countVC.view.isHidden = true
        countView = countVC.view
        self.addChildViewController(countVC)
        self.view.addSubview(countVC.view)
    }
    
    func onSwitchClick() {

        mapkitView.isHidden = !mapkitView.isHidden
        countView.isHidden = !countView.isHidden
        
        if mapkitView.isHidden == false {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"Patro_switch_list"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(onSwitchClick))
        } else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"Patro_switch_mapkit"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(onSwitchClick))
        }
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
            
//            annotationArray = NSMutableArray()
//            _mapView.removeAnnotations(_mapView.annotations)
//            _mapView.removeOverlays(_mapView.overlays)
//
//            ////////
//            let noDelAry:NSMutableArray = NSMutableArray()
//            for j in 0..<4 {
//                switch j {
//                case 0:
//                    let model:XHWLMapKitModel = XHWLMapKitModel()
//                    model.latitude = "22.549329"
//                    model.longitude = "113.959076"
//                    model.nickname = "0"
//                    noDelAry.add(model)
//                case 1:
//                    let model:XHWLMapKitModel = XHWLMapKitModel()
//                    model.latitude = "22.649329"
//                    model.longitude = "113.959076"
//                    model.nickname = "1"
//                    noDelAry.add(model)
//                case 2:
//                    let model:XHWLMapKitModel = XHWLMapKitModel()
//                    model.latitude = "22.659329"
//                    model.longitude = "113.859076"
//                    model.nickname = "3"
//                    noDelAry.add(model)
//                case 3:
//                    let model:XHWLMapKitModel = XHWLMapKitModel()
//                    model.latitude = "22.549329"
//                    model.longitude = "113.879076"
//                    model.nickname = "2"
//                    noDelAry.add(model)
//                default:
//                    break
//                }
//            }
//
//            dealArray = noDelAry
//            ///////
//
//            for i in 0..<dealArray.count {
//                let model:XHWLMapKitModel = dealArray[i] as! XHWLMapKitModel
//
//                let coor:CLLocationCoordinate2D = CLLocationCoordinate2DMake(Double(model.latitude)!, Double(model.longitude)!)
//                stickAnnotation(coor, model)
//            }
//            setupLine(dealArray)
        }
    }
    
    func requestFail(_ requestKey:NSInteger, _ error:NSError) {
        
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
