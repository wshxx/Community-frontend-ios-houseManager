//
//  XHWLCallSubView.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/10/26.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLCallSubView: UIView {

    var bgImage:UIImageView!
    var labelViewArray:NSMutableArray!
    var array:NSArray!
    var bgSc:UIScrollView!
    
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
        bgImage.image = UIImage(named:"Visitor_bg")
        self.addSubview(bgImage)
        
        bgSc = UIScrollView()
        bgSc.showsVerticalScrollIndicator = false
        self.addSubview(bgSc)
    }
    
    func createArray(array:NSArray) {
        
        labelViewArray = NSMutableArray()
        self.array = array
        
        for i in 0...array.count-1 {
            
            let menuModel :XHWLMenuModel = array[i] as! XHWLMenuModel
            let labelView: XHWLLineView = XHWLLineView()
            labelView.showText(leftText: menuModel.name, rightText:menuModel.content)
            bgSc.addSubview(labelView)
            labelViewArray.add(labelView)
        }
    }
    
    func heightWithSize(_ menuModel :XHWLMenuModel ) -> CGFloat {
        
        //        let sizeL:CGSize = menuModel.name.boundingRect(with: CGSize(width:CGFloat(MAXFLOAT), height:30), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:font_14], context: nil).size //CGFloat(self.bounds.size.width-sizeL.width-30)
        let sizeR:CGSize = menuModel.content.boundingRect(with: CGSize(width:CGFloat(Int(self.bounds.size.width-100-15)), height:CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:font_14], context: nil).size
        
        return sizeR.height + 5
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bgImage.frame = self.bounds
        bgSc.frame = self.bounds
        var maxHeight = 25
        for i in 0...labelViewArray.count-1 {
            
            let menuModel :XHWLMenuModel = array[i] as! XHWLMenuModel
            let labelView:XHWLLineView = labelViewArray[i] as! XHWLLineView
            labelView.frame = CGRect(x:0, y:maxHeight+5, width:Int(self.bounds.size.width-15), height:Int(heightWithSize(menuModel)))
            labelView.showText(leftText: menuModel.name, rightText:menuModel.content)
            maxHeight = Int(labelView.frame.maxY)
        }
        
        bgSc.contentSize = CGSize(width:0, height:maxHeight + 30)
        
    }
}
