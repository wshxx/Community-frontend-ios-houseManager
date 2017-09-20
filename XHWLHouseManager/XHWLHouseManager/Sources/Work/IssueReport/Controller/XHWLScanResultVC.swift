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
        
        let array :NSArray = [["name":"设备地址：", "content":scanModel!.address, "isHiddenEdit": true],
                              ["name":"编码信息：", "content":scanModel!.name, "isHiddenEdit": true],
                              ["name":"最后修改时间：", "content":scanModel!.projectName, "isHiddenEdit":true],
                              ["name":"当前状态：", "content":scanModel!.status, "isHiddenEdit": true]]
        dataAry = XHWLMenuModel.mj_objectArray(withKeyValuesArray: array)
        
        
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
        
        let image:UIImage = UIImage(named:"warning_bg")!
        warningView = XHWLScanResultView()
        warningView.bounds = CGRect(x:0, y:0, width:image.size.width, height:image.size.height)
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
        warningView.titleL.text = scanModel!.name
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
