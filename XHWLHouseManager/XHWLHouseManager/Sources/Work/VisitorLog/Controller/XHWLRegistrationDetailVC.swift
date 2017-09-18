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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        
        dataAry = NSMutableArray()
        let array :NSArray = [["name":"姓名：", "content":"徐柳飞", "isHiddenEdit": true],
                              ["name":"类型：", "content":"访客友人", "isHiddenEdit": true],
                              ["name":"证件：", "content":"身份证1320380483084", "isHiddenEdit":true],
                              ["name":"手机：", "content":"103843074", "isHiddenEdit": true],
                              ["name":"时效：", "content":"1小时", "isHiddenEdit": true],
                              ["name":"业主：", "content":"张浩然", "isHiddenEdit": true],
                              ["name":"房间：", "content":"1栋1单元2304", "isHiddenEdit": true],
                              ["name":"事由：", "content":"看望业主", "isHiddenEdit": true],
                              ["name":"登记时间：", "content":"2017-01-21 12:23", "isHiddenEdit": true],
                              ["name":"离开时间：", "content":"2017-01-21 12:23", "isHiddenEdit": true]]
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
        
        let image:UIImage = UIImage(named:"subview_bg")!
        let warningView:XHWLRegistrationDetailView = XHWLRegistrationDetailView()
        warningView.bounds = CGRect(x:0, y:0, width:image.size.width, height:image.size.height)
        warningView.center = CGPoint(x:self.view.frame.size.width/2.0, y:self.view.frame.size.height/2.0)
        warningView.createArray(array: dataAry)
        warningView.successView()
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
