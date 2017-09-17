//
//  XHWLCheckVC.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/10.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLCheckVC: UIViewController  , XHWLScanTestVCDelegate, XHWLNetworkDelegate{
    
    var bgImg:UIImageView!
    var topMenu:XHWLTopView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        setupView()
        setupNav()
    }
    
    func setupNav() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"scan_back"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(onBack))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "记录", style: UIBarButtonItemStyle.plain, target: self, action: #selector(onRecordClick))
        
        let array:NSArray = ["访客登记"]
        topMenu = XHWLTopView.init(frame: CGRect.zero)
        topMenu.createArray(array: array)
        topMenu.frame = CGRect(x:0, y:0, width:Screen_width-100, height:44)
        topMenu.center = CGPoint(x:Screen_width/2.0, y:22)
        self.navigationItem.titleView = topMenu
    }
    
    func onRecordClick() {
        
        let vc:XHWLRegistrationVC = XHWLRegistrationVC() // 访客记录
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func onBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupView() {
        
        bgImg = UIImageView()
        bgImg.frame = self.view.bounds
        bgImg.image = UIImage(named:"home_bg")
        self.view.addSubview(bgImg)
        
        let showImg:UIImage = UIImage(named:"menu_bg")!
        let warningView:XHWLCheckListView = XHWLCheckListView()
        warningView.bounds = CGRect(x:0, y:0, width:showImg.size.width, height:showImg.size.height)
        warningView.center = CGPoint(x:self.view.frame.size.width/2.0, y:self.view.frame.size.height/2.0)
        warningView.btnBlock = {index in
            
            if index == 0 {
                let vc:XHWLRegistrationVC = XHWLRegistrationVC()
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                
            }
        }
        self.view.addSubview(warningView)
        
    }
    
    func loadData() {
//        wyBusiness/visitor/regist
        
        let data:NSData = UserDefaults.standard.object(forKey: "user") as! NSData
        let dict:NSDictionary = data.mj_JSONObject() as! NSDictionary
        let userModel:XHWLUserModel = XHWLUserModel.mj_object(withKeyValues: dict)
        
        let params = [
            "token":userModel.wyAccount.token, // 	用户登录token
            "name":"",//	访客姓名
            "type":"", // 	访客类型
            "certificateType":"", // 	证件类型
            "cetificateNo":"", // 	证件号
            "telephone":"", //  	访客电话号码
            "timeUnit":"", //  	访问时间单位（天/时/分等）
            "timeNo":"", //  	访问时间值
            "carNo":"" //  	车牌号
        ]
        
        XHWLNetwork.shared.postVisitRegisterClick(params as NSDictionary, self)
    }
    
    
    // MARK: - XHWLNetworkDelegate
    
    func requestSuccess(_ requestKey:NSInteger, _ response:[String : AnyObject]) {
        
        
    }
    
    func requestFail(_ requestKey:NSInteger, _ error:NSError) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
