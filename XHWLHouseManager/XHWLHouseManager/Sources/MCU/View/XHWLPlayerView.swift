//
//  XHWLPlayerView.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/10/20.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

@objc protocol XHWLPlayerViewDelegate:NSObjectProtocol {
    @objc optional func playViewWithSwitchAV(_ playView:XHWLPlayerView)
//    @objc optional func playViewWithSwitchAV(_ playView:XHWLPlayerView)
//    @objc optional func playViewWithDelete(_ playView:XHWLPlayerView)
}

class XHWLPlayerView: UIView, XHWLMcuViewDelegate {

    var bgImage:UIImageView!
    var selectMcuView:XHWLMcuView!
    var playAry:NSMutableArray = NSMutableArray()
    weak var delegate:XHWLPlayerViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
        bgImage = UIImageView()
        bgImage.image = UIImage(named:"subview_bg")
        self.addSubview(bgImage)
        
        playAry = NSMutableArray()
        for i in 0..<2 {
            let orginX:CGFloat = 5
            let orginY:CGFloat = CGFloat(i*200+30)
            let width:CGFloat = self.bounds.size.width-10
            let height:CGFloat = 150.0
            
            let first = XHWLMcuView(frame:CGRect(x:orginX, y:orginY, width:width, height:height))
            first.delegate = self
            first.tag = comTag+i
            self.addSubview(first)
            playAry.add(first)
        }
    }
    
    func mcuViewWithTouch(_ mcuView:XHWLMcuView) {
        
        if mcuView == selectMcuView {
            return
        }
        
        // 选中 修改功能
        if selectMcuView != nil {
            selectMcuView.layer.borderColor = UIColor.clear.cgColor
            selectMcuView.layer.borderWidth = 0.5
            selectMcuView.isHiddenTool = true
        }
        
        selectMcuView = mcuView
        selectMcuView.layer.borderColor = UIColor().colorWithHexString(colorStr: "#ffff00").cgColor
        selectMcuView.layer.borderWidth = 2.0
    }
    
    func mcuViewWithSwitchAV(_ mcuView:XHWLMcuView) {
        
        self.delegate?.playViewWithSwitchAV!(self)
    }
    
    func mcuViewWithDelete(_ mcuView:XHWLMcuView) {
        
        playAry.remove(mcuView)
        mcuView.removeFromSuperview()
        self.setNeedsDisplay()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bgImage.frame = self.bounds
        
        for i in 0..<playAry.count {
            let orginX:CGFloat = 5
            let orginY:CGFloat = CGFloat(i*200+30)
            let width:CGFloat = self.bounds.size.width-10
            let height:CGFloat = 150.0
            
            let first:XHWLMcuView = playAry[i] as! XHWLMcuView
            first.frame = CGRect(x:orginX, y:orginY, width:width, height:height)
        }
    }
}
