//
//  XHWLConfigure.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/8/30.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import Foundation
import UIKit

#if DEBUG // 判断是否在测试环境下
let apsForProduction:Bool = false  // 0 (默认值)表示采用的是开发证书，1 表示采用生产证书发布应用
#else // REALEASE
let apsForProduction:Bool = true  // 0 (默认值)表示采用的是开发证书，1 表示采用生产证书发布应用
#endif

// mark -- 登录及地址界面
let MSP_ADDRESS : String  =  "202.105.104.109"
let MSP_PORT  : String    =  "443"
let MSP_USERNAME : String =  "yanfa"
let MSP_PASSWORD:String   =  "yf1234567"

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

// MARK: -- 屏幕尺寸
let Screen_height:CGFloat = UIScreen.main.bounds.size.height
let Screen_width:CGFloat = UIScreen.main.bounds.size.width

// MARK: -- 错误码
let code_401:NSInteger = 401
let code_400:NSInteger = 400
//110---验证码已过期
//111---验证码无效
//113---账号名/密码不正确
//114---用户名不存在
//115---没有操作权限
//116---记录不存在/业主不存在
//117---业主没有相关房址信息
//200---操作成功
//201---系统异常，操作失败
//202---没有相关数据返回
//203---操作成功，修改了电话号码，需要重新登录
//400---用户没有登录
//401---用户token过期
//402---登出成功
//-1---缺少参数值
//-2---二维码错误
//-3---没有匹配的信息
//-4---短信发送失败
//-5---账号已注册过

// 声网
let agoraAppKey:String = "8ae34391a8184609a868c76743eabc6d"

// 听云
let TYAppKey:String = "02cbe5f197bd4b2a9e33898dbcf7dd6d"

// MARK: -- 百度地图
let MapKitAK:String = "B7Ml8pkMdglObbl5GiXDGyu2m9VRNHVG"

// MARK: -- 天气
let WeatherKey:String = "3e6338eef8c947dd89f4ffebbf580778"

// MARK: -- 极光推送
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
