//
//  XHWLMcuCell.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/10/20.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLMcuCell: UITableViewCell {

    var node:XHWLMcuModel! {
        willSet {
            self.textLabel?.text = newValue.nodeName
            if newValue.isSelected {
                self.accessoryType = UITableViewCellAccessoryType.checkmark
            } else {
                self.accessoryType = UITableViewCellAccessoryType.none
            }
        }
    }
    var workerModel:XHWLWorkerModel! {
        willSet {
            self.textLabel?.text = newValue.name
            if newValue.isSelected {
                self.accessoryType = UITableViewCellAccessoryType.checkmark
            } else {
                self.accessoryType = UITableViewCellAccessoryType.none
            }
        }
    }
    
    static func cellWithTableView(_ tableView:UITableView) -> XHWLMcuCell {
        let ID: String = "XHWLMcuCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: ID)
        if cell == nil {
            cell =  XHWLMcuCell.init(style: UITableViewCellStyle.default, reuseIdentifier: ID)
        }
        
        return cell! as! XHWLMcuCell
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        
        self.textLabel?.font = font_14
        self.textLabel?.textColor = UIColor.white
        
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
