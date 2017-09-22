//
//  XHWLScanResultView.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/9.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLScanResultView: UIView {

    var bgImage:UIImageView!
    var showImg:UIImageView!
    var titleL:UILabel!
    var okBtn:UIButton!
    var cancelBtn:UIButton!
    var labelViewArray:NSMutableArray! = NSMutableArray()
    var btnBlock:(NSInteger)->(Void) = { param in }
    var dataAry:NSMutableArray!
    
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
    
    func setupView() {
        bgImage = UIImageView()
        bgImage.image = UIImage(named:"menu_bg")
        self.addSubview(bgImage)
        
        showImg = UIImageView()
        showImg.image = UIImage(named:"home_bg")
        self.addSubview(showImg)
        
        titleL = UILabel()
        titleL.textAlignment = NSTextAlignment.center
        titleL.textColor = UIColor.white
        titleL.font = font_13
        titleL.text = "电梯"
        self.addSubview(titleL)
        
        okBtn = UIButton()
        okBtn.tag = comTag + 1
        okBtn.setTitle("报事", for: UIControlState.normal)
        okBtn.setTitleColor(UIColor().colorWithHexString(colorStr: "51ebfd"), for: UIControlState.normal)
        okBtn.addTarget(self, action: #selector(XHWLScanResultView.btnClick), for: UIControlEvents.touchUpInside)
        okBtn.setBackgroundImage(UIImage(named:"btn_background"), for: UIControlState.normal)
        okBtn.titleLabel?.font = font_13
        self.addSubview(okBtn)
        
        cancelBtn = UIButton()
        cancelBtn.setTitle("取消", for: UIControlState.normal)
        cancelBtn.titleLabel?.font = font_13
        cancelBtn.tag = comTag
        cancelBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        cancelBtn.addTarget(self, action: #selector(XHWLScanResultView.btnClick), for: UIControlEvents.touchUpInside)
        cancelBtn.setBackgroundImage(UIImage(named:"btn_background"), for: UIControlState.normal)
        self.addSubview(cancelBtn)
        
    }
    
    func btnClick(btn:UIButton) {
        self.btnBlock(btn.tag-comTag)
    }
    
    func createArray(_ array:NSArray) {
        
        labelViewArray = NSMutableArray()
        
        for i in 0...array.count-1 {
            
            let menuModel :XHWLMenuModel = array[i] as! XHWLMenuModel
            let labelView: XHWLLabelView = XHWLLabelView()
            labelView.showText(leftText: menuModel.name, rightText:menuModel.content)
            labelView.contentTextAlign(textAlignment: NSTextAlignment.right)
            self.addSubview(labelView)
            labelViewArray.add(labelView)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bgImage.frame = self.bounds
        showImg.frame = CGRect(x:(self.bounds.size.width-227)/2.0, y:20, width:227, height:227)
        titleL.frame = CGRect(x:10, y:showImg.frame.maxY+10, width:self.bounds.size.width-20, height:30)
        let img:UIImage = UIImage(named:"btn_background")!
        let h:CGFloat = titleL.frame.maxY+10
        
        if labelViewArray.count > 0 {
            for i in 0...labelViewArray.count-1 {
                let label:XHWLLabelView = labelViewArray[i] as! XHWLLabelView
                label.frame = CGRect(x:50, y:CGFloat(i).multiplied(by: 30.0) + h, width:self.bounds.size.width-70, height:30)
            }
        }

        okBtn.frame = CGRect(x:self.bounds.size.width-img.size.width-50, y:self.bounds.size.height-img.size.height-20, width:img.size.width, height:img.size.height)
        cancelBtn.frame = CGRect(x:50, y:self.bounds.size.height-img.size.height-20, width:img.size.width, height:img.size.height)
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
