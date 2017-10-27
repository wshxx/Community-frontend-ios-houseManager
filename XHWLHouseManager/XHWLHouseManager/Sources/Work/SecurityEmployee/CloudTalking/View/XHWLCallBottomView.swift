//
//  XHWLCallBottomView.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/10/21.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

protocol XHWLCallBottomViewDelegate:NSObjectProtocol {
    func callBottomViewWithCancel(_ bottomView:XHWLCallBottomView)
    func callBottomViewWithFreeHand(_ bottomView:XHWLCallBottomView)
}

class XHWLCallBottomView: UIView {
    
    weak var delegate:XHWLCallBottomViewDelegate?
    var receiveType:XHWLCallType = .calling { // 是否接通
        willSet {
            if newValue == .calling {
                self.freehandBtn.isHidden = true
                self.cancelBtn.bounds = CGRect(x:0, y:0, width:72, height:self.bounds.size.height)
                self.cancelBtn.center = CGPoint(x:self.bounds.size.width/2.0, y:self.bounds.size.height/2.0)
                self.cancelBtn.setImage(UIImage(named:"cloudTalking_cancel"), for: .normal)
            } else if newValue == .receive {
                self.cancelBtn.bounds = CGRect(x:0, y:0, width:72, height:self.bounds.size.height)
                self.cancelBtn.center = CGPoint(x:self.bounds.size.width/2.0-72, y:self.bounds.size.height/2.0)
                self.cancelBtn.setImage(UIImage(named:"cloudTalking_off"), for: .normal)
                
                self.freehandBtn.isHidden = true
//                self.freehandBtn.bounds = CGRect(x:0, y:0, width:72, height:self.bounds.size.height)
//                self.freehandBtn.center = CGPoint(x:self.bounds.size.width/2.0+72, y:self.bounds.size.height/2.0)
//                self.freehandBtn.setImage(UIImage(named:"cloudTalking_freeHand"), for: .normal)
            } else {
                
                self.freehandBtn.isHidden = true
                self.cancelBtn.bounds = CGRect(x:0, y:0, width:72, height:self.bounds.size.height)
                self.cancelBtn.center = CGPoint(x:self.bounds.size.width/2.0, y:self.bounds.size.height/2.0)
                self.cancelBtn.setImage(UIImage(named:"cloudTalking_cancel"), for: .normal)
            }
        }
    }
    
    lazy fileprivate var cancelBtn:UIButton = {
        let btn:UIButton = UIButton()
        btn.setImage(UIImage(named:"cloudTalking_cancel"), for: .normal)
        btn.addTarget(self, action: #selector(onCancelClick), for: .touchUpInside)
        self.addSubview(btn)
        
        return btn
    }()
    
    lazy fileprivate var freehandBtn:UIButton = {
        let btn:UIButton = UIButton()
        btn.setImage(UIImage(named:"cloudTalking_freeHand"), for: .normal)
        btn.addTarget(self, action: #selector(onFreeHandClick), for: .touchUpInside)
        self.addSubview(btn)
        
        return btn
    }()
    
    func onCancelClick() {
        self.delegate?.callBottomViewWithCancel(self)
    }
    
    func onFreeHandClick() {
        self.delegate?.callBottomViewWithFreeHand(self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        self.cancelBtn.isHidden = false
        
        calateRect()
    }
    
    func calateRect() {
        if receiveType == .calling {
            self.cancelBtn.bounds = CGRect(x:0, y:0, width:72, height:self.bounds.size.height)
            self.cancelBtn.center = CGPoint(x:self.bounds.size.width/2.0, y:self.bounds.size.height/2.0)
        } else if receiveType == .receive {
            self.cancelBtn.bounds = CGRect(x:0, y:0, width:72, height:self.bounds.size.height)
            self.cancelBtn.center = CGPoint(x:self.bounds.size.width/2.0-72, y:self.bounds.size.height/2.0)
            
            self.freehandBtn.bounds = CGRect(x:0, y:0, width:72, height:self.bounds.size.height)
            self.freehandBtn.center = CGPoint(x:self.bounds.size.width/2.0+72, y:self.bounds.size.height/2.0)
        } else {
            
            self.cancelBtn.bounds = CGRect(x:0, y:0, width:72, height:self.bounds.size.height)
            self.cancelBtn.center = CGPoint(x:self.bounds.size.width/2.0, y:self.bounds.size.height/2.0)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        calateRect()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
