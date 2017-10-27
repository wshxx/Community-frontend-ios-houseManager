//
//  XHWLShowImageView.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/10/26.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLShowImageView: UIView {

    var bgImage:UIImageView!
    var showIV:UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        
        bgImage = UIImageView()
        bgImage.image = UIImage(named:"subview_bg")
        bgImage.frame = self.bounds
        self.addSubview(bgImage)
        
        showIV = UIImageView()
        showIV.image = UIImage(named:"subview_bg")
        showIV.frame = CGRect(x:15, y:15, width:self.bounds.size.width-30, height:self.bounds.size.height-30)
        self.addSubview(showIV)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
