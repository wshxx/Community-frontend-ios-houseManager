//
//  XHWLMcuView.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/1.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit
import SnapKit

let SCREEN_WIDTH:CGFloat = UIScreen.main.bounds.size.width

var video_intercom_queue: DispatchQueue {
    struct Static {
        static let instance: DispatchQueue = DispatchQueue(label: "voice.intercom.queue")
    }
    return Static.instance
}


@objc protocol XHWLMcuViewDelegate:NSObjectProtocol {
    @objc optional func mcuViewWithTouch(_ mcuView:XHWLMcuView)
    @objc optional func mcuViewWithSwitchAV(_ mcuView:XHWLMcuView)
    @objc optional func mcuViewWithDelete(_ mcuView:XHWLMcuView)
}

class XHWLMcuView: UIView, RealPlayManagerDelegate, PlayViewDelegate {
    
    var g_playView:PlayView? = nil                 /**< 播放块*/
    var g_playMamager:RealPlayManager?       /**<  预览管理类对象*/
    var g_activity:UIActivityIndicatorView? = nil  /**< 加载动画*/
    var g_refreshButton:UIButton? = nil            /**< 刷新按钮*/
    var cameraSyscode:String!        /**< 监控点syscode*/
    var g_currentQuality:VP_STREAM_TYPE? = nil/**< 当前播放码流*/
    weak var delegate:XHWLMcuViewDelegate?
    
    var isHiddenTool:Bool! {
        willSet {
            switchBtn.isHidden = newValue
            deleteBtn.isHidden = newValue
            voiceBtn.isHidden = newValue
        }
    }
    lazy fileprivate var switchBtn: UIButton = {
        let jumpBtn = UIButton()
        jumpBtn.backgroundColor = UIColor.clear
        jumpBtn.setImage(UIImage(named:"CloudEyes_switch"), for: .normal)
        jumpBtn.setImage(UIImage(named:"CloudEyes_switch"), for: .selected)
        jumpBtn.isHidden = true
        jumpBtn.addTarget(self, action: #selector(onSwitchAV), for: .touchUpInside)
        self.addSubview(jumpBtn)
        return jumpBtn
    }()
    
    lazy fileprivate var voiceBtn: UIButton = {
        let jumpBtn = UIButton()
        jumpBtn.backgroundColor = UIColor.clear
        jumpBtn.setImage(UIImage(named:"CloudEyes_close_voice"), for: .normal)
        jumpBtn.setImage(UIImage(named:"CloudEyes_voice"), for: .selected)
        jumpBtn.isHidden = true
        jumpBtn.addTarget(self, action: #selector(onAudio), for: .touchUpInside)
        self.addSubview(jumpBtn)
        return jumpBtn
    }()
    
    lazy fileprivate var deleteBtn: UIButton = {
        let jumpBtn = UIButton()
        jumpBtn.backgroundColor = UIColor.clear
        jumpBtn.setImage(UIImage(named:"CloudEyes_delete"), for: .normal)
        jumpBtn.setImage(UIImage(named:"CloudEyes_delete"), for: .selected)
        jumpBtn.isHidden = true
        jumpBtn.addTarget(self, action: #selector(onDelete), for: .touchUpInside)
        self.addSubview(jumpBtn)
        return jumpBtn
    }()

    func onSwitchAV() {
        self.delegate?.mcuViewWithSwitchAV!(self)
    }
    
    func onDelete() {
        
        self.delegate?.mcuViewWithDelete!(self)
    }
    
    /**
     声音开关按钮
     
     如果监控设备是支持传递声音,那么就可以进行声音开关控制
     开关声音实现:
     1.开启声音.调用预览管理类RealPlayManager方法
     - openAudio,
     2.关闭声音.调用预览管理类RealPlayManager方法
     - turnoffAudio;
     */
    func onAudio(_ audioButton:UIButton) {
        
        if (self.g_playView?.isAudioing)! {
            
            //关闭声音
            let finish:Bool  = self.g_playMamager!.turnoffAudio()
            if (finish) {
                audioButton.isSelected = !audioButton.isSelected
                self.g_playView?.isAudioing = false
                print("关闭声音成功")
            } else {
                print("关闭声音失败")
            }
        } else {
            
            //开启声音
            let finish:Bool  = self.g_playMamager!.openAudio()
            if (finish) {
                audioButton.isSelected = !audioButton.isSelected
                self.g_playView?.isAudioing = true
                print("开启声音成功")
            } else {
                print("开启声音失败")
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.black
//        self.layer.borderColor = UIColor.white.cgColor
//        self.layer.borderWidth = 0.5
        
        initUI()
        
        //首先初始化预览管理类对象,并设置其代理,遵循RealPlayManagerDelegate并实现其代理方法
        g_playMamager = RealPlayManager.init(delegate: self)
        
        //设置要播放视频的清晰度.0高清,1标清,2流畅.此处用户可以存储视频清晰度到本地,下次需要重新选择清晰度时,直接在本地读取和修改
        g_currentQuality = STREAM_MAG
        
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapPlay))
        self.addGestureRecognizer(tap)
    }
    

    
    func tapPlay() {
        isHiddenTool = false
        self.delegate?.mcuViewWithTouch!(self)
    }
    
    func initUI() {
        
        g_playView = PlayView()
        g_playView?.delegate = self
        g_playView?.backgroundColor = UIColor.black
        g_playView?.frame = self.bounds
        self.addSubview(g_playView!)
        
        g_activity = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        g_activity?.hidesWhenStopped = true
        g_playView?.addSubview(g_activity!)
        
        g_refreshButton = UIButton()
        g_refreshButton?.backgroundColor = UIColor.clear
        g_refreshButton?.setTitle("刷新", for: UIControlState.normal)
        g_refreshButton?.setTitleColor(UIColor.white, for: UIControlState.normal)
        g_refreshButton?.addTarget(self, action: #selector(refreshRealPlay), for: UIControlEvents.touchUpInside)
        g_refreshButton?.isHidden = true
        g_playView?.addSubview(g_refreshButton!)
        
        
        g_activity?.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(CGSize(width:50, height:50))
            make.center.equalTo(g_playView!)
        }

        g_refreshButton?.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(g_activity!)
            make.center.equalTo(g_playView!)
        }
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        g_playView?.frame = self.bounds
        
        g_activity?.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(CGSize(width:50, height:50))
            make.center.equalTo(g_playView!)
        }
        
        g_refreshButton?.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(g_activity!)
            make.center.equalTo(g_playView!)
        }
        
        deleteBtn.frame = CGRect(x:self.bounds.size.width-70, y:0, width:25, height:24)
        switchBtn.frame = CGRect(x:self.bounds.size.width-35, y:0, width:25, height:24)
        voiceBtn.frame = CGRect(x:10, y:self.bounds.size.height-30, width:25, height:24)
    }
    
    
//    #pragma mark --重新预览
    /**
     重新预览 就是重新调用开始预览的方法
     */
    func refreshRealPlay() {
        
        g_activity?.isHidden = false
        g_activity?.startAnimating()
        g_refreshButton?.isHidden = true
        g_playMamager?.startRealPlay(cameraSyscode, videoType: STREAM_SUB, play: g_playView?.playView, complete: { (finish, message) in
            if (finish) {
//                NSLog(@"调用预览成功");
                //                #warning 刷新UI必须在主线程操作
                DispatchQueue.main.async {
                    self.g_activity?.stopAnimating()
                }
            } else {
//                NSLog(@"调用预览失败 %@",message);
//                #warning 刷新UI必须在主线程操作         
                DispatchQueue.main.async {
                    self.g_activity?.stopAnimating()
                    self.g_refreshButton?.isHidden = false
                }
            }
        })
    }
    
