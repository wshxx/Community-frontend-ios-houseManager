//
//  XHWLLineView.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/20.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLLineView: UIView {

    var titleL:UILabel!
    var contentL:UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        self.backgroundColor = UIColor.red
        setupView()
    }
    
    func setupView() {
        
        titleL = UILabel()
        titleL.textColor = UIColor.white
        titleL.textAlignment = .right
        titleL.font = font_14
        self.addSubview(titleL)
        
        contentL = UILabel.init(frame: CGRect(x:0,
                                              y:0,
                                              width:100,
                                              height:font_14.lineHeight))
        contentL.font = font_14
        contentL.textColor = UIColor.white
        contentL.numberOfLines = 0
        contentL.textAlignment = NSTextAlignment(rawValue: 7)!
        self.addSubview(contentL)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleL.frame = CGRect(x:10, y:0, width:80, height:font_14.lineHeight)
        
        let size:CGSize = contentL.text!.boundingRect(with: CGSize(width:self.bounds.size.width-100, height:CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:font_14], context: nil).size
        contentL.frame = CGRect(x: 90, y: 0, width: self.bounds.size.width-100, height:size.height)
    }
    
    func showText(leftText:String, rightText:String) {
        titleL.text = leftText
        contentL.text = rightText
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
