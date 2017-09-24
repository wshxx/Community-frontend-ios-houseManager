//
//  XHWLWaterVC.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/10.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLWaterVC: UIViewController, XHWLNetworkDelegate {
    
    var bgImg:UIImageView!
    var warningView:XHWLWaterView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        setupView()
        setupNav()
//        onLoadNavParameData()
        loadDeviceInfo()
//        onLoadRealData()
    }
    
    func setupNav() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"scan_back"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(onBack))
        self.title = "供配电"
        
    }

    func onBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
    //    返回项目下所有设备信息
    func loadDeviceInfo() {
        
        let data:NSData = UserDefaults.standard.object(forKey: "user") as! NSData
        let userModel:XHWLUserModel = XHWLUserModel.mj_object(withKeyValues: data.mj_JSONObject())
        let param = ["ProjectCode": "10200", // 项目编号 201
            "token":userModel.wyAccount.token]
        
        XHWLNetwork.shared.postDeviceInfoClick(param as NSDictionary, self)
    }

//    func onLoadNavParameData() {
//        
//        let data:NSData = UserDefaults.standard.object(forKey: "user") as! NSData
//        let userModel:XHWLUserModel = XHWLUserModel.mj_object(withKeyValues: data.mj_JSONObject())
//        
//        let params:[String:Any] = ["ProjectCode":"201", // 项目编号
//            "token":userModel.wyAccount.token,
//            ]
//       
////       ?AccessToken=bd4f1ce1b544463094726ebc23a6c9f1
//        
//        XHWLNetwork.shared.postNavParameClick(params as NSDictionary, self)
//    }
    
    func onLoadRealData() {
        
        let data:NSData = UserDefaults.standard.object(forKey: "user") as! NSData
        let userModel:XHWLUserModel = XHWLUserModel.mj_object(withKeyValues: data.mj_JSONObject())
        
        let deviceData:NSData = UserDefaults.standard.object(forKey: "deviceList") as! NSData
        let deviceList:NSArray = XHWLDeviceModel.mj_objectArray(withKeyValuesArray: deviceData.mj_JSONObject())
        let model:XHWLDeviceModel = deviceList[1] as! XHWLDeviceModel
        
        let params:[String:Any] = ["ProjectCode":"201", // 项目编号
            "DeviceID":model.DeviceID,
            "token":userModel.wyAccount.token
            ]
        
        XHWLNetwork.shared.postRealDataClick(params as NSDictionary, self)
    }
    
    // MARK: - XHWLNetworkDelegate
    
    func requestSuccess(_ requestKey:NSInteger, _ response:[String : AnyObject]) {

        if requestKey == XHWLRequestKeyID.XHWL_NAVPARAME.rawValue {
            let list:NSArray = response["result"] as! NSArray
            
            let array:NSArray = XHWLProjectModel.mj_objectArray(withKeyValuesArray: list.mj_JSONObject())
        }
        else if requestKey == XHWLRequestKeyID.XHWL_REALDATA.rawValue {
            let list:NSArray = response["result"] as! NSArray
            
            let array:NSArray = XHWLProjectModel.mj_objectArray(withKeyValuesArray: list.mj_JSONObject())
        }
        else if requestKey == XHWLRequestKeyID.XHWL_DEVICEINFO.rawValue {
            let list:NSArray = response["result"] as! NSArray
            let ary:NSArray = XHWLDeviceModel.mj_objectArray(withKeyValuesArray: list)
            let array:NSArray =  XHWLDeviceModel.mj_keyValuesArray(withObjectArray: ary as! [Any]) //XHWLDeviceModel. .mj_objectArray(withKeyValuesArray: list)
            
            
            let dataDict = groupDictWith(array, "NavName") as NSDictionary // 转为【“”： NSArray]
            print("\(dataDict)")
            
            let dataSourceAry = NSMutableArray()
            let keyAry = dataDict.allKeys as NSArray //["", "" ]
            for i in 0..<keyAry.count {
                let key = keyAry[i] as! String
                let value = dataDict[key] as! NSArray
                print("\(value)")
                let subDataDict = groupDictWith(value, "TypeName") as NSDictionary // // 转为【“”： ["":NSArray]]
                print("\(subDataDict)")
                
                let subDataAry = NSMutableArray()
                let subKeyAry = subDataDict.allKeys as NSArray
                for j in 0..<subKeyAry.count {
                    let subKey = subKeyAry[j] as! String
                    let array:NSArray = XHWLDeviceModel.mj_objectArray(withKeyValuesArray: subDataDict[subKey])
                    subDataAry.add(["deviceSubTitle":subKey, "deviceSubAry": array])
                }
                
                let modelAry:NSArray = XHWLDeviceSubTitleModel.mj_objectArray(withKeyValuesArray: subDataAry)
                
                
                dataSourceAry.add(["deviceTitle":key, "deviceAry":modelAry])
            }

            let modelAry = XHWLDeviceTitleModel.mj_objectArray(withKeyValuesArray: dataSourceAry)
            
            print("\(modelAry)")
            warningView.modelAry = modelAry
            warningView.tableView.reloadData()
        }
    }
    
    func groupDictWith(_ array:NSArray, _ key:String) -> NSDictionary {
        let dict = NSMutableDictionary()
        for i in 0..<array.count {
            let model = array[i] as! NSDictionary
            
            print("\(model)")
            let currentKey = model.object(forKey: key) as! String
            
            let keyAry = dict.allKeys as NSArray
            var isCommon:Bool = false
            for j in 0..<keyAry.count {
                let oneKey = keyAry[j] as! String
                if oneKey == currentKey {
                    isCommon = true
                    break
                }
            }
            
            if isCommon == true {
                let valueAry = dict[currentKey] as! NSMutableArray
                valueAry.add(model)
                dict[currentKey] = valueAry
            } else {
                let ary:NSMutableArray = [model]
                dict[currentKey] = ary
            }
        }
         print("\(dict)")
        
        return dict
    }
    
    func requestFail(_ requestKey:NSInteger, _ error:NSError) {
        
    }
    
    func setupView() {
        
        bgImg = UIImageView()
        bgImg.frame = self.view.bounds
        bgImg.image = UIImage(named:"home_bg")
        self.view.addSubview(bgImg)
        
        let showImg:UIImage = UIImage(named:"menu_bg")!
        warningView = XHWLWaterView()
        warningView.bounds = CGRect(x:0, y:0, width:338, height:68+showImg.size.height)
        warningView.center = CGPoint(x:self.view.frame.size.width/2.0, y:self.view.frame.size.height/2.0)
        warningView.clickCell = {indexPath,index in
            
//            let vc:XHWLHistoryDetailVC = XHWLHistoryDetailVC()
            let vc:XHWLDeviceDetailVC = XHWLDeviceDetailVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        self.view.addSubview(warningView)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
