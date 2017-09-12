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
    var progressView:UIProgressView!
    
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
        
        titleL = UILabel()
        titleL.textColor = UIColor.white
        titleL.font = font_12
        titleL.text = "许柳飞"
        self.contentView.addSubview(titleL)
        
        progressView = UIProgressView(progressViewStyle:UIProgressViewStyle.default)
        progressView.progress=0.8 //默认进度50%
        progressView.progressTintColor=color_01f0ff  //已有进度颜色
        progressView.trackTintColor=UIColor.red  //剩余进度颜色（即进度槽颜色）
        //        progressView.setProgress(0.8,animated:true)
        self.contentView.addSubview(progressView)
        
        timeL = UILabel()
        timeL.textColor = UIColor().colorWithHexString(colorStr: "7a9198")
        timeL.font = font_9
        timeL.text = "12/22"
        self.contentView.addSubview(timeL)
        
        accessIV = UIImageView()
        accessIV.image = UIImage(named: "warning_accessView")
        self.contentView.addSubview(accessIV)
        
        lineIV = UIImageView()
        lineIV.image = UIImage(named: "warning_cell_line")
        self.contentView.addSubview(lineIV)
    }
    
    func setModel(waringModel:XHWLWarningModel) {
        titleL.text = waringModel.name
        timeL.text = waringModel.time
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleL.frame = CGRect(x:13, y:0, width:80, height:44)
        progressView.frame = CGRect(x:0, y:0, width:200, height:25)
        progressView.center = CGPoint(x:self.bounds.size.width/2.0, y:self.bounds.size.height/2.0)
        progressView.transform = CGAffineTransform(scaleX: 1.0, y: 5.0)
        timeL.frame = CGRect(x:progressView.frame.maxX+5, y:0, width:60, height:44)
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
