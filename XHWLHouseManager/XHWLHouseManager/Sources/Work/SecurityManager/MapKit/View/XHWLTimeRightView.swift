//
//  XHWLTimeRightView.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/10/23.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLTimeRightView: UIView, THDatePickerViewDelegate {

    var bgIV:UIImageView!
    var timeBtn:UIButton!
    var dateView:THDatePickerView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
        bgIV = UIImageView(frame:self.bounds)
        bgIV.image = UIImage(named:"Patrol_white_bg")
        self.addSubview(bgIV)
        
        timeBtn = UIButton()
        timeBtn.setTitleColor(UIColor.black, for: .normal)
        timeBtn.titleLabel?.font = font_13
        timeBtn.setTitle(Date.getCurrentDate("yyyy-MM-dd HH:mm") , for: .normal)
        timeBtn.addTarget(self, action: #selector(showDatePickerView), for: .touchUpInside)
        timeBtn?.frame = CGRect(x:5, y:0, width:self.bounds.size.width-10, height:self.bounds.size.height)
        self.addSubview(timeBtn)

        dateView = THDatePickerView.init(frame: CGRect(x:0, y:Screen_height, width:Screen_width, height:260))
        dateView.delegate = self
        dateView.title = "请选择时间"
        dateView.backgroundColor = UIColor().colorWithHexString(colorStr: "999999")
        let window:UIWindow = UIApplication.shared.keyWindow!
        window.addSubview(dateView)
    }
    
    func showDatePickerView() {
//        let window:UIWindow = UIApplication.shared.keyWindow!
//        window.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.3) {
            self.dateView.frame = CGRect(x:0, y:Screen_height - 260, width:Screen_width, height:260)
            self.dateView.show()
        }
    }
    
    //    #pragma mark - THDatePickerViewDelegate
    func datePickerViewSaveBtnClick(_ timer: String!) {
        timeBtn.setTitle(timer, for: .normal)
        
        UIView.animate(withDuration: 0.3) {
            self.dateView.frame = CGRect(x:0, y:Screen_height, width:Screen_width, height:260)
        }
//        let window:UIWindow = UIApplication.shared.keyWindow!
//        window.isUserInteractionEnabled = true
    }
    
    func datePickerViewCancelBtnClick() {
        
        UIView.animate(withDuration: 0.3) {
            self.dateView.frame = CGRect(x:0, y:Screen_height, width:Screen_width, height:260)
        }
//        let window:UIWindow = UIApplication.shared.keyWindow!
//        window.isUserInteractionEnabled = true
    }
}
