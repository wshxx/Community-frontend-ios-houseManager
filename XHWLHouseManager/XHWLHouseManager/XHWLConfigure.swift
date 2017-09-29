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
let color_01f0ff:UIColor = UIColor().colorWithHexString(colorStr: "#01f0ff") //主色调
let color_7a9198:UIColor = UIColor().colorWithHexString(colorStr: "#7a9198") //主色调
let color_09fbfe:UIColor = UIColor().colorWithHexString(colorStr: "#09fbfe") //主色调
let color_c8e5f0:UIColor = UIColor().colorWithHexString(colorStr: "#c8e5f0") // 默认placholder颜色
let color_f2f2f2:UIColor = UIColor().colorWithHexString(colorStr: "#f2f2f2") // 线的颜色
let color_f9f9f9:UIColor = UIColor().colorWithHexString(colorStr: "#f9f9f9") // 文字的颜色
let color_5284d6:UIColor = UIColor().colorWithHexString(colorStr: "#5284d6") // 蓝色的文字
let color_58e9f3:UIColor = UIColor().colorWithHexString(colorStr: "#58e9f3") // 蓝色的文字
let color_51ebfd:UIColor = UIColor().colorWithHexString(colorStr: "#51ebfd") // 蓝色的文字
let color_328bfe:UIColor = UIColor().colorWithHexString(colorStr: "#328bfe") // 蓝色的文字
let color_d724d9:UIColor = UIColor().colorWithHexString(colorStr: "#d724d9") // 蓝色的文字


// MARK: -- 字体

let font_9:UIFont = UIFont.systemFont(ofSize: 9)
let font_12:UIFont = UIFont.systemFont(ofSize: 12)
let font_13:UIFont = UIFont.systemFont(ofSize: 13)
let font_14:UIFont = UIFont.systemFont(ofSize: 14)
let font_15:UIFont = UIFont.systemFont(ofSize: 15)
let font_16:UIFont = UIFont.systemFont(ofSize: 16)
let font_17:UIFont = UIFont.systemFont(ofSize: 17)
let font_18:UIFont = UIFont.systemFont(ofSize: 18)


let Screen_height:CGFloat = UIScreen.main.bounds.size.height
let Screen_width:CGFloat = UIScreen.main.bounds.size.width


// MARK: -- 百度地图
let MapKitAK:String = "B7Ml8pkMdglObbl5GiXDGyu2m9VRNHVG"
//"10092150" // 应用编号
let WeatherKey:String = "3e6338eef8c947dd89f4ffebbf580778"

// 野狗云
//let kWilddogUrl:String = "https://demochat.wilddogio.com"
let VideoAppId:String = "wd3420885063wekxii"
let WDGSyncId:String = "wd3420885063wekxii"

//wd2565313036qrpdim
let kWilddogUrl:String = "https://\(VideoAppId).wilddogio.com"
// 极光推送
let jPushAppKey:String = "f7da6d8af1224999462d44c7"
let channel:String = "Publish channel"

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
