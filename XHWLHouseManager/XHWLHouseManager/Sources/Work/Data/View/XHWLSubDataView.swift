//
//  XHWLSubDataView.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/19.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLSubDataView: UIView {

    var titleL:UILabel!
    var contentL:UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
        titleL = UILabel()
        titleL.font = font_14
        titleL.textColor = UIColor.white
        titleL.textAlignment = NSTextAlignment.center
        self.addSubview(titleL)
        
        contentL = UILabel()
        contentL.textColor = color_01f0ff
        contentL.font = font_14
        contentL.textAlignment = NSTextAlignment.center
        self.addSubview(contentL)
    }
    
    func setTitle(_ title:String, content:String) {
        titleL.text = title
        contentL.text = content
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleL.frame = CGRect(x:10, y:0, width:self.bounds.size.width-20, height:self.bounds.size.height/2.0)
        contentL.frame = CGRect(x:10, y:self.bounds.size.height/2.0, width:self.bounds.size.width-20, height:self.bounds.size.height/2.0)
    }
}
