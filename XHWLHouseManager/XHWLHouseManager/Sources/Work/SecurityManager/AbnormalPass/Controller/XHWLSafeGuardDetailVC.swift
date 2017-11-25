//
//  XHWLSafeGuardDetailVC.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/11.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLSafeGuardDetailVC: XHWLBaseVC {
    
    var backReloadBlock:()->() = {param in }
    var abnormalModel:XHWLAbnormalPassModel!
    var dataAry:NSMutableArray! = NSMutableArray()
    var dataAry2:NSMutableArray! = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        self.title = "详情"
        
        print("\(abnormalModel.operatorName)")
        dataAry = NSMutableArray()
        let array :NSArray = [["name":"放行原因：", "content":abnormalModel.reason, "isHiddenEdit": false, "type": 0],
                              ["name":"项目：", "content":abnormalModel.project, "isHiddenEdit": true, "type": 0],
                              ["name":"道口编号：", "content":abnormalModel.reason, "isHiddenEdit":false, "type": 0],
                              ["name":"道口名称：", "content":abnormalModel.roadName, "isHiddenEdit": true, "type": 0],
                              ["name":"车牌：", "content":abnormalModel.cardNo, "isHiddenEdit": false, "type": 0],
                              ["name":"出入时间：", "content":"\(abnormalModel.inDate) \n\(abnormalModel.outDate)", "isHiddenEdit": true, "type": 1],
                              ["name":"操作人：", "content":abnormalModel.operatorName, "isHiddenEdit":false, "type": 0],
                              ["name":"岗位：", "content":abnormalModel.station, "isHiddenEdit": true, "type": 0],
                              ["name":"照片：", "content":"业主", "isHiddenEdit": false, "type": 2]]
        
        let dataArray:NSMutableArray = NSMutableArray()
        if !abnormalModel.status.isEmpty { // isAgree
            if abnormalModel.status == "y" {
                dataArray.add(["name":"处置结果：", "content":"同意", "isHiddenEdit": true, "type": 0])
            } else if abnormalModel.status == "n" {
                dataArray.add(["name":"处置结果：", "content":"拒绝", "isHiddenEdit": true, "type": 0])
            }
            dataArray.add(["name":"处置人：", "content":abnormalModel.handleName, "isHiddenEdit": true, "type": 0])
            dataArray.add(["name":"处置时间：", "content":Date.getStringDate(Int(abnormalModel.handleTime)!), "isHiddenEdit": true, "type": 0])
        }
        dataAry = XHWLMenuModel.mj_objectArray(withKeyValuesArray: array)
        dataAry2 = XHWLMenuModel.mj_objectArray(withKeyValuesArray: dataArray)
        
        setupView()
    }
    
    func setupView() {
        
        let warningView:XHWLSafeGuardDetailView = XHWLSafeGuardDetailView(frame: CGRect.zero, !abnormalModel.status.isEmpty, dataAry, dataAry2)
        warningView.bounds = CGRect(x:0, y:0, width:Screen_width*13/16.0, height:Screen_height*2/3.0)
        warningView.center = CGPoint(x:self.view.frame.size.width/2.0, y:self.view.frame.size.height/2.0)
        warningView.exceptionId = abnormalModel.outExceptionId
        warningView.backReloadBlock = {[weak self] _ in
            self?.backReloadBlock()
            self?.navigationController?.popViewController(animated: true)

        }
        self.view.addSubview(warningView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
