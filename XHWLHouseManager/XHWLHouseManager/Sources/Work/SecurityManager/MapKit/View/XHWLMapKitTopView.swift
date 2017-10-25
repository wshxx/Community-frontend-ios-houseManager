//
//  XHWLMapKitTopView.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/10/23.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLMapKitTopView: UIView {

    var timeLeftView:UIView!
    var timeRightView:UIView!
    var personView:UIView!
    var searchBtn:UIButton!
    var trailBtn:UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        timeLeftView = XHWLTimeLeftView(frame: CGRect(x:20, y:20, width:self.bounds.size.width/2.0, height:30))
        self.addSubview(timeLeftView)
        
        timeRightView = XHWLTimeRightView(frame: CGRect(x:self.bounds.size.width/2.0+30, y:20, width:self.bounds.size.width/2.0-20-30, height:30))
        self.addSubview(timeRightView)

        trailBtn = UIButton()
        trailBtn.setTitleColor(UIColor.white, for: .normal)
        trailBtn.setTitle("轨迹回放", for: .normal)
        trailBtn.titleLabel?.font = font_14
        trailBtn.setBackgroundImage(UIImage(named:"Patrol_blue_bg"), for: .normal)
        trailBtn?.frame = CGRect(x:self.bounds.size.width-100, y:60, width:80, height:30)
        self.addSubview(trailBtn)
        
        searchBtn = UIButton()
        searchBtn.setTitleColor(UIColor.white, for: .normal)
        searchBtn.setTitle("查询", for: .normal)
        searchBtn.titleLabel?.font = font_14
        searchBtn.setBackgroundImage(UIImage(named:"Patrol_blue_bg"), for: .normal)
        searchBtn?.frame = CGRect(x:self.bounds.size.width-190, y:60, width:80, height:30)
        self.addSubview(searchBtn)
        
        personView = XHWLPersonView(frame: CGRect(x:20, y:60, width:self.bounds.size.width-200-20, height:30))
        self.addSubview(personView)
    }
}
