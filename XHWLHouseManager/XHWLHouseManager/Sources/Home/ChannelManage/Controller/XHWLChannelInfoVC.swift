//
//  XHWLChannelInfoVC.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/11/17.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLChannelInfoVC: XHWLBaseVC, XHWLNetworkDelegate {

    var channelModel:XHWLChannelModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "频道信息"
        setupView()
        // Do any additional setup after loading the view.
    }
    
    lazy fileprivate var deleteBtn:UIButton = {
        let btn:UIButton = UIButton.init(type: .custom)
        btn.setTitle("删除频道", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor = UIColor.red
        btn.layer.cornerRadius = 4
        btn.layer.masksToBounds = true
        self.view.addSubview(btn)
        
        return btn
    }()
    func setupView() {
        
        let gridView:XHWLGridView = XHWLGridView(frame:CGRect(x:0, y:64, width:Screen_width, height:200))
        gridView.backgroundColor = UIColor.clear
        self.view.addSubview(gridView)
        
        self.deleteBtn.frame = CGRect(x:30, y:gridView.frame.maxY+20, width:Screen_width-60, height:40)
    }

    // 删除频道
    func onDelete() {
        //取出user的信息
        let data = UserDefaults.standard.object(forKey: "user") as? NSData
        let userModel = XHWLUserModel.mj_object(withKeyValues: data?.mj_JSONObject())
    
        let params:NSDictionary = ["token":userModel?.wyAccount.token, //    用户登录token
            "channelId":channelModel.id, // 是    频道id
            "wyAccountIds":"", // 删除频道（否）/删除频道成员（是）    频道人员的id
            "isRemoveChannel":"" // 是    是否删除频道
        ]
        
        XHWLNetwork.shared.postDeleteChannelClick(params, self)
    }
    
    // MARK: - XHWLNetworkDelegate
    
    func requestSuccess(_ requestKey:NSInteger, _ response:[String : AnyObject]) {
        
        if requestKey == XHWLRequestKeyID.XHWL_DELETECHANNEL.rawValue {
            
            
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
