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
    var tipImg:UIImageView!
    var tipLabel:UILabel!
    var tableView:UITableView!
    var dataAry:NSMutableArray!
    var dataSource:NSMutableArray!
    var clickCell:(Bool, NSInteger)->(Void) = {param in }
    var topMenu:XHWLTopView!
    var isHistory:Bool! = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        let array:NSArray = [["name": "负载率过高告警当前值2.0%", "time":"2017.01.21 12:23:00", "content":"抵压配电房-4#变压器"],
                             ["name": "负载率过高告警当前值2.0%", "time":"2017.01.21 12:23:00", "content":"抵压配电房-4#变压器"]
        ]
        
        dataAry = NSMutableArray()
        dataAry = XHWLWarningModel.mj_objectArray(withKeyValuesArray: array)
        
        let array2:NSArray = [["name": "历史负载率过高告警当前值2.0%", "time":"2017.01.21 12:23:00", "content":"抵压配电房-4#变压器"],
                             ["name": "历史负载率过高告警当前值2.0%", "time":"2017.01.21 12:23:00", "content":"抵压配电房-4#变压器"]
        ]
        
        dataSource = NSMutableArray()
        dataSource = XHWLWarningModel.mj_objectArray(withKeyValuesArray: array2)
        

        
        setupView()
        
    }
    
    func setupView() {
        
        bgImage = UIImageView()
        bgImage.image = UIImage(named:"menu_bg")
        self.addSubview(bgImage)
        
//        tipImg = UIImageView()
//        tipImg.frame = CGRect(x:0, y:0, width:55, height:55)
//        tipImg.center = CGPoint(x: self.bounds.size.width/2.0, y: self.bounds.size.height/2.0-20)
//        self.addSubview(tipImg)
        
//        tipLabel = UILabel()
//        tipLabel.textAlignment = NSTextAlignment.center
//        tipLabel.textColor = UIColor().colorWithHexString(colorStr: "32b7e2")
//        tipLabel.font = font_15
//        self.addSubview(tipLabel)
        
        let array:NSArray = ["当前告警", "历史告警"]
        topMenu = XHWLTopView.init(frame: CGRect.zero)
        topMenu.createArray(array: array)
        topMenu.btnBlock = { index in
            if index == 0 {
                self.isHistory = false
            } else {
                self.isHistory = true
            }
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
        
        bgImage.frame = self.bounds
//        tipLabel.frame = CGRect(x:10, y:self.bounds.size.height-80, width:self.bounds.size.width-20, height:40)
        topMenu.frame = CGRect(x:0, y:0, width:self.bounds.size.width, height:44)
        tableView.frame = CGRect(x:0, y:44, width:self.bounds.size.width, height:self.frame.size.height-44)
        
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
        cell.setModel(waringModel: model)
        
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
