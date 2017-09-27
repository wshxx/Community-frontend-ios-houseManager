//
//  XHWLSafeGuardDetailView.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/11.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

@objc protocol XHWLSafeGuardViewDelegate:NSObjectProtocol {
    @objc optional func onSafeGuard(_ isAdd:Bool, _ index:NSInteger, _ isPictureAdd:Bool)
}

class XHWLSafeGuardView: UIView {

    var bgImage:UIImageView!
    var bgScrollView: UIScrollView!
    var head1: XHWLHeadView!
    var pickPhoto:XHWLPickPhotoView!
    var remark:XHWLRemarkView!
    weak var delegate:XHWLSafeGuardViewDelegate?
    var head2: XHWLHeadView!
    var head3: XHWLHeadView!
    var picture:XHWLPickPhotoView!
    var dataAry1:NSMutableArray!
    var dataAry2:NSMutableArray!
    var dataAry3:NSMutableArray!
    var labelViewArray1:NSMutableArray!
    var labelViewArray2:NSMutableArray!
    var labelViewArray3:NSMutableArray!
    var isFinished:Bool!
    var model:XHWLSafeProtectionModel! // 单号
    var submitBlock:(String)->(Void) = {param in }
    var remarkStr:String! = ""
    
    var submitBtn:UIButton!
    
