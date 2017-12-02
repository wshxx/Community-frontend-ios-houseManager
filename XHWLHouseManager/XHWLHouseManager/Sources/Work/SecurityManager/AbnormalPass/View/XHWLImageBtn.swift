//
//  XHWLImageBtn.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/12.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLImageBtn: UIView {

    var imageIV:UIImageView!
    var deleIV:UIButton!
    var videoView:MicroVideoPlayView!
    var deleteImageBlock:()->(Void) = { param in }
    var isVideo:Bool! = false
    var isShow:Bool = false

    init(frame: CGRect, _ isVideo:Bool, _ isShow:Bool) {
        super.init(frame: frame)
        
        setupView(isVideo, isShow)
    }
    
    func setupView(_ isVideo:Bool, _ isShow:Bool) {
        
        self.isVideo = isVideo
        self.isShow = isShow
        if isVideo {
            videoView = MicroVideoPlayView.init(frame: CGRect(x:0, y:10, width:50, height:50))
            self.addSubview(videoView)
        } else {
            imageIV = UIImageView()
            imageIV.isUserInteractionEnabled = true
            self.addSubview(imageIV)
            
            let tap:UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(onScaleImage))
            imageIV.addGestureRecognizer(tap)
        }

        if !isShow {
            deleIV = UIButton()
            deleIV.setImage(UIImage(named:"login_textfield_clear"), for: UIControlState.normal)
            deleIV.addTarget(self, action: #selector(onDeleteImage), for: UIControlEvents.touchUpInside)
            self.addSubview(deleIV)
        }
    }
    
    func onDeleteImage() {
        self.deleteImageBlock()
    }
    
    func onScaleImage(_ tap:UITapGestureRecognizer) {
        let views:UIImageView = tap.view as! UIImageView
        
        XHWLImageScale.scanBigImage(with: views, alpha: 1.0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !isShow {
            if isVideo {
                videoView.frame = CGRect(x:0, y:10, width:self.bounds.size.width-10, height:self.bounds.size.height-10)
            } else {
                imageIV.frame = CGRect(x:0, y:10, width:self.bounds.size.width-10, height:self.bounds.size.height-10)
            }
            
            deleIV.frame = CGRect(x:0, y:0, width:10, height:10)
            deleIV.center = CGPoint(x:self.bounds.size.width-10, y:10)
        } else {
            if isVideo {
                videoView.frame = CGRect(x:0, y:5, width:self.bounds.size.width-10, height:self.bounds.size.height-10)
            } else {
                imageIV.frame = CGRect(x:0, y:5, width:self.bounds.size.width-10, height:self.bounds.size.height-10)
            }
        }
    }
    
    func setContentUrl(_ url:String) {
        
        if isVideo {
            videoView.setContentUrl(url)
        } else {
            //            http://odum9helk.qnssl.com/resource/gogopher.jpg?imageView2/1/w/200/h/200
            let url = URL.init(string: "\(url)?imageView2/1/w/200/h/200")!
            guard let data = try? Data.init(contentsOf: url, options: Data.ReadingOptions.alwaysMapped) else {
                return
            }
            
            let image:UIImage = UIImage.init(data: data)!
            imageIV.image = image
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
