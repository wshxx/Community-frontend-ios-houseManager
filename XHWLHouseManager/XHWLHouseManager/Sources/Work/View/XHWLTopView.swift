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
    var tipLabel:UILabel!
    var btnArray:NSMutableArray! = NSMutableArray()
    var btnBlock:(NSInteger)->(Void) = { param in }
    var selectBtn:UIButton!
    var sc:UIScrollView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        
        bgImage = UIImageView()
        bgImage.image = UIImage(named:"warning_subview_top_bg")
        self.addSubview(bgImage)
        
        

    }
    
    func createModelArray(_ array:NSArray) {
        
        sc = UIScrollView()
        sc.showsHorizontalScrollIndicator = false
        self.addSubview(sc)
        
        btnArray = NSMutableArray()
        
        for i in 0..<array.count {
            
            let btn:UIButton = UIButton()
            let model:XHWLDeviceTitleModel = array[i] as! XHWLDeviceTitleModel
            print("\(model.deviceTitle)")
            btn.setTitle(model.deviceTitle, for: UIControlState.normal)
            btn.tag = i+btnTag
            btn.contentHorizontalAlignment = .center
            btn.setTitleColor(UIColor.white, for: UIControlState.normal)
            btn.addTarget(self, action: #selector(btnClick), for: UIControlEvents.touchUpInside)
            sc.addSubview(btn)
            btnArray.add(btn)
            
            if i == 0 {
                selectBtn = btn
                btn.setTitleColor(UIColor().colorWithHexString(colorStr: "09fbfe"), for: UIControlState.normal)
            }
        }
        
        if array.count > 1 {
            tipLabel = UILabel()
            tipLabel.backgroundColor = UIColor().colorWithHexString(colorStr: "09fbfe")
            sc.addSubview(tipLabel)
        }
        
    }
    
    func createArray(array:NSArray) {
        
        sc = UIScrollView()
        sc.showsHorizontalScrollIndicator = false
        self.addSubview(sc)
        
        btnArray = NSMutableArray()
        
        
        for i in 0..<array.count {
            
            let btn:UIButton = UIButton()
            let text:String = array[i] as! String
            btn.setTitle(text, for: UIControlState.normal)
            btn.tag = i+btnTag
            btn.contentHorizontalAlignment = .center
            btn.setTitleColor(UIColor.white, for: UIControlState.normal)
            btn.addTarget(self, action: #selector(btnClick), for: UIControlEvents.touchUpInside)
            sc.addSubview(btn)
            btnArray.add(btn)
            
            if i == 0 {
                selectBtn = btn
                btn.setTitleColor(UIColor().colorWithHexString(colorStr: "09fbfe"), for: UIControlState.normal)
            }
        }
        
        if array.count > 1 {
            tipLabel = UILabel()
            tipLabel.backgroundColor = UIColor().colorWithHexString(colorStr: "09fbfe")
            sc.addSubview(tipLabel)
        }
        
    }
    
    func btnClick(btn:UIButton) {
        
        if btnArray.count > 1 {
            selectBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
            selectBtn = btn
            let w:CGFloat = self.frame.size.width/CGFloat(btnArray.count)
            UIView.animate(withDuration: 0.3) {
                
                self.selectBtn.setTitleColor(UIColor().colorWithHexString(colorStr: "09fbfe"), for: UIControlState.normal)
                
                if self.btnArray.count <= 2 {
                    self.tipLabel.frame = CGRect(x:self.selectBtn.frame.minX+40, y:self.bounds.size.height-18, width:(w-80), height:2)
                } else {
                    
                    self.tipLabel.frame = CGRect(x:self.selectBtn.frame.minX, y:self.bounds.size.height-18, width:120, height:2)
                }
            }
        }
        self.btnBlock(btn.tag-btnTag)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bgImage.frame = self.bounds
        
        if btnArray.count > 0 {
            sc.frame = CGRect(x:20, y:0, width:self.bounds.size.width-40, height:self.bounds.size.height)
            
            if btnArray.count <= 2 {
                let w:CGFloat = self.frame.size.width/CGFloat(btnArray.count)
                sc.contentSize = CGSize(width:0, height:0)
                for i in 0..<btnArray.count {
                    
                    let btn:UIButton = btnArray[i] as! UIButton
                    btn.frame = CGRect(x:w.multiplied(by: CGFloat(i)), y:16, width:w, height:self.frame.size.height-32)
                }
                if btnArray.count > 1 {
                    tipLabel.frame = CGRect(x:selectBtn.frame.minX+40, y:self.bounds.size.height-18, width:(w-80), height:2)
                }
            } else {
                let w:CGFloat = 120
                sc.contentSize = CGSize(width:btnArray.count*120+20, height:0)
                for i in 0..<btnArray.count {
                    
                    let btn:UIButton = btnArray[i] as! UIButton
                    btn.frame = CGRect(x:w.multiplied(by: CGFloat(i)), y:16, width:w, height:self.frame.size.height-32)
                }
                
                if btnArray.count > 1 {
                    tipLabel.frame = CGRect(x:selectBtn.frame.minX, y:self.bounds.size.height-18, width:w, height:2)
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
