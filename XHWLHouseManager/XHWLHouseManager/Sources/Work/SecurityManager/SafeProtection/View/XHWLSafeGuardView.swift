//
//  XHWLSafeGuardDetailView.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/11.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

@objc protocol XHWLSafeGuardViewDelegate:NSObjectProtocol {
    @objc optional func onSafeGuard(_ index:NSInteger, _ count:NSInteger)
    @objc optional func safeGuardViewWithSubmit(_ view:XHWLSafeGuardView, _ text:String)
}


class XHWLSafeGuardView: UIView {

    var bgImage:UIImageView!
    var tableView:UITableView!
    var dataSource:NSArray! = NSArray()
    var state:XHWLSafeGuardStateEnum = .undistributed
    var submitBtn:UIButton!
    weak var delegate:XHWLSafeGuardViewDelegate?
    var clickCell:XHWLPickPictureCell!
    var model:XHWLSafeProtectionModel! {// 单号
        willSet {
            if (newValue != nil) {
                
                print("\(newValue.image)")
                self.dataSource = newValue.dataSource
                self.tableView.reloadData()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
        bgImage = UIImageView()
        bgImage.image = UIImage(named:"subview_bg")
        self.addSubview(bgImage)
        
        tableView = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionFooterHeight = 0.0
        tableView.backgroundColor = UIColor.clear
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.showsVerticalScrollIndicator = false
        self.addSubview(tableView)
        
        submitBtn = UIButton()
        submitBtn.setTitle("提交", for: UIControlState.normal)
        submitBtn.setTitleColor(color_09fbfe, for: UIControlState.normal)
        submitBtn.setBackgroundImage(UIImage(named:"btn_background"), for: UIControlState.normal)
        submitBtn.addTarget(self, action: #selector(submitClick), for: UIControlEvents.touchUpInside)
        self.addSubview(submitBtn)
    }
    
    func submitClick() {
        self.delegate?.safeGuardViewWithSubmit!(self, "") // self.remarkStr
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        bgImage.frame = self.bounds
        
        if model != nil && model.state == .pending {
            tableView.frame = CGRect(x:0, y:5, width:self.bounds.size.width, height:self.frame.size.height-10-50)
            submitBtn.bounds = CGRect(x:0, y:0, width:150, height:30)
            submitBtn.center = CGPoint(x:self.bounds.size.width/2.0, y:self.bounds.size.height-30)
            submitBtn.isHidden = false
        } else {
            tableView.frame = CGRect(x:0, y:5, width:self.bounds.size.width, height:self.frame.size.height-10)
            submitBtn.bounds = CGRect(x:0, y:0, width:150, height:0)
            submitBtn.center = CGPoint(x:self.bounds.size.width/2.0, y:self.bounds.size.height-30)
            submitBtn.isHidden = true
        }
    }
}


extension XHWLSafeGuardView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dict:NSDictionary = self.dataSource[section] as! NSDictionary
        let array = dict.allValues[0] as! NSArray
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dict:NSDictionary = self.dataSource[indexPath.section] as! NSDictionary
        let array = dict.allValues[0] as! NSArray
        let model:XHWLMenuModel = array[indexPath.row] as! XHWLMenuModel
        
        switch model.type {
        case 0:
            let cell: XHWLLabelCell = XHWLLabelCell.cellWithTableView(tableView: tableView)
            cell.menuModel = model
            
            return cell;
        case 1:
            let cell: XHWLPickPictureCell = XHWLPickPictureCell.cellWithTableView(tableView: tableView, model.content)
            cell.menuModel = model
            cell.delegate = self
            
            return cell;
        case 2:
            let cell: XHWLRemarkCell = XHWLRemarkCell.cellWithTableView(tableView: tableView)
            cell.menuModel = model
            
            return cell;
        case 3:
            let cell: XHWLLineCell = XHWLLineCell.cellWithTableView(tableView: tableView)
            
            return cell;
        default:
            break;
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let dict:NSDictionary = self.dataSource[section] as! NSDictionary
        let string = dict.allKeys[0] as! String
        
        let head3 = XHWLHeadView()
        head3.frame = CGRect(x:10, y:0, width:self.bounds.size.width-20, height:30)
        head3.showText(string)
        head3.showTextColor = color_01f0ff
        
        return head3
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    //将分组尾设置为一个空的View
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let dict:NSDictionary = self.dataSource[indexPath.section] as! NSDictionary
        let array = dict.allValues[0] as! NSArray
        let model:XHWLMenuModel = array[indexPath.row] as! XHWLMenuModel
        
        switch model.type {
        case 0:
            return 25
        case 1:
            return 95
        case 2:
            return 80
        case 3:
            return 3
        default:
            break;
        }
        return 0
    }
}

extension XHWLSafeGuardView:XHWLPickPictureCellDelegage {
    
    func pickPictureCellWithAddImageOrVideo(_ index:NSInteger, _ count:NSInteger, _ cell:XHWLPickPictureCell) {
        clickCell = cell
         self.delegate?.onSafeGuard!(index, count)
    }
}

