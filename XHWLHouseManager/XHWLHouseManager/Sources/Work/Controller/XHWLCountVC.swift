//
//  XHWLCountVC.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/10.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLCountVC: UIViewController , XHWLScanTestVCDelegate{
    
    var bgImg:UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
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
        
        let showImg:UIImage = UIImage(named:"menu_bg")!
        let warningView:XHWLCountView = XHWLCountView(frame:CGRect.zero, array:["", ""])
        warningView.bounds = CGRect(x:0, y:0, width:showImg.size.width, height:showImg.size.height)
        warningView.center = CGPoint(x:self.view.frame.size.width/2.0, y:self.view.frame.size.height/2.0)
//        warningView.clickCell = {index in
//            
//            let vc:XHWLHistoryDetailVC = XHWLHistoryDetailVC()
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
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
