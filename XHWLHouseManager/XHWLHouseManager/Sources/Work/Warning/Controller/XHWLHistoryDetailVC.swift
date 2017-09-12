//
//  XHWLHistoryDetailVC.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/9.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLHistoryDetailVC: UIViewController , XHWLScanTestVCDelegate{
    
    var bgImg:UIImageView!
    var dataAry:NSMutableArray!
    var isHistory:Bool! // 是历史记录
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        
        dataAry = NSMutableArray()
        let array :NSMutableArray = [["name":"告警等级：", "content":"严重", "isHiddenEdit": true],
                              ["name":"项目名称：", "content":"中海华庭", "isHiddenEdit": true],
                              ["name":"房间名称：", "content":"低压配电房", "isHiddenEdit":true],
                              ["name":"设备名称：", "content":"4#变压器", "isHiddenEdit": true],
                              ["name":"设备类型：", "content":"变压器", "isHiddenEdit": true],
                              ["name":"告警信息：", "content":"负载率过高警告当前", "isHiddenEdit": true],
                              ["name":"告警时间：", "content":"2017-01-21 12:23", "isHiddenEdit": true]]
        if isHistory {
            array.add(["name":"告警解除时间：", "content":"2017-01-21 12:23", "isHiddenEdit": true])
        }
        dataAry = XHWLMenuModel.mj_objectArray(withKeyValuesArray: array)
        
        setupView()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"xhwl_back"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(onBack))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"home_scan"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(onScan))
    }
    
    func onBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
    // 扫一扫
    func onScan() {
        let vc: XHWLScanTestVC = XHWLScanTestVC()
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setupView() {
        
        bgImg = UIImageView()
        bgImg.frame = self.view.bounds
        bgImg.image = UIImage(named:"xhwl_bg")
        self.view.addSubview(bgImg)
        
        let image:UIImage = UIImage(named:"menu_bg")!
        let warningView:XHWLHistoryWarningView = XHWLHistoryWarningView()
        warningView.bounds = CGRect(x:0, y:0, width:image.size.width, height:image.size.height)
        warningView.center = CGPoint(x:self.view.frame.size.width/2.0, y:self.view.frame.size.height/2.0)
        warningView.createArray(array: dataAry)
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
