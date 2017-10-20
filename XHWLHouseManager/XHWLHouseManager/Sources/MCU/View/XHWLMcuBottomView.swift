
//
//  XHWLMcuBottomView.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/2.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit
import SnapKit

let buttonInterval:NSInteger  = 5 /**< 按钮间距*/

class XHWLMcuBottomView: UIView , QualityPanelViewDelegate, PtzPanelViewDelegate {
    
    var mcuView:XHWLMcuView!                        /**< 播放块*/
    var g_captureButton:UIButton!                    /**< 抓图按钮*/
    var g_stopButton:UIButton!                    /**< 停止预览按钮*/
    var g_recordButton: UIButton!                    /**< 录像按钮*/
    var g_qualityButton:UIButton!                    /**< 码流切换按钮*/
    var g_audioButton:UIButton!                    /**< 声音按钮*/
    var g_eleZoomButton:UIButton!                    /**< 电子放大按钮*/
    var g_ptzButton: UIButton!                    /**< 云台控制按钮*/
    
    var g_qualityPanel:QualityPanelView!            /**< 码流切换工具栏*/
    var g_ptzPanel:PtzPanelView!                /**< 云台控制工具栏*/
    
    var g_currentQuality:VP_STREAM_TYPE!              /**< 当前播放码流*/
    
//    var g_ptzPopView:PtzPopView                  /**< ptz弹出框*/
//    var g_ptzPresetPositionPopView:PtzPresetPositionPopView    /**< 预置点弹出框*/
//    var recordInfo:VPRecordInfo                //记录一下当前的录像信息
    var isHaveTalkResult:Bool!                        //当前是否有对讲回调
    
    var presetPositionState:Bool!
    var talkButton:UIButton!                     /**< 对讲按钮*/
//    var talkChannelView:TalkChannelView         /**< 对讲通道视图*/



    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.gray
        
