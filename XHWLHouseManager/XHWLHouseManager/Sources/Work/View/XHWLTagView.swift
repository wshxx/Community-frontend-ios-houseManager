//
//  XHWLTagView.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/10.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLTagView: UIView {

    var btnArray:NSMutableArray! = NSMutableArray()
    var btnBlock:(NSInteger)->(Void) = { param in }
    var selectBtn:UIButton!
    
    
//    static var shared: XHWLTagView {
//        struct Static {
//            static let instance: XHWLTagView = XHWLTagView.init(frame: CGRect.zero)
//        }
//        return Static.instance
//    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
    }
    
    func createModelArray(_ array:NSArray) {
        
        for i in 0..<btnArray.count {
            let btn:UIButton = btnArray[i] as! UIButton
            btn.removeFromSuperview()
        }
        btnArray = NSMutableArray()
        
        for i in 0..<array.count {
            let btn:UIButton = UIButton()
            let model:XHWLDeviceSubTitleModel = array[i] as! XHWLDeviceSubTitleModel
            btn.setTitle(model.deviceSubTitle, for: UIControlState.normal)
            btn.tag = i+btnTag
            btn.titleLabel?.font = font_13
            btn.setBackgroundImage(UIImage(named:"xhwl_water"), for: UIControlState.normal)
            btn.setTitleColor(UIColor.white, for: UIControlState.normal)
            btn.addTarget(self, action: #selector(btnClick), for: UIControlEvents.touchUpInside)
            self.addSubview(btn)
            btnArray.add(btn)
            
            if i == 0 {
                selectBtn = btn
                btn.setTitleColor(UIColor().colorWithHexString(colorStr: "09fbfe"), for: UIControlState.normal)
            }
        }
    }
    
    
    func createArray(array:NSArray) {
        
        btnArray = NSMutableArray()
        
        for i in 0..<array.count {
            let btn:UIButton = UIButton()
            let text:String = array[i] as! String
            btn.setTitle(text, for: UIControlState.normal)
            btn.tag = i+btnTag
            btn.titleLabel?.font = font_14
            btn.setBackgroundImage(UIImage(named:"xhwl_water"), for: UIControlState.normal)
            btn.setTitleColor(UIColor.white, for: UIControlState.normal)
            btn.addTarget(self, action: #selector(btnClick), for: UIControlEvents.touchUpInside)
            self.addSubview(btn)
            btnArray.add(btn)
            
            if i == 0 {
                selectBtn = btn
                btn.setTitleColor(UIColor().colorWithHexString(colorStr: "09fbfe"), for: UIControlState.normal)
            }
        }
    }
    
    func btnClick(btn:UIButton) {
        if btnArray.count > 1 {
            selectBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
            selectBtn = btn
            UIView.animate(withDuration: 0.3) {
                
                self.selectBtn.setTitleColor(UIColor().colorWithHexString(colorStr: "09fbfe"), for: UIControlState.normal)
            }
        }
        self.btnBlock(btn.tag-btnTag)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let w:CGFloat = (self.frame.size.width-30)/3.0
        
        for i in 0..<btnArray.count {
            
            let btn:UIButton = btnArray[i] as! UIButton
            btn.frame = CGRect(x:(w+5).multiplied(by: CGFloat(i%3))+10, y:CGFloat(15 + 40*(i/3)), width:w, height:30)
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
