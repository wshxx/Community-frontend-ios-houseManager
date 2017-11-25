//
//  OtherAnimatedAnnotationView.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/10/10.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLOtherAnnotationView:BMKAnnotationView  { // BMKAnnotationView MKPinAnnotationView

    var annotationImageView: UIImageView!
    var showView:UIView!
    var nameL:UILabel!
    var progressL:UILabel!
    var pointModel:XHWLMapKitModel! {
        willSet {
            showView.isHidden = !newValue.isSelected
            nameL.isHidden = !newValue.isSelected
            progressL.isHidden = !newValue.isSelected
            
            nameL.text = newValue.nickname
            if !newValue.progress.isEmpty {
                let ary:NSArray = newValue.progress.components(separatedBy: "/") as NSArray
                if (ary[1] as! String) == "0" {
                    progressL.text = "0%"
                } else {
                    let progross:String = String(Int(Int(ary[0] as! String)! * 100 / Int(ary[1] as! String)!))
                    
                    progressL.text = progross+"%"
                }
            } else {
                progressL.text = "0%"
            }
        }
    }
    
    override init(annotation: BMKAnnotation!, reuseIdentifier: String!) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        self.bounds = CGRect(x: 0, y: 0, width: 32, height: 32)
        self.backgroundColor = UIColor.clear
        self.centerOffset = CGPoint(x:0, y:0)
        self.isDraggable = false
        self.canShowCallout = false
        
        annotationImageView = UIImageView(frame: bounds)
        annotationImageView.contentMode = UIViewContentMode.center
        annotationImageView.image = UIImage(named: "pin_other")!
        self.addSubview(annotationImageView)
        
        showView = UIView.init(frame: CGRect(x:0, y:0, width:100, height:40))
        showView.center = CGPoint(x:0, y:-20)
        showView.backgroundColor = UIColor.white
        showView.layer.cornerRadius = 5
        showView.layer.masksToBounds = true
        self.addSubview(showView)
        
        nameL = UILabel.init(frame: CGRect(x:0, y:0, width:100, height:20))
        nameL.text = ""
        nameL.backgroundColor = UIColor.clear
        nameL.font = font_14
        nameL.textColor = UIColor.black
        nameL.textAlignment = .center
        nameL.center = CGPoint(x:50, y:10)
        showView.addSubview(nameL)
        
        progressL = UILabel.init(frame: CGRect(x:0, y:25, width:100, height:20))
        progressL.text = ""
        progressL.backgroundColor = UIColor.clear
        progressL.font = font_14
        progressL.textColor = color_328bfe
        progressL.textAlignment = .center
        progressL.center = CGPoint(x:50, y:30)
        showView.addSubview(progressL)
        
//        let paoView = UIView()
//        paoView.backgroundColor = UIColor.white
//        paoView.frame = CGRect(x:0, y:0, width:100, height:60)

        //自定义显示的内容
//        nameL = UILabel.init(frame: CGRect(x:0, y:0, width:100, height:20))
//        nameL.text = "张XX师傅"
//        nameL.backgroundColor = UIColor.clear
//        nameL.font = font_14
//        nameL.textColor = UIColor.black
//        nameL.textAlignment = .center
//        paoView.addSubview(nameL)

//        progressL = UILabel.init(frame: CGRect(x:0, y:25, width:100, height:20))
//        progressL.text = "京A123456"
//        progressL.backgroundColor = UIColor.clear
//        progressL.font = font_14
//        progressL.textColor = UIColor.black
//        progressL.textAlignment = .center
//        paoView.addSubview(progressL)
        
//        self.paopaoView = BMKActionPaopaoView(customView: paoView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
