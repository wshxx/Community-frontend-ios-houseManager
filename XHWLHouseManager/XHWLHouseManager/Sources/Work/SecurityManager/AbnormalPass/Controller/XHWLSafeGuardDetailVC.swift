//
//  XHWLSafeGuardDetailVC.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/11.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLSafeGuardDetailVC: UIViewController, XHWLScanTestVCDelegate{
    
    var bgImg:UIImageView!
    var backReloadBlock:()->() = {param in }
    var abnormalModel:XHWLAbnormalPassModel!
    var dataAry:NSMutableArray! = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white

        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"scan_back"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(onBack))
        self.title = "详情"
        
        dataAry = NSMutableArray()
        let array :NSArray = [["name":"放行原因：", "content":abnormalModel.reason, "isHiddenEdit": false, "type": 0],
                              ["name":"项目：", "content":abnormalModel.project, "isHiddenEdit": true, "type": 0],
                              ["name":"道口编号：", "content":abnormalModel.reason, "isHiddenEdit":false, "type": 0],
                              ["name":"道口名称：", "content":abnormalModel.roadName, "isHiddenEdit": true, "type": 0],
                              ["name":"车牌：", "content":abnormalModel.cardNo, "isHiddenEdit": false, "type": 0],
                              ["name":"出入时间：", "content":"\(abnormalModel.inDate) \n\(abnormalModel.outDate)", "isHiddenEdit": true, "type": 1],
                              ["name":"操作人：", "content":abnormalModel.oper, "isHiddenEdit":false, "type": 0],
                              ["name":"岗位：", "content":abnormalModel.station, "isHiddenEdit": true, "type": 0],
                              ["name":"照片：", "content":"业主", "isHiddenEdit": false, "type": 2]]
        
        let dataArray:NSMutableArray = NSMutableArray()
        dataArray.addObjects(from: array as! [Any])
        if true { // isAgree
            dataArray.add(["name":"处置结果：", "content":"同意", "isHiddenEdit": true, "type": 0])
        }
        dataAry = XHWLMenuModel.mj_objectArray(withKeyValuesArray: dataArray)
        
        setupView()
    }
    
    func onBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupView() {
        
        bgImg = UIImageView()
        bgImg.frame = self.view.bounds
        bgImg.image = UIImage(named:"home_bg")
        self.view.addSubview(bgImg)
        
        let warningView:XHWLSafeGuardDetailView = XHWLSafeGuardDetailView(frame: CGRect.zero, false, dataAry)
        warningView.bounds = CGRect(x:0, y:0, width:Screen_width*13/16.0, height:Screen_height*2/3.0)
        warningView.center = CGPoint(x:self.view.frame.size.width/2.0, y:self.view.frame.size.height/2.0)
        warningView.backReloadBlock = { _ in
            self.backReloadBlock()
            self.navigationController?.popViewController(animated: true)

        }
        self.view.addSubview(warningView)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
