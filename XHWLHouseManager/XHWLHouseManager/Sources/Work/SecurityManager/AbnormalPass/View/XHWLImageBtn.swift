//
//  XHWLImageBtn.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/12.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLImageBtn: UIView {

    var imageIV:UIButton!
    var deleIV:UIButton!
    var deleteBlock:()->(Void) = { param in }
    var selectImgBlock:()->(Void) = { param in }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    func setupView() {
        
        imageIV = UIButton()
        imageIV.addTarget(self, action: #selector(onSelectIamge), for: UIControlEvents.touchUpInside)
        self.addSubview(imageIV)
        
        deleIV = UIButton()
        deleIV.setImage(UIImage(named:"login_textfield_clear"), for: UIControlState.normal)
        deleIV.addTarget(self, action: #selector(onDelete), for: UIControlEvents.touchUpInside)
        self.addSubview(deleIV)
    }
    
    func onDelete() {
        self.deleteBlock()
    }
    func onSelectIamge() {
        self.selectImgBlock()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageIV.frame = CGRect(x:0, y:10, width:self.bounds.size.width-10, height:self.bounds.size.height-10)
        
        deleIV.frame = CGRect(x:0, y:0, width:10, height:10)
        deleIV.center = CGPoint(x:self.bounds.size.width-10, y:10)
    }
    
    func setImage(_ image:UIImage) {
        imageIV.setImage(image, for: UIControlState.normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
