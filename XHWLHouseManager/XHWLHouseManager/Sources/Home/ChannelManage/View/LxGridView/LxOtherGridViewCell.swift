//
//  LxOtherGridViewCell.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/11/20.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class LxOtherGridViewCell: UICollectionViewCell {
    var delegate: LxGridViewCellDelegate?
    var iconImageView: UIImageView?
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        
        iconImageView = UIImageView()
//        iconImageView?.contentMode = .scaleAspectFit
        iconImageView?.isUserInteractionEnabled = true
        contentView.addSubview(iconImageView!)
        
        iconImageView?.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        let iconImageViewLeftConstraint = NSLayoutConstraint(item: iconImageView!, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: 0)
        let iconImageViewRightConstraint = NSLayoutConstraint(item: iconImageView!, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: 0)
        let iconImageViewTopConstraint = NSLayoutConstraint(item: iconImageView!, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 0)
        let iconImageViewHeightConstraint = NSLayoutConstraint(item: iconImageView!, attribute: .width, relatedBy: .equal, toItem: iconImageView, attribute: .height, multiplier: 1, constant: 0)
        contentView.addConstraints([iconImageViewLeftConstraint, iconImageViewRightConstraint, iconImageViewTopConstraint, iconImageViewHeightConstraint])

    }
    
}
