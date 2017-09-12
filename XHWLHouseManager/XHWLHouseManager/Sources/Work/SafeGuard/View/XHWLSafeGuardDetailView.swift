//
//  XHWLSafeGuardDetailView.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/11.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

enum XHWLSafeGuardDetailEnum : Int{
    case label = 0
    case doubleLabel
    case picture
}

class XHWLSafeGuardDetailView: UIView {

    var bgImage:UIImageView!
    var bgScrollView:UIScrollView!
    var titleL:UILabel!
    var dataAry:NSMutableArray!
    var labelViewArray:NSMutableArray!
    var lineIV:UIImageView!
    
    var submitBtn:UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        dataAry = NSMutableArray()
        let array :NSArray = [["name":"放行原因：", "content":"特殊车辆", "isHiddenEdit": false, "type": 0],
                               ["name":"项目：", "content":"中海华庭", "isHiddenEdit": true, "type": 0],
                               ["name":"道口编号：", "content":"12345", "isHiddenEdit":false, "type": 0],
                               ["name":"道口名称：", "content":"12345", "isHiddenEdit": true, "type": 0],
                               ["name":"车牌：", "content":"翼3047504", "isHiddenEdit": false, "type": 0],
                               ["name":"出入时间：", "content":"2017-11-11 09:12:30 \n 2017-11-11", "isHiddenEdit": true, "type": 1],
                               ["name":"操作人：", "content":"徐柳飞", "isHiddenEdit":false, "type": 0],
                               ["name":"岗位：", "content":"门岗", "isHiddenEdit": true, "type": 0],
                               ["name":"照片：", "content":"业主", "isHiddenEdit": false, "type": 2],
                               ["name":"处置结果：", "content":"同意", "isHiddenEdit": true, "type": 0]]
        dataAry = XHWLMenuModel.mj_objectArray(withKeyValuesArray: array)
        
        setupView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
        bgImage = UIImageView()
        bgImage.image = UIImage(named:"menu_bg")
        self.addSubview(bgImage)
        
        bgScrollView = UIScrollView()
        bgScrollView.showsVerticalScrollIndicator = false
        self.addSubview(bgScrollView)
        
        titleL = UILabel()
        titleL.textAlignment = NSTextAlignment.center
        titleL.textColor = color_09fbfe
        titleL.font = font_13
        titleL.text = "详情"
        self.addSubview(titleL)
        
        lineIV = UIImageView()
        lineIV.image = UIImage(named: "warning_cell_line")
        self.addSubview(lineIV)
        
        labelViewArray = NSMutableArray()
        for i in 0...dataAry.count-1  {
            let menuModel :XHWLMenuModel = dataAry[i] as! XHWLMenuModel
      
            if menuModel.type == 0 {
                let labelView: XHWLLabelView = XHWLLabelView()
                labelView.showText(leftText: menuModel.name, rightText:menuModel.content)
                labelView.contentTextAlign(textAlignment: NSTextAlignment.left)
                self.addSubview(labelView)
                labelViewArray.add(labelView)
            }
            else if menuModel.type == 1 {
                let labelView: XHWLLabelView = XHWLLabelView()
                labelView.showText(leftText: menuModel.name, rightText:menuModel.content)
                labelView.contentTextAlign(textAlignment: NSTextAlignment.left)
                self.addSubview(labelView)
                labelViewArray.add(labelView)
            }
            else if menuModel.type == 2 {
                let picture:XHWLPickPhotoView = XHWLPickPhotoView()
                self.addSubview(picture)
                labelViewArray.add(picture)
            }
        }
    
//        submitBtn = UIButton()
//        submitBtn.setTitle("提交", for: UIControlState.normal)
//        submitBtn.setTitleColor(color_09fbfe, for: UIControlState.normal)
//        submitBtn.setBackgroundImage(UIImage(named:"btn_background"), for: UIControlState.normal)
//        submitBtn.addTarget(self, action: #selector(submitClick), for: UIControlEvents.touchUpInside)
//        bgScrollView.addSubview(submitBtn)
    }
    
    func submitClick() {
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bgImage.frame = self.bounds
        titleL.frame = CGRect(x:10, y:0, width:self.bounds.size.width-20, height:44)
        lineIV.frame = CGRect(x:10, y:titleL.frame.maxY, width:self.bounds.size.width-20, height:0.5)
//        bgScrollView.frame = CGRect(x:0, y:titleL.frame.maxY, width:self.bounds.size.width, height:self.bounds.size.height-titleL.frame.maxY)
        var first:NSInteger = 0
        var second:NSInteger = 0
        var third:NSInteger = 0
        
        for i in 0...labelViewArray.count-1 {
            
            let menuModel :XHWLMenuModel = dataAry[i] as! XHWLMenuModel
            if menuModel.type == 0 {
                let labelView :XHWLLabelView = labelViewArray[i] as! XHWLLabelView
                labelView.bounds = CGRect(x:0, y:0, width:258, height:25)
                labelView.center = CGPoint(x:self.frame.size.width/2.0, y:lineIV.frame.maxY+10+CGFloat(first*25+second*25+third*60))
                first += 1
            }
            else if menuModel.type == 1 {
                let labelView :XHWLLabelView = labelViewArray[i] as! XHWLLabelView
                labelView.bounds = CGRect(x:0, y:0, width:258, height:25)
                labelView.center = CGPoint(x:self.frame.size.width/2.0, y:lineIV.frame.maxY+10+CGFloat(first*25+second*25+third*60))
                second += 1
            }
            else if menuModel.type == 2 {
                
                let labelView :XHWLPickPhotoView = labelViewArray[i] as! XHWLPickPhotoView
                labelView.frame = CGRect(x:(self.bounds.size.width-258)/2.0, y:lineIV.frame.maxY+CGFloat(first*25+second*25+third*60), width:60, height:60)
                third += 1
            }
        }
        
//        submitBtn.bounds = CGRect(x:0, y:0, width:150, height:30)
//        submitBtn.center = CGPoint(x:self.bounds.size.width/2.0, y:picture.frame.maxY+45)
        
//        bgScrollView.contentSize = CGSize(width:0, height:500)
    }
}
