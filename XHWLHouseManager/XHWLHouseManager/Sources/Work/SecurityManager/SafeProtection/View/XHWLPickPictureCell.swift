//
//  XHWLPickPictureCell.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/11/25.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLPickPictureCell: UITableViewCell {

    var pickPhoto:XHWLPickPhotoView!
    var isFinished:Bool!
    var menuModel:XHWLMenuModel! {
        willSet {
//            pickPhoto.showText(leftText: newValue.name, rightText:newValue.content)
            //            labelView.textAlign = NSTextAlignment.center
        }
    }
    
    class func cellWithTableView(tableView:UITableView, _ isFinished:String) -> XHWLPickPictureCell {
        
        let ID: String = "XHWLPickPictureCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: ID)
        if (cell == nil) {
            cell =  XHWLPickPictureCell.init(style: UITableViewCellStyle.default, reuseIdentifier: ID, isFinished)
        }
        
        return cell as! XHWLPickPictureCell
    }
    
    init(style: UITableViewCellStyle, reuseIdentifier: String?, _ isFinished:String) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        if isFinished == "1" {
            self.isFinished = true
        } else {
            self.isFinished = false
        }
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        
        setupView()
    }

    func setupView() {
        
        pickPhoto = XHWLPickPhotoView(frame: CGRect.zero, isFinished)
        pickPhoto.showText("现场照片：")
        if isFinished {
//            if !model.appComplaint.manageImgUrl.isEmpty {
//                let array:NSArray = model.appComplaint.manageImgUrl.components(separatedBy: ",") as NSArray
//                pickPhoto.onShowImgArray(array)
//            }
        }
        //        pickPhoto.isShow = isFinished // 显示
        pickPhoto.addPictureBlock = { isAdd, index, isPictureAdd in
//            self.delegate?.onSafeGuard!(isAdd, index, isPictureAdd)
        }
        contentView.addSubview(pickPhoto)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        pickPhoto.frame = CGRect(x:10, y:0, width:self.bounds.size.width-10, height:self.bounds.size.height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
