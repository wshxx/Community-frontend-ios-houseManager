//
//  XHWLRemarkView.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/11.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLRemarkView: UIView , UITextViewDelegate {

    var titleL:UILabel!
    var textView:UITextView!
    var placeholderL:UILabel!
    var textViewBlock:(String)->(Void) = {param in }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    func setupView() {
        
        titleL = UILabel()
        titleL.textColor = UIColor.white
        titleL.font = font_14
        titleL.textAlignment = .right
        titleL.text = "业主认证："
        self.addSubview(titleL)
        
        textView = UITextView()
        textView.backgroundColor = UIColor.clear
        textView.tintColor = UIColor.white
        textView.textColor = UIColor.white
        textView.font = font_14
        textView.delegate = self
        self.addSubview(textView)
        
        placeholderL = UILabel()
        placeholderL.font = font_14
        placeholderL.backgroundColor = UIColor.clear
        placeholderL.textColor = UIColor.white.withAlphaComponent(0.5)
        self.addSubview(placeholderL)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
//        let size:CGSize = titleL.text!.boundingRect(with: CGSize(width:CGFloat(MAXFLOAT), height:30), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:titleL.font], context: nil).size
//        
//        titleL.frame = CGRect(x:10, y:0, width:size.width, height:30)
        titleL.frame = CGRect(x:0, y:0, width:80, height:30)
        textView.frame = CGRect(x:titleL.frame.maxX+10, y:10, width:self.bounds.size.width-titleL.frame.maxX-20, height:self.bounds.size.height-20)
        let imgIV:UIImageView = UIImageView.init(frame: CGRect(x:0, y:0, width:textView.frame.size.width, height:textView.frame.size.height))
        imgIV.image = UIImage(named:"safeGuard_remark")
        textView.addSubview(imgIV)
        
        placeholderL.frame = CGRect(x:titleL.frame.maxX+12, y:12, width:self.bounds.size.width-titleL.frame.maxX-50, height:30)
    }
    
    func showText(_ leftText:String) {
        titleL.text = "\(leftText):"

        placeholderL.text = "请输入\(leftText)"
//        let color:UIColor =
//        textView.attributedPlaceholder = NSAttributedString.init(string: "请输入\(leftText)", attributes: [NSForegroundColorAttributeName: color])
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text == "" {
            let placeStr:NSString = "请输入\(titleL.text!)" as NSString
             placeholderL.text = placeStr.substring(to: placeStr.length-1) as String
            placeholderL.isHidden = false
        } else {
            placeholderL.isHidden = true
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.textViewBlock(textView.text)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
