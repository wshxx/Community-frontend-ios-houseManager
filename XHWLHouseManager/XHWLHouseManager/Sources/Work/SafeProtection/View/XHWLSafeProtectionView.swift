//
//  XHWLSafeProtectionView.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/12.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLSafeProtectionView: UIView , UITableViewDelegate, UITableViewDataSource {
    
    var bgImage:UIImageView!
    var tipImg:UIImageView!
    var tipLabel:UILabel!
    var tableView:UITableView!
    var dataAry:NSMutableArray! = NSMutableArray()
    var dataSource:NSMutableArray! = NSMutableArray()
    var clickCell:(NSInteger, NSInteger, XHWLSafeProtectionModel)->(Void) = {param in }
    var selectIndex:NSInteger! = 0
    var topMenu:XHWLTopView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    func setupView() {
        
        bgImage = UIImageView()
        bgImage.image = UIImage(named:"menu_bg")
        self.addSubview(bgImage)
        
        let array:NSArray = ["待处理", "已处理"]
        topMenu = XHWLTopView.init(frame: CGRect.zero)
        topMenu.createArray(array: array)
        topMenu.btnBlock = {[weak self] index in
            self?.selectIndex = index
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
        if selectIndex == 0 {
            return dataAry.count
        }
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: XHWLRegistrationCell = XHWLRegistrationCell.cellWithTableView(tableView: tableView)
        var model:XHWLSafeProtectionModel! //XHWLRegisterationModel!
        if selectIndex == 0 {
            model = dataAry[indexPath.row] as! XHWLSafeProtectionModel //XHWLRegisterationModel
        } else {
            model = dataSource[indexPath.row] as! XHWLSafeProtectionModel //XHWLRegisterationModel
        }
        cell.setModel(model)
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        var model:XHWLSafeProtectionModel! //XHWLRegisterationModel!
        if selectIndex == 0 {
            model = dataAry[indexPath.row] as! XHWLSafeProtectionModel //XHWLRegisterationModel
        } else {
            model = dataSource[indexPath.row] as! XHWLSafeProtectionModel //XHWLRegisterationModel
        }
        self.clickCell(selectIndex, indexPath.row, model)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
