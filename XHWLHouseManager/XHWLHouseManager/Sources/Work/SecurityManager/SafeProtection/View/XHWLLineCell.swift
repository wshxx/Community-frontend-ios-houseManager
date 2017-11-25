//
//  XHWLLineCell.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/11/25.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLLineCell: UITableViewCell {

    var lineL: UILabel!
    
    class func cellWithTableView(tableView:UITableView) -> XHWLLineCell {
        
        let ID: String = "XHWLLineCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: ID)
        if (cell == nil) {
            cell =  XHWLLineCell.init(style: UITableViewCellStyle.default, reuseIdentifier: ID)
        }
        
        return cell as! XHWLLineCell
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        
        setupView()
    }
    
    func setupView() {
        
        lineL = UILabel()
        contentView.addSubview(lineL)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        lineL.frame = CGRect(x:60, y:self.contentView.bounds.size.height/2.0, width:self.contentView.bounds.size.width-60, height:0.5)
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
