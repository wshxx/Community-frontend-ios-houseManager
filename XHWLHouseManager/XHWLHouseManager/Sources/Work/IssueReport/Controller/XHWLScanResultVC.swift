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
                              ["name":"编码信息：", "content":scanModel!.code, "isHiddenEdit": true],
//                              ["name":"最后修改时间：", "content":"", "isHiddenEdit":true],
                              ["name":"当前状态：", "content":scanModel!.status, "isHiddenEdit": true],
                              ["name":"基础信息：", "content":scanModel!.name, "isHiddenEdit": true],
                              ["name":"价格：", "content":scanModel!.price, "isHiddenEdit": true],
                              ["name":"项目名称：", "content":scanModel!.projectName, "isHiddenEdit": true]]
        dataAry = XHWLMenuModel.mj_objectArray(withKeyValuesArray: array)
        
        

        
        
//        category = "\U56ed\U6797\U7eff\U690d";
//        code = pl01;
//        description = "\U56ed\U6797\U7eff\U690d";
//        id = "'1e69d4e7-8e1a-11e7-a2f9-4ccc6aeb6282'";
//        name = "\U9ec4\U6768";
//        price = 700;
//        prodDate = "-2211696000000";
//        projectName = "\U4e2d\U6d77\U5929\U9882\U96c5\U82d1";
//        status = 06;
//        sysProject =         {
//            code = zhht;
//            divisionName = "\U5e7f\U4e1c\U7701";
//            id = "01a4fb8b-8e1f-11e7-a2f9-4ccc6aeb6282";
//            latitude = "102.1233";
//            longitude = 101;
//            name = "\U4e2d\U6d77\U5929\U9882\U96c5\U82d1";
//        };
//        type = 01;
        
        
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
        warningView.titleL.text = scanModel.type == "01" ? "园林绿植":"设备" // scanModel!.name
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
