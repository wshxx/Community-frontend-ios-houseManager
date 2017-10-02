//
//  XHWLMessageDetailVC.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/10/1.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLMessageDetailVC: XHWLBaseVC {

    var warningView:XHWLMessageDetailView!
    var dataAry:NSArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        
        
        dataAry = NSMutableArray()
        let array :NSArray = [["name":"标题：", "content":""],
                              ["name":"内容：", "content":""],
                              ["name":"发布时间：", "content":""],
                              ["name":"发布者：", "content":""],]
        dataAry = XHWLMenuModel.mj_objectArray(withKeyValuesArray: array)
        
        setupView()
        setupNav()
        
    }
    
    func setupNav() {
        self.title = "消息详情"
    }
    
    func setupView() {
        
        warningView = XHWLMessageDetailView(frame: CGRect.zero, dataAry)
        warningView.bounds = CGRect(x:0, y:0, width:Screen_width*13/16.0, height:Screen_height*2/3.0)
        warningView.center = CGPoint(x:self.view.frame.size.width/2.0, y:self.view.frame.size.height/2.0)
//        warningView.clickCell = {index in
//
//            let vc:XHWLSafeGuardDetailVC = XHWLSafeGuardDetailVC()
//            vc.abnormalModel = self.dealArray[index] as! XHWLAbnormalPassModel
//            vc.backReloadBlock = {[weak self] _ in
//                self?.onLoadData()
//            }
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
        self.view.addSubview(warningView)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
