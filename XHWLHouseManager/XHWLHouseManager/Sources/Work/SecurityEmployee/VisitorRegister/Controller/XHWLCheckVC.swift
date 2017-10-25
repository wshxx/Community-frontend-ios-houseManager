//
//  XHWLCheckVC.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/10.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLCheckVC: XHWLBaseVC , XHWLNetworkDelegate {
    
    var warningView:XHWLCheckListView!
    var submitBtn:UIButton!
    var nextParams:NSMutableDictionary! = NSMutableDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        setupView()
        setupNav()
        
        self.navigationController?.delegate = self
    }
    
    func setupNav() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "记录", style: UIBarButtonItemStyle.plain, target: self, action: #selector(onRecordClick))
        
        self.title = "访客登记"
    }
    
    func onRecordClick() {
        
        let vc:XHWLRegistrationVC = XHWLRegistrationVC() // 访客记录
        vc.title = "登记记录"
        self.navigationController?.delegate = self //as? UINavigationControllerDelegate // push/ pop
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setupView() {
        
        warningView = XHWLCheckListView()
        warningView.bounds = CGRect(x:0, y:0, width:Screen_width*13/16.0, height:Screen_height*2/3.0)
        warningView.center = CGPoint(x:self.view.frame.size.width/2.0, y:self.view.frame.size.height/2.0)
        self.view.addSubview(warningView)
        
        submitBtn = UIButton()
        submitBtn.bounds = CGRect(x:0, y:0, width:150, height:30)
        submitBtn.center = CGPoint(x:self.view.bounds.size.width/2.0, y:warningView.frame.maxY+40)
        submitBtn.setTitle("提交", for: UIControlState.normal)
        submitBtn.setTitleColor(color_09fbfe, for: UIControlState.normal)
        submitBtn.titleLabel?.font = font_14
        submitBtn.setBackgroundImage(UIImage(named:"menu_text_bg"), for: UIControlState.normal)
        submitBtn.addTarget(self, action: #selector(submitClick), for: UIControlEvents.touchUpInside)
        self.view.addSubview(submitBtn)
    }
    
    func submitClick() {
        
        self.warningView.endEditing(true)
        
        if warningView.name.isEmpty {
            "您的姓名为空".ext_debugPrintAndHint()
            return
        }
        
        if warningView.type.isEmpty {
            "请选择访客类型".ext_debugPrintAndHint()
            return
        }
        
        if warningView.certificateType.compare("身份证").rawValue == 0 {
            
            if warningView.certificateNo.isEmpty {
                "您的身份证为空".ext_debugPrintAndHint()
                return
            }
            else if !Validation.cardNum(warningView.certificateNo).isRight {
                "您输入的身份证不合法".ext_debugPrintAndHint()
                return
            }
        }
        
        if warningView.certificateType.compare("护照").rawValue == 0 {
            if warningView.certificateNo.isEmpty {
                "您输入的护照不能为空".ext_debugPrintAndHint()
                return
            }
        }
        
        print("\(warningView.name) \(warningView.telephone)")
        
        if warningView.telephone.isEmpty || !Validation.phoneNum(warningView.telephone).isRight {
            "您输入的电话号码不合法".ext_debugPrintAndHint()
            return
        }
        
        if warningView.timeNo.isEmpty {
            "您的时效为空".ext_debugPrintAndHint()
            return
        }
        
        if !warningView.carNo.isEmpty && !Validation.carNo(warningView.carNo).isRight {
            "您输入的车牌不合法".ext_debugPrintAndHint()
            return
        }
        
        if warningView.accessReason.isEmpty {
            "您的事由为空".ext_debugPrintAndHint()
            return
        }
        
        var isYZAgree:String = "y"
        
        let data:NSData = UserDefaults.standard.object(forKey: "user") as! NSData
        let dict:NSDictionary = data.mj_JSONObject() as! NSDictionary
        let userModel:XHWLUserModel = XHWLUserModel.mj_object(withKeyValues: dict)
        
        
        if !warningView.subView.isHidden {
//            isYZAgree = "n"
            if warningView.subView.roomNo.isEmpty {
                "请先选择房间".ext_debugPrintAndHint()
                return
            }
            
            if warningView.subView.roomNo.isEmpty {
                "您的输入的房号为空".ext_debugPrintAndHint()
                return
            }
            
            nextParams.addEntries(from: [
                "token":userModel.wyAccount.token, //     用户登录token
                "name":warningView.name,//    访客姓名
                "type":warningView.type, // 访客类型
                "certificateType":warningView.certificateType, //     证件类型
                "cetificateNo":warningView.certificateNo, //     证件号
                "telephone":warningView.telephone, //      访客电话号码
                "timeUnit":warningView.timeUnit, //      访问时间单位（天/时/分等）
                "timeNo":warningView.timeNo, //      访问时间值
                "carNo":warningView.carNo, //      车牌号
                "accessReason": warningView.accessReason, //    string    是    来访事由
                "roomNo":self.warningView.subView.isHidden ? "":warningView.subView.roomNo, //+warningView.subView.roomNo, //    string    否    房间号（根据获取的业主所拥有的单元选择，房间号手动输入）
                "yzId":self.warningView.subView.isHidden ? "":warningView.subView.yzId, //    string    否    业主id
                "isYZAgree":isYZAgree
            ])
            registerJpush()
        } else {
            
            submit(isYZAgree)
        }
    }
    
    func registerJpush() {
        let data:NSData = UserDefaults.standard.object(forKey: "user") as! NSData
        let dict:NSDictionary = data.mj_JSONObject() as! NSDictionary
        let userModel:XHWLUserModel = XHWLUserModel.mj_object(withKeyValues: dict)
        
        let params = ["yzAlias":warningView.subView.yzTele, //   是（物业端门岗提交访客数据向业主发起云对讲）/否（业主端）    业主号码（推送别名）
            "msg":userModel.telephone // warningView.name+"向您发起访客认证"// 是    推送提示消息
        ]
        XHWLNetwork.shared.postRegisterJpushClick(params as NSDictionary, self)
    }
    
    func submit(_ isYZAgree:String) {
        
        let data:NSData = UserDefaults.standard.object(forKey: "user") as! NSData
        let dict:NSDictionary = data.mj_JSONObject() as! NSDictionary
        let userModel:XHWLUserModel = XHWLUserModel.mj_object(withKeyValues: dict)
        
        let params:NSDictionary = [
            "token":userModel.wyAccount.token, //     用户登录token
            "name":warningView.name,//    访客姓名
            "type":warningView.type, // 访客类型
            "certificateType":warningView.certificateType, //     证件类型
            "cetificateNo":warningView.certificateNo, //     证件号
            "telephone":warningView.telephone, //      访客电话号码
            "timeUnit":warningView.timeUnit, //      访问时间单位（天/时/分等）
            "timeNo":warningView.timeNo, //      访问时间值
            "carNo":warningView.carNo, //      车牌号
            "accessReason": warningView.accessReason, //    string    是    来访事由
            "roomNo":self.warningView.subView.isHidden ? "":warningView.subView.roomNo, //+warningView.subView.roomNo, //    string    否    房间号（根据获取的业主所拥有的单元选择，房间号手动输入）
            "yzId":self.warningView.subView.isHidden ? "":warningView.subView.yzId, //    string    否    业主id
            "isYZAgree":isYZAgree
        ]
        
//        nextParams = params
        XHWLNetwork.shared.postVisitRegisterClick(params as NSDictionary, self)
    }
    
    func requestSuccess(_ requestKey: NSInteger, _ response: [String : AnyObject]) {
        
        if requestKey == XHWLRequestKeyID.XHWL_REGISTERJPUSH.rawValue {
            
            let vc:XHWLCallTakingVC = XHWLCallTakingVC()
            let data:NSData = UserDefaults.standard.object(forKey: "user") as! NSData
            let dict:NSDictionary = data.mj_JSONObject() as! NSDictionary
            let userModel:XHWLUserModel = XHWLUserModel.mj_object(withKeyValues: dict)
            
            vc.roomName = userModel.telephone// warningView.subView.yzTele
            vc.yzName = warningView.subView.yzName
            vc.backBlock = { isAgree in
                
                self.nextParams.addEntries(from: ["isYZAgree":isAgree])
                XHWLNetwork.shared.postVisitRegisterClick(self.nextParams as NSDictionary, self)
            }
            vc.nextParams = self.nextParams
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            if !warningView.subView.isHidden {
                
            } else {
                "提交成功".ext_debugPrintAndHint()
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func requestFail(_ requestKey: NSInteger, _ error: NSError) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
