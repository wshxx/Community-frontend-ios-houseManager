//
//  XHWLHomeView.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/12.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

// 安管主任：安防事件、在线定位、进度查看、数据、访客记录、异常放行、一键开门、远程开门
// 安管人员-门岗：访客登记、一键开门、远程开门
// 工程：设备报警、供配电、给排水、设备统计、能耗统计、一键开门、远程开门

@objc protocol XHWLHomeViewDelegate:NSObjectProtocol
{
    @objc optional func onHomeViewWithOpenBluetooth(_ homeView:XHWLHomeView)
    @objc optional func onHomeViewWithOpenNetwork(_ homeView:XHWLHomeView)
    @objc optional func onHomeViewWithBindCard(_ homeView:XHWLHomeView)
    @objc optional func onHomeViewWithMessage(_ homeView:XHWLHomeView)
}

class XHWLHomeView: UIView  {
    
//    var spaceBg:YLImageView!
    var spaceBigCircle:UIImageView!
    var spaceSmallCircle:UIImageView!
    var openBtn:UIButton!
    var netOpenBtn:UIButton!
    var bindCardBtn:UIButton!
//    var messageBtn:UIButton!
    var delegate:XHWLHomeViewDelegate?
    
    weak var bluePoint: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        setupView()
    }
    
    func setupView() {
        let bigImg = UIImage(named:"home_circle_outer")!
        spaceBigCircle = UIImageView()
        spaceBigCircle.bounds = CGRect(x:0, y:0, width:bigImg.size.width, height:bigImg.size.height)
        spaceBigCircle.center = CGPoint(x:self.bounds.size.width/2.0, y:self.bounds.size.height/2.0)
        spaceBigCircle.image = bigImg
        self.addSubview(spaceBigCircle)
        
        let smallImg = UIImage(named:"home_circle_inner")!
        spaceSmallCircle = UIImageView()
        spaceSmallCircle.bounds = CGRect(x:0, y:0, width:smallImg.size.width, height:smallImg.size.height)
        spaceSmallCircle.center = CGPoint(x:self.bounds.size.width/2.0, y:self.bounds.size.height/2.0)
        spaceSmallCircle.image = smallImg
        self.addSubview(spaceSmallCircle)
        
        let openImg:UIImage = UIImage(named: "home_finger_print")!
        openBtn = UIButton()
        openBtn.frame = CGRect(x:0, y:0, width:openImg.size.width, height:openImg.size.height)
        openBtn.center = CGPoint(x:self.bounds.size.width/2.0, y:self.bounds.size.height/2.0+5)
        openBtn.setImage(openImg, for: UIControlState.normal)
        openBtn.addTarget(self, action: #selector(onBluetoothOpenDoorClick), for: UIControlEvents.touchUpInside)
        self.addSubview(openBtn)
        
        let netOpenImg:UIImage = UIImage(named: "home_network")!
        netOpenBtn = UIButton()
        netOpenBtn.frame = CGRect(x:0, y:0, width:netOpenImg.size.width, height:netOpenImg.size.height)
        netOpenBtn.center = CGPoint(x:self.bounds.size.width/2.0+115, y:self.bounds.size.height/2.0+80)
        netOpenBtn.setImage(netOpenImg, for: UIControlState.normal)
        netOpenBtn.addTarget(self, action: #selector(onNetDoorBtnClicked), for: UIControlEvents.touchUpInside)
        self.addSubview(netOpenBtn)
        
        let cardImg:UIImage = UIImage(named: "home_bluetooth_bind")!
        bindCardBtn = UIButton()
        bindCardBtn.frame = CGRect(x:0, y:0, width:cardImg.size.width, height:cardImg.size.height)
        bindCardBtn.center = CGPoint(x:self.bounds.size.width/2.0-115, y:self.bounds.size.height/2.0-80)
        bindCardBtn.setImage(cardImg, for: UIControlState.normal)
        bindCardBtn.addTarget(self, action: #selector(onBindCardBtnClicked), for: UIControlEvents.touchUpInside)
        self.addSubview(bindCardBtn)
        
        let data:NSData = UserDefaults.standard.object(forKey: "user") as! NSData
        let userModel:XHWLUserModel = XHWLUserModel.mj_object(withKeyValues: data.mj_JSONObject())
        
//        if userModel.wyAccount.wyRole.name.compare("工程").rawValue == 0 {
//            let messageImg:UIImage = UIImage(named: "home_message")!
//            messageBtn = UIButton()
//            messageBtn.frame = CGRect(x:0, y:0, width:messageImg.size.width, height:messageImg.size.height)
//            messageBtn.center = CGPoint(x:self.bounds.size.width/2.0-115, y:self.bounds.size.height/2.0+80)
//            messageBtn.setImage(messageImg, for: UIControlState.normal)
//            messageBtn.addTarget(self, action: #selector(onMessageClicked), for: UIControlEvents.touchUpInside)
//            self.addSubview(messageBtn)
//        }

//        let window:UIWindow = UIApplication.shared.keyWindow!
//        spaceBg = YLImageView(frame: UIScreen.main.bounds)
//        spaceBg.isHidden = true
//        window.addSubview(spaceBg!)
//        window.bringSubview(toFront: spaceBg)
        
    }
    
    lazy fileprivate var spaceBg: YLImageView = {
        let window:UIWindow = UIApplication.shared.keyWindow!
        let spaceBg:YLImageView = YLImageView(frame: UIScreen.main.bounds)
        spaceBg.isHidden = true
        window.addSubview(spaceBg)
        window.bringSubview(toFront: spaceBg)
        
        return spaceBg
    }()
    

    // 蓝牙一键开门
    func onBluetoothOpenDoorClick() {
        
        self.spaceBg.isHidden = false
        let window:UIWindow = UIApplication.shared.keyWindow!
        window.bringSubview(toFront: spaceBg)
        YLGIFImage.setPrefetchNum(5)
        
        // Do any additional setup after loading the view, typically from a nib.
        let path = Bundle.main.url(forResource: "open_door", withExtension: "gif")?.absoluteString as String!
        spaceBg.image = YLGIFImage(contentsOfFile: path!)
        spaceBg.startAnimating()
        
        self.delegate?.onHomeViewWithOpenBluetooth!(self)
        //睡眠1.0s，
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + TimeInterval(1.0)){
            self.spaceBg.stopAnimating()
            //            let window:UIWindow = UIApplication.shared.keyWindow!
            //            window.sendSubview(toBack: self.spaceBg)
            self.spaceBg.isHidden = true
            self.spaceBg.image = UIImage(named: "Space_SpaceBg")
        }
        
    }
    
    // 蓝牙绑卡
    func onBindCardBtnClicked(_ sender: UIButton) {
        
        self.delegate?.onHomeViewWithBindCard!(self)
    }
    
    // 远程开门
    func onNetDoorBtnClicked(_ sender: UIButton) {

        self.delegate?.onHomeViewWithOpenNetwork!(self)
    }
    
    func onMessageClicked(_ sender: UIButton) {
        
        self.delegate?.onHomeViewWithMessage!(self)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
