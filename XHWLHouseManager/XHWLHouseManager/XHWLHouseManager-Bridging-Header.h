//
//  XHWLHouseManager-Bridging-Header.h
//  XHWLHouseManager
//
//  Created by gongairong on 2017/8/30.
//  Copyright © 2017年 XHWL. All rights reserved.
//

#ifndef XHWLHouseManager_Bridging_Header_h
#define XHWLHouseManager_Bridging_Header_h


//#define w_kHeight [[UIScreen mainScreen] bounds].size.height
//#define w_kWidth [[UIScreen mainScreen] bounds].size.width

#import "Mcu_sdk/MCUVmsNetSDK.h"
#import "Mcu_sdk/VideoPlaySDK.h"
#import "Mcu_sdk/MCUResourceNode.h"
#import "Mcu_sdk/VPCaptureInfo.h"

#import <CommonCrypto/CommonDigest.h>
#import "RealPlayViewController.h"
#import "PlayBackViewController.h"


#import "PlayView.h"
#import "QualityPanelView.h"
#import "PtzPanelView.h"
#import "Mcu_sdk/RealPlayManager.h"

// 地图
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件
#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件
#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件

#import "MJExtension.h"
#import "RTRootNavigationController.h"

#import "CYTabBarController.h"
#import "HZActionSheet.h"

#import "LYMUILabel+TextAlignment.h"

// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

#import "CYButton.h"

#import <tingyunApp/NBSAppAgent.h>

#endif /* XHWLHouseManager_Bridging_Header_h */
