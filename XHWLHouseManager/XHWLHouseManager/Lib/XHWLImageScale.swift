//
//  XHWLImageScale.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/10/7.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLImageScale: NSObject {

    //原始尺寸
    static var oldframe:CGRect = CGRect.zero
    
    /**
     *  浏览大图
     *
     *  @param currentImageview 当前图片
     *  @param alpha            背景透明度
     */
    static func scanBigImage(with currentImageview:UIImageView, alpha:CGFloat) {
        
        //  当前imageview的图片
        let image:UIImage = currentImageview.image!
        //  当前视图
        let window:UIWindow = UIApplication.shared.keyWindow!
        //  背景
        let backgroundView:UIView = UIView.init(frame: CGRect(x:0, y:0, width:Screen_width, height:Screen_height))
        //  当前imageview的原始尺寸->将像素currentImageview.bounds由currentImageview.bounds所在视图转换到目标视图window中，返回在目标视图window中的像素值
        oldframe = currentImageview.convert(currentImageview.bounds, to: window)
       
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(alpha)
        //  此时视图不会显示
        backgroundView.alpha = 0
        //  将所展示的imageView重新绘制在Window中
        let imageView:UIImageView = UIImageView.init(frame: oldframe)
        imageView.image = image
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        imageView.tag = 1024
        backgroundView.addSubview(imageView)
        //  将原始视图添加到背景视图中
        window.addSubview(backgroundView)
        
        
        //  添加点击事件同样是类方法 -> 作用是再次点击回到初始大小
        let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(hideImageView(_:)))
        backgroundView.addGestureRecognizer(tapGestureRecognizer)
        
        //  动画放大所展示的ImageView
        UIView.animate(withDuration: 0.4,
                       animations: {
                        let y,width,height:CGFloat
                        y = (Screen_height - image.size.height * Screen_width / image.size.width) * 0.5
                        //宽度为屏幕宽度
                        width = Screen_width
                        //高度 根据图片宽高比设置
                        height = image.size.height * Screen_width / image.size.width
                        imageView.frame = CGRect(x:0, y:y, width:width, height:height)
                        //重要！ 将视图显示出来
                        backgroundView.alpha = 1
        })
    }
    
    /**
     *  恢复imageView原始尺寸
     *
     *  @param tap 点击事件
     */
    static func hideImageView(_ tap:UITapGestureRecognizer) {
        
        let backgroundView:UIView = tap.view!
        //  原始imageview
        let imageView:UIImageView = tap.view?.viewWithTag(1024) as! UIImageView
        //  恢复
        UIView.animate(withDuration: 0.4,
                       animations: {
                        imageView.frame = oldframe
                        backgroundView.alpha = 0
        }) { (finished) in
            backgroundView.removeFromSuperview()
        }
    }
}