        setupView()
    }
    
    func setupView() {
        //工具栏按钮
        g_captureButton = UIButton()
        g_captureButton.backgroundColor = UIColor.blue
        g_captureButton.setTitle("抓图", for: UIControlState.normal)
        g_captureButton.titleLabel?.font = font_14
        g_captureButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        g_captureButton.addTarget(self, action: #selector(capture), for: UIControlEvents.touchUpInside)
        self.addSubview(g_captureButton)
        
        
        g_stopButton = UIButton()
        g_stopButton.backgroundColor = UIColor.blue
        g_stopButton.setTitle("停止", for: UIControlState.normal)
        g_stopButton.titleLabel?.font = font_14
        g_stopButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        g_stopButton.addTarget(self, action: #selector(stopRealPlay), for: UIControlEvents.touchUpInside)
        self.addSubview(g_stopButton)
        
        g_recordButton = UIButton()
        g_recordButton.backgroundColor = UIColor.blue
        g_recordButton.setTitle("录像", for: UIControlState.normal)
        g_recordButton.titleLabel?.font = font_14
        g_recordButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        g_recordButton.addTarget(self, action: #selector(record), for: UIControlEvents.touchUpInside)
        self.addSubview(g_recordButton)
        
        g_audioButton = UIButton()
        g_audioButton.backgroundColor = UIColor.blue
        g_audioButton.setTitle("声音", for: UIControlState.normal)
        g_audioButton.titleLabel?.font = font_14
        g_audioButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        g_audioButton.addTarget(self, action: #selector(audio), for: UIControlEvents.touchUpInside)
        self.addSubview(g_audioButton)
        
        g_eleZoomButton = UIButton()
        g_eleZoomButton.backgroundColor = UIColor.blue
        g_eleZoomButton.setTitle("电子放大", for: UIControlState.normal)
        g_eleZoomButton.titleLabel?.font = font_14
        g_eleZoomButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        g_eleZoomButton.addTarget(self, action: #selector(eleZoom), for: UIControlEvents.touchUpInside)
        self.addSubview(g_eleZoomButton)
        
        g_qualityButton = UIButton()
        g_qualityButton.backgroundColor = UIColor.blue
        g_qualityButton.setTitle("码流", for: UIControlState.normal)
        g_qualityButton.titleLabel?.font = font_14
        g_qualityButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        g_qualityButton.addTarget(self, action: #selector(chageQuality), for: UIControlEvents.touchUpInside)
        self.addSubview(g_qualityButton)
        
        g_ptzButton = UIButton()
        g_ptzButton.backgroundColor = UIColor.blue
        g_ptzButton.setTitle("云台控制", for: UIControlState.normal)
        g_ptzButton.titleLabel?.font = font_14
        g_ptzButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        g_ptzButton.addTarget(self, action: #selector(ptzController), for: UIControlEvents.touchUpInside)
        self.addSubview(g_ptzButton)
        
        //码流切换和云台控制工具栏
        g_qualityPanel = QualityPanelView(frame:CGRect.zero)
        g_qualityPanel.alpha = 0
        g_qualityPanel.delegate = self
        g_qualityPanel.selectButton(1)
        self.addSubview(g_qualityPanel)

        
        g_ptzPanel = PtzPanelView(frame:CGRect.zero)
        g_ptzPanel.alpha = 0
        g_ptzPanel.delegate = self
        self.addSubview(g_ptzPanel)
        
        //对讲
        talkButton = UIButton()
        talkButton.backgroundColor = UIColor.blue
        talkButton.setTitle("开启对讲", for: UIControlState.normal)
        talkButton.titleLabel?.font = font_14
        talkButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        talkButton.addTarget(self, action: #selector(talking), for: UIControlEvents.touchUpInside)
        self.addSubview(talkButton)
    }

//    #pragma mark --对预览画面进行抓图操作 抓图
    /**
     对预览画面进行抓图操作
     
     抓图操作,需要先设置抓图信息,然后再开始抓图操作
     抓图操作实现:
     1.创建一个抓图信息VPCaptureInfo对象
     2.生成抓图信息 调用VideoPlayUtility类方法:
     + getCaptureInfo: toCaptureInfo:,
     3.设置 抓图信息对象 的抓图质量  VPCaptureInfo的 nPicQuality属性.1-100 越高质量越高
     4. 对播放画面进行抓图  调用预览管理类RealPlayManager方法
     - capture:,
     */
    //        #warning 录像和截图操作不能同时进行
    func capture(){
        
        //如果此时暂停状态，不允许截图
//        if playView.isPausing{
//            return
//        }
//        //1.创建一个抓图信息VPCaptureInfo对象
//        let captureInfo:VPCaptureInfo = VPCaptureInfo.init()
//        
//        //2.生成抓图信息
//        //此处参数 camera01 是用户自定义参数,可传入监控点名称,用作在截图成功后,拼接在图片名称的前部.如:camera01_20170302202334565.jpg
//        if !VideoPlayUtility.getCaptureInfo("camera01", to:captureInfo){
//            NSLog("getCaptureInfo failed!")
//            return
//        }
//        
//        // 3.设置抓图质量 1-100 越高质量越高
//        captureInfo.nPicQuality = 80
//        //4.开始抓图
//        let result = g_playManager.capture(captureInfo)
//        if result{
//            NSLog("截图成功，图片路径:%@",captureInfo.strCapturePath)
//        }else{
//            NSLog("截图失败");
//        }
//        
//        let savedImg = UIImage.init(contentsOfFile: captureInfo.strCapturePath)
//        
//        //        g_audioBtn.setBackgroundImage(savedImg, for: .normal)
//        UIImageWriteToSavedPhotosAlbum(savedImg!, nil, nil, nil)
//        //        self.backClosure!(savedImg!)

//        
//        //下面是对截图进行处理的操作,如果用户项目中没有这项功能需求,可不用关注.
//        
//        //对截图重新进行保存,方便客户能够获取到截图,根据项目需求自行操作.
//        //截图统一放在document文件夹下,自定义文件夹capture里面,用户也可按照自己的项目需求建立新的文件夹
//        //获取document文件夹
//        NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
//        //自定义新的文件夹capture
//        NSString *capture = [documentPath stringByAppendingPathComponent:@"capture"];
//        //如果capture文件夹不存在,先创建capture文件夹
//        if (![[NSFileManager defaultManager] fileExistsAtPath:capture]) {
//            [[NSFileManager defaultManager] createDirectoryAtPath:capture withIntermediateDirectories:YES attributes:nil error:nil];
//        }
//        
//        //分割原文件路径,获取文件名称
//        NSString *fileName = [captureInfo.strCapturePath componentsSeparatedByString:@"/"].lastObject;
//        //新的文件路径
//        NSString *newPath = [capture stringByAppendingPathComponent:fileName];
//        NSLog(@"newPath :%@", newPath);
//        //把截图移动到自定义文件夹,方便用户获取文件,并对其进行操作
//        [[NSFileManager defaultManager] moveItemAtPath:captureInfo.strCapturePath toPath:newPath error:nil];
//        //删除原来文件夹, 原文件夹是以截图时日期为名称
//        NSDate *date = [NSDate date];
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        [formatter setDateFormat:@"YYYYMMdd"];
//        //获取当前日期字符串
//        NSString *dateString = [formatter stringFromDate:date];
//        NSString *oldPath = [NSString stringWithFormat:@"%@/%@", documentPath, dateString];
//        [[NSFileManager defaultManager] removeItemAtPath:oldPath error:nil];
    }
//    停止
    func stopRealPlay(){
    
    }
//    录像
    func record() {
        
    }
//   #pragma mark --声音控制
    /**
     声音开关按钮
     
     如果监控设备是支持传递声音,那么就可以进行声音开关控制
     开关声音实现:
     1.开启声音.调用预览管理类RealPlayManager方法
     - openAudio,
     2.关闭声音.调用预览管理类RealPlayManager方法
     - turnoffAudio;
     */
    func audio(audioButton:UIButton) {
        if mcuView == nil {
            return
        }
        if (mcuView.g_playView?.isAudioing)! {
            mcuView.g_playView?.isAudioing = false
            audioButton.backgroundColor = UIColor.blue
            
            //关闭声音
            let finish:Bool  = mcuView.g_playMamager!.turnoffAudio()
            if (finish) {
                print("关闭声音成功")
            } else {
                print("关闭声音失败")
            }
        } else {
            mcuView.g_playView?.isAudioing = true
            audioButton.backgroundColor = UIColor.red
            
            //开启声音
            let finish:Bool  = mcuView.g_playMamager!.openAudio()
            if (finish) {
                print("开启声音成功")
            } else {
                print("开启声音失败")
            }
        }
    }

//    电子放大
    func eleZoom() {
        
    }
//    码流
    func chageQuality() {
        
    }
//    云台控制
    func ptzController() {
        
    }
//    开启对讲
    func talking() {
        
    }
    
    //    QualityPanelViewDelegate
    func qualityChange(_ qualityType: VP_STREAM_TYPE) {
        
    }
    
    //    PtzPanelViewDelegate
    /**
     自动巡航按钮点击代理
     */
    func ptzPanelViewPanAutoButtonTouchUpInside() {
        
    }
    
    /**
     焦距按钮点击代理
     */
    func ptzPanelViewZoomButtonTouchUpInside() {
        
    }
    
    /**
     聚焦按钮点击代理
     */
    func ptzPanelViewFocusButtonTouchUpInside() {
        
    }
    
    /**
     光圈按钮点击代理
     */
    func ptzPanelViewIrisButtonTouchUpInside() {
        
    }
    
    /**
     预置点按钮点击代理
     */
    func ptzPanelViewPresetPositionButtonTouchUpInside() {
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        g_qualityPanel?.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.snp.top)
            make.left.equalTo(self)
            make.size.equalTo(CGSize(width:self.bounds.size.width, height:74))
        }
        
        g_ptzPanel?.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.snp.top)
            make.left.equalTo(self)
            make.size.equalTo(CGSize(width:self.bounds.size.width, height:74))
        }
        
        //按钮布局
        g_captureButton.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(self).offset(10)
            make.top.equalTo(g_qualityPanel.snp.bottom).offset(10)
            make.size.equalTo(CGSize(width:70, height:40))
        }
        
        g_recordButton.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(g_stopButton.snp.right).offset(buttonInterval)
            make.top.equalTo(g_captureButton)
            make.size.equalTo(g_captureButton)
        }
        
        g_ptzButton.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(g_recordButton.snp.right).offset(buttonInterval)
            make.top.equalTo(g_captureButton)
            make.size.equalTo(g_captureButton)
        }
        
        g_audioButton.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(g_ptzButton.snp.right).offset(buttonInterval)
            make.top.equalTo(g_captureButton)
            make.size.equalTo(g_captureButton)
        }
        
        g_qualityButton.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(g_audioButton.snp.right).offset(buttonInterval)
            make.top.equalTo(g_captureButton)
            make.size.equalTo(g_captureButton)
        }
        
        g_stopButton.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(g_captureButton)
            make.top.equalTo(g_captureButton.snp.bottom).offset(10)
            make.size.equalTo(g_captureButton)
        }
        
        g_eleZoomButton.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(g_stopButton.snp.right).offset(buttonInterval)
            make.top.equalTo(g_stopButton)
            make.size.equalTo(g_captureButton)
        }
        
        talkButton.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(g_eleZoomButton.snp.right).offset(buttonInterval)
            make.top.equalTo(g_eleZoomButton)
            make.size.equalTo(g_captureButton)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
