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
    var addPictureBlock:(NSInteger, NSInteger)->(Void) = {param in } // 是否添加，对应哪张图切换， 对应哪张是否是添加
    var imgIVArray:NSMutableArray!
    var selectImg:XHWLImageBtn!
    var isShow:Bool!
    var isBundle:Bool! = false
    var isVideo:Bool = false
    
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
                    let imgV:UIView = imgIVArray[i] as! UIView
//                    let imgV:MicroVideoPlayView = imgIVArray[i] as! MicroVideoPlayView
//                    let imgV:UIImageView = imgIVArray[i] as! UIImageView
                    imgV.frame = CGRect(x:orginX+10, y:titleL.frame.maxY+5, width:60, height:60)
                    orginX = imgV.frame.maxX
                }
            }
        } else {
            if imgIVArray.count > 0 {
                for i in 0...imgIVArray.count-1 {
                    let imgV:UIView = imgIVArray[i] as! UIView
//                    let imgV:MicroVideoPlayView = imgIVArray[i] as! MicroVideoPlayView
//                    let imgV:XHWLImageBtn = imgIVArray[i] as! XHWLImageBtn
                    //                let imgV:UIImageView = imgIVArray[i] as! UIImageView
                    imgV.frame = CGRect(x:orginX+10, y:titleL.frame.maxY+5, width:60, height:60)
//                    imgV.frame = CGRect(x:orginX+10, y:titleL.frame.maxY+5, width:self.bounds.size.height-20, height:self.bounds.size.height-titleL.frame.maxY)
                    orginX = imgV.frame.maxX
                }
            }
            
            if isVideo && imgIVArray.count >= 1 || !isVideo && imgIVArray.count >= 3  {
                addBtn.isHidden = true
            } else {
                addBtn.isHidden = false
            }
//             addBtn.frame = CGRect(x:orginX+10, y:titleL.frame.maxY+5, width:self.bounds.size.height-20, height:self.bounds.size.height-titleL.frame.maxY)
            addBtn.frame = CGRect(x:orginX+10, y:titleL.frame.maxY+5, width:60, height:60)
        }
        
    }
    
    // 上传图片或视频
    func onCreateImgView(_ url:String, _ isVideo:Bool) {
        print("\(imgIVArray.count), \(imgIVArray)")
       
        self.isVideo = isVideo
        if !isVideo && imgIVArray.count < 3 || isVideo && imgIVArray.count < 1 { // 显示图片
            let imgV:XHWLImageBtn = XHWLImageBtn.init(frame: CGRect.zero, isVideo, false)
            imgV.setContentUrl(url)
            imgV.tag = comTag+imgIVArray.count
            // 删除图片
            imgV.deleteImageBlock = { [weak imgV] _ in
                self.addPictureBlock((imgV?.tag)!-comTag, self.imgIVArray.count) // 是否添加
                self.imgIVArray.remove(imgV)
                imgV?.removeFromSuperview()
            }
            self.addSubview(imgV)
            imgIVArray.add(imgV)
        }
    }
    
    // 显示链接图片或视频
    func showImgOrVideoArray(_ array:NSArray) {
        
        imgIVArray = NSMutableArray()
        var num:NSInteger = array.count
        if array.count > 3 {
            num = 3
        }
        for i in 0..<num {
            let url:String = array[i] as! String
            let array:NSArray = url.components(separatedBy: ".") as NSArray
            var isVideo = true
            if (array.lastObject as! String) == "png" {
                isVideo = false
            }
            let imgV:XHWLImageBtn = XHWLImageBtn.init(frame: CGRect.zero, isVideo, true)
            imgV.setContentUrl(url)
            imgV.tag = comTag+imgIVArray.count
            self.addSubview(imgV)
            imgIVArray.add(imgV)
            
            
//            imgV.isUserInteractionEnabled = true
//            let tap:UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(onScaleImg(_:)))
//            imgV.addGestureRecognizer(tap)
            
//            if isBundle == false {
//                let urlStr = "\(XHWLHttpURL)/\(array[i] as! String)"
//                let url = URL(string: urlStr)
//                //                imgV.kf.setImage(with: url)
//                imgV.kf.setImage(with: url, placeholder: UIImage(named:"default_icon"), options: nil, progressBlock: nil, completionHandler: nil)
//                self.addSubview(imgV)
//                imgIVArray.add(imgV)
//            } else {
//                imgV.image = UIImage(named:"IMG_\(i)")
//                self.addSubview(imgV)
//                imgIVArray.add(imgV)
//            }
        }
    }
    
     // 显示ben di图片或视频
    func onShowImgArray(_ array:NSArray) {
        
        imgIVArray = NSMutableArray()
        var num:NSInteger = array.count
        if array.count > 3 {
            num = 3
        }
        for i in 0..<num {
            let imgV:UIImageView = UIImageView()
            imgV.isUserInteractionEnabled = true
            let tap:UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(onScaleImg(_:)))
            imgV.addGestureRecognizer(tap)
            
            if isBundle == false {
                let urlStr = "\(XHWLHttpURL)/\(array[i] as! String)"
                let url = URL(string: urlStr)
//                imgV.kf.setImage(with: url)
                imgV.kf.setImage(with: url, placeholder: UIImage(named:"default_icon"), options: nil, progressBlock: nil, completionHandler: nil)
                self.addSubview(imgV)
                imgIVArray.add(imgV)
            } else {
                imgV.image = UIImage(named:"IMG_\(i)")
                self.addSubview(imgV)
                imgIVArray.add(imgV)
            }
        }
    }
    
    // 放大图片
    func onScaleImg(_ tap:UITapGestureRecognizer) {
        let views:UIImageView = tap.view as! UIImageView
        
        XHWLImageScale.scanBigImage(with: views, alpha: 1.0)
    }
    
    // 添加图片
    func onAddClick() {
        
        self.addPictureBlock(-1, imgIVArray.count)
    }
    
    func showText(_ leftText:String) {
        titleL.text = leftText
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
