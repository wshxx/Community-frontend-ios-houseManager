//
//  AnimatedAnnotationView.swift
//  BMKSwiftDemo
//
//  Created by wzy on 15/11/5.
//  Copyright © 2015年 baidu. All rights reserved.
//

import UIKit

/*
*自定义BMKAnnotationView：动画AnnotationView
*/
class AnimatedAnnotationView: BMKAnnotationView {
    
//    var annotationImages: [UIImage]!
    var annotationImageView: UIImageView!
    
    override init(annotation: BMKAnnotation!, reuseIdentifier: String!) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        self.bounds = CGRect(x: 0, y: 0, width: 32, height: 32)
        self.backgroundColor = UIColor.clear
        self.centerOffset = CGPoint(x:0, y:0)
        self.isDraggable = false
        
        annotationImageView = UIImageView(frame: bounds)
        annotationImageView.contentMode = UIViewContentMode.center
        annotationImageView.image = UIImage(named: "pin")!
        
        self.addSubview(annotationImageView)

        let paoView = UIView()
        paoView.backgroundColor = UIColor.red
        paoView.frame = CGRect(x:0, y:0, width:20, height:20)
        
//        UIView *popView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth-100, popViewH)];
//        popView.backgroundColor = [UIColor whiteColor];
//        [popView.layer setMasksToBounds:YES];
//        [popView.layer setCornerRadius:3.0];
//        popView.alpha = 0.9;
        
        //自定义气泡的内容，添加子控件在popView上
//        UILabel *driverName = [[UILabel alloc]initWithFrame:CGRectMake(8, 4, 160, 30)];
//        driverName.text = annotation.title;
//        driverName.numberOfLines = 0;
//        driverName.backgroundColor = [UIColor clearColor];
//        driverName.font = [UIFont systemFontOfSize:15];
//        driverName.textColor = [UIColor blackColor];
//        driverName.textAlignment = NSTextAlignmentLeft;
//        [popView addSubview:driverName];
//        
//        UILabel *carName = [[UILabel alloc]initWithFrame:CGRectMake(8, 30, 180, 30)];
//        carName.text = annotation.subtitle;
//        carName.backgroundColor = [UIColor clearColor];
//        carName.font = [UIFont systemFontOfSize:11];
//        carName.textColor = [UIColor lightGrayColor];
//        carName.textAlignment = NSTextAlignmentLeft;
//        [popView addSubview:carName];
        
        
        self.paopaoView = BMKActionPaopaoView(customView: paopaoView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    func setImages(_ images: [UIImage]) {
//        annotationImages = images
//        updateImageView()
//    }
//    
//    func updateImageView() {
//        if annotationImageView.isAnimating {
//            annotationImageView.stopAnimating()
//        }
//        annotationImageView.animationImages = annotationImages
//        annotationImageView.animationDuration = 0.5 * TimeInterval(self.annotationImages.count)
//        annotationImageView.animationRepeatCount = 0
//        annotationImageView.startAnimating()
//    }
}
