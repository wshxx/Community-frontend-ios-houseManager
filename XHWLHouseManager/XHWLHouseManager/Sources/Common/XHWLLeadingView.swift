//
//  XHWLLeadingView.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/29.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLLeadingView: UIView {

    var imageV:UIImageView!
    var num:NSInteger! = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        
        num = 0
        imageV = UIImageView()
        imageV.image = UIImage(named:"leading_1")
        imageV.frame = self.bounds
        self.addSubview(imageV)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        onTapClick()
    }
    func onTapClick() {
        if num == 0 {
            imageV.image = UIImage(named:"leading_2")
            num = num+1
        } else {
            self.removeFromSuperview()
        }
    }
    
    class func showLeadingView() {
        let leadingView:XHWLLeadingView = XHWLLeadingView(frame:UIScreen.main.bounds)
        let window = UIApplication.shared.keyWindow!
        window.addSubview(leadingView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    


}
