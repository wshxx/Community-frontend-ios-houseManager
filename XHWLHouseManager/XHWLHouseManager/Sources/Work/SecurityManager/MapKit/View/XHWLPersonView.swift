//
//  XHWLPersonView.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/10/23.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLPersonView: UIView {

    var bgIV:UIImageView!
    var nameL:UILabel!
    var lineL:UILabel!
    var timeBtn:UIButton!
    var arrowIV:UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
        bgIV = UIImageView(frame:self.bounds)
        bgIV.image = UIImage(named:"Patrol_white_bg")
        self.addSubview(bgIV)
        
        nameL = UILabel()
        nameL.text = "人员："
        nameL.font = font_13
        nameL?.frame = CGRect(x:5, y:0, width:40, height:self.bounds.size.height)
        self.addSubview(nameL)
        
        lineL = UILabel()
        lineL.backgroundColor = UIColor.black
        lineL?.frame = CGRect(x:nameL.frame.maxX+5, y:5, width:0.5, height:self.bounds.size.height-10)
        self.addSubview(lineL)
        
//        let img:UIImage = UIImage(named:"Patrol_arrow")!
//        arrowIV = UIImageView(frame: CGRect(x:self.bounds.size.width-5-img.size.width, y:(self.bounds.size.height-img.size.height)/2.0, width:img.size.width, height:img.size.height))
//        arrowIV.image = img
//        self.addSubview(arrowIV)
        
//        timeBtn = UIButton()
//        timeBtn.setTitleColor(UIColor.black, for: .normal)
//        timeBtn.titleLabel?.font = font_13
//        timeBtn?.frame = CGRect(x:lineL.frame.maxX+5, y:0, width:self.bounds.size.width-lineL.frame.maxX-img.size.width-15, height:self.bounds.size.height)
//        self.addSubview(timeBtn)
        
        let vc:UIViewController = AppDelegate.shared().getCurrentVC()
        //        let window:UIWindow = UIApplication.shared.keyWindow!
        vc.view.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        
        let defaultTitle = "1号岗"
        let choices = ["第一个", "第二个", "第三个", "第四个"]
        let rect = CGRect(x:lineL.frame.maxX+5, y:2, width:self.bounds.size.width-lineL.frame.maxX-10, height:self.bounds.size.height-4)
        let dropBoxView = XHWLGroupBoxListView(parentVC: vc, title: defaultTitle, items: choices, frame: rect)
        dropBoxView.isHightWhenShowList = true
        dropBoxView.willShowOrHideBoxListHandler = { (isShow) in
            if isShow { NSLog("will show choices") }
            else { NSLog("will hide choices") }
        }
        dropBoxView.didShowOrHideBoxListHandler = { (isShow) in
            if isShow { NSLog("did show choices") }
            else { NSLog("did hide choices") }
        }
        dropBoxView.didSelectBoxItemHandler = { (row) in
            NSLog("selected No.\(row): \(dropBoxView.currentTitle())")
        }
        self.addSubview(dropBoxView)
    }
    
    func onListClick() {
        
        let vc:UIViewController = AppDelegate.shared().getCurrentVC()
//        let window:UIWindow = UIApplication.shared.keyWindow!
        vc.view.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        
        let defaultTitle = "这是一个下拉框，请选择"
        let choices = ["第一个选项", "第二个选项", "第三个选项", "第四个选项"]
        let rect = CGRect(x: 50, y: 100, width: Screen_width - 100, height: 50)
        let dropBoxView = XHWLGroupBoxListView(parentVC: vc, title: defaultTitle, items: choices, frame: rect)
        dropBoxView.isHightWhenShowList = true
        dropBoxView.willShowOrHideBoxListHandler = { (isShow) in
            if isShow { NSLog("will show choices") }
            else { NSLog("will hide choices") }
        }
        dropBoxView.didShowOrHideBoxListHandler = { (isShow) in
            if isShow { NSLog("did show choices") }
            else { NSLog("did hide choices") }
        }
        dropBoxView.didSelectBoxItemHandler = { (row) in
            NSLog("selected No.\(row): \(dropBoxView.currentTitle())")
        }
        vc.view.addSubview(dropBoxView)
    }
}
