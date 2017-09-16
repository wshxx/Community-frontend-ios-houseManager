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
    var dataAry:NSMutableArray!
    var dataSource:NSMutableArray!
    var clickCell:(NSInteger, NSInteger)->(Void) = {param in }
    var selectIndex:NSInteger! = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let array:NSArray = [["name": "电梯无法工作", "time":"2017.01.21", "registerName":"哈哈", "content":"张浩然"],
                             ["name": "电梯无法工作", "time":"2017.01.21", "registerName":"哈哈",  "content":"张浩然"]
        ]
        let array2:NSArray = [["name": "已处理电梯无法工作", "time":"2017.01.21", "registerName":"哈哈", "content":"张浩然"],
                             ["name": "已处理电梯无法工作", "time":"2017.01.21", "registerName":"哈哈",  "content":"张浩然"]
        ]
        dataAry = NSMutableArray()
        dataAry = XHWLRegisterationModel.mj_objectArray(withKeyValuesArray: array)
        dataSource = NSMutableArray()
        dataSource = XHWLRegisterationModel.mj_objectArray(withKeyValuesArray: array2)
        
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
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.addSubview(tableView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bgImage.frame = self.bounds
        tableView.frame = CGRect(x:7, y:58, width:self.bounds.size.width-14, height:self.frame.size.height-36)
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
        var model:XHWLRegisterationModel!
        if selectIndex == 0 {
            model = dataAry[indexPath.row] as! XHWLRegisterationModel
        } else {
            model = dataSource[indexPath.row] as! XHWLRegisterationModel
        }
        cell.setModel(registrationModel: model)
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.clickCell(selectIndex, indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
