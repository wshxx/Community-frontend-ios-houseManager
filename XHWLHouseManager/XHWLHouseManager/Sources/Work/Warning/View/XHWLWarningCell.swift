//
//  XHWLWarningCell.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/8.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLWarningCell: UITableViewCell {

    var iconIV :UIImageView!
    var titleL:UILabel!
    var timeL:UILabel!
    var contentL:UILabel!
    var accessIV:UIImageView!
    var lineIV:UIImageView!
    var waringModel:XHWLWarningModel! {
        willSet {
            if (newValue != nil) {
                
                titleL.text = newValue.AlarmType
                contentL.text = newValue.AlarmInfo
                timeL.text = newValue.Alarmtime

            }
        }
    }
    
    class func cellWithTableView(tableView:UITableView) -> XHWLWarningCell {
        
        let ID: String = "XHWLWarningCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: ID)
        if (cell == nil) {
            cell =  XHWLWarningCell.init(style: UITableViewCellStyle.default, reuseIdentifier: ID)
        }
        
        return cell as! XHWLWarningCell
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        iconIV = UIImageView()
        iconIV.image = UIImage(named: "failure")
        self.contentView.addSubview(iconIV)
        
        titleL = UILabel()
        titleL.textColor = UIColor.white
        titleL.font = font_12
        self.contentView.addSubview(titleL)
        
        timeL = UILabel()
        timeL.textColor = UIColor().colorWithHexString(colorStr: "7a9198")
        timeL.font = font_9
        self.contentView.addSubview(timeL)
        
        contentL = UILabel()
        contentL.textColor = UIColor().colorWithHexString(colorStr: "7a9198")
        contentL.font = font_9
        contentL.textAlignment = NSTextAlignment.right
        self.contentView.addSubview(contentL)
        
        accessIV = UIImageView()
        accessIV.image = UIImage(named: "warning_accessView")
        self.contentView.addSubview(accessIV)
        
        lineIV = UIImageView()
        lineIV.image = UIImage(named: "warning_cell_line")
        self.contentView.addSubview(lineIV)
    }
    
//    func setModel(waringModel:XHWLWarningModel) {
//        titleL.text = waringModel.name
//        contentL.text = waringModel.content
//        timeL.text = waringModel.time
//    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        iconIV.bounds = CGRect(x:0, y:0, width:14, height:14)
        iconIV.center = CGPoint(x:20, y:self.frame.size.height/2.0)
        titleL.frame = CGRect(x:iconIV.frame.maxX+5, y:0, width:self.frame.size.width-iconIV.frame.maxX-30, height:30)
        timeL.frame = CGRect(x:iconIV.frame.maxX+5, y:30, width:100, height:25)
        contentL.frame = CGRect(x:timeL.frame.maxX, y:30, width:self.frame.size.width-timeL.frame.maxX-30, height:30)
        accessIV.bounds = CGRect(x:0, y:0, width:7, height:12)
        accessIV.center = CGPoint(x:self.frame.size.width-17, y:self.frame.size.height/2.0)
        lineIV.frame = CGRect(x:13, y:self.frame.size.height-0.5, width:self.frame.size.width-30, height:0.5)
        
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
