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
    var scrollView:UIScrollView!
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
        
        scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        self.addSubview(scrollView)
        
        showImg = UIImageView()
        showImg.image = UIImage(named:"scan_show")
        self.addSubview(showImg)
        
        titleL = UILabel()
        titleL.textAlignment = NSTextAlignment.center
        titleL.textColor = UIColor.white
        titleL.font = font_13
        titleL.text = "电梯"
        scrollView.addSubview(titleL)
        
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
            scrollView.addSubview(labelView)
            labelViewArray.add(labelView)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let img:UIImage = UIImage(named:"btn_background")!
        bgImage.frame = self.bounds
        showImg.frame = CGRect(x:(self.bounds.size.width-Screen_width*2/3.0)/2.0, y:20, width:Screen_width*2/3.0, height:Screen_height/3.0)
        scrollView.frame = CGRect(x:0, y:showImg.frame.maxY+10, width:self.bounds.size.width, height:self.bounds.size.height-showImg.frame.maxY-img.size.height-30)
        titleL.frame = CGRect(x:10, y:0, width:self.bounds.size.width-20, height:30)

        let h:CGFloat = titleL.frame.maxY+10
        
        var height:CGFloat = 0
        if labelViewArray.count > 0 {
            for i in 0...labelViewArray.count-1 {
                let label:XHWLLabelView = labelViewArray[i] as! XHWLLabelView
                label.frame = CGRect(x:50, y:CGFloat(i).multiplied(by: 30.0) + h, width:self.bounds.size.width-70, height:30)
                height = label.frame.maxY
            }
        }
        
        scrollView.contentSize = CGSize(width:0, height:height+5)
        okBtn.frame = CGRect(x:self.bounds.size.width-img.size.width-50, y:self.bounds.size.height-img.size.height-20, width:img.size.width, height:img.size.height)
        cancelBtn.frame = CGRect(x:50, y:self.bounds.size.height-img.size.height-20, width:img.size.width, height:img.size.height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
