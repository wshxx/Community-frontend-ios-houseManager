//
//  XHWLPickPhotoView.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/11.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLPickPhotoView: UIView {

    var titleL:UILabel!
    var addBtn:UIButton!
    var addPictureBlock:(Bool)->(Void) = {param in }
    var imgIVArray:NSMutableArray!
    var selectImg:XHWLImageBtn!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imgIVArray = NSMutableArray()
        
        setupView()
    }
    
    func setupView() {
        
        titleL = UILabel()
        titleL.textColor = UIColor.white
        titleL.font = font_12
        titleL.textAlignment = NSTextAlignment.left
        titleL.text = "现场照片："
        self.addSubview(titleL)
        
        addBtn = UIButton()
        addBtn.setImage(UIImage(named:"safeGuard_add"), for: UIControlState.normal)
        addBtn.setBackgroundImage(UIImage(named:"safeGuard_add_bg"), for: UIControlState.normal)
        addBtn.addTarget(self, action: #selector(onAddClick), for: UIControlEvents.touchUpInside)
        self.addSubview(addBtn)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        let size:CGSize = titleL.text!.boundingRect(with: CGSize(width:CGFloat(MAXFLOAT), height:25), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:titleL.font], context: nil).size
        
        titleL.frame = CGRect(x:10, y:0, width:size.width, height:25)
        
        var orginX = titleL.frame.maxX
        
        if imgIVArray.count > 0 {
            for i in 0...imgIVArray.count-1 {
                let imgV:XHWLImageBtn = imgIVArray[i] as! XHWLImageBtn
//                let imgV:UIImageView = imgIVArray[i] as! UIImageView
                imgV.frame = CGRect(x:orginX+10, y:10, width:self.bounds.size.height-20, height:self.bounds.size.height-20)
                orginX = imgV.frame.maxX
            }
        }
        if imgIVArray.count >= 3 {
            addBtn.isHidden = true
        } else {
            addBtn.isHidden = false
        }
        addBtn.frame = CGRect(x:orginX+10, y:10, width:self.bounds.size.height-20, height:self.bounds.size.height-20)
    }
    
    func onCreateImgView(_ image:UIImage) {
        print("\(imgIVArray.count), \(imgIVArray)")
        if imgIVArray.count < 3 {
            let imgV:XHWLImageBtn = XHWLImageBtn()
            imgV.setImage(image)
            imgV.deleteBlock = { [weak imgV] _ in
                //                self.addPictureBlock()
                self.imgIVArray.remove(imgV)
                imgV?.removeFromSuperview()
            }
            imgV.selectImgBlock = { _ in
                self.selectImg = imgV
                self.addPictureBlock(false)
            }
            self.addSubview(imgV)
            imgIVArray.add(imgV)
        }
    }
    
    func onChangePicture(_ image:UIImage) {
        self.selectImg.setImage(image)
    }
    
    func onAddClick() {
        
        self.addPictureBlock(true)
    }
    
//    func createBtn() {
//        var btn:
//    }
    
    func showText(_ leftText:String) {
        titleL.text = leftText
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
