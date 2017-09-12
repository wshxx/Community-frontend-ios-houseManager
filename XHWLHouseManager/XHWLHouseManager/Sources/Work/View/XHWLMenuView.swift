//
//  XHWLMenuView.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/8.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLMenuView: UIView {

    var bgImg :UIImageView!
    var headOutImg :UIImageView!
    var headImg :UIImageView!
    var dataAry:NSMutableArray!
    var labelViewArray:NSMutableArray!
    
//    var 
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        
        dataAry = NSMutableArray()
        let array :NSArray = [["name":"姓名：", "content":"张雁称", "isHiddenEdit": false],
                   ["name":"工号：", "content":"3406745", "isHiddenEdit": true],
                   ["name":"手机：", "content":"13713432456", "isHiddenEdit":false],
                   ["name":"岗位：", "content":"工程", "isHiddenEdit": true],
                   ["name":"项目：", "content":"华庭", "isHiddenEdit": true]]
        dataAry = XHWLMenuModel.mj_objectArray(withKeyValuesArray: array)
        setupView()
        
        
    }
    
    func setupView() {
        bgImg = UIImageView()
        bgImg.frame = self.bounds
        bgImg.image = UIImage(named:"menu_bg")
        self.addSubview(bgImg)
        
        headOutImg = UIImageView()
        headOutImg.bounds = CGRect(x:0, y:0, width:86, height:86)
        headOutImg.image = UIImage(named:"head_outer_circle")
        headOutImg.center = CGPoint(x:self.frame.size.width/2.0, y:58)
        self.addSubview(headOutImg)
        
        headImg = UIImageView()
        headImg.bounds = CGRect(x:0, y:0, width:77, height:77)
        headImg.image = UIImage(named:"head_inner_circle")
        headImg.center = CGPoint(x:self.frame.size.width/2.0, y:58)
        self.addSubview(headImg)
        
        labelViewArray = NSMutableArray()
        for obj in dataAry {
            let menuModel :XHWLMenuModel = obj as! XHWLMenuModel
            let labelView: XHWLMenuLabelView = XHWLMenuLabelView()
            labelView.showText(leftText: menuModel.name, rightText:menuModel.content, isHiddenEdit: menuModel.isHiddenEdit)
            labelView.isHiddenEdit = menuModel.isHiddenEdit
            self.addSubview(labelView)
            labelViewArray.add(labelView)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        for i in 0...labelViewArray.count-1 {
            
            let labelView :XHWLMenuLabelView = labelViewArray[i] as! XHWLMenuLabelView
            labelView.bounds = CGRect(x:0, y:0, width:258, height:30)
            labelView.center = CGPoint(x:self.frame.size.width/2.0, y:CGFloat(145 + i*52))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
