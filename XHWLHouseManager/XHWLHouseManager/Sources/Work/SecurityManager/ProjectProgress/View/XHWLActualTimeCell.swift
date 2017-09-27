//
//  XHWLActualTimeCell.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/12.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLActualTimeCell: UITableViewCell {

    var titleL:UILabel!
    var timeL:UILabel!
    var accessIV:UIImageView!
    var lineIV:UIImageView!
    var waringModel:XHWLWarningModel!
   // var progressView:UIProgressView!
    var progressView:XHWLProgressView!
    var progressModel:XHWLRealProgressModel! {
        willSet {
            if newValue != nil {
                
                progressView.progressModel = newValue
            }
        }
    }
    
    class func cellWithTableView(tableView:UITableView) -> XHWLActualTimeCell {
        
        let ID: String = "XHWLActualTimeCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: ID)
        if (cell == nil) {
            cell =  XHWLActualTimeCell.init(style: UITableViewCellStyle.default, reuseIdentifier: ID)
        }
        
        return cell as! XHWLActualTimeCell
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
        
        progressView = XHWLProgressView()
        self.contentView.addSubview(progressView)
        
        accessIV = UIImageView()
        accessIV.image = UIImage(named: "warning_accessView")
        self.contentView.addSubview(accessIV)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        progressView.frame = self.contentView.bounds
       accessIV.bounds = CGRect(x:0, y:0, width:7, height:12)
       accessIV.center = CGPoint(x:self.frame.size.width-17, y:self.frame.size.height/2.0)
        
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
