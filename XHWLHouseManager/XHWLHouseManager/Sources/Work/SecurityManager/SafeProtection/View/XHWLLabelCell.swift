//
//  XHWLLabelCell.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/11/25.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLLabelCell: UITableViewCell {
    
    var labelView: XHWLLineView!
    var menuModel:XHWLMenuModel! {
        willSet {
            labelView.showText(leftText: newValue.name, rightText:newValue.content)
            //            labelView.textAlign = NSTextAlignment.center
        }
    }
    
    class func cellWithTableView(tableView:UITableView) -> XHWLLabelCell {
        
        let ID: String = "XHWLLabelCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: ID)
        if (cell == nil) {
            cell =  XHWLLabelCell.init(style: UITableViewCellStyle.default, reuseIdentifier: ID)
        }
        
        return cell as! XHWLLabelCell
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        self.selectionStyle = .none
        
        setupView()
    }
    
    func setupView() {
        
        labelView = XHWLLineView()
        contentView.addSubview(labelView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        labelView.frame = self.contentView.bounds
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
