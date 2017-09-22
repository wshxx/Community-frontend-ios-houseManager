//
//  XHWLProgressDetailCell.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/15.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLProgressDetailCell: UITableViewCell {

    var titleL:UILabel!
    var timeL:UILabel!
    var iconIV:UIImageView!
    var topLineIV:UIImageView!
    var bottomLineIV:UIImageView!
    
    var waringModel:XHWLWarningModel!
    var realModel:XHWLDetailProgressModel! {
        willSet {
            if (newValue != nil) {
                titleL.text = newValue.name
                timeL.text = newValue.createTime
            }
        }
    }
    
    class func cellWithTableView(tableView:UITableView) -> XHWLProgressDetailCell {
        
        let ID: String = "XHWLProgressDetailCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: ID)
        if (cell == nil) {
            cell =  XHWLProgressDetailCell.init(style: UITableViewCellStyle.default, reuseIdentifier: ID)
        }
        
        return cell as! XHWLProgressDetailCell
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
        
        titleL = UILabel()
        titleL.textColor = UIColor.white
        titleL.font = font_14
        titleL.text = "许柳飞"
        self.contentView.addSubview(titleL)
        
        timeL = UILabel()
        timeL.textColor = UIColor().colorWithHexString(colorStr: "7a9198")
        timeL.font = font_13
        timeL.text = "12/22"
        self.contentView.addSubview(timeL)
        
        iconIV = UIImageView()
        iconIV.image = UIImage(named: "dot_green")
        self.contentView.addSubview(iconIV)
        
        topLineIV = UIImageView()
        topLineIV.image = UIImage(named: "progress_line")
        self.contentView.addSubview(topLineIV)
        
        bottomLineIV = UIImageView()
        bottomLineIV.image = UIImage(named: "progress_line")
        self.contentView.addSubview(bottomLineIV)
        
    }
    
//    func setModel(waringModel:XHWLWarningModel) {
//        titleL.text = waringModel.name
//        timeL.text = waringModel.time
//    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        iconIV.frame = CGRect(x:15, y:11, width:12, height:12)
        titleL.frame = CGRect(x:iconIV.frame.maxX+10, y:2, width:self.contentView.bounds.size.width-iconIV.frame.maxX-20, height:25)
        timeL.frame = CGRect(x:iconIV.frame.maxX+10, y:titleL.frame.maxY, width:self.contentView.bounds.size.width-iconIV.frame.maxX-20, height:25)
        topLineIV.frame = CGRect(x:21, y:0, width:0.5, height:11)
        bottomLineIV.frame = CGRect(x:21, y:23, width:0.5, height:self.contentView.bounds.size.height-23)
    }
    
    var isTop:Bool? = false  {
        willSet {
            if newValue == true {
                topLineIV.isHidden = true
            }
        }
    }
    
    var isBottom:Bool?  = false  {
        willSet {
            if newValue == true {
                bottomLineIV.isHidden = true
            }
        }
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
