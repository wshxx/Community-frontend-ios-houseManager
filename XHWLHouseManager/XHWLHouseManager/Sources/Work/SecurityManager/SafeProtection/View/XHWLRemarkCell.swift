//
//  XHWLRemarkCell.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/11/25.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLRemarkCell: UITableViewCell {

    var remark: XHWLRemarkView!
    var menuModel:XHWLMenuModel! {
        willSet {
            let str:NSString = NSString.init(string: newValue.name)
            remark.showText(newValue.name.substring(to: String.Index(str.length-1)))
        }
    }
    
    class func cellWithTableView(tableView:UITableView) -> XHWLRemarkCell {
        
        let ID: String = "XHWLRemarkCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: ID)
        if (cell == nil) {
            cell =  XHWLRemarkCell.init(style: UITableViewCellStyle.default, reuseIdentifier: ID)
        }
        
        return cell as! XHWLRemarkCell
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        self.selectionStyle = .none
        
        setupView()
    }
    
    func setupView() {
        
        remark = XHWLRemarkView()
        remark.showText("备注")
        remark.textViewBlock = {[weak self] text in
//            self?.remarkStr = text
        }
        contentView.addSubview(remark)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        remark.frame = CGRect(x:10, y:0, width:self.bounds.size.width-10, height:self.bounds.size.height)        
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



