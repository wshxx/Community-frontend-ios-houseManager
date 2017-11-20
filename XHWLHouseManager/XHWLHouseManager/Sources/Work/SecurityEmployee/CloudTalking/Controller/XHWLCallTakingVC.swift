//
//  XHWLCallTakingVC.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/10/21.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit
import AgoraRtcEngineKit

class XHWLCallTakingVC: XHWLBaseVC {
    
    var backBlock:(String)->() = { param in }
    var yzName:String! = ""
    var roomName:String! = "" // 房间
    lazy fileprivate var callView:XHWLCallView! = {

       let callView:XHWLCallView = XHWLCallView(frame:UIScreen.main.bounds)
        callView.delegate = self
        self.view.addSubview(callView)

        return callView
    }()

    var nextParams:NSDictionary! = NSDictionary() {
        willSet {
            
            let array:NSArray = [["name":"姓名：", "content": newValue.object(forKey: "name")],
                                 ["name":"类型：", "content": newValue.object(forKey: "type")],
                                 ["name":"证件：", "content": (newValue.object(forKey: "certificateType") as! String) + (newValue.object(forKey: "cetificateNo") as! String)],
                                 ["name":"手机：", "content": newValue.object(forKey: "telephone")],
                                 ["name":"时效：", "content": (newValue.object(forKey: "timeNo") as! String) + (newValue.object(forKey: "timeUnit") as! String)],
                                 ["name":"车牌：", "content": newValue.object(forKey: "carNo")],
                                 ["name":"事由：", "content": newValue.object(forKey: "accessReason")],
                                 ["name":"业主：", "content": yzName],
                                 ["name":"房间：", "content": newValue.object(forKey: "roomNo")]]

            
            let dataAry:NSArray = XHWLMenuModel.mj_objectArray(withKeyValuesArray: array)
            callView.dataAry = dataAry
        }
    }
//    var callView:XHWLCallView!
    
    var clientRole = AgoraRtcClientRole.clientRole_Broadcaster
    var videoProfile: AgoraRtcVideoProfile! = AgoraRtcVideoProfile._VideoProfile_360P

    //MARK: - engine & session view
    var rtcEngine: AgoraRtcEngineKit!
    fileprivate var isBroadcaster: Bool {
        return clientRole == .clientRole_Broadcaster
    }

    fileprivate var videoSessions = [VideoSession]() {
        didSet {
            guard self.callView.remoteContainerView != nil else {
                return
            }
            
            fullSession = videoSessions.last// newValue.last // 最后一个
//            updateInterface(withAnimation: true)
        }
    }
    fileprivate var fullSession: VideoSession? {
        didSet {
            if fullSession != oldValue && self.callView.remoteContainerView != nil {
                updateInterface(withAnimation: true)
            }
        }
    }
    
    fileprivate let viewLayouter = VideoViewLayouter()
    
