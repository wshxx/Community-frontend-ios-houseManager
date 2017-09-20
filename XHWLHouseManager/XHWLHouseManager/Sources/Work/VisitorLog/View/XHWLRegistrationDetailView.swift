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
        bgImage.image = UIImage(named:"subview_bg")
        self.addSubview(bgImage)
        
        showIV = UIImageView()
        self.addSubview(showIV)
    }
    
    func successView() {
        
        showIV.image = UIImage(named: "argee")
    }
    func failView() {
        
        showIV.image = UIImage(named: "disagree")
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
        
        for i in 0...labelViewArray.count-1 {
            
            let label:XHWLLabelView = labelViewArray[i] as! XHWLLabelView
            label.frame = CGRect(x:75, y:30*i+5, width:Int(self.bounds.size.width-85), height:30)
        }
        
        showIV.frame = CGRect(x:self.bounds.size.width-130, y:self.frame.size.height-90, width:94, height:51)
    }

}
