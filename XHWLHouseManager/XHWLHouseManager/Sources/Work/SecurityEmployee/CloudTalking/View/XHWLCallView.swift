//
//  XHWLCallView.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/10/21.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

protocol XHWLCallViewDelegate:NSObjectProtocol {
    func callViewWithCancel(_ callView:XHWLCallView)
    func callViewWithFreeHand(_ callView:XHWLCallView)
}

enum XHWLCallType {
    case calling
    case receive
    case offline
}

class XHWLCallView: UIView , XHWLCallBottomViewDelegate {

    weak var delegate:XHWLCallViewDelegate?
    var receiveType:XHWLCallType = .calling { // 是否接通
        willSet {
            self.bottomView.receiveType = newValue
            if newValue == .offline {
                self.callNameL.isHidden = true
                self.showTipL.isHidden = true
                self.timerLabel.isHidden = true
                self.callNameL.text = ""
                self.showTipL.text = ""
                self.timerLabel.pause()
//                self.timerLabel.reset()
                
            } else if newValue == .receive {
                self.callNameL.isHidden = true
                self.showTipL.isHidden = true
                self.timerLabel.isHidden = false
//                self.callNameL.text = self.roomName
//                self.showTipL.text = "00:00"
                self.bringSubview(toFront: self.timerLabel)
                
                self.timerLabel.start()
                self.callSubView.createArray(array: dataAry)
                
                UIView.animate(withDuration: 0.3,
                               animations: {
                                self.callSubView.frame = CGRect(x:20, y:Screen_height*2/3.0, width:Screen_width-40, height:Screen_height/3.0)
                                self.bottomView.frame = CGRect(x:10, y:Screen_height*2/3.0-100, width:Screen_width-20, height:93)
                })
            } else {
                self.callNameL.isHidden = false
                self.showTipL.isHidden = false
                self.timerLabel.isHidden = true
//                self.bringSubview(toFront: self.callNameL)
            }
        }
    }
    
    var roomName:String! = "" {
        willSet {
            if roomName != nil {
                callNameL.text = newValue
            }
        }
    }
    
    lazy fileprivate var callSubView:XHWLCallSubView! = {
        
        let callView:XHWLCallSubView = XHWLCallSubView(frame:CGRect(x:20, y:Screen_height, width:Screen_width-40, height:0))
        self.addSubview(callView)
        return callView
    }()
    
    var dataAry:NSArray! = NSArray()
    
    lazy var remoteContainerView:UIView! = {
        let view:UIView = UIView()
        self.sendSubview(toBack: view)
        self.addSubview(view)
        
        return view
    }()
    
    lazy var localContainerView:UIView! = {
        let view:UIView = UIView()
        self.sendSubview(toBack: view)
        self.addSubview(view)
        
        return view
    }()
    
    lazy fileprivate var callNameL:UILabel = {
        let label:UILabel = UILabel()
        label.textColor = UIColor.white
        label.font = font_16
        label.text = "name"
        label.textAlignment = .center
        self.addSubview(label)
        
        return label
    }()
    
    lazy fileprivate var showTipL:UILabel = {
        let label:UILabel = UILabel()
        label.textColor = UIColor.white
        label.font = font_14
        label.textAlignment = .center
        label.text = "正在等待对方接受通话..."
        self.addSubview(label)
        
        return label
    }()
    
    lazy fileprivate var timerLabel:MZTimerLabel = {

        let timerLabel:MZTimerLabel = MZTimerLabel.init(frame:CGRect(x:0, y:155, width:self.frame.size.width , height: 40))
        timerLabel.timerType = MZTimerLabelTypeStopWatch
        timerLabel.timeLabel.backgroundColor = UIColor.clear
        timerLabel.timeLabel.font = font_16
        timerLabel.timeLabel.textColor = UIColor.white
        timerLabel.timeLabel.textAlignment = .center;
        timerLabel.isHidden = true
        self.addSubview(timerLabel)
        
        return timerLabel
    }()
    
    
    
    lazy fileprivate var bottomView:XHWLCallBottomView = {
        let bottomView:XHWLCallBottomView = XHWLCallBottomView(frame:CGRect(x:10, y:self.bounds.height-100, width:self.bounds.size.width-20, height:93))
        bottomView.delegate = self
        self.bringSubview(toFront: bottomView)
        self.addSubview(bottomView)
        
        return bottomView
    }()
    
    
    // MARK: - XHWLCallBottomViewDelegate
    
    func callBottomViewWithCancel(_ bottomView:XHWLCallBottomView) {
        self.delegate?.callViewWithCancel(self)
    }
    
    func callBottomViewWithFreeHand(_ bottomView:XHWLCallBottomView) {
        self.delegate?.callViewWithFreeHand(self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        
        setupView()
    }
    
    func setupView() {
        self.remoteContainerView.frame = self.bounds
        self.localContainerView.frame = CGRect(x:self.bounds.size.width-100, y:64, width:80, height:150)
        self.callNameL.frame = CGRect(x:10, y:self.bounds.size.height/2.0-20, width:self.bounds.size.width-20, height:30)
        
        self.timerLabel.frame = CGRect(x:10, y:self.bounds.size.height/2.0-30, width:self.bounds.size.width-20, height:30)
        self.showTipL.frame = CGRect(x:10, y:self.callNameL.frame.maxY+5, width:self.bounds.size.width-20, height:30)
        if self.receiveType == .receive {
            self.bottomView.frame = CGRect(x:10, y:self.bounds.height*2/3.0-100, width:self.bounds.size.width-20, height:93)
        } else {
            self.bottomView.frame = CGRect(x:10, y:self.bounds.height-100, width:self.bounds.size.width-20, height:93)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupView()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
