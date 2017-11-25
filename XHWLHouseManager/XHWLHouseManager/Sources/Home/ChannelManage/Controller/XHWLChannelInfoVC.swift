//
//  XHWLChannelInfoVC.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/11/17.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLChannelInfoVC: XHWLBaseVC {

    var channelModel:XHWLChannelModel!
    var warningView:XHWLChannelInfoView!
    var channelAry:NSMutableArray = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "频道信息"
        channelAry = XHWLChannelRoleModel.mj_objectArray(withKeyValuesArray: channelModel.wyAccount)
        setupView()
        // Do any additional setup after loading the view.
    }

    lazy fileprivate var deleteBtn:UIButton = {
        let btn:UIButton = UIButton.init(type: .custom)
        btn.setTitle("删除频道", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = font_14
        btn.setBackgroundImage(UIImage(named:"btn_background"), for: UIControlState.normal)
        btn.addTarget(self, action: #selector(onDelete), for: .touchUpInside)
        self.view.addSubview(btn)

        return btn
    }()
    
    func setupView() {
        warningView = XHWLChannelInfoView()
        warningView.bounds = CGRect(x:0, y:0, width:Screen_width*13/16.0, height:Screen_height*2/3.0)
        warningView.center = CGPoint(x:self.view.frame.size.width/2.0, y:self.view.frame.size.height/2.0)
        warningView.channelModel = channelModel
        warningView.channelAry = channelAry
        warningView.addBlock = {[weak self] _ in
            
            let vc:XHWLSelectGroupVC = XHWLSelectGroupVC()
            vc.isNewChannel = false
            vc.channelId = (self?.channelModel.id)!
            vc.joinAry = (self?.channelAry)!
            vc.reloadData = { array in
                for i in 0..<array.count {
                    let model:XHWLWorkerModel = array[i] as! XHWLWorkerModel
                    let channelModel:XHWLChannelRoleModel = XHWLChannelRoleModel()
                    channelModel.id = model.wyAccountId
                    channelModel.wyUserName = model.name
                    self?.channelAry.add(channelModel)
                }
                self?.warningView.channelAry = NSMutableArray()
                self?.warningView.channelAry = (self?.channelAry)!
//                self?.channelModel.wyAccount.addObjects(from: array as! [Any])
//                self?.warningView.channelModel = self?.channelModel
            }
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        warningView.deleteBlock = { index in
            self.channelAry.removeObject(at: index)
        }
        self.view.addSubview(warningView)
        self.deleteBtn.frame = CGRect(x:Screen_width*0.3, y:warningView.frame.maxY+20, width:Screen_width*0.4, height:40)
    }

    // 删除频道
    func onDelete() {
        //取出user的信息
        let data = UserDefaults.standard.object(forKey: "user") as? NSData
        let userModel = XHWLUserModel.mj_object(withKeyValues: data?.mj_JSONObject())

        let params:NSDictionary = ["token":userModel?.wyAccount.token, //    用户登录token
            "channelId":channelModel.id, // 是    频道id
            "wyAccountIds":"", // 删除频道（否）/删除频道成员（是）    频道人员的id
            "isRemoveChannel":"y" // 是    是否删除频道
        ]

        XHWLNetwork.shared.postDeleteChannelClick(params, self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
// MARK: - XHWLNetworkDelegate

extension XHWLChannelInfoVC: XHWLNetworkDelegate {

    func requestSuccess(_ requestKey:NSInteger, _ response:[String : AnyObject]) {
        
        if requestKey == XHWLRequestKeyID.XHWL_DELETECHANNEL.rawValue {
            
            
        }
    }
    
    func requestFail(_ requestKey:NSInteger, _ error:NSError) {
        
    }
}



