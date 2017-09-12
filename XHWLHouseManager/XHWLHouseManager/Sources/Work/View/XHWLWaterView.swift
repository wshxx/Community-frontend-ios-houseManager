//
//  XHWLWaterView.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/10.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLWaterView: UIView , UITableViewDelegate, UITableViewDataSource {
    
    var bgImage:UIImageView!
    var tipImg:UIImageView!
    var tipLabel:UILabel!
    var tableView:UITableView!
    var dataAry:NSMutableArray!
    var clickCell:(NSInteger)->(Void) = {param in }
    var topMenu:XHWLTopView!
    var tagMenu:XHWLTagView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let array:NSArray = [["name": "生活水管", "time":"2017.01.21 12:23:00", "content":"抵压配电房-4#变压器"],
                             ["name": "生活水管", "time":"2017.01.21 12:23:00", "content":"抵压配电房-4#变压器"]
        ]
        
        dataAry = NSMutableArray()
        dataAry = XHWLWarningModel.mj_objectArray(withKeyValuesArray: array)
        
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
        
        let array:NSArray = ["水泵房", "排污泵"]
        topMenu = XHWLTopView.init(frame: CGRect.zero)
        topMenu.createArray(array: array)
        topMenu.btnBlock = { index in
            
        }
        self.addSubview(topMenu)
        
        
        let waterArray:NSArray = ["生活水泵", "生活水泵"]
        tagMenu = XHWLTagView.shared
        tagMenu.createArray(array: waterArray)
        tagMenu.btnBlock = { index in
            
        }
        self.addSubview(tagMenu)
        
        
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
        tagMenu.frame = CGRect(x:0, y:44, width:self.bounds.size.width, height:44)
        tableView.frame = CGRect(x:0, y:tagMenu.frame.maxY, width:self.bounds.size.width, height:self.frame.size.height-tagMenu.frame.maxY)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataAry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: XHWLWarningCell = XHWLWarningCell.cellWithTableView(tableView: tableView)
        let model:XHWLWarningModel = dataAry[indexPath.row] as! XHWLWarningModel
        cell.setModel(waringModel: model)
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.clickCell(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headV:UIView = UIView()
        headV.frame = CGRect(x:0, y:0, width:self.tableView.bounds.size.width, height:30)
        
        let titleL:UILabel = UILabel()
        titleL.text = "冷水泵"
        titleL.frame = CGRect(x:13, y:0, width:45, height:30)
        titleL.textColor = UIColor.white
        titleL.font = font_12
        headV.addSubview(titleL)
        
        let lineIV:UIImageView = UIImageView()
        lineIV.frame = CGRect(x:titleL.frame.maxX+10, y:headV.bounds.size.height/2.0, width:self.tableView.bounds.size.width-26-titleL.frame.maxX, height:0.5)
        lineIV.image = UIImage(named: "warning_cell_line")
        headV.addSubview(lineIV)
        
        return headV
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
