//
//  XHWLProgressView.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/15.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLProgressView: UIView {
    
    var titleL:UILabel!
    var timeL:UILabel!
    //var accessIV:UIImageView!
    var lineIV:UIImageView!
    var waringModel:XHWLWarningModel!
    var progressView:JGProgressView!
    var progressModel:XHWLRealProgressModel! {
        willSet {
            if newValue != nil {
                titleL.text = newValue.nickname
                timeL.text = newValue.progress
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        
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
        self.addSubview(titleL)
        
        //进度条
        progressView = JGProgressView.init(frame: CGRect(x:0, y:0, width:180, height:12))
        progressView.progress = 0.5
        self.addSubview(progressView)
        
        timeL = UILabel()
        timeL.textColor = UIColor().colorWithHexString(colorStr: "7a9198")
        timeL.font = font_9
        timeL.text = "12/22"
        self.addSubview(timeL)
        
        lineIV = UIImageView()
        lineIV.image = UIImage(named: "warning_cell_line")
        self.addSubview(lineIV)
    }
    
//    func setModel(waringModel:XHWLWarningModel) {
//        titleL.text = waringModel.name
//        timeL.text = waringModel.time
//    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleL.frame = CGRect(x:13, y:0, width:80, height:44)
        progressView.frame = CGRect(x:0, y:0, width:180, height:12)
        timeL.frame = CGRect(x:self.frame.size.width-60, y:0, width:40, height:44)
//      //  accessIV.bounds = CGRect(x:0, y:0, width:7, height:12)
//       // accessIV.center = CGPoint(x:self.frame.size.width-17, y:self.frame.size.height/2.0)
        lineIV.frame = CGRect(x:13, y:self.frame.size.height-0.5, width:self.frame.size.width-30, height:0.5)
        progressView.center = CGPoint(x:self.bounds.size.width/2.0, y:self.bounds.size.height/2.0)
    }
}
