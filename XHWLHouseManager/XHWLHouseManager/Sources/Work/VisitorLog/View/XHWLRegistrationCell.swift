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
    var timeL:UILabel!
    var registerNameL:UILabel!
    var contentL:UILabel!
    var accessIV:UIImageView!
    var lineIV:UIImageView!
    var waringModel:XHWLWarningModel!
    
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
        titleL.font = font_12
        self.contentView.addSubview(titleL)
        
        timeL = UILabel()
        timeL.textColor = UIColor().colorWithHexString(colorStr: "7a9198")
        timeL.font = font_9
        self.contentView.addSubview(timeL)
        
        registerNameL = UILabel()
        registerNameL.textColor = UIColor().colorWithHexString(colorStr: "7a9198")
        registerNameL.font = font_9
        registerNameL.textAlignment = NSTextAlignment.right
        self.contentView.addSubview(registerNameL)
        
        
        contentL = UILabel()
        contentL.textColor = UIColor().colorWithHexString(colorStr: "7a9198")
        contentL.font = font_9
        self.contentView.addSubview(contentL)
        
        accessIV = UIImageView()
        accessIV.image = UIImage(named: "warning_accessView")
        self.contentView.addSubview(accessIV)
        
        lineIV = UIImageView()
        lineIV.image = UIImage(named: "warning_cell_line")
        self.contentView.addSubview(lineIV)
    }
    
//    ["name": "电梯无法工作", "time":"2017.01.21", "registerName":"哈哈", "content":"张浩然"],
    func setModel(_ registrationModel:XHWLSafeProtectionModel) {
        titleL.text = registrationModel.urgency
        contentL.text = "业主:\(registrationModel.manageRemarks)"
        registerNameL.text = "登记人：\(registrationModel.remarks)"
        timeL.text = registrationModel.createTime
    }
    
    func setRegisterModel(_ registrationModel:XHWLRegisterationModel) {
        titleL.text = registrationModel.name
        contentL.text = "业主:\(registrationModel.content)"
        registerNameL.text = "登记人：\(registrationModel.registerName)"
        timeL.text = registrationModel.time
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleL.frame = CGRect(x:13, y:0, width:self.frame.size.width-30-13, height:30)
        timeL.frame = CGRect(x:13, y:30, width:60, height:25)
        contentL.frame = CGRect(x:13+timeL.frame.maxX, y:30, width:80, height:25)
        registerNameL.frame = CGRect(x:contentL.frame.maxX, y:30, width:self.frame.size.width-contentL.frame.maxX-30, height:25)
        accessIV.bounds = CGRect(x:0, y:0, width:7, height:12)
        accessIV.center = CGPoint(x:self.frame.size.width-17, y:self.frame.size.height/2.0)
        lineIV.frame = CGRect(x:13, y:self.frame.size.height-0.5, width:self.frame.size.width-30, height:0.5)
        
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