    func realPlay(cameraSyscode:String) {
        self.cameraSyscode = cameraSyscode
        
        g_activity?.startAnimating()
        //开始预览操作
        //需要传入三个参数.cameraSyscode是监控点的唯一标识.   g_currentQuality 是上面设置的视频清晰度  playView是用户自己指定一个用来播放视频的视图
        g_playMamager?.startRealPlay(cameraSyscode, videoType: g_currentQuality!, play: g_playView?.playView , complete: { (finish, message) in
            //finish返回YES时,代表当前操作成功.finish返回NO时,message会返回预览过程中的失败信息
            if (finish) {
                print("调用预览成功\(message)")
                //        #warning  刷新UI操作必须在主线程操作
                
                DispatchQueue.main.async {
                    self.g_activity?.stopAnimating()
                }
                
            } else {
                print("调用预览失败\(message)")
                
                DispatchQueue.main.async {
                    //                    #warning  刷新UI操作必须在主线程操作
                    self.g_activity?.stopAnimating()
                    self.g_refreshButton?.isHidden = false
                }
            }
        })
    }
    
    func stopRealPlay() {
        
    }
    
    func resetRealPlay() {
        
    }
    
    // RealPlayManagerDelegate
    /**
     播放库预览状态回调
     
     用户可通过播放库返回的不同播放状态进行自己的业务处理
     
     @param playState 当前播放状态
     @param realPlayManager 预览管理类
     */
    func realPlayCallBack(_ playState: PLAY_STATE, realManager realPlayManager: RealPlayManager!) {
        
        g_activity?.stopAnimating()
        
        switch playState {
        case PLAY_STATE_PLAYING: //正在播放
            print("playing")
            break
        case PLAY_STATE_STOPED: //停止播放
            print("stoped")
            g_refreshButton?.isHidden = false
            break
        case PLAY_STATE_STARTED: //开始播放
            print("started")
            break
        case PLAY_STATE_FAILED: //播放失败
            print("failed")
            g_refreshButton?.isHidden = false
            break
        case PLAY_STATE_EXCEPTION: //播放异常
            print("exception")
            g_refreshButton?.isHidden = false
            break
        default:
            break
        }
    }
    
    /**
     云台控制代理方法
     
     @param ptzCommand 云台控制命令
     @param stop 是否停止
     @param end  是否结束
     */
    func ptzOperation(inControl ptzCommand: Int32, stop: Bool, end: Bool) {
        
    }
    
    //  viewWillDisappear
    func backView() {
        
        //        #warning 退出界面必须进行停止播放操作和停止对讲操作,防止因为播放句柄未释放而造成的崩溃
        if (g_playView?.isTalking)! {
            
            video_intercom_queue.async {
                 self.g_playMamager?.stopTalking()
            }
        }
        g_playMamager?.stopRealPlay()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
