//
//  XHWLChannelInfoView.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/11/21.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLChannelInfoView: UIView , XHWLNetworkDelegate {
    
    var bgImage:UIImageView!
    var dataAry:NSMutableArray! = NSMutableArray()
    var gridViewCellIndexPath:IndexPath!
    var addBlock:()->(Void) = {param in }
    var deleteBlock:(NSInteger) -> () = {param in }
    var channelAry:NSMutableArray = NSMutableArray() {
        willSet {
            updateGridViewFrame()
            gridView.dataArray = NSMutableArray()
            gridView.dataArray.addObjects(from:newValue as! [Any])
            gridView._gridView?.reloadData()
        }
    }
    var channelModel:XHWLChannelModel! {
        willSet {
            if newValue != nil {
                self.lineTF.nameTF.text = newValue.name
//                gridView.dataArray = NSMutableArray()
//                gridView.dataArray.addObjects(from:XHWLChannelRoleModel.mj_objectArray(withKeyValuesArray: newValue.wyAccount) as! [Any])
//                gridView._gridView?.reloadData()
            }
        }
    }
    lazy fileprivate var lineTF:XHWLLineTF! = {
        let lineTF:XHWLLineTF = XHWLLineTF(frame:CGRect(x:0, y:0, width:Screen_width, height:30))
        lineTF.endEditBlock = {[weak self] text in
            //取出user的信息
            let data = UserDefaults.standard.object(forKey: "user") as? NSData
            let userModel = XHWLUserModel.mj_object(withKeyValues: data?.mj_JSONObject())
            
            let params:NSDictionary = ["token":userModel?.wyAccount.token, //    用户登录token
                "channelId":self!.channelModel.id,
                "name":text // 是    是否删除频道
            ]
            
            XHWLNetwork.shared.postRenameChannelClick(params, self!)
        }
        self.addSubview(lineTF)
        return lineTF
    }()
    
    var gridView:XHWLGridView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
        bgImage = UIImageView()
        bgImage.image = UIImage(named:"subview_bg")
        self.addSubview(bgImage)

        gridView = XHWLGridView(frame:CGRect(x:0, y:0, width:self.bounds.size.width, height:0))
        gridView.backgroundColor = UIColor.clear
        gridView.addBlock = {[weak self] _ in
            self?.addBlock()
        }
        gridView.deleteBlock = { [weak self] gridViewCellIndexPath in
            print("\(gridViewCellIndexPath)")
            self?.gridViewCellIndexPath = gridViewCellIndexPath
            let model:XHWLChannelRoleModel = self?.gridView.dataArray[gridViewCellIndexPath.item] as! XHWLChannelRoleModel
            self?.onDelete(model.id)
        }
        self.addSubview(gridView)
        
        self.lineTF.frame = CGRect(x:0, y:gridView.frame.maxY+10, width:self.bounds.size.width, height:30)
    }
    
    // 删除频道
    func onDelete(_ wyAccountIds:String) {
        //取出user的信息
        let data = UserDefaults.standard.object(forKey: "user") as? NSData
        let userModel = XHWLUserModel.mj_object(withKeyValues: data?.mj_JSONObject())
        
        let params:NSDictionary = ["token":userModel?.wyAccount.token, //    用户登录token
            "channelId":channelModel.id, // 是    频道id
            "wyAccountIds":wyAccountIds, // 删除频道（否）/删除频道成员（是）    频道人员的id
            "isRemoveChannel":"n" // 是    是否删除频道
        ]
        
        XHWLNetwork.shared.postDeleteChannelClick(params, self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bgImage.frame = self.bounds
        
        self.lineTF.frame = CGRect(x:0, y:20, width:self.bounds.size.width, height:30)
        
       updateGridViewFrame()
    }
    
    func updateGridViewFrame() {
        var num:Int = 0
        let rowNum:Int = Int(self.bounds.size.width-30) / 60
        if (Int(self.channelAry.count) + 2) % rowNum == 0 {
            num = (Int(self.channelAry.count) + 2) / rowNum
        } else {
            num = (Int(self.channelAry.count) + 2) / rowNum + 1
        }
        var height:CGFloat = CGFloat(num)*60.0 + 36
        if height > self.bounds.size.height - 50 {
            height = self.bounds.size.height - 50
        }
        gridView.frame = CGRect(x:0, y:lineTF.frame.maxY, width:self.bounds.size.width, height:height)
    }
    
    // MARK: - XHWLNetworkDelegate
    
    func requestSuccess(_ requestKey:NSInteger, _ response:[String : AnyObject]) {
        
        if requestKey == XHWLRequestKeyID.XHWL_RENAMECHANNEL.rawValue {
            
            print("\(response)")
        } else if requestKey == XHWLRequestKeyID.XHWL_DELETECHANNEL.rawValue {
            
            self.deleteBlock(gridViewCellIndexPath.item)
            gridView.dataArray.removeObject(at: gridViewCellIndexPath.item)
            gridView._gridView?.deleteItems(at: [gridViewCellIndexPath])
        }
    }
    
    func requestFail(_ requestKey:NSInteger, _ error:NSError) {
        
    }
}
