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

class XHWLSafeGuardDetailView: UIView , XHWLNetworkDelegate{

    var bgImage:UIImageView!
    var bgScrollView:UIScrollView!
    var dataAry:NSMutableArray!
    var labelViewArray:NSMutableArray!
    var cancelBtn:UIButton!
    var agreeBtn:UIButton!
    var backReloadBlock:()->() = {param in }
    var exceptionId:String! // 异常放行ID
    
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
        bgImage.image = UIImage(named:"subview_bg")
        self.addSubview(bgImage)
        
        bgScrollView = UIScrollView()
        bgScrollView.showsVerticalScrollIndicator = false
        self.addSubview(bgScrollView)
        
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
    
        agreeBtn = UIButton()
        agreeBtn.setTitle("同意", for: UIControlState.normal)
        agreeBtn.setTitleColor(color_09fbfe, for: UIControlState.normal)
        agreeBtn.tag = comTag
        agreeBtn.titleLabel?.font = font_12
        agreeBtn.setBackgroundImage(UIImage(named:"btn_background"), for: UIControlState.normal)
        agreeBtn.addTarget(self, action: #selector(submitClick), for: UIControlEvents.touchUpInside)
        self.addSubview(agreeBtn)
        
        cancelBtn = UIButton()
        cancelBtn.setTitle("过失", for: UIControlState.normal)
        cancelBtn.tag = comTag+1
        cancelBtn.titleLabel?.font = font_12
        cancelBtn.setTitleColor(color_09fbfe, for: UIControlState.normal)
        cancelBtn.setBackgroundImage(UIImage(named:"btn_background"), for: UIControlState.normal)
        cancelBtn.addTarget(self, action: #selector(submitClick), for: UIControlEvents.touchUpInside)
        self.addSubview(cancelBtn)
    }
    
    func submitClick(btn:UIButton) {
//        self.btnClickBlock(btn.tag-comTag)
        var status:String = "n"
        if btn.tag-comTag == 0 {
            status = "y"
        }
        
        let data:NSData = UserDefaults.standard.object(forKey: "user") as! NSData
        let userModel:XHWLUserModel = XHWLUserModel.mj_object(withKeyValues: data.mj_JSONObject())
        
        let param = ["token":userModel.wyAccount.token,
                     "exceptionId":self.exceptionId, // 异常记录Id
                     "status": status]//处理意见/状态（y：同意，n：过失）
        
        XHWLNetwork.shared.postHandleExceptionPassClick(param as NSDictionary, self)
    }
    
    // MARK: - XHWLNetworkDelegate
    
    func requestSuccess(_ requestKey:NSInteger, _ response:[String : AnyObject]) {
        
        if requestKey == XHWLRequestKeyID.XHWL_HANDLEEXCEPTIONPASS.rawValue {

            self.backReloadBlock()
        }
        
    }
    
    func requestFail(_ requestKey:NSInteger, _ error:NSError) {
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bgImage.frame = self.bounds
//        bgScrollView.frame = CGRect(x:0, y:titleL.frame.maxY, width:self.bounds.size.width, height:self.bounds.size.height-titleL.frame.maxY)
        var first:NSInteger = 0
        var second:NSInteger = 0
        var third:NSInteger = 0
        var height:CGFloat = 0
        
        if labelViewArray.count > 0 {
            for i in 0...labelViewArray.count-1 {
                
                let menuModel :XHWLMenuModel = dataAry[i] as! XHWLMenuModel
                if menuModel.type == 0 {
                    let labelView :XHWLLabelView = labelViewArray[i] as! XHWLLabelView
                    labelView.bounds = CGRect(x:0, y:0, width:258, height:25)
                    labelView.center = CGPoint(x:self.frame.size.width/2.0, y:5+10+CGFloat(first*25+second*25+third*80))
                    first += 1
                }
                else if menuModel.type == 1 {
                    let labelView :XHWLLabelView = labelViewArray[i] as! XHWLLabelView
                    labelView.bounds = CGRect(x:0, y:0, width:258, height:25)
                    labelView.center = CGPoint(x:self.frame.size.width/2.0, y:5+10+CGFloat(first*25+second*25+third*80))
                    second += 1
                }
                else if menuModel.type == 2 {
                    
                    let labelView :XHWLPickPhotoView = labelViewArray[i] as! XHWLPickPhotoView
                    labelView.frame = CGRect(x:(self.bounds.size.width-258)/2.0, y:5+CGFloat(first*25+second*25+third*80), width:80, height:80)
                    third += 1
                }
                
            }
            
            let lastView:UIView = labelViewArray.lastObject as! UIView
            height = lastView.frame.maxY
        }
        
        agreeBtn.bounds = CGRect(x:0, y:0, width:70, height:30)
        agreeBtn.center = CGPoint(x:80, y:height+45)
        
        cancelBtn.bounds = CGRect(x:0, y:0, width:70, height:30)
        cancelBtn.center = CGPoint(x:self.bounds.size.width-80, y:height+45)
        
//        bgScrollView.contentSize = CGSize(width:0, height:500)
    }
}
