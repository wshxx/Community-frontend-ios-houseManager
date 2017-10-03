//
//  XHWLHistoryWarningView.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/9.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLHistoryWarningView: UIView {

    var bgImage:UIImageView!
    var btn:UIButton!
    var labelViewArray:NSMutableArray!
    var array:NSArray!
    var btnBlock:()->(Void) = { param in }
    var bgSc:UIScrollView!
    
    static var shared: XHWLHistoryWarningView {
        struct Static {
            static let instance: XHWLHistoryWarningView = XHWLHistoryWarningView.init(frame: CGRect.zero)
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
        
        bgSc = UIScrollView()
        bgSc.showsVerticalScrollIndicator = false
        self.addSubview(bgSc)
        
        btn = UIButton()
        btn.addTarget(self, action: #selector(onDeviceDetail), for: UIControlEvents.touchUpInside)
        btn.setTitle("设备实时运行监控 >>", for: UIControlState.normal)
        btn.titleLabel?.font = font_14
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        btn.setTitleColor(UIColor().colorWithHexString(colorStr: "09fbfe") , for: UIControlState.normal)
        bgSc.addSubview(btn)
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

    func onDeviceDetail() {
        self.btnBlock()
    }
    
    func heightWithSize(_ menuModel :XHWLMenuModel ) -> CGFloat {
        
//        let sizeL:CGSize = menuModel.name.boundingRect(with: CGSize(width:CGFloat(MAXFLOAT), height:30), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:font_14], context: nil).size //CGFloat(self.bounds.size.width-sizeL.width-30)
        let sizeR:CGSize = menuModel.content.boundingRect(with: CGSize(width:CGFloat(Int(self.bounds.size.width-100-30)), height:CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:font_14], context: nil).size
        
        return sizeR.height + 5
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bgImage.frame = self.bounds
        bgSc.frame = self.bounds
        //        tipLabel.frame = CGRect(x:10, y:self.bounds.size.height-80, width:self.bounds.size.width-20, height:40)
        var maxHeight = 25
        for i in 0...labelViewArray.count-1 {
            
            let menuModel :XHWLMenuModel = array[i] as! XHWLMenuModel
            let labelView:XHWLLineView = labelViewArray[i] as! XHWLLineView
            labelView.frame = CGRect(x:15, y:maxHeight+5, width:Int(self.bounds.size.width-30), height:Int(heightWithSize(menuModel)))
            labelView.showText(leftText: menuModel.name, rightText:menuModel.content)
            maxHeight = Int(labelView.frame.maxY)
        }
        
        btn.frame = CGRect(x:50, y:maxHeight+30, width:Int(self.bounds.size.width-100), height:44)
        bgSc.contentSize = CGSize(width:0, height:btn.frame.maxY + 30)
        
    }
}
