//
//  XHWLTalkManager.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/11/24.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLTalkManager: NSObject {

    var agoraKit:AgoraRtcEngineKit!
    
    class var sharedInstance: XHWLTalkManager {
        struct Static {
            static let instance = XHWLTalkManager.init()
        }
        return Static.instance
    }
    
    override init() {
        super.init()
        
        loadAgoraKit()
    }
}

//MARK: - engine
extension XHWLTalkManager {
    // 初始化
    func loadAgoraKit() {
        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: agoraAppKey, delegate: self)
        agoraKit.setLocalVoicePitch(1.0)// 设置本地语音音调, [0.5, 2.0],默认值为 1.0
        agoraKit.setInEarMonitoringVolume(100) // 设置耳返音量,[0.100], 默认100
        agoraKit.setDefaultAudioRouteToSpeakerphone(true)// 设置语音路由 true 外放 ,默认： 语音通话: 听筒  视频通话: 外放
        agoraKit.setEnableSpeakerphone(true) // 打开外放
    }
    
    func onJoinRoom(_ roomName:String) {
        
        let code = agoraKit.joinChannel(byKey: nil, channelName: roomName, info: nil, uid: 0) { (channel, uid, elapsed) in
            "开始对讲吧".ext_debugPrintAndHint()
        }
        if code != 0 {
            DispatchQueue.main.async(execute: {
                "连接失败".ext_debugPrintAndHint()
            })
        }
    }
    
    // 开关音频
    func enableAudio(_ isOpen:Bool) {
        if isOpen {
            agoraKit.enableAudio()
        } else {
            agoraKit.disableAudio()
        }
    }
    
    // 离开房间
    func leaveChannel() {
        agoraKit.leaveChannel { (stat) in
            
        }
    }
}

extension XHWLTalkManager: AgoraRtcEngineDelegate {
    func rtcEngineConnectionDidInterrupted(_ engine: AgoraRtcEngineKit!) {
        "网络连接中断".ext_debugPrintAndHint()
    }
    
    func rtcEngineConnectionDidLost(_ engine: AgoraRtcEngineKit!) {
        "网络连接丢失".ext_debugPrintAndHint()
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit!, didOccurError errorCode: AgoraRtcErrorCode) {
        "发生错误: \(errorCode.rawValue)".ext_debugPrintAndHint()
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit!, didJoinChannel channel: String!, withUid uid: UInt, elapsed: Int) {
        "加入频道: \(channel!), with uid: \(uid), elapsed: \(elapsed)".ext_debugPrintAndHint()
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit!, didJoinedOfUid uid: UInt, elapsed: Int) {
        "用户加入: \(uid)".ext_debugPrintAndHint()
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit!, didOfflineOfUid uid: UInt, reason: AgoraRtcUserOfflineReason) {
        "用户离线: \(uid), reason: \(reason.rawValue)".ext_debugPrintAndHint()
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit!, audioQualityOfUid uid: UInt, quality: AgoraRtcQuality, delay: UInt, lost: UInt) {
        "Audio Quality of uid: \(uid), quality: \(quality.rawValue), delay: \(delay), lost: \(lost)".ext_debugPrintAndHint()
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit!, didApiCallExecute api: String!, error: Int) {
        "Did api call execute: \(api!), error: \(error)".ext_debugPrintAndHint()
    }
}
