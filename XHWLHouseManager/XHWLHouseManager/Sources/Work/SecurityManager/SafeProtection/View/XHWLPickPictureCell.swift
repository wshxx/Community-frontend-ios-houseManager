//
//  XHWLPickPictureCell.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/11/25.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

protocol XHWLPickPictureCellDelegage:NSObjectProtocol {
    func pickPictureCellWithAddImageOrVideo(_ index:NSInteger, _ count:NSInteger, _ cell:XHWLPickPictureCell)
}

class XHWLPickPictureCell: UITableViewCell {

    weak var delegate:XHWLPickPictureCellDelegage?
    var pickPhoto:XHWLPickPhotoView!
    var isFinished:Bool!
    var menuModel:XHWLMenuModel! {
        willSet {
            
            pickPhoto.showText(newValue.name)
            if isFinished {
                if !newValue.content.isEmpty {
                    let array:NSArray = newValue.content.components(separatedBy: ",") as NSArray
                    pickPhoto.showImgOrVideoArray(array)
                }
            }
        }
    }
    
    class func cellWithTableView(tableView:UITableView, _ content:String) -> XHWLPickPictureCell {
        
        let ID: String = "XHWLPickPictureCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: ID)
        if (cell == nil) {
            cell =  XHWLPickPictureCell.init(style: UITableViewCellStyle.default, reuseIdentifier: ID, content)
        }
        
        return cell as! XHWLPickPictureCell
    }
    
    init(style: UITableViewCellStyle, reuseIdentifier: String?, _ content:String) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        if !content.isEmpty {
            self.isFinished = true
        } else {
            self.isFinished = false
        }
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
         self.selectionStyle = .none
        
        setupView()
    }

    func setupView() {
        
        pickPhoto = XHWLPickPhotoView(frame: CGRect.zero, isFinished)
        pickPhoto.showText("现场照片：")
//        pickPhoto.isShow = isFinished // 显示
        pickPhoto.addPictureBlock = { index, count in
            self.delegate?.pickPictureCellWithAddImageOrVideo(index, count, self)
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
