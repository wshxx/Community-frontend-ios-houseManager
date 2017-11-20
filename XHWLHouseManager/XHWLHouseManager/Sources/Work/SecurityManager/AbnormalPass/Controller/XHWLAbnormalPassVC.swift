//
//  XHWLAbnormalPassVC.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/12.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLAbnormalPassVC: XHWLBaseVC , XHWLNetworkDelegate {

//    var bgImg:UIImageView!
//    var topMenu:XHWLTopView!
//    var warningView:XHWLSafeProtectionView!
    var warningView:XHWLAbnormalPassView!
    var dealArray:NSArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        setupView()
        setupNav()
        onLoadData()
    }
    
    func setupNav() {
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"scan_back"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(onBack))
        
        self.title = "异常放行记录"
    }
    
//    func onBack(){
//        self.navigationController?.popViewController(animated: true)
//    }
    
    func onLoadData() {
        
        let data:NSData = UserDefaults.standard.object(forKey: "user") as! NSData
        let userModel:XHWLUserModel = XHWLUserModel.mj_object(withKeyValues: data.mj_JSONObject())
        
        XHWLNetwork.shared.getExceptionPassLogClick([userModel.wyAccount.token] as NSArray, self)
    }
    
    // MARK: - XHWLNetworkDelegate
    
    func requestSuccess(_ requestKey:NSInteger, _ response:[String : AnyObject]) {
        
        if requestKey == XHWLRequestKeyID.XHWL_EXCEPTIONPASSLOG.rawValue {
            
            let dict = response["result"] as! NSDictionary
            let array = dict["rows"] as! NSArray
            if array.count <= 0 {
                return
            }
            let dealArray:NSArray = XHWLAbnormalPassModel.mj_objectArray(withKeyValuesArray:array)
            self.dealArray = dealArray
            self.warningView.dataAry = NSMutableArray()
            self.warningView.dataAry.addObjects(from: dealArray as! [Any])
            self.warningView.tableView.reloadData()
        }
    }
    
    func requestFail(_ requestKey:NSInteger, _ error:NSError) {
        
    }
    
    func setupView() {
        
//        bgImg = UIImageView()
//        bgImg.frame = self.view.bounds
//        bgImg.image = UIImage(named:"home_bg")
//        self.view.addSubview(bgImg)
        
        warningView = XHWLAbnormalPassView()
        warningView.bounds = CGRect(x:0, y:0, width:Screen_width*13/16.0, height:Screen_height*2/3.0)
        warningView.center = CGPoint(x:self.view.frame.size.width/2.0, y:self.view.frame.size.height/2.0)
        warningView.clickCell = {index in
            
            let vc:XHWLSafeGuardDetailVC = XHWLSafeGuardDetailVC()
            vc.abnormalModel = self.dealArray[index] as! XHWLAbnormalPassModel
            vc.backReloadBlock = {[weak self] _ in
                self?.onLoadData()
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        self.view.addSubview(warningView)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
