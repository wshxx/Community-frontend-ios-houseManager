//
//  XHWLSelectGroupVC.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/11/16.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLSelectGroupVC: XHWLBaseVC , XHWLNetworkDelegate {
    
    var warningView:XHWLSelectGroupView!
    var dealArray:NSArray!
    var selectAry:NSMutableArray! = NSMutableArray()
    var isNewChannel:Bool = true
    var reloadData:()->() = { param in }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        self.title = "选择群组成员"
        setupView()
        onLoadData()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "完成", style: .plain, target: self, action: #selector(onAddClick))
    }
    
    func onAddClick() {
        
        if isNewChannel {
            
            addNewChannel("")
        } else {
            
            addNewChannel("channelId")
        }
    }
    
    // 新增频道
    func addNewChannel(_ channelId:String) {
//        selectAry 需添加人员的id
        var wyAccountIds:String = ""
        for i in 0..<warningView.selectAry.count {
            let model:XHWLWorkerModel = warningView.selectAry[i] as! XHWLHouseManager.XHWLWorkerModel
            let idStr:String = model.wyAccountId
            if !wyAccountIds.isEmpty {
                wyAccountIds += ","
            }
            wyAccountIds += idStr
        }
        let data:NSData = UserDefaults.standard.object(forKey: "user") as! NSData
        let userModel:XHWLUserModel = XHWLUserModel.mj_object(withKeyValues: data.mj_JSONObject())
        let params:NSDictionary = ["token":userModel.wyAccount.token, //是    用户登录token
            "channelId":channelId, // 新增频道（否）/新增频道成员（是）    频道id
            "wyAccountIds":wyAccountIds // 是    需添加人员的id
        ]
        XHWLNetwork.shared.postAddChannelClick(params, self)
    }
    
    // 获取所有物业工作人员信息
    func onLoadData() {
        
        let data:NSData = UserDefaults.standard.object(forKey: "user") as! NSData
        let userModel:XHWLUserModel = XHWLUserModel.mj_object(withKeyValues: data.mj_JSONObject())
        
        XHWLNetwork.shared.getWorkerListClick([userModel.wyAccount.token] as NSArray, self)
    }
    
    // MARK: - XHWLNetworkDelegate
    
    func requestSuccess(_ requestKey:NSInteger, _ response:[String : AnyObject]) {
        
        if requestKey == XHWLRequestKeyID.XHWL_WORKERLIST.rawValue {
            
            let dict = response["result"] as! NSDictionary
            let array = dict["rows"] as! NSArray
            if array.count <= 0 {
                return
            }
            
            let dealArray:NSArray = XHWLWorkerModel.mj_objectArray(withKeyValuesArray:array)
            self.dealArray = dealArray
            self.warningView.dataAry = NSMutableArray()
            self.warningView.dataAry.addObjects(from: dealArray as! [Any])
            self.warningView.tableView.reloadData()
        } else if requestKey == XHWLRequestKeyID.XHWL_ADDCHANNEL.rawValue {
            self.reloadData()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func requestFail(_ requestKey:NSInteger, _ error:NSError) {
        
    }
    
    func setupView() {
        warningView = XHWLSelectGroupView()
        warningView.bounds = CGRect(x:0, y:0, width:Screen_width*13/16.0, height:Screen_height*2/3.0)
        warningView.center = CGPoint(x:self.view.frame.size.width/2.0, y:self.view.frame.size.height/2.0)
        warningView.clickCell = {index in
            
            //            let vc:XHWLSafeGuardDetailVC = XHWLSafeGuardDetailVC()
            //            vc.abnormalModel = self.dealArray[index] as! XHWLAbnormalPassModel
            //            vc.backReloadBlock = {[weak self] _ in
            //                self?.onLoadData()
            //            }
            //            self.navigationController?.pushViewController(vc, animated: true)
        }
        self.view.addSubview(warningView)
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
