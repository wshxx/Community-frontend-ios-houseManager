//
//  XHWLRegistrationCell.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/10.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLRegistrationCell: UITableViewCell {

    var titleL:UILabel!
    var stateL:UILabel!
    var timeL:UILabel!
    var contentL:UILabel!
    var accessIV:UIImageView!
    var lineIV:UIImageView!
    var waringModel:XHWLWarningModel!
    var visitorLogModel:XHWLVisitLogModel! {
        willSet {
            if (newValue != nil) {
                titleL.text = newValue.sysVisitor.accessReason
                
                stateL.isHidden = false
//                stateL.text = "状态：同意" //newValue.yzName.isEmpty ? "状态：拒绝":"状态：同意"
                contentL.text = "登记人:\(newValue.sysVisitor.name)"
                timeL.text = Date.getDateWith(Int(newValue.sysVisitor.accessTime)!, "yyyy-MM-dd HH:mm")
            }
        }
    }
    var abnormalModel:XHWLAbnormalPassModel! {
        willSet {
            if (newValue != nil) {
                titleL.text = newValue.roadName
                
//                stateL.isHidden = false
//                stateL.text = "状态：同意" //newValue.yzName.isEmpty ? "状态：拒绝":"状态：同意"
                contentL.text = "道口编号:\(newValue.roadCode)"
                timeL.text = newValue.date// Date.getDateWith(Int(newValue.sysVisitor.accessTime)!, "yyyy-MM-dd HH:mm")
            }
        }
    }
    
    class func cellWithTableView(tableView:UITableView) -> XHWLRegistrationCell {
        
        let ID: String = "XHWLRegistrationCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: ID)
        if (cell == nil) {
            cell =  XHWLRegistrationCell.init(style: UITableViewCellStyle.default, reuseIdentifier: ID)
        }
        
        return cell as! XHWLRegistrationCell
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
        
        stateL = UILabel()
        stateL.textColor = color_01f0ff
        stateL.font = font_13
        stateL.isHidden = true
        self.contentView.addSubview(stateL)
        
        timeL = UILabel()
        timeL.textColor = UIColor().colorWithHexString(colorStr: "7a9198")
        timeL.font = font_13
        self.contentView.addSubview(timeL)
        
        contentL = UILabel()
        contentL.textColor = UIColor().colorWithHexString(colorStr: "7a9198")
        contentL.font = font_13
        self.contentView.addSubview(contentL)
        
        accessIV = UIImageView()
        accessIV.image = UIImage(named: "warning_accessView")
        self.contentView.addSubview(accessIV)
        
        lineIV = UIImageView()
        lineIV.image = UIImage(named: "warning_cell_line")
        self.contentView.addSubview(lineIV)
    }

    func setModel(_ registrationModel:XHWLSafeProtectionModel) {
        titleL.text = registrationModel.appComplaint.remarks
        contentL.text = "来源:\(registrationModel.appComplaint.wyAccount.wyRole.name)"
        timeL.text = Date.getDateWith(Int(registrationModel.appComplaint.createTime)!, "yyyy-MM-dd")
    }
    
    func setRegisterModel(_ registrationModel:XHWLRegisterationModel) {
        titleL.text = registrationModel.name
        contentL.text = "登记人:\(registrationModel.registerName)"
        timeL.text = registrationModel.time
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if stateL.isHidden {
             titleL.frame = CGRect(x:10, y:0, width:self.frame.size.width-30-13, height:30)
            stateL.frame = CGRect(x:0, y:0, width:0, height:30)
        } else {
             titleL.frame = CGRect(x:10, y:0, width:self.frame.size.width-30-13-100, height:30)
            stateL.frame = CGRect(x:self.frame.size.width-100, y:0, width:80, height:30)
        }
        
        timeL.frame = CGRect(x:10, y:30, width:(self.bounds.size.width-40)/2.0+20, height:25)
        contentL.frame = CGRect(x:timeL.frame.maxX, y:30, width:(self.bounds.size.width-40)/2.0-10, height:25)
        accessIV.bounds = CGRect(x:0, y:0, width:7, height:12)
        accessIV.center = CGPoint(x:self.frame.size.width-17, y:self.frame.size.height/2.0)
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
