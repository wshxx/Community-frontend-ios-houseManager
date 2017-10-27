//
//  XHWLProgressDetailVC.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/15.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLProgressDetailVC: XHWLBaseVC {

    var warningView:XHWLProgressDetailView!
    var realModel:XHWLRealProgressModel!
    var userId:String! = "" 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        setupView()
        setupNav()
    }
    
    func setupNav() {
        self.title = "进度详情"
    }
    
    func setupView() {

        print("\(userId)")
        warningView = XHWLProgressDetailView(frame:CGRect.zero)
//        warningView.realModel = realModel
        warningView.userId = userId
        warningView.bounds = CGRect(x:0, y:0, width:Screen_width*13/16.0, height:Screen_height*2/3.0)
        warningView.center = CGPoint(x:self.view.frame.size.width/2.0, y:self.view.frame.size.height/2.0)
        warningView.dismissBlock = { index in
            
        }
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
