//
//  XHWLTopView.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/8.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

let btnTag:NSInteger = 100

class XHWLTopView: UIView {

    var bgImage:UIImageView!
    var tipImg:UIImageView!
    var tipLabel:UILabel!
    var btnArray:NSMutableArray!
    var btnBlock:(NSInteger)->(Void) = { param in }
    var selectBtn:UIButton!
    
//    static var shared: XHWLTopView {
//        struct Static {
//            static let instance: XHWLTopView = XHWLTopView.init(frame: CGRect.zero)
//        }
//        return Static.instance
//    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        
        setupView()
    }
    
    func setupView() {
        
        bgImage = UIImageView()
        bgImage.image = UIImage(named:"warning_cell_bgBorder")
        self.addSubview(bgImage)
        
//        tipImg = UIImageView()
//        tipImg.image = UIImage(named:"warning_cell_bgBorder")
//        self.addSubview(tipImg)
        

    }
    
    func createArray(array:NSArray) {
        
        btnArray = NSMutableArray()
        
        for i in 0...array.count-1 {
            let btn:UIButton = UIButton()
            let text:String = array[i] as! String
            btn.setTitle(text, for: UIControlState.normal)
            btn.tag = i+btnTag
            btn.setTitleColor(UIColor.white, for: UIControlState.normal)
            btn.addTarget(self, action: #selector(btnClick), for: UIControlEvents.touchUpInside)
            self.addSubview(btn)
            btnArray.add(btn)
            
            if i == 0 {
                selectBtn = btn
                btn.setTitleColor(UIColor().colorWithHexString(colorStr: "09fbfe"), for: UIControlState.normal)
            }
        }
        
        if array.count > 1 {
            tipLabel = UILabel()
            tipLabel.backgroundColor = UIColor().colorWithHexString(colorStr: "09fbfe")
            self.addSubview(tipLabel)
        }
        
    }
    
    func btnClick(btn:UIButton) {
        
        if btnArray.count > 1 {
            selectBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
            selectBtn = btn
            let w:CGFloat = self.frame.size.width/CGFloat(btnArray.count)
            UIView.animate(withDuration: 0.3) {
                
                self.selectBtn.setTitleColor(UIColor().colorWithHexString(colorStr: "09fbfe"), for: UIControlState.normal)
                self.tipLabel.frame = CGRect(x:self.selectBtn.frame.minX+40, y:self.bounds.size.height-2, width:(w-80), height:2)
            }
        }
        self.btnBlock(btn.tag-btnTag)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bgImage.frame = self.bounds
//        tipImg.frame = self.bounds
        
        let w:CGFloat = self.frame.size.width/CGFloat(btnArray.count)
        for i in 0...btnArray.count-1 {
            
            let btn:UIButton = btnArray[i] as! UIButton
            btn.frame = CGRect(x:w.multiplied(by: CGFloat(i)), y:0, width:w, height:self.frame.size.height)
        }
       
        if btnArray.count > 1 {
            tipLabel.frame = CGRect(x:selectBtn.frame.minX+40, y:self.bounds.size.height-2, width:(w-80), height:2)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
