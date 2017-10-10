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
            if !model.appComplaint.manageImgUrl.isEmpty {
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
                
                let labelView: XHWLLineView = XHWLLineView()
//                let labelView: XHWLLabelView = XHWLLabelView()
                labelView.showText(leftText: menuModel.name, rightText:menuModel.content)
//                labelView.textAlign = NSTextAlignment.center
                bgScrollView.addSubview(labelView)
                labelViewArray1.add(labelView)
            }
        } else {
            remark = XHWLRemarkView()
            remark.showText("备注")
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
//            let labelView: XHWLLabelView = XHWLLabelView()
            let labelView: XHWLLineView = XHWLLineView()
            labelView.showText(leftText: menuModel.name, rightText:menuModel.content)
//            labelView.textAlign = NSTextAlignment.center
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
//            let labelView: XHWLLabelView = XHWLLabelView()
            
            let labelView: XHWLLineView = XHWLLineView()
            labelView.showText(leftText: menuModel.name, rightText:menuModel.content)
//            labelView.textAlign = NSTextAlignment.center
            bgScrollView.addSubview(labelView)
            labelViewArray3.add(labelView)
        }
        
        picture = XHWLPickPhotoView(frame: CGRect.zero, true)
//        picture.isShow = true
        if !model.appComplaint.imgUrl.isEmpty {
            
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
        if isFinished {
            if !model.appComplaint.manageImgUrl.isEmpty {
                pickPhoto.frame = CGRect(x:15, y:head1.frame.maxY+10, width:self.bounds.size.width-30, height:80)
            } else {
                pickPhoto.frame = CGRect(x:15, y:head1.frame.maxY+10, width:self.bounds.size.width-30, height:25)
            }
        } else {
            pickPhoto.frame = CGRect(x:15, y:head1.frame.maxY+10, width:self.bounds.size.width-30, height:80)
        }
        
        var height:CGFloat! = pickPhoto.frame.maxY+5
        if isFinished {
            for i in 0...labelViewArray1.count-1 {
                
                let menuModel :XHWLMenuModel = dataAry1[i] as! XHWLMenuModel
                let size:CGSize = menuModel.content.boundingRect(with: CGSize(width:self.frame.size.width-30-100, height:CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:font_14], context: nil).size
                let labelH:CGFloat = size.height < font_14.lineHeight ? font_14.lineHeight:size.height
                let labelView:XHWLLineView = labelViewArray1[i] as! XHWLLineView
                labelView.frame = CGRect(x:5, y:Int(height + 10), width:Int(self.frame.size.width-10), height:Int(labelH))
                
                height = labelView.frame.maxY
            }
        } else {
            remark.frame = CGRect(x:0, y:pickPhoto.frame.maxY+10, width:self.bounds.size.width-20, height:80)
            height = remark.frame.maxY
        }
        
        head2.frame = CGRect(x:10, y:height+10, width:self.bounds.size.width-20, height:20)
        height = head2.frame.maxY
        
        for i in 0...labelViewArray2.count-1 {
            
            let menuModel :XHWLMenuModel = dataAry2[i] as! XHWLMenuModel
            let size:CGSize = menuModel.content.boundingRect(with: CGSize(width:self.frame.size.width-30-100, height:CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:font_14], context: nil).size
            let labelH:CGFloat = size.height < font_14.lineHeight ? font_14.lineHeight:size.height
            let labelView:XHWLLineView = labelViewArray2[i] as! XHWLLineView
            labelView.frame = CGRect(x:5, y:Int(height + 10), width:Int(self.frame.size.width-10), height:Int(labelH))
            
            height = labelView.frame.maxY
        }
        
        head3.frame = CGRect(x:10, y:height+10, width:self.bounds.size.width-20, height:20)
        
        height = head3.frame.maxY
        
        for i in 0...labelViewArray3.count-1 {

            let menuModel :XHWLMenuModel = dataAry3[i] as! XHWLMenuModel
            let size:CGSize = menuModel.content.boundingRect(with: CGSize(width:self.frame.size.width-30-100, height:CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:font_14], context: nil).size
            let labelH:CGFloat = size.height < font_14.lineHeight ? font_14.lineHeight:size.height
            let labelView:XHWLLineView = labelViewArray3[i] as! XHWLLineView
            labelView.frame = CGRect(x:5, y:Int(height + 10), width:Int(self.frame.size.width-10), height:Int(labelH))
            
            height = labelView.frame.maxY
        }
         if !model.appComplaint.imgUrl.isEmpty {
            picture.frame = CGRect(x:15, y:height+5, width:self.bounds.size.width-30, height:80)
        } else {
            picture.frame = CGRect(x:15, y:height+5, width:self.bounds.size.width-30, height:25)
        }
        if !isFinished {
            submitBtn.bounds = CGRect(x:0, y:0, width:150, height:30)
            submitBtn.center = CGPoint(x:self.bounds.size.width/2.0, y:self.bounds.size.height-30)
            bgScrollView.contentSize = CGSize(width:0, height:picture.frame.maxY+80)
        } else {
            
            bgScrollView.contentSize = CGSize(width:0, height:picture.frame.maxY+80)
        }
    }
}
