//
//  JGProgressView.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/19.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit


let KProgressBorderWidth:CGFloat = 0.5

class JGProgressView: UIView {
    
    var tView:UIView!
    var progress:CGFloat! {
        willSet {
            if (newValue != nil)  {
                let margin:CGFloat  = KProgressBorderWidth
                let maxWidth:CGFloat  = self.bounds.size.width - margin * 2
                let heigth: CGFloat = self.bounds.size.height - margin * 2
                
                tView.frame = CGRect(x:margin, y:margin, width:maxWidth * newValue, height:heigth)
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //边框
        let borderView:UIView  = UIView.init(frame: self.bounds)
        borderView.backgroundColor = UIColor.clear
        borderView.layer.borderColor = color_01f0ff.cgColor
        borderView.layer.borderWidth = KProgressBorderWidth
        self.addSubview(borderView)
        
        //进度
        tView = UIView()
        tView.backgroundColor = color_01f0ff
        self.addSubview(tView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
