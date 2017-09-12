//
//  XHWLSafeGuardDetailView.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/11.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

@objc protocol XHWLSafeGuardViewDelegate:NSObjectProtocol {
    @objc optional func onSafeGuard(_ isAdd:Bool)
}

class XHWLSafeGuardView: UIView {

    var bgImage:UIImageView!
    var bgScrollView: UIScrollView!
    var titleL:UILabel!
    var head1: XHWLHeadView!
    var pickPhoto:XHWLPickPhotoView!
    var remark:XHWLRemarkView!
    weak var delegate:XHWLSafeGuardViewDelegate?
    var head2: XHWLHeadView!
    var head3: XHWLHeadView!
    var picture:XHWLPickPhotoView!
    var dataAry2:NSMutableArray!
    var dataAry3:NSMutableArray!
    var labelViewArray2:NSMutableArray!
    var labelViewArray3:NSMutableArray!
    
    
    var submitBtn:UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        dataAry2 = NSMutableArray()
        let array2 :NSArray = [["name":"来源：", "content":"业主", "isHiddenEdit": false],
                              ["name":"报事人：", "content":"徐柳飞", "isHiddenEdit": true],
                              ["name":"报事时间：", "content":"2017.06.23 10:11:20", "isHiddenEdit":false],
                              ["name":"工单编号：", "content":"AH03475409797", "isHiddenEdit": true]]
        dataAry2 = XHWLMenuModel.mj_objectArray(withKeyValuesArray: array2)
        
        dataAry3 = NSMutableArray()
        let array3 :NSArray = [["name":"异常类型：", "content":"张雁称", "isHiddenEdit": false],
                              ["name":"巡检点位：", "content":"徐柳飞", "isHiddenEdit": true],
                              ["name":"备注：", "content":"2017.06.23 10:11:20", "isHiddenEdit":false],
                              ["name":"紧急情况：", "content":"是", "isHiddenEdit": true]]
        dataAry3 = XHWLMenuModel.mj_objectArray(withKeyValuesArray: array3)

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
        titleL.text = "安防事件详情"
        self.addSubview(titleL)
        
        //
        head1 = XHWLHeadView()
        head1.showText("来源详情：")
        bgScrollView.addSubview(head1)
        
        pickPhoto = XHWLPickPhotoView()
        pickPhoto.showText("现场照片：")
        pickPhoto.addPictureBlock = { isAdd in

            self.delegate?.onSafeGuard!(isAdd)
        }
        bgScrollView.addSubview(pickPhoto)
        
        remark = XHWLRemarkView()
        remark.showText("备注：")
        bgScrollView.addSubview(remark)
        
        //
        head2 = XHWLHeadView()
        head2.showText("来源详情：")
        bgScrollView.addSubview(head2)
        
        labelViewArray2 = NSMutableArray()
        for i in 0...dataAry2.count-1  {
            let menuModel :XHWLMenuModel = dataAry2[i] as! XHWLMenuModel
            let labelView: XHWLLabelView = XHWLLabelView()
            labelView.showText(leftText: menuModel.name, rightText:menuModel.content)
            labelView.contentTextAlign(textAlignment: NSTextAlignment.center)
            bgScrollView.addSubview(labelView)
            labelViewArray2.add(labelView)
        }
        
        head3 = XHWLHeadView()
        head3.showText("来源详情：")
        bgScrollView.addSubview(head3)
        
        labelViewArray3 = NSMutableArray()
        for i in 0...dataAry3.count-1  {
            let menuModel :XHWLMenuModel = dataAry3[i] as! XHWLMenuModel
            let labelView: XHWLLabelView = XHWLLabelView()
            labelView.showText(leftText: menuModel.name, rightText:menuModel.content)
            labelView.contentTextAlign(textAlignment: NSTextAlignment.center)
            bgScrollView.addSubview(labelView)
            labelViewArray3.add(labelView)
        }
        
        picture = XHWLPickPhotoView()
        bgScrollView.addSubview(picture)
        
        submitBtn = UIButton()
        submitBtn.setTitle("提交", for: UIControlState.normal)
        submitBtn.setTitleColor(color_09fbfe, for: UIControlState.normal)
        submitBtn.setBackgroundImage(UIImage(named:"btn_background"), for: UIControlState.normal)
        submitBtn.addTarget(self, action: #selector(submitClick), for: UIControlEvents.touchUpInside)
        bgScrollView.addSubview(submitBtn)
    }
    
    func submitClick() {
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bgImage.frame = self.bounds
        titleL.frame = CGRect(x:10, y:0, width:self.bounds.size.width-20, height:44)
        bgScrollView.frame = CGRect(x:0, y:titleL.frame.maxY, width:self.bounds.size.width, height:self.bounds.size.height-titleL.frame.maxY)
        
        head1.frame = CGRect(x:10, y:0, width:self.bounds.size.width-20, height:20)
        pickPhoto.frame = CGRect(x:10, y:head1.frame.maxY+10, width:self.bounds.size.width-20, height:80)
        remark.frame = CGRect(x:10, y:pickPhoto.frame.maxY+10, width:self.bounds.size.width-20, height:80)
        
        head2.frame = CGRect(x:10, y:remark.frame.maxY+10, width:self.bounds.size.width-20, height:20)
        for i in 0...labelViewArray2.count-1 {
            
            let labelView :XHWLLabelView = labelViewArray2[i] as! XHWLLabelView
            labelView.bounds = CGRect(x:0, y:0, width:258, height:25)
            labelView.center = CGPoint(x:self.frame.size.width/2.0, y:head2.frame.maxY+10+CGFloat(i*25))
        }
        
        head3.frame = CGRect(x:10, y:head2.frame.maxY+20+CGFloat(labelViewArray2.count).multiplied(by:25), width:self.bounds.size.width-20, height:20)
        
        for i in 0...labelViewArray3.count-1 {
            
            let labelView :XHWLLabelView = labelViewArray3[i] as! XHWLLabelView
            labelView.bounds = CGRect(x:0, y:0, width:258, height:25)
            labelView.center = CGPoint(x:self.frame.size.width/2.0, y:head3.frame.maxY + 10 + CGFloat(i*25))
        }
        picture.frame = CGRect(x:10, y:head3.frame.maxY+20+CGFloat(labelViewArray3.count).multiplied(by:25), width:self.bounds.size.width-20, height:80)
        
        submitBtn.bounds = CGRect(x:0, y:0, width:150, height:30)
        submitBtn.center = CGPoint(x:self.bounds.size.width/2.0, y:picture.frame.maxY+45)
        
        bgScrollView.contentSize = CGSize(width:0, height:submitBtn.frame.maxY+45)
    }
}