    init(frame: CGRect, _ isFinished:Bool, _ model:XHWLSafeProtectionModel) {
        super.init(frame: frame)
        
        self.isFinished = isFinished
        self.model = model
        
        if Int(model.appComplaint.status) == 1 {
            dataAry1 = NSMutableArray()
            let array1 :NSArray = [["name":"备注：", "content":model.appComplaint.manageRemarks, "isHiddenEdit": false],
                                   ["name":"处理人：", "content":model.manageUserName, "isHiddenEdit": true],
                                   ["name":"处理时间：", "content":Date.getDateWith(Int(model.appComplaint.manageTime)!, "yyyy-MM-dd"), "isHiddenEdit":false]]
            dataAry1 = XHWLMenuModel.mj_objectArray(withKeyValuesArray: array1)
        }
        
        dataAry2 = NSMutableArray()
        let array2 :NSArray = [["name":"来源：", "content":model.appComplaint.wyAccount.wyRole.name, "isHiddenEdit": false],
                              ["name":"报事人：", "content":model.complaintUserName, "isHiddenEdit": true],
                              ["name":"报事时间：", "content":Date.getDateWith(Int(model.appComplaint.createTime)!, "yyyy-MM-dd HH:mm:ss"), "isHiddenEdit":false],
                              ["name":"工单编号：", "content":model.appComplaint.code, "isHiddenEdit": true]]
        dataAry2 = XHWLMenuModel.mj_objectArray(withKeyValuesArray: array2)
        
        dataAry3 = NSMutableArray()
        let array3 :NSArray = [["name":"异常类型：", "content":model.appComplaint.type, "isHiddenEdit": false],
                              ["name":"巡检点位：", "content":model.appComplaint.inspectionPoint, "isHiddenEdit": true],
                              ["name":"备注：", "content":model.appComplaint.remarks, "isHiddenEdit":false],
                              ["name":"紧急情况：", "content":model.appComplaint.urgency, "isHiddenEdit": true]]
        dataAry3 = XHWLMenuModel.mj_objectArray(withKeyValuesArray: array3)

        setupView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
        bgImage = UIImageView()
        bgImage.image = UIImage(named:"subview_bg")
        self.addSubview(bgImage)
        
        bgScrollView = UIScrollView()
        bgScrollView.showsVerticalScrollIndicator = false
        self.addSubview(bgScrollView)
        
        //
        head1 = XHWLHeadView()
        head1.showText("处理详情：")
        head1.showTextColor = color_01f0ff
        bgScrollView.addSubview(head1)
        
        pickPhoto = XHWLPickPhotoView(frame: CGRect.zero, isFinished)
        pickPhoto.showText("现场照片：")
        if isFinished {
            if !(model.appComplaint.imgUrl is NSNull) {
                let array:NSArray = model.appComplaint.manageImgUrl.components(separatedBy: ",") as NSArray
                pickPhoto.onShowImgArray(array)
            }
        }
//        pickPhoto.isShow = isFinished // 显示
        pickPhoto.addPictureBlock = { isAdd, index, isPictureAdd in
            self.delegate?.onSafeGuard!(isAdd, index, isPictureAdd)
        }
        bgScrollView.addSubview(pickPhoto)
        
        if isFinished {
            labelViewArray1 = NSMutableArray()
            for i in 0...dataAry1.count-1  {
                let menuModel :XHWLMenuModel = dataAry1[i] as! XHWLMenuModel
                let labelView: XHWLLabelView = XHWLLabelView()
                labelView.showText(leftText: menuModel.name, rightText:menuModel.content)
                labelView.contentTextAlign(NSTextAlignment.center)
                bgScrollView.addSubview(labelView)
                labelViewArray1.add(labelView)
            }
        } else {
            remark = XHWLRemarkView()
            remark.showText("备注：")
            remark.textViewBlock = {[weak self] text in
                self?.remarkStr = text
            }
            bgScrollView.addSubview(remark)
        }
        
        
        //
        head2 = XHWLHeadView()
        head2.showText("来源详情：")
        head2.showTextColor = color_01f0ff
        bgScrollView.addSubview(head2)
        
        labelViewArray2 = NSMutableArray()
        for i in 0...dataAry2.count-1  {
            let menuModel :XHWLMenuModel = dataAry2[i] as! XHWLMenuModel
            let labelView: XHWLLabelView = XHWLLabelView()
            labelView.showText(leftText: menuModel.name, rightText:menuModel.content)
            labelView.contentTextAlign(NSTextAlignment.center)
            bgScrollView.addSubview(labelView)
            labelViewArray2.add(labelView)
        }
        
        head3 = XHWLHeadView()
        head3.showText("事件详情：")
        head3.showTextColor = color_01f0ff
        bgScrollView.addSubview(head3)
        
        labelViewArray3 = NSMutableArray()
        for i in 0...dataAry3.count-1  {
            let menuModel :XHWLMenuModel = dataAry3[i] as! XHWLMenuModel
            let labelView: XHWLLabelView = XHWLLabelView()
            labelView.showText(leftText: menuModel.name, rightText:menuModel.content)
            labelView.contentTextAlign(NSTextAlignment.center)
            bgScrollView.addSubview(labelView)
            labelViewArray3.add(labelView)
        }
        
        picture = XHWLPickPhotoView(frame: CGRect.zero, true)
//        picture.isShow = true
        if !(model.appComplaint.imgUrl is NSNull) {
            
            let array:NSArray = model.appComplaint.imgUrl.components(separatedBy: ",") as NSArray
            picture.onShowImgArray(array)
        }
        bgScrollView.addSubview(picture)
        
        if !isFinished {
            submitBtn = UIButton()
            submitBtn.setTitle("提交", for: UIControlState.normal)
            submitBtn.setTitleColor(color_09fbfe, for: UIControlState.normal)
            submitBtn.setBackgroundImage(UIImage(named:"btn_background"), for: UIControlState.normal)
            submitBtn.addTarget(self, action: #selector(submitClick), for: UIControlEvents.touchUpInside)
            self.addSubview(submitBtn)
        }

    }
    
    func submitClick() {
        self.submitBlock(self.remarkStr!)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        bgImage.frame = self.bounds
        var scHeight = self.bounds.size.height
        if !isFinished {
            scHeight = self.bounds.size.height-60
        }
        
        bgScrollView.frame = CGRect(x:0, y:0, width:self.bounds.size.width, height:scHeight)
        
        head1.frame = CGRect(x:10, y:20, width:self.bounds.size.width-20, height:20)
        pickPhoto.frame = CGRect(x:0, y:head1.frame.maxY+10, width:self.bounds.size.width, height:80)
        var height:CGFloat!
        if isFinished {
            for i in 0...labelViewArray1.count-1 {
                
                let labelView :XHWLLabelView = labelViewArray1[i] as! XHWLLabelView
                labelView.bounds = CGRect(x:0, y:0, width:self.bounds.size.width, height:25)
                labelView.center = CGPoint(x:self.frame.size.width/2.0, y:pickPhoto.frame.maxY+10+25/2.0+CGFloat(i*25))
                height = labelView.frame.maxY
            }
        } else {
            remark.frame = CGRect(x:0, y:pickPhoto.frame.maxY+10, width:self.bounds.size.width-20, height:80)
            height = remark.frame.maxY
        }
        
        head2.frame = CGRect(x:10, y:height+10, width:self.bounds.size.width-20, height:20)
        for i in 0...labelViewArray2.count-1 {
            
            let labelView :XHWLLabelView = labelViewArray2[i] as! XHWLLabelView
            labelView.bounds = CGRect(x:0, y:0, width:self.bounds.size.width, height:25)
            labelView.center = CGPoint(x:self.frame.size.width/2.0, y:head2.frame.maxY+10+25/2.0+CGFloat(i*25))
        }
        
        head3.frame = CGRect(x:10, y:head2.frame.maxY+20+CGFloat(labelViewArray2.count).multiplied(by:25), width:self.bounds.size.width-20, height:20)
        
        for i in 0...labelViewArray3.count-1 {
            
            let labelView :XHWLLabelView = labelViewArray3[i] as! XHWLLabelView
            labelView.bounds = CGRect(x:0, y:0, width:self.bounds.size.width, height:25)
            labelView.center = CGPoint(x:self.frame.size.width/2.0, y:head3.frame.maxY + 10 + 25/2.0 + CGFloat(i*25))
        }
        picture.frame = CGRect(x:0, y:head3.frame.maxY+5+CGFloat(labelViewArray3.count).multiplied(by:25), width:self.bounds.size.width-20, height:80)
        
        if !isFinished {
            submitBtn.bounds = CGRect(x:0, y:0, width:150, height:30)
            submitBtn.center = CGPoint(x:self.bounds.size.width/2.0, y:self.bounds.size.height-30)
            bgScrollView.contentSize = CGSize(width:0, height:picture.frame.maxY+80)
        } else {
            
            bgScrollView.contentSize = CGSize(width:0, height:picture.frame.maxY+80)
        }
    }
}
