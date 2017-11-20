//
//  XHWLRosterManageView.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/11/10.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLRosterManageView: UIView,  XHWLNetworkDelegate ,UITableViewDelegate, UITableViewDataSource {
    
    var bgImage:UIImageView!
    var tipImg:UIImageView!
    var tableView:UITableView!
    var dataAry:NSMutableArray! = NSMutableArray()
    var dataSource:NSMutableArray! = NSMutableArray()

    var clickCell:(NSInteger, NSInteger, XHWLRosterModel)->(Void) = {param in }
    var topMenu:XHWLTopView!
    var selectIndex:NSInteger! = 0
    var oneCurrentPage:NSInteger = 1
    var twoCurrentPage:NSInteger = 1
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    func setupView() {
        
        bgImage = UIImageView()
        bgImage.image = UIImage(named:"menu_bg")
        self.addSubview(bgImage)
        
        let array:NSArray = ["黑名单", "灰名单"]
        topMenu = XHWLTopView.init(frame: CGRect.zero)
        topMenu.createArray(array: array)
        topMenu.btnBlock = {[weak self] index in
            if self?.selectIndex != index {
                self?.selectIndex = index
                if index == 0 && self?.oneCurrentPage == 1 ||
                    index == 1 && self?.twoCurrentPage == 1 {
                    self?.tableView.mj_header.beginRefreshing()
                } else {
                    self?.tableView.reloadData()
                }
            }
        }
        self.addSubview(topMenu)
        
        tableView = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.showsVerticalScrollIndicator = false
        self.addSubview(tableView)
        
        tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            if self.selectIndex == 0 {
                self.oneCurrentPage = 1
                self.dataAry =  NSMutableArray()
                self.onLoadData("黑名单", self.oneCurrentPage)
            } else if self.selectIndex == 1 {
                self.dataSource =  NSMutableArray()
                self.twoCurrentPage = 1
                self.onLoadData("灰名单", self.twoCurrentPage)
            }
        })
        
        tableView.mj_header.beginRefreshing()
        
        tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
            if self.selectIndex == 0 {
                self.oneCurrentPage += 1
                self.onLoadData("黑名单", self.oneCurrentPage)
            } else if self.selectIndex == 1 {
                self.twoCurrentPage += 1
                self.onLoadData("灰名单", self.twoCurrentPage)
            }
        })
    }
    
    func onLoadData(_ type:String, _ pageNumber:NSInteger) {
        
        let data:NSData = UserDefaults.standard.object(forKey: "user") as! NSData
        let userModel:XHWLUserModel = XHWLUserModel.mj_object(withKeyValues: data.mj_JSONObject())
        let params:NSDictionary = [
            "token":userModel.wyAccount.token, //   是    用户登录token
            "type": type,//    是    类别：黑名单、灰名单
            "pageNumber":"\(pageNumber)", //   否    当前页数
            "pageSize":"10"   // 请求数量
        ]
        
        XHWLNetwork.shared.postRosterListClick(params, self)
    }
    
    // MARK: - XHWLNetworkDelegate
    
    func requestSuccess(_ requestKey:NSInteger, _ response:[String : AnyObject]) {
        
        if requestKey == XHWLRequestKeyID.XHWL_ROSTERLIST.rawValue {
            
            tableView.mj_header.endRefreshing()
            tableView.mj_footer.endRefreshing()
            
            let dict = response["result"] as! NSDictionary
            if dict.count == 0 {
                self.tableView.reloadData()
                return
            }
            let array = dict["rosterList"] as! NSArray
            if array.count <= 0 {
                return
            }
            //XHWLRosterModel(jsonData: array)
            let dealArray:NSArray = XHWLRosterModel.mj_objectArray(withKeyValuesArray:array)

            if self.selectIndex == 0 {
                self.dataAry.addObjects(from: dealArray as! [Any])
            }
            else if self.selectIndex == 1 {
                self.dataSource.addObjects(from: dealArray as! [Any])
            }
            self.tableView.reloadData()
        }
    }
    
    func requestFail(_ requestKey:NSInteger, _ error:NSError) {
        if requestKey == XHWLRequestKeyID.XHWL_ROSTERLIST.rawValue {
            tableView.mj_header.endRefreshing()
            tableView.mj_footer.endRefreshing()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let img = UIImage(named:"warning_subview_top_bg")!
        topMenu.frame =  CGRect(x:0, y:0, width:self.bounds.size.width, height:img.size.height)
        bgImage.frame = CGRect(x:14.5, y:56, width:self.bounds.size.width-29, height:self.frame.size.height-56)
        tableView.frame = CGRect(x:14, y:topMenu.frame.maxY, width:self.bounds.size.width-28, height:self.frame.size.height-topMenu.frame.maxY-14)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectIndex == 0 {
            return dataAry.count
        }
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: XHWLRosterManageCell = XHWLRosterManageCell.cellWithTableView(tableView: tableView)

        var model:XHWLRosterModel!
        if selectIndex == 0 {
            model = dataAry[indexPath.row] as! XHWLRosterModel
        } else {
            model = dataSource[indexPath.row] as! XHWLRosterModel
        }
        cell.rosterModel = model
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        var model:XHWLRosterModel!
        if selectIndex == 0 {
            model = dataAry[indexPath.row] as! XHWLRosterModel
        } else {
            model = dataSource[indexPath.row] as! XHWLRosterModel
        }
        self.clickCell(selectIndex, indexPath.row, model)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
