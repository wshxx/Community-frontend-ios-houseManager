//
//  XHWLMapKitTopView.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/10/23.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

protocol XHWLMapKitTopViewDelegate:NSObjectProtocol {
    func mapKitViewWithSearch(_ topView:XHWLMapKitTopView, _ array:NSArray)
    func mapKitViewWithTrail(_ topView:XHWLMapKitTopView, _ array:NSArray)
}
class XHWLMapKitTopView: UIView , XHWLNetworkDelegate {

    var timeLeftView:XHWLTimeLeftView!
//    var timeRightView:XHWLTimeRightView!
    var personView:XHWLPersonView!
    var searchBtn:UIButton!
    var trailBtn:UIButton!
    var userId:String! = ""
    var startTime:String! = ""
    var selectTimeV:AnyObject!
    var isSearch:Bool = true
    weak var delegate:XHWLMapKitTopViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var personAry:NSArray = NSArray() {
        willSet {
            self.personView.personAry = newValue
        }
    }
    
    func setupView() {
        timeLeftView = XHWLTimeLeftView(frame: CGRect(x:20, y:20, width:self.bounds.size.width-140, height:30))
        timeLeftView.selectBlock = { startTime in
            self.startTime = startTime
//            self.timeRightView.minTime = startTime
        }
        self.addSubview(timeLeftView)
        
//        timeRightView = XHWLTimeRightView(frame: CGRect(x:self.bounds.size.width/2.0+30, y:20, width:self.bounds.size.width/2.0-20-30, height:30))
//        timeRightView.selectBlock = { endTime in
//            self.endTime = endTime
//            self.timeLeftView.maxTime = endTime
//        }
//        self.addSubview(timeRightView)

        trailBtn = UIButton()
        trailBtn.setTitleColor(UIColor.white, for: .normal)
        trailBtn.setTitle("轨迹回放", for: .normal)
        trailBtn.titleLabel?.font = font_14
        trailBtn.setBackgroundImage(UIImage(named:"Patrol_blue_bg"), for: .normal)
        trailBtn?.frame = CGRect(x:self.bounds.size.width-100, y:60, width:80, height:30)
        trailBtn.addTarget(self, action: #selector(onTrailClick), for: .touchUpInside)
        self.addSubview(trailBtn)
        
        searchBtn = UIButton()
        searchBtn.setTitleColor(UIColor.white, for: .normal)
        searchBtn.setTitle("查询", for: .normal)
        searchBtn.titleLabel?.font = font_14
        searchBtn.setBackgroundImage(UIImage(named:"Patrol_blue_bg"), for: .normal)
        searchBtn?.frame = CGRect(x:self.bounds.size.width-100, y:20, width:80, height:30)
        searchBtn.addTarget(self, action: #selector(onSearchClick), for: .touchUpInside)
        self.addSubview(searchBtn)
        
        personView = XHWLPersonView(frame: CGRect(x:20, y:60, width:self.bounds.size.width-140, height:30))
        personView.selectBlock = { userId in
            self.userId = userId
        }
        self.addSubview(personView)
    }
    
    func onSearchClick() {
        isSearch = true
        onSearch()
    }
    
    func onSearch() {
        if startTime.isEmpty {
            "请选择时间".ext_debugPrintAndHint()
            return
        }
        if userId.isEmpty {
            "请选择人员".ext_debugPrintAndHint()
            return
        }
        let data:NSData = UserDefaults.standard.object(forKey: "user") as! NSData
        let userModel:XHWLUserModel = XHWLUserModel.mj_object(withKeyValues: data.mj_JSONObject())
        
        //        let start = (startTime.substring(to: String.Index(10)) ) + "+" + (startTime.substring(from: String.Index(11)) ) + ":00"
        let start = (startTime.substring(to: String.Index(10)) ) + "+" + "00:00:00"
        let end = (startTime.substring(to: String.Index(10)) ) + "+" + "23:59:59"
        
        let param:NSArray = [userModel.wyAccount.token,
                             userId,
                             start,
                             end]
        XHWLNetwork.shared.getSearchPinClick(param, self)
    }
    
    func onTrailClick() {
        isSearch = false
        onSearch()
    }
    
    // MARK: - XHWLNetworkDelegate
    
    func requestSuccess(_ requestKey:NSInteger, _ response:[String : AnyObject]) {
        
        if requestKey == XHWLRequestKeyID.XHWL_SEARCHPIN.rawValue {
            if response["result"] is NSNull {
                return
            }
            let dict:NSDictionary = response["result"] as! NSDictionary
            var dealArray:NSArray = NSArray()
            if !(dict["trails"] is NSNull) {
                dealArray = XHWLMapKitModel.mj_objectArray(withKeyValuesArray:dict["trails"] as! NSArray)
            }

            if isSearch {
                self.delegate?.mapKitViewWithSearch(self, dealArray)
            } else {
                self.delegate?.mapKitViewWithTrail(self, dealArray)
            }
        }
    }
    
    func requestFail(_ requestKey: NSInteger, _ error: NSError) {
        
    }
    
}
