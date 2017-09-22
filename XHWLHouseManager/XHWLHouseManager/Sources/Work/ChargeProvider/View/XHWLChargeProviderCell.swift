//
//  XHWLChargeProviderCell.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/22.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLChargeProviderCell: UITableViewCell {

    var firstBtn:XHWLChargeButton!
    var btnAry:NSMutableArray!
    var onClickCell:(NSInteger)->() = {param in }
    
    class func cellWithTableView(_ tableView:UITableView) -> XHWLChargeProviderCell {
        
        let ID: String = "XHWLChargeProviderCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: ID)
        if (cell == nil) {
            cell =  XHWLChargeProviderCell.init(style: UITableViewCellStyle.default, reuseIdentifier: ID)
        }
        
        return cell as! XHWLChargeProviderCell
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        self.selectionStyle = .none
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
        
    }
    
    func createView(_ array:NSArray) {
        
        btnAry = NSMutableArray()
        
        for i in 0..<array.count {
            
            print("\(array)")
            let firstBtn:XHWLChargeButton = XHWLChargeButton()
            firstBtn.tag = comTag+i
            let model:XHWLDeviceModel = array[i] as! XHWLDeviceModel
            firstBtn.showText(model.DeviceName, model.TypeName)
            firstBtn.addTarget(self, action: #selector(onBtnClick), for: .touchUpInside)
            self.contentView.addSubview(firstBtn)
            btnAry.add(firstBtn)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let width:CGFloat = (self.frame.size.width-45)/4.0
        for i in 0..<btnAry.count {
            let firstBtn:XHWLChargeButton = btnAry[i] as! XHWLChargeButton
            firstBtn.frame = CGRect(x:15+CGFloat(i)*(width+5), y:2, width:width, height:self.bounds.size.height-5)
        }
    }
    
    func onBtnClick(btn:UIButton) {
        
        self.onClickCell(btn.tag-comTag)
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
