//
//  XHMLProgressHUD.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/5.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHMLProgressHUD: UIView {
    
    var indicatorView:HLBarIndicatorView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        self.backgroundColor = UIColor.black
        
        indicatorView = HLBarIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 80))
        indicatorView.center = CGPoint(x:self.frame.size.width/2.0, y:self.frame.size.height/2.0)
        indicatorView.indicatorType = .barScaleFromRight
        self.addSubview(indicatorView)
        
        hide()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show() {
        self.isHidden = false
        self.indicatorView.startAnimating()
    }

    func hide() {
        self.indicatorView.pauseAnimating()
        self.isHidden = true
    }
}
