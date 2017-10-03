//
//  XHWLMenuLineView.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/10/3.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLMenuLineView: UIView {

    var labelBgIV:UIImageView!
    var titleL:UILabel!
    var contentTF:UILabel!
    
    var isShowEdit:Bool! = false
    var isHiddenEdit:Bool! = false
    var delegate:XHWLMenuLabelViewDelegate?
    var onOKClickBlock : (String, ((Bool) -> ())) -> () = {param in }
    var contentStr:String?
    var isClickOk:Bool! = false

    init(frame: CGRect, _ isShowEdit:Bool) {
        super.init(frame: frame)

        self.isShowEdit = isShowEdit
        setupView()
    }

    func isHiddenImg() {

        labelBgIV.isHidden = true
    }

    func setupView() {
        labelBgIV = UIImageView()
        labelBgIV.image = UIImage(named:"menu_text_bg")
        self.addSubview(labelBgIV)

        titleL = UILabel()
        titleL.textColor = UIColor.white
        titleL.font = font_14
        self.addSubview(titleL)

        contentTF = UILabel()
        contentTF.font = font_14
        contentTF.textColor = UIColor.white
        contentTF.backgroundColor = UIColor.clear
//        contentTF.textAlignment = NSTextAlignment.left
        contentTF.numberOfLines = 0
        contentTF.textAlignment = NSTextAlignment(rawValue: 7)!
        contentTF.tintColor = color_c8e5f0
        self.addSubview(contentTF)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        labelBgIV.frame = self.bounds

        let size:CGSize = titleL.text!.boundingRect(with: CGSize(width:CGFloat(MAXFLOAT), height:30), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:titleL.font], context: nil).size

//        titleL.frame = CGRect(x:5, y:0, width:size.width, height:30)
//        if isShowEdit {
//            contentTF.frame = CGRect(x: titleL.frame.maxX+10, y: 2, width: 100, height: 26)
//        } else {
//            contentTF.frame = CGRect(x: titleL.frame.maxX+10, y: 2, width: self.bounds.size.width-titleL.frame.maxX-20, height: 26)
//        }
        
        titleL.frame = CGRect(x:5, y:(30-font_14.lineHeight)/2.0, width:size.width, height:font_14.lineHeight)
        
        let sizeR:CGSize = contentTF.text!.boundingRect(with: CGSize(width:self.bounds.size.width-titleL.frame.maxX-15, height:CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:font_14], context: nil).size
        contentTF.frame = CGRect(x: titleL.frame.maxX+10, y: (30-font_14.lineHeight)/2.0, width: self.bounds.size.width-titleL.frame.maxX-15, height:sizeR.height)
    }

    func showText(leftText:String, rightText:String, isHiddenEdit:Bool) {
        titleL.text = leftText
        contentTF.text = rightText
        contentStr = rightText
//        if isShowEdit {
////            rightBtn.isHidden = isHiddenEdit
//            //        okBtn.isHidden = isHiddenEdit
//        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
