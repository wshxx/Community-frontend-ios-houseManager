//
//  XHWLPickerCell.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/21.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLPickerCell: UITableViewCell {

    var titleL:UILabel!
//    var lineIV:UIImageView!
    
    class func cellWithTableView(_ tableView:UITableView) -> XHWLPickerCell {
        
        let ID: String = "XHWLPickerCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: ID)
        if (cell == nil) {
            cell =  XHWLPickerCell.init(style: UITableViewCellStyle.default, reuseIdentifier: ID)
        }
        
        return cell as! XHWLPickerCell
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
        
        titleL = UILabel()
        titleL.textColor = UIColor.white
        titleL.textAlignment = .center
        titleL.font = font_14
        self.contentView.addSubview(titleL)
        
//        lineIV = UIImageView()
//        lineIV.image = UIImage(named: "warning_cell_line")
//        self.contentView.addSubview(lineIV)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleL.frame = CGRect(x:15, y:0, width:self.frame.size.width-30, height:self.bounds.size.height)
//        lineIV.frame = CGRect(x:0, y:self.frame.size.height-0.5, width:self.frame.size.width, height:0.5)
        
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
