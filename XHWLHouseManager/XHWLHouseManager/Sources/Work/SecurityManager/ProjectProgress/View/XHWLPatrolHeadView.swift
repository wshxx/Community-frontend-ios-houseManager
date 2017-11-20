//
//  XHWLHeadView.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/10/24.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

//protocol XHWLPatrolHeadViewDelegate: NSObjectProtocol {
//    func headViewClicked(_ cellModel: XHWLPatrolDetailModel, _ headView: XHWLPatrolHeadView)
//}

class XHWLPatrolHeadView: UITableViewHeaderFooterView {
    
    var progressView: XHWLProgressView!
    var accessIV:UIImageView!
    var projectL:UILabel!
    var headViewBlock:(XHWLPatrolLineModel) -> () = { param in }
    var cellModel:XHWLPatrolLineModel! {
        willSet {
            if newValue != nil {
                
                projectL.text = "巡检计划名称："+newValue.lineName
                progressView.show(name: "进度：", progress: newValue.progress)
                
                if newValue.isFlod == true {
                    self.progressView.lineIV.isHidden = true
                    
                } else {
                    self.progressView.lineIV.isHidden = false
                    self.progressView.lineIV.image = UIImage(named: "Patrol_line")!
                }
            }
        }
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        self.buildHeadView()
    }
    
    func buildHeadView() {
        
        //self.contentView.backgroundColor 默认是有颜色的
        projectL = UILabel()
        projectL.textColor = UIColor.white
        projectL.font = font_14
        projectL.text = "巡检计划名称：中海华庭"
        self.contentView.addSubview(projectL)
        
        self.progressView = XHWLProgressView()
        self.contentView.addSubview(self.progressView)
        self.progressView.lineIV.image = UIImage(named: "Patrol_line")!
        
        self.selfAddTapGesture()
    }
    
    func selfAddTapGesture() {
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapAction))
        
        self.addGestureRecognizer(tap)
    }
    
    func tapAction() {
        
        UIView.animate(withDuration: 0.5) {
            
            if self.cellModel.isFlod == false {
                self.cellModel.isFlod = true
                
                self.progressView.lineIV.isHidden = true
//                self.indicateIcon.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI));
                
            } else {
                self.cellModel.isFlod = false
//                self.indicateIcon.transform = CGAffineTransform(rotationAngle: CGFloat(0));
                self.progressView.lineIV.isHidden = false
                self.progressView.lineIV.image = UIImage(named: "Patrol_line")!
            }
        }
        
        self.headViewBlock(self.cellModel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        projectL.frame = CGRect(x:10, y:0, width:self.bounds.size.width-20, height:20)
        progressView.frame = CGRect(x:0, y:projectL.frame.maxY, width:self.bounds.size.width, height:44)
//        accessIV.frame = CGRect(x:10, y:self.bounds.size.height-1, width:self.bounds.size.width-20, height:1)
    }
    
    deinit {
        print("HeadView deinit")
        
    }
    
}

//class HeadViwInfo {
//    //size
//    fileprivate static let titleLabelHeight = 33
//    fileprivate static let indicateIconRightMarge = -20
//
//    fileprivate static let indicateIconWidth = 18
//    fileprivate static let indicateIconHeight = 12
//
//    fileprivate static let practiceIconWidth = 18
//    fileprivate static let practiceIconHeight = 12
//
//    fileprivate static let practiceLabelWidth = 20
//    fileprivate static let practiceLabelHeight = 18
//    fileprivate static let practiceLabelLeftMarge = 10
//
//
//    fileprivate static let testIconWidth = 18
//    fileprivate static let testIconHeight = 12
//
//    fileprivate static let testLabelWidth = 20
//    fileprivate static let testLabelHeight = 18
//    fileprivate static let testLabelLeftMarge = 10
//
//    fileprivate static let bottomLineHeight = 1
//
//    //font practiceLabel
//    fileprivate static let titleLabelFont = UIFont.systemFont(ofSize: 16)
//    fileprivate static let practiceLabelFont = UIFont.systemFont(ofSize: 14)
//    fileprivate static let testLabelFont = UIFont.systemFont(ofSize: 14)
//
//    //background color
//    fileprivate static let bottomLineColor = UIColor.init(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
//    fileprivate static let titleLabelTextColor =  UIColor.init(red: 0.3, green: 0.3, blue: 0.3, alpha: 1)
//    fileprivate static let practiceLabelTextColor =  UIColor.init(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
//    fileprivate static let testLabelTextColor =  UIColor.init(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
//
//
//    //fold section animation time
//    fileprivate static let foldDuration = 0.25
//
//}

