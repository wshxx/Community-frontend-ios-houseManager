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
    var btnBlock:(NSInteger)->(Void) = { param in }
    
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
        
        btn = UIButton()
        btn.addTarget(self, action: #selector(onDeviceDetail), for: UIControlEvents.touchUpInside)
        btn.setTitle("设备实时运行监控 >>", for: UIControlState.normal)
        btn.titleLabel?.font = font_12
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        btn.setTitleColor(UIColor().colorWithHexString(colorStr: "09fbfe") , for: UIControlState.normal)
        self.addSubview(btn)
    }
    
    func createArray(array:NSArray) {
        
        labelViewArray = NSMutableArray()
        self.array = array
        
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
    
    func heightWithSize(_ menuModel :XHWLMenuModel ) -> CGFloat {
        
        let sizeL:CGSize = menuModel.name.boundingRect(with: CGSize(width:CGFloat(MAXFLOAT), height:30), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:font_12], context: nil).size
        let sizeR:CGSize = menuModel.content.boundingRect(with: CGSize(width:CGFloat(self.bounds.size.width-sizeL.width-30), height:CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.usesFontLeading, attributes: [NSFontAttributeName:font_12], context: nil).size
        
        return sizeR.height + 10
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bgImage.frame = self.bounds
        //        tipLabel.frame = CGRect(x:10, y:self.bounds.size.height-80, width:self.bounds.size.width-20, height:40)
        
        for i in 0...labelViewArray.count-1 {
            
            let menuModel :XHWLMenuModel = array[i] as! XHWLMenuModel
            let label:XHWLLineView = labelViewArray[i] as! XHWLLineView
            label.frame = CGRect(x:15, y:30*i+5, width:Int(self.bounds.size.width-30), height:Int(heightWithSize(menuModel)))
        }
        
        btn.frame = CGRect(x:50, y:self.frame.size.height-172, width:self.bounds.size.width-100, height:44)
        
    }
}
