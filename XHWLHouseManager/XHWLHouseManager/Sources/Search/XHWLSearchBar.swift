//
//  XHWLSearchBar.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/5.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

@objc protocol XHWLSearchBarDelegate: NSObjectProtocol {
    
    func searchBarCancelButtonClicked(searchBar:XHWLSearchBar)
    func searchBarTextDidBeginEditing(searchBar:XHWLSearchBar)
    func searchBarSearchButtonClicked(searchBar:XHWLSearchBar)
}

class XHWLSearchBar: UIView, UITextFieldDelegate {

    var imgV: UIImageView!
    var searchBar:UIView!
    var cancelButton:UIButton!
    var searchTextField:UITextField!
    weak var delegate:XHWLSearchBarDelegate?
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        let horizontalPadding:CGFloat = 15
        let verticalPadding:CGFloat = 5
        
        //_searchBar
        searchBar = UIView.init(frame: self.bounds)
        searchBar.backgroundColor = UIColor.clear
        self.addSubview(searchBar)
        
        let tSize:CGSize  = "取消".boundingRect(with: CGSize(width:120, height:searchBar.frame.size.height), options: NSStringDrawingOptions.usesFontLeading, attributes: [NSFontAttributeName:font_14], context: nil).size
        // 取消
        cancelButton = UIButton.init(frame: CGRect(x:searchBar.frame.size.width-tSize.width-horizontalPadding, y:verticalPadding, width:tSize.width, height:36))
        cancelButton.setTitle("取消", for: UIControlState.normal)
        cancelButton.setTitleColor(UIColor.orange, for: UIControlState.normal)
        cancelButton.titleLabel?.font = font_14
        cancelButton.addTarget(self, action: #selector(cancelClick), for: UIControlEvents.touchUpInside)
        self.addSubview(cancelButton)
        
        // 输入框
        searchTextField = UITextField.init(frame: CGRect(x:horizontalPadding, y:verticalPadding, width:self.frame.size.width - horizontalPadding * 3-tSize.width, height:self.frame.size.height - verticalPadding * 2))
        searchTextField.autoresizingMask = UIViewAutoresizing.flexibleWidth
        searchTextField.font = font_14
        searchTextField.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        searchTextField.delegate = self;
        searchTextField.layer.borderColor = UIColor.black.cgColor
        searchTextField.layer.borderWidth = 0.65
        searchTextField.returnKeyType =  UIReturnKeyType.send
        searchTextField.enablesReturnKeyAutomatically = true // UITextView内部判断send按钮是否可以用
        
        let leftV: UIView = UIView.init(frame: CGRect(x:0, y:0, width:36, height:searchTextField.frame.size.height))
        imgV = UIImageView.init(frame: CGRect(x:8, y:9, width:17, height:17))
        imgV.image = UIImage(named:"sousuo")
        leftV.addSubview(imgV)
        searchTextField.leftView = leftV
        searchTextField.leftViewMode = UITextFieldViewMode.always
        searchBar.addSubview(searchTextField)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var placeholder:String
    {
        get {
            return self.placeholder
        }
        set(newValue) {
            searchTextField.placeholder = newValue
        }
    }
    
    var font:UIFont
    {
        get {
            return self.font
        }
        set(newValue) {
            searchTextField.font = newValue
        }
    }

    var textColor:UIColor
    {
        get {
            return self.textColor
        }
        set(newValue) {
            searchTextField.textColor = newValue
            searchTextField.setValue(newValue, forKeyPath:"_placeholderLabel.textColor")
        }
    }
    
    var clearButtonMode:UITextFieldViewMode
    {
        get {
            return self.clearButtonMode
        }
        set(newValue) {
            searchTextField.clearButtonMode = newValue
        }
    }

    var leftImage:UIImage
    {
        get {
            return self.leftImage
        }
        set(newValue) {
            imgV.image = newValue
        }
    }
    
    var tintBarColor:UIColor
    {
        get {
            return self.tintBarColor
        }
        set(newValue) {
            searchBar.backgroundColor = newValue
        }
    }
    
    var textFieldBgColor:UIColor
    {
        get {
            return self.textFieldBgColor
        }
        set(newValue) {
            searchTextField.backgroundColor = newValue
        }
    }
    
    var borderColor:UIColor
    {
        get {
            return self.borderColor
        }
        set(newValue) {
            searchTextField.layer.borderColor = newValue.cgColor
        }
    }
    
    var cancelText:String
    {
        get {
            return self.cancelText
        }
        set(newValue) {
            cancelButton.setTitle(newValue, for: UIControlState.normal)
        }
    }
    
    var cancelColor:UIColor
    {
        get {
            return self.cancelColor
        }
        set(newValue) {
            cancelButton.setTitleColor(newValue, for: UIControlState.normal)
        }
    }
    
    // 点击取消
    func cancelClick()
    {
        
//        if self.delegate?.responds(to: #selector(searchBarCancelButtonClicked)) {
        self.delegate?.searchBarCancelButtonClicked(searchBar:self)
//        }
    }

//    #pragma mark - UITextFieldDelegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
//        if self.delegate?.responds(to: #selector(searchBarCancelButtonClicked)) {
        self.delegate?.searchBarTextDidBeginEditing(searchBar:self)
//        }
        
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
        
        self.delegate?.searchBarTextDidBeginEditing(searchBar: self)
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.compare("\n").rawValue == 0 {
           
            self.delegate?.searchBarSearchButtonClicked(searchBar: self)
            
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        if ([self.delegate respondsToSelector:@selector(searchBarSearchButtonClicked:)]) {
        
        self.delegate?.searchBarSearchButtonClicked(searchBar: self)
//        }
        return true
    }
    
    //  默认高度
    class func defaultHeight()->CGFloat {
         return 5 * 2 + 36
    }
}
