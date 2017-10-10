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
    var dataAry:NSArray!
    
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
        
        dataAry = array
        labelViewArray = NSMutableArray()
        
        for i in 0..<array.count {
            
            let menuModel :XHWLMenuModel = array[i] as! XHWLMenuModel
//            let labelView: XHWLLabelView = XHWLLabelView()
            let labelView: XHWLLineView = XHWLLineView()
            labelView.showText(leftText: menuModel.name, rightText:menuModel.content)
            labelView.textAlignment = NSTextAlignment(rawValue: 8)!
            scrollView.addSubview(labelView)
            labelViewArray.add(labelView)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let img:UIImage = UIImage(named:"btn_background")!
        bgImage.frame = self.bounds
        showImg.frame = CGRect(x:(self.bounds.size.width-Screen_width*2/3.0)/2.0, y:20, width:Screen_width*2/3.0, height:Screen_height/3.0)
        scrollView.frame = CGRect(x:0, y:showImg.frame.maxY+10, width:self.bounds.size.width, height:self.bounds.size.height-showImg.frame.maxY-img.size.height-40)
        titleL.frame = CGRect(x:10, y:0, width:self.bounds.size.width-20, height:30)
        
        var height:CGFloat = titleL.frame.maxY
        if labelViewArray.count > 0 {
            for i in 0..<labelViewArray.count {
//                let label:XHWLLabelView = labelViewArray[i] as! XHWLLabelView
//                label.frame = CGRect(x:15, y:CGFloat(i).multiplied(by: 30.0) + h, width:self.bounds.size.width-30, height:30)
//                height = label.frame.maxY
                
                let menuModel :XHWLMenuModel = dataAry[i] as! XHWLMenuModel
                let size:CGSize = menuModel.content.boundingRect(with: CGSize(width:self.frame.size.width-30-100, height:CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:font_14], context: nil).size
                let labelH:CGFloat = size.height < font_14.lineHeight ? font_14.lineHeight:size.height
                let labelView:XHWLLineView = labelViewArray[i] as! XHWLLineView
                labelView.frame = CGRect(x:5, y:Int(height + 10), width:Int(self.frame.size.width-20), height:Int(labelH))
                
                height = labelView.frame.maxY
            }
        }
        
        scrollView.contentSize = CGSize(width:0, height:height+30)
        okBtn.frame = CGRect(x:self.bounds.size.width-img.size.width-50, y:self.bounds.size.height-img.size.height-20, width:img.size.width, height:img.size.height)
        cancelBtn.frame = CGRect(x:50, y:self.bounds.size.height-img.size.height-20, width:img.size.width, height:img.size.height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
