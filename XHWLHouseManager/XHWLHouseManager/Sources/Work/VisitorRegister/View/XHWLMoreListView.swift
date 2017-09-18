//
//  XHWLMoreListView.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/11.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLMoreListView: UIView {

    var labelView:XHWLCheckTF!
    var phoneView:XHWLSelTypeView!
    var cardView:XHWLCheckTF!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    func setupView() {
        
        labelView = XHWLCheckTF()
        labelView.showText(leftText: "业主：", rightText:"")
        self.addSubview(labelView)
        
        phoneView = XHWLSelTypeView()
        phoneView.showText(leftText: "房间：", btnTitle:"请选择")
        phoneView.btnBlock = { [weak phoneView] in
            let array:NSArray = ["亲属", "友人", "家教", "家政", "快递", "外卖", "维修人员", "其他"]
            let pickerView:XHWLPickerView = XHWLPickerView(frame:CGRect.zero, array:array)
            
            let window: UIWindow = (UIApplication.shared.keyWindow)!
            pickerView.dismissBlock = { [weak pickerView] (index)->() in
                print("\(index)")
                if index != -1 {
                    phoneView?.showBtnTitle(array[index] as! String)
                }
                pickerView?.removeFromSuperview()
            }
            pickerView.frame = UIScreen.main.bounds
            window.addSubview(pickerView)
        }
        self.addSubview(phoneView)

        cardView = XHWLCheckTF()
        cardView.showText(leftText: "事由：", rightText:"")
        self.addSubview(cardView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        labelView.bounds = CGRect(x:0, y:0, width:258, height:20)
        labelView.center = CGPoint(x:self.frame.size.width/2.0, y:30)
        
        phoneView.bounds = CGRect(x:0, y:0, width:258, height:20)
        phoneView.center = CGPoint(x:self.frame.size.width/2.0, y:labelView.frame.maxY+30)
        
        
        cardView.bounds = CGRect(x:0, y:0, width:258, height:20)
        cardView.center = CGPoint(x:self.frame.size.width/2.0, y:phoneView.frame.maxY+30)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
