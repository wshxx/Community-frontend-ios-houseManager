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
    var progressView:UIProgressView!
    
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
        
        progressView = UIProgressView(progressViewStyle:UIProgressViewStyle.default)
        progressView.progress=0.8 //默认进度50%
        progressView.progressTintColor=color_01f0ff  //已有进度颜色
        progressView.trackTintColor=UIColor.red  //剩余进度颜色（即进度槽颜色）
        //        progressView.setProgress(0.8,animated:true)
      //  progressView.layer.borderColor = color_58e9f3.cgColor
        //progressView.layer.borderWidth = 0.5
        progressView.frame = CGRect(x:0, y:0, width:200, height:25)
        //设置进度条位置（水平居中）
        progressView.layer.position = CGPoint(x:self.bounds.size.width/2.0, y: 100)
        progressView.transform = CGAffineTransform(scaleX: 1.0, y: 5.0)
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
      //  accessIV.bounds = CGRect(x:0, y:0, width:7, height:12)
       // accessIV.center = CGPoint(x:self.frame.size.width-17, y:self.frame.size.height/2.0)
        lineIV.frame = CGRect(x:13, y:self.frame.size.height-0.5, width:self.frame.size.width-30, height:0.5)
    }
}
