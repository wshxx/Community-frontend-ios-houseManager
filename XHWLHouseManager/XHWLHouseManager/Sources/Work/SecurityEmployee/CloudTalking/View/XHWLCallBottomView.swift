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
}

class XHWLCallBottomView: UIView {
    
    weak var delegate:XHWLCallBottomViewDelegate?
    var receiveType:XHWLCallType = .calling { // 是否接通
        willSet {
            if newValue == .receive {
                self.cancelBtn.setImage(UIImage(named:"cloudTalking_off"), for: .normal)
            } else {
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
    
    func onCancelClick() {
        self.delegate?.callBottomViewWithCancel(self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        self.cancelBtn.isHidden = false
        
        calateRect()
    }
    
    func calateRect() {
        
        self.cancelBtn.bounds = CGRect(x:0, y:0, width:72, height:self.bounds.size.height)
        self.cancelBtn.center = CGPoint(x:self.bounds.size.width/2.0, y:self.bounds.size.height/2.0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        calateRect()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
