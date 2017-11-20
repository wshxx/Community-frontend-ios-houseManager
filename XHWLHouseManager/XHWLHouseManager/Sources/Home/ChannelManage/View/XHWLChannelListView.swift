//
//  XHWLChannelListView.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/11/16.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLChannelListView: UIView , UITableViewDelegate, UITableViewDataSource, XHWLNetworkDelegate {
    
    var bgImage:UIImageView!
    var tipImg:UIImageView!
    var tipLabel:UILabel!
    var tableView:UITableView!
    var dataAry:NSMutableArray! = NSMutableArray()
    var clickCell:(NSInteger)->(Void) = {param in }
    var deleteIndexPath:NSIndexPath!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    func setupView() {
        
        bgImage = UIImageView()
        bgImage.image = UIImage(named:"subview_bg")
        self.addSubview(bgImage)
        
        tableView = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
        tableView.tableFooterView = UIView()
//        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.showsVerticalScrollIndicator = false
        self.addSubview(tableView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bgImage.frame = self.bounds
        tableView.frame = CGRect(x:0, y:10, width:self.frame.size.width, height:self.frame.size.height-10)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataAry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: XHWLRegistrationCell = XHWLRegistrationCell.cellWithTableView(tableView: tableView)
        //        let model:XHWLRegisterationModel = dataAry[indexPath.row] as! XHWLRegisterationModel
        //        cell.setRegisterModel(model)
        let model:XHWLChannelModel = dataAry[indexPath.row] as! XHWLChannelModel
//        cell.abnormalModel = model
        cell.textLabel?.text = "\(model.name)(\(model.wyAccount.count)人）"
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.clickCell(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // 要显示自定义的action,cell必须处于编辑状态
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .normal, title: "删除") { action, index in
            
            self.deleteIndexPath = indexPath as NSIndexPath
            
            self.onDelete()
        }
        delete.backgroundColor = UIColor.clear
        
        return [delete]
    }
    
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //删除
        let deleteRowAction:UIContextualAction = UIContextualAction.init(style: .destructive, title: "删除") { (action, sourceView, completionHandler) in
            self.deleteIndexPath = indexPath as NSIndexPath
            
            self.onDelete()
            
            completionHandler(true)
        }
        deleteRowAction.image = UIImage(named:"visit_delete")
        deleteRowAction.backgroundColor = UIColor.clear
        
        let config:UISwipeActionsConfiguration = UISwipeActionsConfiguration.init(actions: [deleteRowAction])
        
        return config
    }
    
    // 删除频道
    func onDelete() {
        //取出user的信息
        let data = UserDefaults.standard.object(forKey: "user") as? NSData
        let userModel = XHWLUserModel.mj_object(withKeyValues: data?.mj_JSONObject())
        
        let channelModel:XHWLChannelModel = self.dataAry[deleteIndexPath!.row] as! XHWLChannelModel
        
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
