//
//  XHWLSafeGuardDetailView.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/11.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

@objc protocol XHWLSafeGuardViewDelegate:NSObjectProtocol {
    @objc optional func onSafeGuard(_ isAdd:Bool, _ index:NSInteger)
}

class XHWLSafeGuardView: UIView , XHWLNetworkDelegate{

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
    var code:String! // 单号
    var backReloadBlock:()->(Void) = {param in }
    
    var submitBtn:UIButton!
    
    init(frame: CGRect, _ isFinished:Bool, _ code:String) {
        super.init(frame: frame)
        
        self.isFinished = isFinished
        self.code = code
        dataAry1 = NSMutableArray()
        let array1 :NSArray = [["name":"备注：", "content":"业主", "isHiddenEdit": false],
                               ["name":"处理人：", "content":"徐柳飞", "isHiddenEdit": true],
                               ["name":"处理时间：", "content":"2017.06.23 10:11:20", "isHiddenEdit":false]]
        dataAry1 = XHWLMenuModel.mj_objectArray(withKeyValuesArray: array1)
        
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
        bgImage.image = UIImage(named:"subview_bg")
        self.addSubview(bgImage)
        
        bgScrollView = UIScrollView()
        bgScrollView.showsVerticalScrollIndicator = false
        self.addSubview(bgScrollView)
        
        //
        head1 = XHWLHeadView()
        head1.showText("来源详情：")
        bgScrollView.addSubview(head1)
        
        pickPhoto = XHWLPickPhotoView()
        pickPhoto.showText("现场照片：")
        pickPhoto.isShow = isFinished // 显示
        pickPhoto.addPictureBlock = { isAdd, index in
            self.delegate?.onSafeGuard!(isAdd, index)
        }
        bgScrollView.addSubview(pickPhoto)
        
        if isFinished {
            labelViewArray1 = NSMutableArray()
            for i in 0...dataAry1.count-1  {
                let menuModel :XHWLMenuModel = dataAry1[i] as! XHWLMenuModel
                let labelView: XHWLLabelView = XHWLLabelView()
                labelView.showText(leftText: menuModel.name, rightText:menuModel.content)
                labelView.contentTextAlign(textAlignment: NSTextAlignment.center)
                bgScrollView.addSubview(labelView)
                labelViewArray2.add(labelView)
            }
        } else {
            remark = XHWLRemarkView()
            remark.showText("备注：")
            bgScrollView.addSubview(remark)
        }
        
        
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
        picture.isShow = true
        bgScrollView.addSubview(picture)
        
        if !isFinished {
            submitBtn = UIButton()
            submitBtn.setTitle("提交", for: UIControlState.normal)
            submitBtn.setTitleColor(color_09fbfe, for: UIControlState.normal)
            submitBtn.setBackgroundImage(UIImage(named:"btn_background"), for: UIControlState.normal)
            submitBtn.addTarget(self, action: #selector(submitClick), for: UIControlEvents.touchUpInside)
            bgScrollView.addSubview(submitBtn)
        }

    }
    
//     展示图片
//    func () {
//    
//    pickPhoto.onShowImgArray()
//    }
    
    func submitClick() {
        let data:NSData = UserDefaults.standard.object(forKey: "user") as! NSData
        let dict:NSDictionary = data.mj_JSONObject() as! NSDictionary
        let userModel:XHWLUserModel = XHWLUserModel.mj_object(withKeyValues: dict)
        
        let param = ["token": userModel.wyAccount.token,
                    "manageRemarks": "", // 否	处理备注
                    "code": self.code] // 是	工单号
        XHWLNetwork.shared.postSafeGuardSubmitClick(param as NSDictionary , self)
    }
    
    // MARK: - XHWLNetworkDelegate
    
    func requestSuccess(_ requestKey:NSInteger, _ response:[String : AnyObject]) {
        
        if requestKey == XHWLRequestKeyID.XHWL_SAFEGUARDSUBMIT.rawValue {
            self.backReloadBlock()
        }
    }
    
    func requestFail(_ requestKey:NSInteger, _ error:NSError) {
        
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        bgImage.frame = self.bounds
        bgScrollView.frame = CGRect(x:0, y:0, width:self.bounds.size.width, height:self.bounds.size.height)
        
        head1.frame = CGRect(x:10, y:0, width:self.bounds.size.width-20, height:20)
        pickPhoto.frame = CGRect(x:10, y:head1.frame.maxY+10, width:self.bounds.size.width-20, height:80)
        var height:CGFloat!
        if isFinished {
            for i in 0...labelViewArray1.count-1 {
                
                let labelView :XHWLLabelView = labelViewArray1[i] as! XHWLLabelView
                labelView.bounds = CGRect(x:0, y:0, width:258, height:25)
                labelView.center = CGPoint(x:self.frame.size.width/2.0, y:pickPhoto.frame.maxY+10+CGFloat(i*25))
                height = labelView.frame.maxY
            }
        } else {
            remark.frame = CGRect(x:10, y:pickPhoto.frame.maxY+10, width:self.bounds.size.width-20, height:80)
            height = remark.frame.maxY
        }
        
        head2.frame = CGRect(x:10, y:height+10, width:self.bounds.size.width-20, height:20)
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
        
        if isFinished {
            submitBtn.bounds = CGRect(x:0, y:0, width:150, height:30)
            submitBtn.center = CGPoint(x:self.bounds.size.width/2.0, y:picture.frame.maxY+45)
        }
        bgScrollView.contentSize = CGSize(width:0, height:picture.frame.maxY+80)
    }
}
