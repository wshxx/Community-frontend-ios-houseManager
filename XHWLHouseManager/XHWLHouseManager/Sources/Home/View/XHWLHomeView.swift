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
}

class XHWLHomeView: UIView  {
    
//    var spaceBg:YLImageView!
    var spaceBigCircle:UIImageView!
    var spaceSmallCircle:UIImageView!
    var openBtn:UIButton!
    var netOpenBtn:UIButton!
    var bindCardBtn:UIButton!
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
    

    // 蓝牙开门
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
//        authenticate()
        
        self.delegate?.onHomeViewWithOpenNetwork!(self)
    }
    
    // 指纹开锁
    func fingerPrintBtnClicked(doorId:String) {
        
        let params:[String: String] = ["reqId" : "ABCDEF", // 请求代码 【不为空，随意填】
            "upid" : "1234", // 项目唯一编号unique project identifier【现在的门禁服务器上设置的一个项目编号为 1234】
            "doorId" : "319", // 门ID 【在鉴权中获得的MID】
            "phone" : "", // 手机号码 【可为空】
            "personId" : "", // 人员编号【可为空】
            "name" : ""] // 人员姓名 【可为空】
        
//        XHWLHttpTool.sharedInstance.postHttpTool(url: "openDoor", parameters: params, success: { (response) in
//            print("JSON: \(response)")
//        }) { (error) in
//            
//        }
    }
    
    
    //    3.测试接口
    //    【get】 /test/getDoorId
    //    描述：同1中鉴权
    //    【get】 /test/openDoor
    //    描述： 开测试中的门，测试门编号为319，项目编号为1234
    // 鉴权
    func authenticate() {
        
       
        let params:[String: String] = ["reqId" : "ABCDEF", // 请求代码 【不为空，随意填】
            "upid" : "1234", // 项目唯一编号unique project identifier【现在的门禁服务器上设置的一个项目编号为 1234】
            "bldgId" : "319", //unique building identifier 【暂时传1】
            "unitId" : "", // 单元编号 【暂时传2】
            "personId" : "", // 人员编号 【可为空】
            "personType" : "",// 人员类型 【传 YZ】
            "phone" : "", // 手机号码【可为空】
            "name" : ""] // 人员姓名 【可为空】
        
//        XHWLHttpTool.sharedInstance.postHttpTool(url: "authenticate", parameters: params, success: { (response) in
//            print("JSON: \(response)")
//            
//            let dict:NSDictionary = response as! NSDictionary
//            let jg:String = dict["JG"] as! String
//            
//            if jg.compare("0").rawValue == 0 {
//                let doorId:String = ""
//                self.fingerPrintBtnClicked(doorId: doorId)
//            }
//            
//            //            返回结果示例：
//            //                { JQResult: '{"JG":"0","XX":"成功","QQDM":"ABCDEF","RYBH":null,"LYZS":null,"MLB":[{"MMC":"dev门","MID":"319","MLYID":null}]}' }
//            //            返回注释：
//            //            JG：结果代码,0正确
//            //            XX：错误时候有描述信息
//            //            QQDM：请求代码，与请求的一致
//            //            RYBH：人员编号
//            //            LYZS:蓝牙证书，暂为空
//            //            MLB：门列表数组
//            //            MMC：门名称
//            //            MID：门ID
//            //            MLYID：门的蓝牙ID 开发第一阶段为空
//        }) { (error) in
//            
//        }
    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
