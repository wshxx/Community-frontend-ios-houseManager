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
    var visitorLogModel:XHWLVisitLogModel!
    var btnBlock:(NSInteger)->(Void) = { param in }
    var array:NSArray!
    
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
        
        self.array = array
        labelViewArray = NSMutableArray()
        
        for i in 0...array.count-1 {
            
            let menuModel :XHWLMenuModel = array[i] as! XHWLMenuModel
            let labelView: XHWLLineView = XHWLLineView()
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
        
        var maxH:CGFloat = 20
        for i in 0...labelViewArray.count-1 {
            
            let menuModel :XHWLMenuModel = array[i] as! XHWLMenuModel
            
            let size:CGSize = menuModel.content.boundingRect(with: CGSize(width:self.bounds.size.width-100, height:CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:font_14], context: nil).size
            let height:CGFloat = size.height < font_14.lineHeight ? font_14.lineHeight:size.height
            let label:XHWLLineView = labelViewArray[i] as! XHWLLineView
            label.frame = CGRect(x:0, y:Int(maxH+10), width:Int(self.bounds.size.width), height:Int(height)) // 40
            maxH = label.frame.maxY
        }
        
        showIV.frame = CGRect(x:self.bounds.size.width-130, y:self.frame.size.height-90, width:94, height:51)
    }

}
