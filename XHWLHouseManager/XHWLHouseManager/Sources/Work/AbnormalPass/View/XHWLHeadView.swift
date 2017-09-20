//
//  XHWLHeadView.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/11.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLHeadView: UIView {

    var titleL:UILabel!
    var lineV:UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    func setupView() {
        
        titleL = UILabel()
        titleL.textColor = UIColor.white
        titleL.font = font_12
        titleL.text = "业主认证："
        self.addSubview(titleL)
        
        lineV = UIImageView()
        lineV.image = UIImage(named:"warning_cell_line")
        self.addSubview(lineV)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        let size:CGSize = titleL.text!.boundingRect(with: CGSize(width:CGFloat(MAXFLOAT), height:self.bounds.size.height), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:titleL.font], context: nil).size
        
        titleL.frame = CGRect(x:10, y:0, width:size.width, height:self.bounds.size.height)
        
        lineV.frame = CGRect(x:titleL.frame.maxX+10, y:self.bounds.size.height/2.0, width:self.bounds.size.width-titleL.frame.maxX-30, height:0.5)
    }
    
    func showText(_ leftText:String) {
        titleL.text = leftText
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
