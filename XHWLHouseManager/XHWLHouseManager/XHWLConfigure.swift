//
//  XHWLConfigure.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/8/30.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import Foundation
import UIKit

//#pragma mark --登录及地址界面

let MSP_ADDRESS : String  =  "202.105.104.105"
let MSP_PORT  : String    =  "443"
let MSP_USERNAME : String =  "wang"
let MSP_PASSWORD:String   =  "Zhwy1234"

//let DEFAULT_MSP_PORT:String =  "443"
//let PUSH_SERVER_ADDRESS:String = "60.191.22.218"
//let PUSH_SERVER_PORT:String = "8443"


// MARK: -- 颜色

let mainColor:UIColor = UIColor().colorWithHexString(colorStr: "#0abfab") //主色调
let color_c6c6c6:UIColor = UIColor().colorWithHexString(colorStr: "#c6c6c6") // 默认placholder颜色
let color_f2f2f2:UIColor = UIColor().colorWithHexString(colorStr: "#f2f2f2") // 线的颜色
let color_f9f9f9:UIColor = UIColor().colorWithHexString(colorStr: "#f9f9f9") // 文字的颜色
let color_5284d6:UIColor = UIColor().colorWithHexString(colorStr: "#5284d6") // 蓝色的文字


// MARK: -- 字体

let font_14:UIFont = UIFont.systemFont(ofSize: 14)
let font_15:UIFont = UIFont.systemFont(ofSize: 15)
let font_16:UIFont = UIFont.systemFont(ofSize: 16)
let font_17:UIFont = UIFont.systemFont(ofSize: 17)
let font_18:UIFont = UIFont.systemFont(ofSize: 18)


let Screen_height:CGFloat = UIScreen.main.bounds.size.height
let Screen_width:CGFloat = UIScreen.main.bounds.size.width

// MARK: -- 创建分割线

/**
 给一个视图 创建添加 一条分割线 高度 : HJSpaceLineHeight
 
 - parameter view:  需要添加的视图
 - parameter color: 颜色 可选
 
 - returns: 分割线view
 */
func SpaceLineSetup(view:UIView, color:UIColor? = nil) ->UIView {
    
    let spaceLine = UIView()
    
    spaceLine.backgroundColor = color != nil ? color : UIColor.lightGray
    
    view.addSubview(spaceLine)
    
    return spaceLine
}
