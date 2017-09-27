//
//  XHWLRegistrationDetailVC.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/10.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLRegistrationDetailVC: UIViewController  , XHWLScanTestVCDelegate{
    
    var bgImg:UIImageView!
    var dataAry:NSMutableArray!
    var visitorLogModel:XHWLVisitLogModel! 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        
        dataAry = NSMutableArray()
        let array :NSMutableArray = NSMutableArray()
        
        let ary1:NSArray = [["name":"姓名：", "content":visitorLogModel.sysVisitor.name, "isHiddenEdit": true],
                            ["name":"类型：", "content":visitorLogModel.sysVisitor.type, "isHiddenEdit": true],
                            ["name":"证件：", "content":visitorLogModel.sysVisitor.certificateType+visitorLogModel.sysVisitor.cetificateNo, "isHiddenEdit":true],
                            ["name":"手机：", "content":visitorLogModel.sysVisitor.telephone, "isHiddenEdit": true],
                            ["name":"时效：", "content":visitorLogModel.sysVisitor.timeNo+visitorLogModel.sysVisitor.timeUnit, "isHiddenEdit": true]]
        let ary2:NSArray = [
                            ["name":"事由：", "content":visitorLogModel.sysVisitor.accessReason, "isHiddenEdit": true],
                            ["name":"登记时间：", "content":Date.getStringDate(Int(visitorLogModel.sysVisitor.accessTime)!), "isHiddenEdit": true]]
      
        print("\(visitorLogModel.yzName)")
        if !visitorLogModel.yzName.isEmpty {
            array.addObjects(from: ary1 as! [Any])
            array.add(["name":"业主：", "content":visitorLogModel.yzName, "isHiddenEdit": true])
            array.add(["name":"房间：", "content":visitorLogModel.sysVisitor.roomNo, "isHiddenEdit": true])
            array.addObjects(from: ary2 as! [Any])
//            array.add(["name":"离开时间：", "content":Date.getStringDate(Int(visitorLogModel.sysVisitor.leaveTime)!), "isHiddenEdit": true])
        } else {
            array.addObjects(from: ary1 as! [Any])
            array.addObjects(from: ary2 as! [Any])
        }

        dataAry = XHWLMenuModel.mj_objectArray(withKeyValuesArray: array)
        
        setupView()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"scan_back"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(onBack))
        
        self.title = "登记详情"
    }
    
    func onBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupView() {
        
        bgImg = UIImageView()
        bgImg.frame = self.view.bounds
        bgImg.image = UIImage(named:"home_bg")
        self.view.addSubview(bgImg)
        
        let warningView:XHWLRegistrationDetailView = XHWLRegistrationDetailView()
        warningView.bounds = CGRect(x:0, y:0, width:Screen_width*13/16.0, height:Screen_height*2/3.0)
        warningView.center = CGPoint(x:self.view.frame.size.width/2.0, y:self.view.frame.size.height/2.0)
        warningView.createArray(array: dataAry)
        warningView.successView()
        
//        if !visitorLogModel.yzName.isEmpty {
//            
//            warningView.successView()
//        } else {
//            
//            warningView.failView()
//        }
        self.view.addSubview(warningView)
        
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
