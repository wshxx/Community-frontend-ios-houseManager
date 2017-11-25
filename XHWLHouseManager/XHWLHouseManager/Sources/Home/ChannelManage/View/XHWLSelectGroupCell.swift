//
//  XHWLSelectGroupCell.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/11/21.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLSelectGroupCell: UITableViewCell {
    
    var imageIV:UIImageView!
    var titleLable:UILabel!
    var lineL:UILabel!
    
    var workerModel:XHWLWorkerModel! {
        willSet {
            titleLable.text = newValue.name
            if newValue.isSelected {
                imageIV.image = UIImage(named:"channel_selected")
//                self.accessoryType = UITableViewCellAccessoryType.checkmark
            } else {
                imageIV.image = UIImage(named:"channel_unselected")
//                self.accessoryType = UITableViewCellAccessoryType.none
            }
        }
    }
    
    static func cellWithTableView(_ tableView:UITableView) -> XHWLSelectGroupCell {
        let ID: String = "XHWLSelectGroupCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: ID)
        if cell == nil {
            cell =  XHWLSelectGroupCell.init(style: UITableViewCellStyle.default, reuseIdentifier: ID)
        }
        
        return cell! as! XHWLSelectGroupCell
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        
        imageIV = UIImageView()
        contentView.addSubview(imageIV)
        
        titleLable = UILabel()
        titleLable.font = font_14
        titleLable.textColor = UIColor.white
        contentView.addSubview(titleLable)
        
        lineL = UILabel()
        lineL.textColor = UIColor.white
        contentView.addSubview(lineL)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageIV.frame = CGRect(x:0, y:0, width:15, height:15)
        imageIV.center = CGPoint(x:25, y:self.contentView.center.y)
        titleLable.frame = CGRect(x:imageIV.frame.maxX+10, y:0, width:self.contentView.bounds.size.width-50, height:self.contentView.bounds.size.height)
        lineL.frame = CGRect(x:15, y:self.contentView.bounds.size.height-0.5, width:self.contentView.bounds.size.width-30, height:0.5)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
