//
//  XHWLMcuShowVC.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/1.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

let comTag:NSInteger = 100

class XHWLMcuShowVC: UIViewController , XHWLMcuViewDelegate{

    var first:XHWLMcuView!
    var second:XHWLMcuView!
    var three:XHWLMcuView!
    var forth:XHWLMcuView!
    var bottomView:XHWLMcuBottomView!
    
    var selectMcuView:XHWLMcuView!
    var isLogin:Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.isLogin = false
        self.navigationController?.navigationBar.isHidden = false
        self.view.backgroundColor = UIColor.white
        
        //        #warning 正在播放视频时,APP进入后台,必须var止播放.未处理当前播放状态,在APP重新变活跃时会出现崩溃,画面卡死的现象
        //        NotificationCenter.default.addObserver(self, selector: #selector(stopRealPlay), name: UIApplicationDidEnterBackgroundNotification, object: nil)
        //        NotificationCenter.default.addObserver(self, selector: #selector(resetRealPlay), name: UIApplicationDidBecomeActiveNotification, object: nil)
        
        loginButtonClicked()
        setupView()
        
        let registButton:UIButton = UIButton(frame: CGRect(x:0, y:0, width:50, height:24))
        registButton.titleLabel?.font = font_14
        registButton.setTitle("注销", for: UIControlState.normal)
        registButton.setTitleColor(UIColor.blue, for: UIControlState.normal)
        registButton.addTarget(self, action: #selector(regist), for: UIControlEvents.touchUpInside)
        
        let rigthItem:UIBarButtonItem = UIBarButtonItem(customView: registButton)
        self.navigationItem.rightBarButtonItem = rigthItem;
    }
    
    // 注销
    func regist(registButton:UIButton) {
        
        MCUVmsNetSDK.shareInstance().logoutMsp({ (object) in
            self.navigationController?.popViewController(animated: true)
        }) { (error) in
            
            print("注销失败")
        }
    }
    
    //    #pragma mark ---点击登录按钮
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
                ////                [SVProgressHUD dismiss];
                
                self.isLogin = true
            } else {
                print("登陆失败")
                //                //返回码为200,代表登录成功.返回码为202,203,204时,分别代表的意思是初始密码登录,密码强度不符合要求,密码过期.这三种情况都需要修改密码.请开发者使用当前账号登录BS端平台,按要求进行密码修改后,再进行APP的开发测试工作.其他返回码,请根据平台返回提示信息进行提示或处理
                ////                [SVProgressHUD showErrorWithStatus:responseDic[@"description"]];
            }
        }) { (error) in
            
            print("登陆失败")
            //            [SVProgressHUD showErrorWithStatus:@"服务器连接失败"];
        }
    }
    
    func setupView() {
        first = XHWLMcuView(frame:CGRect(x:0, y:64, width:self.view.bounds.size.width/2.0, height:150))
        first.delegate = self
        first.tag = comTag
        self.view.addSubview(first)
        
        second = XHWLMcuView(frame:CGRect(x:first.frame.maxX, y:64, width:self.view.bounds.size.width/2.0, height:150))
        second.delegate = self
        second.tag = comTag + 1
        self.view.addSubview(second)
        
        three = XHWLMcuView(frame:CGRect(x:0, y:first.frame.maxY, width:self.view.bounds.size.width/2.0, height:150))
        three.delegate = self
        three.tag = comTag + 2
        self.view.addSubview(three)
        
        forth = XHWLMcuView(frame:CGRect(x:first.frame.maxX, y:first.frame.maxY, width:self.view.bounds.size.width/2.0, height:150))
        forth.delegate = self
        forth.tag = comTag + 3
        self.view.addSubview(forth)
        
        bottomView = XHWLMcuBottomView(frame:CGRect(x:0, y:self.view.bounds.size.height-200, width:self.view.bounds.size.width, height:200))
        self.view.addSubview(bottomView)
        
    }
    
    func mcuViewWithTouch(mcuView:XHWLMcuView) {
        
        if (mcuView.cameraSyscode != nil) {
//            选中 修改功能
            if selectMcuView != nil {
                selectMcuView.layer.borderColor = UIColor.white.cgColor
                selectMcuView.layer.borderWidth = 0.5
            }
            
            selectMcuView = mcuView
            selectMcuView.layer.borderColor = UIColor.purple.cgColor
            selectMcuView.layer.borderWidth = 2.0
            bottomView.mcuView = selectMcuView
        } else {
            if self.isLogin == true {
                let vc = XHWLMcuResourceVC()
                vc.backBlock = {cameraSyscode in
                    mcuView.realPlay(cameraSyscode: cameraSyscode)
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
