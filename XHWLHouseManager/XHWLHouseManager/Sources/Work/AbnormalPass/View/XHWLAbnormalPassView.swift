//
//  XHWLAbnormalPassView.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/12.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLAbnormalPassView: UIView  , UITableViewDelegate, UITableViewDataSource {
    
    var bgImage:UIImageView!
    var tipImg:UIImageView!
    var tipLabel:UILabel!
    var tableView:UITableView!
    var dataAry:NSMutableArray!
    var clickCell:(NSInteger)->(Void) = {param in }
    var topMenu:XHWLTopView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let array:NSArray = [["name": "特权车辆", "time":"2017.01.21", "registerName":"哈哈", "content":"张浩然"],
                             ["name": "特权车辆", "time":"2017.01.21", "registerName":"哈哈",  "content":"张浩然"]
        ]
        
        dataAry = NSMutableArray()
        dataAry = XHWLRegisterationModel.mj_objectArray(withKeyValuesArray: array)
        
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
        
        let array:NSArray = ["异常放行记录"]
        topMenu = XHWLTopView.init(frame: CGRect.zero)
        topMenu.createArray(array: array)
        topMenu.btnBlock = { index in
            
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
        return dataAry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: XHWLRegistrationCell = XHWLRegistrationCell.cellWithTableView(tableView: tableView)
        let model:XHWLRegisterationModel = dataAry[indexPath.row] as! XHWLRegisterationModel
        cell.setModel(registrationModel: model)
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.clickCell(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
