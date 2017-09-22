//
//  XHWLTipView.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/8.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLTipView: UIView {

    var bgImage:UIImageView!
    var tipImg:UIImageView!
    var tipLabel:UILabel!
    
//    static var share = XHWLTipView.init(frame: CGRect(x:(Screen_width-311)/2.0, y:(Screen_height-178)/2.0, width:311, height:178))
    
    static var shared: XHWLTipView {
        struct Static {
            static let instance: XHWLTipView = XHWLTipView.init(frame: CGRect(x:(Screen_width-311)/2.0, y:(Screen_height-178)/2.0, width:311, height:178))
        }
        return Static.instance
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 311, 178
        
        bgImage = UIImageView()
        bgImage.frame = self.bounds
        bgImage.image = UIImage(named:"menu_bg")
        self.addSubview(bgImage)
        
        tipImg = UIImageView()
        tipImg.frame = CGRect(x:0, y:0, width:55, height:55)
        tipImg.center = CGPoint(x: self.bounds.size.width/2.0, y: self.bounds.size.height/2.0-20)
        self.addSubview(tipImg)
        
        tipLabel = UILabel()
        tipLabel.frame = CGRect(x:10, y:self.bounds.size.height-80, width:self.bounds.size.width-20, height:40)
        tipLabel.textAlignment = NSTextAlignment.center
        tipLabel.textColor = UIColor().colorWithHexString(colorStr: "32b7e2")
        tipLabel.font = font_15
        self.addSubview(tipLabel)
    }
    
    func showSuccess(_ successText:String) {
        tipImg.image = UIImage(named:"finished")
        tipLabel.text = successText
        let window:UIWindow = UIApplication.shared.keyWindow!
        window.addSubview(self)
    }
    
    func remove() {
        self.removeFromSuperview()
    }
    
    func showError(_ errorText:String) {
        tipImg.image = UIImage(named:"failure")
        tipLabel.text = errorText
        let window:UIWindow = UIApplication.shared.keyWindow!
        window.addSubview(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
