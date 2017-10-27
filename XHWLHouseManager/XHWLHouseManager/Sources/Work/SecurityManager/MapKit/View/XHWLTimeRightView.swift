//
//  XHWLTimeRightView.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/10/23.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLTimeRightView: UIView {

    var bgIV:UIImageView!
    var timeBtn:UIButton!
//    var dateView:THDatePickerView!
    var selectBlock:(String)->() = {param in }
    var showPickBlock:(AnyObject) -> () = {param in }
    
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
        timeBtn.setTitle("请选择" , for: .normal)
//        timeBtn.setTitle(Date.getCurrentDate("yyyy-MM-dd HH:mm") , for: .normal)
        timeBtn.addTarget(self, action: #selector(showDatePickerView), for: .touchUpInside)
        timeBtn?.frame = CGRect(x:5, y:0, width:self.bounds.size.width-10, height:self.bounds.size.height)
        self.addSubview(timeBtn)
    }
    
    var minTime:String = ""
    func showDatePickerView() {
        
        //_________________________年-月-日-时-分（滚动到指定的日期）_________________________
        let minDateFormater:DateFormatter = DateFormatter()
        minDateFormater.dateFormat = "yyyy-MM-dd HH:mm"
        
        let datepicker:WSDatePickerView = WSDatePickerView.init(dateStyle:DateStyleShowYearMonthDayHourMinute, scrollTo: Date()) { (selectDate) in
            
            let date:String = minDateFormater.string(from: selectDate!)
            print("选择的日期：\(date)")
            self.timeBtn.setTitle(date, for: .normal)
            self.selectBlock(date)
        }
        if !minTime.isEmpty {
            let minDate:Date = minDateFormater.date(from: minTime)!
            datepicker.minLimitDate = minDate
        }
        datepicker.maxLimitDate = Date()
        datepicker.dateLabelColor = color_09fbfe // RGB(65, 188, 241);//年-月-日-时-分 颜色
        datepicker.datePickerColor = UIColor.black //滚轮日期颜色
        datepicker.doneButtonColor = color_51ebfd // RGB(65, 188, 241);//确定按钮的颜色
        datepicker.yearLabelColor = UIColor.clear //大号年份字体颜色
        datepicker.show()
    }
}
