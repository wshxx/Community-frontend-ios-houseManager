//
//  XHWLRosterManageCell.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/11/15.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLRosterManageCell: UITableViewCell {

    var titleL:UILabel!
    var cardL:UILabel!
    var contentL:UILabel!
    var lineIV:UIImageView!

    var rosterModel:XHWLRosterModel! {
        willSet {
            if (newValue != nil) {
                titleL.text = newValue.name
                cardL.text = "身份证：" + newValue.cetificateNo!
                contentL.text = "详情:" + newValue.remark!
            }
        }
    }
    
    class func cellWithTableView(tableView:UITableView) -> XHWLRosterManageCell {
        
        let ID: String = "XHWLRosterManageCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: ID)
        if (cell == nil) {
            cell =  XHWLRosterManageCell.init(style: UITableViewCellStyle.default, reuseIdentifier: ID)
        }
        
        return cell as! XHWLRosterManageCell
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
        self.contentView.addSubview(titleL)
        
        cardL = UILabel()
        cardL.textColor = UIColor.white
        cardL.font = font_13
        self.contentView.addSubview(cardL)
        
        contentL = UILabel()
        contentL.textColor = UIColor().colorWithHexString(colorStr: "7a9198")
        contentL.font = font_13
        self.contentView.addSubview(contentL)
        
        lineIV = UIImageView()
        lineIV.image = UIImage(named: "warning_cell_line")
        self.contentView.addSubview(lineIV)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleL.frame = CGRect(x:13, y:0, width:self.bounds.size.width-30, height:25)
        cardL.frame = CGRect(x:13, y:titleL.frame.maxY, width:self.bounds.size.width-30, height:25)
        contentL.frame = CGRect(x:13, y:cardL.frame.maxY, width:self.bounds.size.width-30, height:25)
        lineIV.frame = CGRect(x:10, y:self.frame.size.height-0.5, width:self.frame.size.width-30, height:0.5)
        
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
