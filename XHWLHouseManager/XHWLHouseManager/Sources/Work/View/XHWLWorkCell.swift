//
//  XHWLWorkCell.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/16.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLWorkCell: UITableViewCell {

    var showBtn :UIButton!
    var onBtnClickBlock:(XHWLWorkCell)->() = {param in }
    
    class func cellWithTableView(tableView:UITableView) -> XHWLWorkCell {
        
        let ID: String = "XHWLWorkCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: ID)
        if (cell == nil) {
            cell =  XHWLWorkCell.init(style: UITableViewCellStyle.default, reuseIdentifier: ID)
        }
        
        return cell as! XHWLWorkCell
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
        showBtn = UIButton.init(type: UIButtonType.custom)
        showBtn.setBackgroundImage(UIImage(named:"home_btn_bg"), for: UIControlState.normal)
        showBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        showBtn.addTarget(self, action: #selector(onSelectClick), for: UIControlEvents.touchUpInside)
        self.contentView.addSubview(showBtn)
    }
    
    func onSelectClick() {
        self.onBtnClickBlock(self)
    }
    
    var showText:String? {
        willSet {
            if newValue != nil {
                showBtn.setTitle(newValue, for: UIControlState.normal)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        showBtn.bounds = CGRect(x:0, y:0, width:270, height:68)
        showBtn.center = CGPoint(x:self.frame.size.width/2.0, y:self.frame.size.height/2.0)
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
