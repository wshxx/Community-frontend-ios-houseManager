//
//  XHWLMcuShowVC.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/1.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

let comTag:NSInteger = 100

class XHWLMcuShowVC: XHWLBaseVC, XHWLPlayerViewDelegate, XHWLNetworkDelegate{

    var bgImage:UIImageView!
    lazy fileprivate var playerView:XHWLPlayerView! = {
        let playView:XHWLPlayerView = XHWLPlayerView(frame:CGRect(x:Screen_width*3/32.0, y:Screen_height*1/6.0, width:Screen_width*13/16.0, height:Screen_height*2/3.0))
        playView.delegate = self
        self.view.addSubview(playView)
        
        return playView
    }()
    
//    var cameraSyscode:String! {        /**< 监控点syscode*/
//        willSet {
//            if newValue != nil {
//                let mcuView:XHWLMcuView = self.view.viewWithTag(comTag) as! XHWLMcuView
//                mcuView.realPlay(cameraSyscode: newValue)
//            }
//        }
//    }
    
    override func onBack() {
        self.navigationController?.popToViewController((self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)!-3])!, animated: true)
    }
    
    lazy fileprivate var okBtn:UIButton = {
        let jumpBtn = UIButton()
        jumpBtn.setTitle("抓拍", for: .normal)
        jumpBtn.setTitleColor(color_09fbfe, for: UIControlState.normal)
        jumpBtn.titleLabel?.font = font_14
        jumpBtn.setBackgroundImage(UIImage(named:"btn_background"), for: UIControlState.normal)
        jumpBtn.addTarget(self, action: #selector(onCaptureClick), for: .touchUpInside)
        jumpBtn.bounds = CGRect(x:0, y:0, width:Screen_width*0.4, height:30)
        jumpBtn.center = CGPoint(x:Screen_width/2.0, y:self.playerView.frame.maxY+50)
        
        return jumpBtn
    }()
    
    var selectAry:NSArray! {
        willSet {
            if newValue != nil {
                
                self.playerView.selectAry = newValue
//                if newValue.count > 0 {
//                    for i in 0..<newValue.count {
//                        print("\(newValue)")
//
////                        let node:XHWLMcuModel = newValue[i] as! XHWLMcuModel
////                        let mcuView:XHWLMcuView = self.playerView.viewWithTag(comTag+i) as! XHWLMcuView
////                        mcuView.realPlay(cameraSyscode: node.sysCode)
//                    }
//                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        #warning 正在播放视频时,APP进入后台,必须var止播放.未处理当前播放状态,在APP重新变活跃时会出现崩溃,画面卡死的现象
        //        NotificationCenter.default.addObserver(self, selector: #selector(stopRealPlay), name: UIApplicationDidEnterBackgroundNotification, object: nil)
        //        NotificationCenter.default.addObserver(self, selector: #selector(resetRealPlay), name: UIApplicationDidBecomeActiveNotification, object: nil)
        
        self.title = "云瞳监控"
        let isLogin:Bool = UserDefaults.standard.bool(forKey: "isLogin")
        if isLogin == false {
            loginButtonClicked()
        }
        setupView()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage(named:"CloudEyes_picture"), style: .plain, target: self, action: #selector(onCapturePicture))
    }
    
    func setupView() {
//        playerView = XHWLPlayerView()
//        playerView.bounds = CGRect(x:0, y:0, width:Screen_width*13/16.0, height:Screen_height*2/3.0)
//        playerView.center = CGPoint(x:self.view.frame.size.width/2.0, y:self.view.frame.size.height/2.0)
//        playerView.delegate = self
//        self.view.addSubview(playerView)
        
        self.view.addSubview(self.okBtn)
    }
    
    func onCapturePicture() {
        let vc:XHWLMcuPictureListVC = XHWLMcuPictureListVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func onUpladPicture(_ image:UIImage) {
        
        let data:NSData = UserDefaults.standard.object(forKey: "user") as! NSData
        let userModel:XHWLUserModel = XHWLUserModel.mj_object(withKeyValues: data.mj_JSONObject())
        
        let imageData:Data = UIImageJPEGRepresentation(image, 0.5)! // UIImagePNGRepresentation(imageArray[i] as! UIImage)! //
        if UserDefaults.standard.object(forKey: "project") != nil {
            let projectData:NSData = UserDefaults.standard.object(forKey: "project") as! NSData// 项目
            let projectModel:XHWLProjectModel = XHWLProjectModel.mj_object(withKeyValues: projectData.mj_JSONObject())
           
            let param:NSDictionary = ["token":userModel.wyAccount.token,
                                 "projectId":projectModel.id]
            XHWLNetwork.shared.uploadVideoImageClick(param, [imageData], ["image_\(String(Date.getCurrentStamp())).png"], self)
        }
    }
    
    // MARK: - XHWLNetworkDelegate
    
    func requestSuccess(_ requestKey:NSInteger, _ response:[String : AnyObject]) {
        
        if requestKey == XHWLRequestKeyID.XHWL_VIDEOUPLOAD.rawValue {
            
            "抓拍成功".ext_debugPrintAndHint()
//            if response["result"] is NSNull {
//                return
//            }
//            let dict:NSDictionary = response["result"] as! NSDictionary
//            //            let userProgressArray:NSArray = XHWLPatrolDetailModel.mj_objectArray(withKeyValuesArray:dict["userProgress"] as! NSArray)
//            //            self.dataAry = NSMutableArray()
//            realModel = XHWLPatrolDetailModel.mj_object(withKeyValues: dict["userProgress"] )
//            //            self.dataAry.addObjects(from: userProgressArray as! [Any])
//            self.tableView.reloadData()
        }
    }
    
    func requestFail(_ requestKey: NSInteger, _ error: NSError) {
        
    }
    
    //        #warning 录像和截图操作不能同时进行
    func onCaptureClick() {
//        playerView.selectMcuView
        if playerView.selectMcuView == nil {
            "请先选择要截屏的视频".ext_debugPrintAndHint()
            return
        }
        
        //如果此时暂停状态，不允许截图
        if (playerView.selectMcuView.g_playView?.isPausing)! {
            return
        }
        
        //1.创建一个抓图信息VPCaptureInfo对象
        let captureInfo:VPCaptureInfo = VPCaptureInfo.init()

        //2.生成抓图信息
        //此处参数 camera01 是用户自定义参数,可传入监控点名称,用作在截图成功后,拼接在图片名称的前部.如:camera01_20170302202334565.jpg
        if !VideoPlayUtility.getCaptureInfo("camera01", to:captureInfo){
            NSLog("getCaptureInfo failed!")
            return
        }

        // 3.设置抓图质量 1-100 越高质量越高
        captureInfo.nPicQuality = 80
        //4.开始抓图
        let result = playerView.selectMcuView.g_playMamager?.capture(captureInfo)
        if result!{
            NSLog("截图成功，图片路径:%@",captureInfo.strCapturePath)
        }else{
            NSLog("截图失败");
        }
        
        let savedImg = UIImage.init(contentsOfFile: captureInfo.strCapturePath)

        self.onUpladPicture(savedImg!)
        //        g_audioBtn.setBackgroundImage(savedImg, for: .normal)
//        UIImageWriteToSavedPhotosAlbum(savedImg!, nil, nil, nil)
        //        self.backClosure!(savedImg!)
        
        
        
                //1.创建一个抓图信息VPCaptureInfo对象
//        let captureInfo:VPCaptureInfo = VPCaptureInfo()
        
                //2.生成抓图信息
                //此处参数 camera01 是用户自定义参数,可传入监控点名称,用作在截图成功后,拼接在图片名称的前部.如:camera01_20170302202334565.jpg
       
//                if (![VideoPlayUtility getCaptureInfo:@"camera01" toCaptureInfo:captureInfo]) {
//                    NSLog(@"getCaptureInfo failed");
//                    return;
//                }
//         VideoPlayUtility.c
        //        // 3.设置抓图质量 1-100 越高质量越高
        //        captureInfo.nPicQuality = 80;
        //        //4.开始抓图
        //        BOOL result = [g_playMamager capture:captureInfo];
        //        if (result) {
        //            NSLog(@"截图成功，图片路径:%@",captureInfo.strCapturePath);
        //        } else {
        //            NSLog(@"截图失败");
        //        }
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
    
    func playViewWithSwitchAV(_ playView:XHWLPlayerView) {
        let vc = XHWLMcuListVC()
        vc.isSingleSelect = true
        vc.isBackData = true
        vc.backBlock = {nodeAry, isSingleSelect in
            if isSingleSelect {
                let node:XHWLMcuModel = nodeAry[0] as! XHWLMcuModel
                playView.selectMcuView.realPlay(cameraSyscode: node.sysCode)
            }
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - 点击登录按钮
    /**
     *  点击登录按钮
     */
    func loginButtonClicked() {
        
        let password:String = MSP_PASSWORD.md5
        
        //调用 登录平台接口,完成登录操作
        //注意:登录密码必须是经过MD5加密的
        MCUVmsNetSDK.shareInstance().loginMsp(withUsername: MSP_USERNAME, password: password, success: { (responseDic) in
            
            let obj:NSDictionary = responseDic as! NSDictionary
            let status:String = obj["status"] as! String
            
            if (status.compare("200").rawValue == 0) {
                UserDefaults.standard.set(true, forKey: "isLogin")
                UserDefaults.standard.synchronize()
            } else {
                
                "登陆失败".ext_debugPrintAndHint()
                print("登陆失败")
                UserDefaults.standard.set(false, forKey: "isLogin")
                UserDefaults.standard.synchronize()
             //返回码为200,代表登录成功.返回码为202,203,204时,分别代表的意思是初始密码登录,密码强度不符合要求,密码过期.这三种情况都需要修改密码.请开发者使用当前账号登录BS端平台,按要求进行密码修改后,再进行APP的开发测试工作.其他返回码,请根据平台返回提示信息进行提示或处理
                //    [SVProgressHUD showErrorWithStatus:responseDic[@"description"]];
            }
        }) { (error) in
            
            "服务器连接失败".ext_debugPrintAndHint()
            print("登陆请求失败")
        }
    }

    
    func viewWillDisappear(animated:Bool) {
        super.viewWillDisappear(animated)
        
//        #warning 退出界面必须进行停止播放操作和停止对讲操作,防止因为播放句柄未释放而造成的崩溃
    }
    
    deinit {

        
//        NotificationCenter.default.removeObserver(self, name: UIApplicationDidBecomeActiveNotification, object: nil)
//        NotificationCenter.default.removeObserver(self, name: UIApplicationDidEnterBackgroundNotification, object: nil)
    }
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
