//
//  XHWLMcuPictureListVC.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/10/23.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLMcuPictureListVC: XHWLBaseVC {
    
    
    var warningView:XHWLPictureListView!
    lazy fileprivate var deleteBtn:UIButton = {
        let jumpBtn = UIButton()
        jumpBtn.setTitle("删除", for: .normal)
        jumpBtn.setTitleColor(color_09fbfe, for: UIControlState.normal)
        jumpBtn.titleLabel?.font = font_14
        jumpBtn.setBackgroundImage(UIImage(named:"btn_background"), for: UIControlState.normal)
        jumpBtn.addTarget(self, action: #selector(onDelete), for: .touchUpInside)
        jumpBtn.bounds = CGRect(x:0, y:0, width:Screen_width*0.4, height:30)
        jumpBtn.center = CGPoint(x:Screen_width/2.0, y:self.warningView.frame.maxY+50)
//        jumpBtn.isHidden = true
        self.view.addSubview(jumpBtn)
        
        return jumpBtn
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.view.addSubview(self.logView)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "编辑", style:.plain, target: self, action: #selector(onEdit))
        self.title = "云瞳监控"
        
        setupView()
    }
    
    func setupView() {
        
        warningView = XHWLPictureListView(frame:CGRect(x:Screen_width*3/32.0, y:Screen_height/6.0, width:Screen_width*13/16.0, height:Screen_height*2/3.0))
        self.view.addSubview(warningView)
        
        self.view.addSubview(self.deleteBtn)
    }
    
//    lazy fileprivate var logView:XHWLMcuLogView! = {
//        let logView:XHWLMcuLogView = XHWLMcuLogView(frame:CGRect(x:Screen_width*3/32.0, y:Screen_height*1/6.0, width:Screen_width*13/16.0, height:Screen_height*2/3.0))
//        //        playView.delegate = self
//
//        return logView
//    }()
    
    func onEdit() {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "取消", style:.plain, target: self, action: #selector(onCancel))
        self.deleteBtn.isHidden = false
    }
    
    func onCancel() {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "编辑", style:.plain, target: self, action: #selector(onEdit))
        self.deleteBtn.isHidden = true
    }
    
    func onDelete() {
        
        onCancel()
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
