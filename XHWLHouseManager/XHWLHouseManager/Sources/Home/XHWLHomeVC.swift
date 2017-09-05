//
//  XHWLHomeVC.swift
//  XHWLHouseManager
//
//  Created by admin on 2017/8/30.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import Foundation

import UIKit

class XHWLHomeVC: UIViewController {
    
    var bgView:UIImageView!
    var upBtn:UIButton!
    var spaceBg:YLImageView!
    var openBtn:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        setupView()
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeUpGesture(gesture:)))
        swipeUp.direction = UISwipeGestureRecognizerDirection.up
        self.view.addGestureRecognizer(swipeUp)
        
    }
    
    func setupView() {
        bgView = UIImageView(frame: self.view.bounds)
        bgView.image = UIImage(named:"Space_SpaceBg")
        self.view.addSubview(bgView)
        
        spaceBg = YLImageView(frame: CGRect(x:self.view.bounds.size.width/2.0-71, y:0, width:142, height:129))
        spaceBg.center = CGPoint(x:self.view.bounds.size.width/2.0, y:self.view.bounds.size.height/2.0)
        self.view.addSubview(spaceBg!)
        
        
        let img:UIImage = UIImage(named: "Space_UpBtn")!
        upBtn = UIButton()
        upBtn.frame = CGRect(x:0, y:0, width:img.size.width, height:img.size.height)
        upBtn.center = CGPoint(x:self.view.bounds.size.width/2.0, y:self.view.bounds.size.height-img.size.height/2.0-40)
        upBtn.setImage(img, for: UIControlState.normal)
        self.view.addSubview(upBtn)
        
        let openImg:UIImage = UIImage(named: "Space_FingerPrint")!
        openBtn = UIButton()
        openBtn.frame = CGRect(x:0, y:0, width:openImg.size.width, height:openImg.size.height)
        openBtn.center = CGPoint(x:self.view.bounds.size.width/2.0, y:self.view.bounds.size.height/2.0)
        openBtn.setImage(openImg, for: UIControlState.normal)
        openBtn.addTarget(self, action: #selector(authenticate), for: UIControlEvents.touchUpInside)
        self.view.addSubview(openBtn)
    }
    
    func changeStyleBtnClicked(_ sender: UIButton) {
        
    }
    
   // 指纹开锁
    func fingerPrintBtnClicked(doorId:String) {
        
        let params:[String: String] = ["reqId" : "ABCDEF", // 请求代码 【不为空，随意填】
                                       "upid" : "1234", // 项目唯一编号unique project identifier【现在的门禁服务器上设置的一个项目编号为 1234】
                                       "doorId" : "319", // 门ID 【在鉴权中获得的MID】
                                       "phone" : "", // 手机号码 【可为空】
                                       "personId" : "", // 人员编号【可为空】
                                       "name" : ""] // 人员姓名 【可为空】
        
        XHWLHttpTool.sharedInstance.postHttpTool(url: "openDoor", parameters: params, success: { (response) in
            print("JSON: \(response)")
        }) { (error) in
            
        }

        
        //睡眠1.9s，
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + TimeInterval(1.9)){
            self.spaceBg.stopAnimating()
            self.view.sendSubview(toBack: self.spaceBg)
            self.spaceBg.image = UIImage(named: "Space_SpaceBg")
        }
    }
    
    
//    3.测试接口
//    【get】 /test/getDoorId
//    描述：同1中鉴权
//    【get】 /test/openDoor
//    描述： 开测试中的门，测试门编号为319，项目编号为1234
    
    // 鉴权
    func authenticate()
    {
        
        self.view.bringSubview(toFront: self.spaceBg)
        YLGIFImage.setPrefetchNum(5)
        
        // Do any additional setup after loading the view, typically from a nib.
        let path = Bundle.main.url(forResource: "door2", withExtension: "gif")?.absoluteString as String!
        self.spaceBg.image = YLGIFImage(contentsOfFile: path!)
        self.spaceBg.startAnimating()
        
        let params:[String: String] = ["reqId" : "ABCDEF", // 请求代码 【不为空，随意填】
            "upid" : "1234", // 项目唯一编号unique project identifier【现在的门禁服务器上设置的一个项目编号为 1234】
            "bldgId" : "319", //unique building identifier 【暂时传1】
            "unitId" : "", // 单元编号 【暂时传2】
            "personId" : "", // 人员编号 【可为空】
            "personType" : "",// 人员类型 【传 YZ】
            "phone" : "", // 手机号码【可为空】
            "name" : ""] // 人员姓名 【可为空】
        
        XHWLHttpTool.sharedInstance.postHttpTool(url: "authenticate", parameters: params, success: { (response) in
             print("JSON: \(response)")
            
            let dict:NSDictionary = response as! NSDictionary
            let jg:String = dict["JG"] as! String
            
            if jg.compare("0").rawValue == 0 {
                let doorId:String = ""
                self.fingerPrintBtnClicked(doorId: doorId)
            }
            
            //            返回结果示例：
            //                { JQResult: '{"JG":"0","XX":"成功","QQDM":"ABCDEF","RYBH":null,"LYZS":null,"MLB":[{"MMC":"dev门","MID":"319","MLYID":null}]}' }
            //            返回注释：
            //            JG：结果代码,0正确
            //            XX：错误时候有描述信息
            //            QQDM：请求代码，与请求的一致
            //            RYBH：人员编号
            //            LYZS:蓝牙证书，暂为空
            //            MLB：门列表数组
            //            MMC：门名称
            //            MID：门ID
            //            MLYID：门的蓝牙ID 开发第一阶段为空
        }) { (error) in
            
        }
    }
    
    func personBtnClicked(_ sender: UIButton) {
    }
    func phoneCallBtnClicked(_ sender: UIButton) {
    }
    func cardBtnClicked(_ sender: UIButton) {
    }
    func doorBtnClicked(_ sender: UIButton) {
    }
    func upBtnClicked(_ sender: UIButton) {
        
        let vc = XHWLMcuShowVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    weak var bluePoint: UIImageView!
    
    
    func respondToSwipeUpGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.up:
                upBtnClicked(self.upBtn)
            default:
                break
            }
        }
    }
    
    

}
