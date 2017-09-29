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
    var addPictureBlock:(Bool, NSInteger, Bool)->(Void) = {param in } // 是否添加，对应哪张图切换， 对应哪张是否是添加
    var imgIVArray:NSMutableArray!
    var selectImg:XHWLImageBtn!
    var isShow:Bool!
    var isBundle:Bool! = false
    
    init(frame: CGRect, _ isShow:Bool) {
        super.init(frame: frame)
        
        self.isShow = isShow
        imgIVArray = NSMutableArray()
        
        setupView()
    }
    
    func setupView() {
        
        titleL = UILabel()
        titleL.textColor = UIColor.white
        titleL.font = font_14
        titleL.textAlignment = .right
        titleL.text = "现场照片："
        self.addSubview(titleL)
        
        // 不是展示图片
        if !isShow {
            addBtn = UIButton()
            addBtn.setImage(UIImage(named:"safeGuard_add"), for: UIControlState.normal)
            //        addBtn.setBackgroundImage(UIImage(named:"safeGuard_add_bg"), for: UIControlState.normal)
            addBtn.addTarget(self, action: #selector(onAddClick), for: UIControlEvents.touchUpInside)
            self.addSubview(addBtn)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
//        let size:CGSize = titleL.text!.boundingRect(with: CGSize(width:CGFloat(MAXFLOAT), height:25), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:titleL.font], context: nil).size
//        
//        titleL.frame = CGRect(x:10, y:0, width:size.width, height:25)
        titleL.frame = CGRect(x:10, y:0, width:80, height:25)
        
        var orginX:CGFloat = 70
        if self.bounds.size.width-70<210 {
            orginX = self.bounds.size.width-210
        }
        
        if isShow {
            if imgIVArray.count > 0 {
                for i in 0...imgIVArray.count-1 {
                    let imgV:UIImageView = imgIVArray[i] as! UIImageView
//                    imgV.frame = CGRect(x:orginX+10, y:titleL.frame.maxY+5, width:self.bounds.size.height-20, height:self.bounds.size.height-titleL.frame.maxY)
                    imgV.frame = CGRect(x:orginX+10, y:titleL.frame.maxY+5, width:60, height:60)
                    orginX = imgV.frame.maxX
                }
            }
        } else {
            if imgIVArray.count > 0 {
                for i in 0...imgIVArray.count-1 {
                    let imgV:XHWLImageBtn = imgIVArray[i] as! XHWLImageBtn
                    //                let imgV:UIImageView = imgIVArray[i] as! UIImageView
                    imgV.frame = CGRect(x:orginX+10, y:titleL.frame.maxY+5, width:60, height:60)
//                    imgV.frame = CGRect(x:orginX+10, y:titleL.frame.maxY+5, width:self.bounds.size.height-20, height:self.bounds.size.height-titleL.frame.maxY)
                    orginX = imgV.frame.maxX
                }
            }
            if imgIVArray.count >= 3 {
                addBtn.isHidden = true
            } else {
                addBtn.isHidden = false
            }
//             addBtn.frame = CGRect(x:orginX+10, y:titleL.frame.maxY+5, width:self.bounds.size.height-20, height:self.bounds.size.height-titleL.frame.maxY)
            addBtn.frame = CGRect(x:orginX+10, y:titleL.frame.maxY+5, width:60, height:60)
        }
        
    }
    
    func onCreateImgView(_ image:UIImage) {
        print("\(imgIVArray.count), \(imgIVArray)")
        if imgIVArray.count < 3 {
            let imgV:XHWLImageBtn = XHWLImageBtn()
            imgV.setImage(image)
            imgV.tag = comTag+imgIVArray.count
            imgV.deleteBlock = { [weak imgV] _ in
                //                self.addPictureBlock()
                self.addPictureBlock(false, (imgV?.tag)!-comTag, false)
                self.imgIVArray.remove(imgV)
                imgV?.removeFromSuperview()
            }
            imgV.selectImgBlock = { _ in
                self.selectImg = imgV
                self.addPictureBlock(false, imgV.tag-comTag, true)
            }
            self.addSubview(imgV)
            imgIVArray.add(imgV)
        }
    }
    
    func onShowImgArray(_ array:NSArray) {
        
        imgIVArray = NSMutableArray()
        for i in 0..<array.count {
            let imgV:UIImageView = UIImageView()
            if isBundle == false {
                let urlStr = "\(XHWLImgURL)/\(array[i] as! String)"
                let url = URL(string: urlStr)
                imgV.kf.setImage(with: url)
                self.addSubview(imgV)
                imgIVArray.add(imgV)
            } else {
                imgV.image = UIImage(named:"3.jpg")
                self.addSubview(imgV)
                imgIVArray.add(imgV)
            }
        }
    }
    
    func onChangePicture(_ image:UIImage) {
        self.selectImg.setImage(image)
    }
    
    func onAddClick() {
        
        self.addPictureBlock(true, -1, true)
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
