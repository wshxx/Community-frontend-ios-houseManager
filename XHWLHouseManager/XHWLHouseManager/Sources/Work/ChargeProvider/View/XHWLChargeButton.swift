//
//  XHWLChargeButton.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/22.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLChargeButton: UIButton {

    var titleL:UILabel!
    var detailL:UILabel!
    var btnBlock:()->(Void) = { param in }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setBackgroundImage(UIImage(named:"power_bg"), for: .normal)
        setupView()
    }
    
    func setupView() {
        
        titleL = UILabel()
        titleL.textColor = UIColor.white
        titleL.font = font_13
        titleL.numberOfLines = 0
        titleL.textAlignment = .center
        self.addSubview(titleL)
        
        detailL = UILabel()
        detailL.font = font_13
        detailL.textColor = color_09fbfe
        detailL.textAlignment = .center
        self.addSubview(detailL)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        titleL.frame = CGRect(x:5, y:0, width:self.bounds.size.width-10, height:self.bounds.size.height/2.0)
        detailL.frame = CGRect(x:5, y:self.bounds.size.height/2.0, width:self.bounds.size.width-10, height:self.bounds.size.height/2.0)
    }
    
    func showText(_ title:String, _ detailText:String) {
        self.titleL.text = title
        self.detailL.text = detailText
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
