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
        showBtn.setBackgroundImage(UIImage(named:"home_btn_bg_high"), for: UIControlState.highlighted)
        showBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        showBtn.titleLabel?.font = font_15
        showBtn.addTarget(self, action: #selector(onSelectClick), for: UIControlEvents.touchUpInside)
        self.contentView.addSubview(showBtn)
        
        self.contentView.addSubview(badgeBtn)
    }
    
    lazy fileprivate var badgeBtn: UIButton = {
    
        let badgeBtn = UIButton.init(type: UIButtonType.custom)
        badgeBtn.backgroundColor = color_d724d9
        badgeBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        badgeBtn.titleLabel?.font = font_9
        badgeBtn.contentHorizontalAlignment = .center
        badgeBtn.layer.cornerRadius = 12
        badgeBtn.layer.masksToBounds = true
        badgeBtn.isHidden = false
        //        badgeBtn.addTarget(self, action: #selector(onSelectClick), for: UIControlEvents.touchUpInside)
        
        return badgeBtn
    }()
    
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
    
    var badgeNumber:NSNumber! {
        willSet {
            if (newValue != nil) {
                print("\(newValue)")

                
                showBtn.bounds = CGRect(x:0, y:0, width:270, height:50)
                showBtn.center = CGPoint(x:self.frame.size.width/2.0, y:self.frame.size.height/2.0)
                
                if newValue == 0 {
                    self.badgeBtn.isHidden = true
                } else {
                    
                    self.badgeBtn.isHidden = false
                    let size:CGSize = showText!.boundingRect(with: CGSize(width:CGFloat(MAXFLOAT), height:30), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:showBtn.titleLabel!.font], context: nil).size
                    if Int(newValue!) > 9 {
                        badgeBtn.layer.cornerRadius = 5
                        badgeBtn.layer.masksToBounds = true
                        badgeBtn.bounds = CGRect(x:0, y:0, width:10, height:10)
                    } else {
                        badgeBtn.layer.cornerRadius = 12
                        badgeBtn.layer.masksToBounds = true
                        badgeBtn.bounds = CGRect(x:0, y:0, width:24, height:24)
                        badgeBtn.setTitle("\(newValue)", for: .normal)
                    }
                    badgeBtn.center = CGPoint(x:(self.frame.size.width + size.width)/2.0, y:(self.frame.size.height-size.height)/2.0)
                }
            }
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        showBtn.bounds = CGRect(x:0, y:0, width:270, height:50)
        showBtn.center = CGPoint(x:self.frame.size.width/2.0, y:self.frame.size.height/2.0)
        
        if showText == "" {
            self.badgeBtn.isHidden = true
//            badgeBtn = nil
        } else {
            if badgeNumber == 0 {
                self.badgeBtn.isHidden = true
            } else {
                self.badgeBtn.isHidden = false
                let size:CGSize = showText!.boundingRect(with: CGSize(width:CGFloat(MAXFLOAT), height:30), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:showBtn.titleLabel!.font], context: nil).size
                if Int(badgeNumber!) > 9 {
                    badgeBtn.layer.cornerRadius = 5
                    badgeBtn.layer.masksToBounds = true
                    badgeBtn.bounds = CGRect(x:0, y:0, width:10, height:10)
                } else {
                    badgeBtn.layer.cornerRadius = 10
                    badgeBtn.layer.masksToBounds = true
                    badgeBtn.bounds = CGRect(x:0, y:0, width:20, height:20)
                }
                badgeBtn.center = CGPoint(x:(self.frame.size.width + size.width)/2.0, y:(self.frame.size.height-size.height)/2.0)
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
