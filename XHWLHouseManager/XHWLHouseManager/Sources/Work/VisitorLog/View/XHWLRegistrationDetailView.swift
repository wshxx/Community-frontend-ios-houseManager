//
//  XHWLRegistrationDetailView.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/10.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLRegistrationDetailView: UIView {

    var bgImage:UIImageView!
    var titleL:UILabel!
    var showIV:UIImageView!
    var labelViewArray:NSMutableArray!
    var btnBlock:(NSInteger)->(Void) = { param in }
    
    static var shared: XHWLRegistrationDetailView {
        struct Static {
            static let instance: XHWLRegistrationDetailView = XHWLRegistrationDetailView.init(frame: CGRect.zero)
        }
        return Static.instance
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        
        
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
        bgImage = UIImageView()
        bgImage.image = UIImage(named:"menu_bg")
        self.addSubview(bgImage)
        
        titleL = UILabel()
        titleL.textAlignment = NSTextAlignment.center
        titleL.textColor = UIColor().colorWithHexString(colorStr: "09fbfe")
        titleL.font = font_13
        titleL.text = "登记详情"
        self.addSubview(titleL)
        
        showIV = UIImageView()
        self.addSubview(showIV)
    }
    
    func successView() {
        
        showIV.image = UIImage(named: "xhwl_bg")
    }
    func failView() {
        
        showIV.image = UIImage(named: "xhwl_bg")
    }
    
    func createArray(array:NSArray) {
        
        labelViewArray = NSMutableArray()
        
        for i in 0...array.count-1 {
            
            let menuModel :XHWLMenuModel = array[i] as! XHWLMenuModel
            let labelView: XHWLLabelView = XHWLLabelView()
            labelView.showText(leftText: menuModel.name, rightText:menuModel.content)
            self.addSubview(labelView)
            labelViewArray.add(labelView)
        }
    }
    
    func onDeviceDetail() {
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bgImage.frame = self.bounds
        //        tipLabel.frame = CGRect(x:10, y:self.bounds.size.height-80, width:self.bounds.size.width-20, height:40)
        titleL.frame = CGRect(x:10, y:23, width:self.bounds.size.width-20, height:44)
        
        for i in 0...labelViewArray.count-1 {
            
            let label:XHWLLabelView = labelViewArray[i] as! XHWLLabelView
            label.frame = CGRect(x:75, y:30*i+55, width:Int(self.bounds.size.width-85), height:30)
        }
        
        showIV.frame = CGRect(x:self.bounds.size.width-130, y:self.frame.size.height-90, width:100, height:55)
        
    }

}
