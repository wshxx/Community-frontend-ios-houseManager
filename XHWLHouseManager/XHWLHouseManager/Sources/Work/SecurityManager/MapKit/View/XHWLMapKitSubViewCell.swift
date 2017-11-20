//
//  XHWLMapKitSubViewCell.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/10/24.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLMapKitSubViewCell: UITableViewCell {
    
    var bgImage:UIImageView!
    var tableView:UITableView!
    var dataAry:NSMutableArray! = NSMutableArray()
    var labelViewArray:NSMutableArray = NSMutableArray()
    var stateView:XHWLPatrolStateView!
    
    class func cellWithTableView(tableView:UITableView) -> XHWLMapKitSubViewCell {
        
        let ID: String = "XHWLMapKitSubViewCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: ID)
        if (cell == nil) {
            cell =  XHWLMapKitSubViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: ID)
        }
        
        return cell as! XHWLMapKitSubViewCell
    }
    var lineModel:XHWLPatrolLineModel! {
        willSet {
            if newValue != nil {
  
                var weekStr:String = ""
                if newValue.mon == "1" {
                    weekStr = weekStr + "、星期一"
                }
                if newValue.tue == "1" {
                    weekStr = weekStr + "、星期二"
                }
                if newValue.wed == "1" {
                    
                    weekStr = weekStr + "、星期三"
                }
                if newValue.thu == "1" {
                    weekStr = weekStr + "、星期四"
                }
                if newValue.fri == "1" {
                    weekStr = weekStr + "、星期五"
                }
                if newValue.sat == "1" {
                    weekStr = weekStr + "、星期六"
                }
                if newValue.sun == "1" {
                    weekStr = weekStr + "、星期日"
                }
                if !weekStr.isEmpty {
                    weekStr = weekStr.substring(from: String.Index(1))
                }
                
                var addressStr:String = ""
                let detailAry:NSArray = XHWLPatrolTotalCheckModel.mj_objectArray(withKeyValuesArray: newValue.currentTimeChecksDetail)
                
                for i in 0..<detailAry.count {
                    let model:XHWLPatrolTotalCheckModel = detailAry[i] as! XHWLPatrolTotalCheckModel
                    addressStr = addressStr + "、" + model.nodeName
                }
                
                if !addressStr.isEmpty {
                    addressStr = addressStr.substring(from: String.Index(1))
                }
                
                let array :NSArray = [["name":"巡检点：", "content":addressStr],
                                      ["name":"巡检日期：", "content":newValue.startDate + "～" + newValue.endDate],
                                      ["name":"周期：", "content":weekStr],]
                
                dataAry = XHWLMenuModel.mj_objectArray(withKeyValuesArray: array)
                
                for i in 0..<dataAry.count {
                    let menuModel :XHWLMenuModel = dataAry[i] as! XHWLMenuModel
                    let labelView: XHWLPatroLabelView = labelViewArray[i] as! XHWLPatroLabelView
                    labelView.showText(leftText: menuModel.name, rightText:menuModel.content)
                }
                
                stateView.planAry = newValue.planTime
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        self.selectionStyle = .none
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
        bgImage = UIImageView()
        bgImage.image = UIImage(named:"Patrol_sub_bg")
        self.contentView.addSubview(bgImage)

        dataAry = NSMutableArray()
        let array :NSArray = [["name":"巡检点：", "content":"1.10号楼一单元 2.10号楼一单元天台 3.9号楼一单元大堂"],
                              ["name":"巡检日期：", "content":"2017-09-20～2017-12-31"],
                              ["name":"周期：", "content":"星期一、星期三、星期五"],]
//                              ["name":"工作时间:", "content":"07:00-09:00\n15:00-17:00\n15:00-17:00"],
        dataAry = XHWLMenuModel.mj_objectArray(withKeyValuesArray: array)
        
        labelViewArray = NSMutableArray()
        for i in 0..<dataAry.count {
            let menuModel :XHWLMenuModel = dataAry[i] as! XHWLMenuModel
            let labelView: XHWLPatroLabelView = XHWLPatroLabelView()
            labelView.showText(leftText: menuModel.name, rightText:menuModel.content)
            labelView.textAlignment = NSTextAlignment(rawValue: 7)!
            self.contentView.addSubview(labelView)
            labelViewArray.add(labelView)
        }
        
        stateView = XHWLPatrolStateView()
        self.contentView.addSubview(stateView)
    }
    
    func heightWithSize(_ menuModel :XHWLMenuModel ) -> CGFloat {
        
        //        let sizeL:CGSize = menuModel.name.boundingRect(with: CGSize(width:CGFloat(MAXFLOAT), height:30), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:font_14], context: nil).size //CGFloat(self.bounds.size.width-sizeL.width-30)
        let sizeR:CGSize = menuModel.content.boundingRect(with: CGSize(width:CGFloat(Int(self.bounds.size.width-80-10)), height:CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:font_14], context: nil).size
        
        return sizeR.height + 5
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bgImage.frame = self.bounds

        var maxHeight = 0
        for i in 0...labelViewArray.count-1 {
            
            let menuModel :XHWLMenuModel = dataAry[i] as! XHWLMenuModel
            let labelView:XHWLPatroLabelView = labelViewArray[i] as! XHWLPatroLabelView
            labelView.frame = CGRect(x:0, y:maxHeight+5, width:Int(self.bounds.size.width), height:Int(heightWithSize(menuModel)))
            maxHeight = Int(labelView.frame.maxY)
        }
        
        var num = 1
        if lineModel.planTime.count > 0 {
            num = lineModel.planTime.count
        }
                
        stateView.frame = CGRect(x:0, y:maxHeight+5, width:Int(self.bounds.size.width), height:num * 25)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