    // MARk: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadAgoraKit() // 初始化
//        callView = XHWLCallView(frame:UIScreen.main.bounds)
//        callView.delegate = self
//        self.view.addSubview(callView)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(operatorTalking), name: NSNotification.Name(rawValue: "Talking"), object: nil)
    }
    
    func operatorTalking(_ note:Notification) {
        
        let yzOperator:String = note.object as! String
        if yzOperator == "n" { // 拒绝
            self.backBlock(yzOperator)
            self.doLeavePressed()
        } else if yzOperator == "y" { // 同意
            self.backBlock(yzOperator)
            self.doLeavePressed()
        } else if yzOperator == "refuse" { // 拒绝通话
            self.doLeavePressed()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
        
        self.callView.roomName = yzName
        self.callView.receiveType = .calling
    }
    
    func updateInterface(withAnimation animation: Bool) {
        if animation {
            UIView.animate(withDuration: 0.3, animations: { [weak self] _ in
                self?.updateInterface()
                self?.view.layoutIfNeeded()
            })
        } else {
            updateInterface()
        }
    }
    
    func updateInterface() {
        var displaySessions = videoSessions
        if !isBroadcaster && !displaySessions.isEmpty {
            displaySessions.removeFirst()
        }

        viewLayouter.layout(sessions: displaySessions, fullSession: fullSession, inContainer: self.callView.remoteContainerView)
        setStreamType(forSessions: displaySessions, fullSession: fullSession)
    }
    
    func setStreamType(forSessions sessions: [VideoSession], fullSession: VideoSession?) {
        if let fullSession = fullSession {
            for session in sessions {
                rtcEngine.setRemoteVideoStream(UInt(session.uid), type: (session == fullSession ? .videoStream_High : .videoStream_Low))
            }
        } else {
            for session in sessions {
                rtcEngine.setRemoteVideoStream(UInt(session.uid), type: .videoStream_High)
            }
        }
    }
    
    //MARK: - user action
    // 切换摄像头
    func doSwitchCameraPressed(_ sender: UIButton) {
        rtcEngine?.switchCamera()
    }
    
    // 是否开语音
    func doMutePressed(_ sender: UIButton) {
//        isMuted = !isMuted
    }
    
    // 双击全屏
    func doDoubleTapped(_ sender: UITapGestureRecognizer) {
//        if fullSession == nil {
//            if let tappedSession = viewLayouter.responseSession(of: sender, inSessions: videoSessions, inContainerView: remoteContainerView) {
//                fullSession = tappedSession
//            }
//        } else {
//            fullSession = nil
//        }
    }
    
    // 退出按钮
    func doLeavePressed() {
        setIdleTimerActive(true)
        
        rtcEngine.setupLocalVideo(nil)
        rtcEngine.leaveChannel(nil)
        if isBroadcaster {
            rtcEngine.stopPreview()
        }
        
        for session in videoSessions {
            session.hostingView.removeFromSuperview()
        }
        videoSessions.removeAll()
        
        self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - Agora Media SDK

private extension XHWLCallTakingVC {
    
    func loadAgoraKit() {
        rtcEngine = AgoraRtcEngineKit.sharedEngine(withAppId: agoraAppKey, delegate: self)
        rtcEngine.setChannelProfile(.channelProfile_LiveBroadcasting)
        rtcEngine.enableDualStreamMode(true)
        rtcEngine.enableVideo()
        rtcEngine.setVideoProfile(videoProfile, swapWidthAndHeight: true)
        rtcEngine.setClientRole(clientRole, withKey: nil)
        
        if isBroadcaster {
            rtcEngine.startPreview()
        }
        
        addLocalSession()
        
        // 进入对应的房间
        let code = rtcEngine.joinChannel(byKey: nil, channelName: roomName, info: nil, uid: 0, joinSuccess: nil)
        if code == 0 {
            setIdleTimerActive(false)
            rtcEngine.setEnableSpeakerphone(true)
        } else {
            DispatchQueue.main.async(execute: {
                "Join channel failed: \(code)".ext_debugPrintAndHint()
            })
        }
    }
    
    func setIdleTimerActive(_ active: Bool) {
        UIApplication.shared.isIdleTimerDisabled = !active
    }
    
    func addLocalSession() {
        let localSession = VideoSession.localSession()
        videoSessions.append(localSession)
        rtcEngine.setupLocalVideo(localSession.canvas)
    }
}

// MARK: - AgoraRtcEngineDelegate
extension XHWLCallTakingVC: AgoraRtcEngineDelegate {
    
    func rtcEngine(_ engine: AgoraRtcEngineKit!, firstRemoteVideoDecodedOfUid uid: UInt, size: CGSize, elapsed: Int) {
        let userSession = videoSession(ofUid: Int64(uid))
        rtcEngine.setupRemoteVideo(userSession.canvas)
        self.callView.receiveType = .receive
    }
    
    func videoSession(ofUid uid: Int64) -> VideoSession {
        if let fetchedSession = fetchSession(ofUid: uid) {
            return fetchedSession
        } else {
            let newSession = VideoSession(uid: uid)
            videoSessions.append(newSession)
            return newSession
        }
    }
    
    func fetchSession(ofUid uid: Int64) -> VideoSession? {
        for session in videoSessions {
            if session.uid == uid {
                return session
            }
        }
        
        return nil
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit!, firstLocalVideoFrameWith size: CGSize, elapsed: Int) {
        if let _ = videoSessions.first {
            updateInterface(withAnimation: false)
        }
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit!, didOfflineOfUid uid: UInt, reason: AgoraRtcUserOfflineReason) {
        var indexToDelete: Int?
        for (index, session) in videoSessions.enumerated() {
            if session.uid == Int64(uid) {
                indexToDelete = index
            }
        }
        
        if let indexToDelete = indexToDelete {
            let deletedSession = videoSessions.remove(at: indexToDelete)
            deletedSession.hostingView.removeFromSuperview()
            
            if deletedSession == fullSession {
                fullSession = nil
            }
        }
        
        self.callView.receiveType = .offline
        self.doLeavePressed()
    }
}

// MARK: - XHWLCallViewDelegate
extension XHWLCallTakingVC : XHWLCallViewDelegate {
    func callViewWithCancel(_ callView:XHWLCallView) {
        self.doLeavePressed()

      
        
    }
    
    func callViewWithFreeHand(_ callView:XHWLCallView) {
        
    }

    
}
