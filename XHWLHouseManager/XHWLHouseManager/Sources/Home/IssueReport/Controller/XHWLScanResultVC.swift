//
//  XHWLScanResultVC.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/14.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLScanResultVC: UIViewController {

    
    var bgImg:UIImageView!
    var warningView:XHWLScanResultView!
    var scanModel:XHWLScanModel!
    var dataAry:NSMutableArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        dataAry = NSMutableArray()
        
        //        一、设备类：1.设备名称。2.项目。3.位置。4.设备编码。5.当前状态。
        //        二、园林类：1.植被名称。2.项目。3.位置。4.编码
        
        var scanDataModel:XHWLScanDataModel?
        if scanModel.type == "plant" {
            scanDataModel = scanModel.plant
        } else {
            scanDataModel = scanModel.plant
        }
        
        let array :NSArray = [["name":"项目：", "content":scanDataModel!.sysProject.name, "isHiddenEdit": true]
                              ]
        let mutableAry :NSMutableArray = NSMutableArray.init(array: array)
        
        if scanModel.type == "plant" {
            mutableAry.add(["name":"位置：", "content":"(\(scanDataModel!.longitude),\(scanDataModel!.latitude))", "isHiddenEdit": true])
            mutableAry.add(["name":"编码：", "content":scanDataModel!.sysProject.ccProjectCode, "isHiddenEdit": true])
         } else {
            mutableAry.add(["name":"位置：", "content":scanDataModel!.address, "isHiddenEdit": true])
            mutableAry.add(["name":"设备编码：", "content":scanDataModel!.sysProject.ccProjectCode, "isHiddenEdit":true])
            mutableAry.add(["name":"当前状态：", "content":scanDataModel!.status, "isHiddenEdit": true])
        }
      
        dataAry = XHWLMenuModel.mj_objectArray(withKeyValuesArray: mutableAry)

        setupNav()
        setupScanResult()
    }
    
    func setupNav() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"scan_back"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(onBack))
    }
    
    func onBack(){
        self.navigationController?.popViewController(animated: true)
    }

    func setupScanResult() {
        bgImg = UIImageView()
        bgImg.frame = self.view.bounds
        bgImg.image = UIImage(named:"home_bg")
        self.view.addSubview(bgImg)
        
        warningView = XHWLScanResultView()
        warningView.bounds = CGRect(x:0, y:0, width:Screen_width*13/16.0, height:Screen_height*2/3.0)
        warningView.center = CGPoint(x:self.view.frame.size.width/2.0, y:self.view.frame.size.height/2.0)
        warningView.btnBlock = {[weak self] index in
            if index == 0 {
                self?.navigationController?.popViewController(animated: true)
            } else {
                let vc:XHWLIssueReportVC = XHWLIssueReportVC()
                vc.scanModel = self?.scanModel
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
        warningView.createArray(dataAry)
        
        if scanModel.type == "plant" {
            let scanDataModel:XHWLScanDataModel = scanModel.plant
            warningView.titleL.text = scanDataModel.name
        } else {
            let scanDataModel:XHWLScanDataModel = scanModel.plant
            warningView.titleL.text = scanDataModel.name
        }
        // scanModel.type == "01" ? "园林绿植":"设备" // scanModel!.name
        self.view.addSubview(warningView)
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
