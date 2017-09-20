//
//  XHWLDataCell.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/19.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLDataCell: UITableViewCell {

    var leftDataView :XHWLSubDataView!
    var rightDataView :XHWLSubDataView!
    var leftModel:XHWLDataModel! {
        willSet {
            if (newValue != nil) {
                
                leftDataView.setTitle(newValue.name, content: newValue.content)
            }
        }
    }
    
    var rightModel:XHWLDataModel! {
        willSet {
            if (newValue != nil) {
                
                rightDataView.setTitle(newValue.name, content: newValue.content)
            }
        }
    }
    
    class func cellWithTableView(tableView:UITableView) -> XHWLDataCell {
        
        let ID: String = "XHWLDataCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: ID)
        if (cell == nil) {
            cell =  XHWLDataCell.init(style: UITableViewCellStyle.default, reuseIdentifier: ID)
        }
        
        return cell as! XHWLDataCell
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        self.selectionStyle = UITableViewCellSelectionStyle.none
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        leftDataView = XHWLSubDataView()
        self.contentView.addSubview(leftDataView)
        
        rightDataView = XHWLSubDataView()
        self.contentView.addSubview(rightDataView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        leftDataView.frame = CGRect(x:0, y:0, width:self.frame.size.width/2.0, height:self.frame.size.height)
        rightDataView.frame = CGRect(x:self.frame.size.width/2.0, y:0, width:self.frame.size.width/2.0, height:self.frame.size.height)
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
