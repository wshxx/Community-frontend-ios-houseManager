//
//  XHWLPatrolStateView.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/10/24.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLPatrolStateView: UIView {

    var titleL:UILabel!
    var lineView:XHWLPatrolLineView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        setupView()
    }
    
    func setupView() {
        
        titleL = UILabel()
        titleL.textColor = UIColor.white
        titleL.text = "工作时间："
        titleL.textAlignment = .right
        titleL.font = font_14
        self.addSubview(titleL)
        
        lineView = XHWLPatrolLineView()
        self.addSubview(lineView)
    }
    
    var planAry:NSArray! {
        willSet {
            if planAry != nil {

                let ary:NSArray = XHWLPatrolPlanTimeModel.mj_objectArray(withKeyValuesArray: newValue)
                
                for i in 0..<ary.count {
                    let model:XHWLPatrolPlanTimeModel = ary[i] as! XHWLPatrolPlanTimeModel
                    if !model.progress.isEmpty {
                        let ary:NSArray = model.progress.components(separatedBy: "/") as NSArray
                        let oneStr:String = ary[0] as! String
                        let twoStr:String = ary[1] as! String
                        let time:String = (model.startTime as! String) + "~" + (model.endTime as! String)
                        
                        if oneStr == twoStr {
                            if oneStr == "0" {
                                lineView.patrolEnum = .unStart
                                lineView.setUnPatrolNum(time, "", "")
                            } else {
                                lineView.patrolEnum = .finished
                                lineView.setUnPatrolNum(time, "", "")
                            }
                        } else {
                            
                            let startStr = Date.getCurrentDate("yyyy-MM-dd") + " " + model.startTime + ":00"
                            let endStr = Date.getCurrentDate("yyyy-MM-dd") + " " + model.startTime + ":00"
                            let startStamp:Int = Date.stringToStamp(startStr)
                            let endStamp:Int = Date.stringToStamp(endStr)
                            let curentStamp:Int = Date.getCurrentStamp()
                            
                            if startStamp <= curentStamp && endStamp >= curentStamp {
                                
                                let num:String = String(Int(twoStr)! - Int(oneStr)!)
                                let progress:String = String(Int(Int(oneStr)! * 100 / Int(twoStr)!)) + "%"
                                lineView.patrolEnum = .unFinished
                                lineView.setUnPatrolNum(time, num, progress)
                            } else {
                                
                                let num:String = String(Int(twoStr)! - Int(oneStr)!)
                                lineView.patrolEnum = .pastUnFinished
                                lineView.setUnPatrolNum(time, num, "")
                            }
                            
                        }
                    }
                }
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleL.frame = CGRect(x:0, y:0, width:80, height:font_14.lineHeight)
        lineView.frame = CGRect(x: titleL.frame.maxX, y: 0, width:self.bounds.size.width-titleL.frame.maxX, height:self.bounds.size.height)
    }
    
    func showText(leftText:String, rightText:String) {
        titleL.text = leftText
//        lineView.text = rightText
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
