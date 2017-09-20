//
//  XHWLWarningView.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/8.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLWarningView: UIView , UITableViewDelegate, UITableViewDataSource {

    var bgImage:UIImageView!
//    var tipImg:UIImageView!
    var tipLabel:UILabel!
    var tableView:UITableView!
    var dataAry:NSMutableArray! = NSMutableArray()
    var dataSource:NSMutableArray! = NSMutableArray()
    var clickCell:(Bool, NSInteger)->(Void) = {param in }
    var topMenu:XHWLTopView!
    var isHistory:Bool! = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        setupView()
    }
    
    func setupView() {
        
        bgImage = UIImageView()
        bgImage.image = UIImage(named:"menu_bg")
        self.addSubview(bgImage)
        
        let array:NSArray = ["当前告警", "历史告警"]
        topMenu = XHWLTopView.init(frame: CGRect.zero)
        topMenu.createArray(array: array)
        topMenu.btnBlock = {[weak self] index in
            if index == 0 {
                self?.isHistory = false
            } else {
                self?.isHistory = true
            }
            self?.tableView.reloadData()
        }
        self.addSubview(topMenu)
        
        tableView = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.addSubview(tableView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let img = UIImage(named:"warning_subview_top_bg")!
        topMenu.frame =  CGRect(x:0, y:0, width:img.size.width, height:img.size.height)
        bgImage.frame = CGRect(x:14, y:56, width:self.bounds.size.width-28, height:self.frame.size.height-56)
        tableView.frame = CGRect(x:14, y:topMenu.frame.maxY, width:self.bounds.size.width-28, height:self.frame.size.height-topMenu.frame.maxY-14)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isHistory {
            return dataSource.count
        }
        return dataAry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: XHWLWarningCell = XHWLWarningCell.cellWithTableView(tableView: tableView)
        let model:XHWLWarningModel!
        if isHistory {
            
            model = dataSource[indexPath.row] as! XHWLWarningModel
        } else {
            
            model = dataAry[indexPath.row] as! XHWLWarningModel
        }
//        cell.setModel(waringModel: model)
        cell.waringModel = model
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.clickCell(isHistory, indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
