//
//  XHWLDataView.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/19.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLDataView: UIView , UITableViewDelegate, UITableViewDataSource {
    
    var bgImage:UIImageView!
    var tableView:UITableView!
    var dataAry:NSMutableArray!
    var titleL:UILabel!
    var clickCell:(NSInteger)->(Void) = {param in }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let array:NSArray = [[["name": "停车总位数", "content":"500(个)"],["name": "车辆入场流量", "content":"155(次)"],
                             ["name": "剩余车位", "content":"50(个)"],["name": "异常抬杆数", "content":"2(次)"]],
                             [["name": "业主入流量", "content":"800(次)"],["name": "访客入流量", "content":"150(次)"],
                             ["name": "当前滞留人数", "content":"10(个)"],["name": "访客人工放行数", "content":"3(次)"]],
                             [["name": "安防事件数", "content":"2100"]],
                             [["name": "环境工作完成率", "content":"98%"]]
        ]
        
        dataAry = NSMutableArray()
        dataAry = XHWLDataModel.mj_objectArray(withKeyValuesArray: array)
        
        setupView()
        
    }
    
    func setupView() {
        
        bgImage = UIImageView()
        bgImage.image = UIImage(named:"subview_bg")
        self.addSubview(bgImage)
        
        titleL = UILabel()
        titleL.text = "今日实时"
        titleL.textColor = UIColor.white
        titleL.font = font_15
        self.addSubview(titleL)
        
        tableView = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.showsVerticalScrollIndicator = false
        self.addSubview(tableView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bgImage.frame = self.bounds
        titleL.frame = CGRect(x: 15, y: 10, width: self.bounds.width-30, height: 44)
        tableView.frame = CGRect(x: 0, y: 54, width: bgImage.bounds.width, height: bgImage.bounds.height-54)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataAry.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (dataAry[section] as! NSArray).count%2 == 1 {
            return (dataAry[section] as! NSArray).count/2+1
        }
        return (dataAry[section] as! NSArray).count/2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: XHWLDataCell = XHWLDataCell.cellWithTableView(tableView: tableView)
        
        let model:XHWLDataModel = (dataAry[indexPath.section] as! NSArray)[indexPath.row*2] as! XHWLDataModel
        cell.leftModel = model
        if indexPath.row*2 + 1 < (dataAry[indexPath.section] as! NSArray).count {
            
            let model1:XHWLDataModel = (dataAry[indexPath.section] as! NSArray)[2*indexPath.row+1] as! XHWLDataModel
            cell.rightModel = model1
        }
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.clickCell(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
   
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let headV:UIView = UIView.init(frame: CGRect(x:0, y:0, width:self.tableView.frame.size.width, height:20))
            let label:UILabel = UILabel.init(frame: CGRect(x:10, y:0, width:self.tableView.frame.size.width-20, height:20))
            label.textColor = color_7a9198
            label.font = font_14
            label.text = "更新时间：\(Date.getCurrentDate())" // 2017-08-11 12:11:01"
            headV.addSubview(label)
            return headV
        } else {
            let headV:UIView = UIView.init(frame: CGRect(x:0, y:0, width:self.tableView.frame.size.width, height:1))
            let label:UILabel = UILabel.init(frame: CGRect(x:10, y:0, width:self.tableView.frame.size.width-20, height:0.5))
            label.backgroundColor = color_01f0ff
            headV.addSubview(label)
            return headV
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 20
        }
        return 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
