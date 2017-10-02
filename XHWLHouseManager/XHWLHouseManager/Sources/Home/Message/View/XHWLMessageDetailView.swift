//
//  XHWLMessageDetailView.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/10/1.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLMessageDetailView: UIView {

    var bgImage:UIImageView!
    var bgScrollView:UIScrollView!
    var dataAry:NSArray! = NSArray()
    var labelViewArray:NSMutableArray = NSMutableArray()
    var backReloadBlock:()->() = {param in }
    
    init(frame: CGRect, _ dataAry:NSArray) {
        super.init(frame: frame)
        
        self.dataAry = dataAry
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
        bgImage = UIImageView()
        bgImage.image = UIImage(named:"subview_bg")
        self.addSubview(bgImage)
        
        bgScrollView = UIScrollView()
        bgScrollView.showsVerticalScrollIndicator = false
        self.addSubview(bgScrollView)
        
        labelViewArray = NSMutableArray()
        for i in 0..<dataAry.count {
            let menuModel :XHWLMenuModel = dataAry[i] as! XHWLMenuModel
            let labelView: XHWLLineView = XHWLLineView()
            labelView.showText(leftText: menuModel.name, rightText:menuModel.content)
            bgScrollView.addSubview(labelView)
            labelViewArray.add(labelView)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bgImage.frame = self.bounds
        bgScrollView.frame = CGRect(x:0, y:0, width:self.bounds.size.width, height:self.bounds.size.height)
        var maxH:CGFloat = 20
        
        if labelViewArray.count > 0 {
            for i in 0...labelViewArray.count-1 {
                let menuModel :XHWLMenuModel = dataAry[i] as! XHWLMenuModel
                
                let size:CGSize = menuModel.content.boundingRect(with: CGSize(width:self.frame.size.width-30-100, height:CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:font_14], context: nil).size
                let height:CGFloat = size.height < font_14.lineHeight ? font_14.lineHeight:size.height
                let labelView:XHWLLineView = labelViewArray[i] as! XHWLLineView
                
                labelView.bounds = CGRect(x:0, y:0, width:Int(self.frame.size.width-30), height:Int(height))
                labelView.center = CGPoint(x:self.frame.size.width/2.0, y:(height)/2.0 + 5 + maxH)
                maxH = labelView.frame.maxY
            }
        }
    }
    
}
