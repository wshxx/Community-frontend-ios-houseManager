//
//  XHWLWaterView.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/10.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLWaterView: UIView , UITableViewDelegate, UITableViewDataSource {
    
    var bgImage:UIImageView!
    var tipImg:UIImageView!
    var tipLabel:UILabel!
    var tableView:UITableView!
    var clickCell:(NSInteger, IndexPath, NSInteger)->(Void) = {param in }
    var topMenu:XHWLTopView!
    
    var topSelectIndex:NSInteger! = 0
    var tagAry:NSArray! = NSArray()
    var modelAry:NSArray! {
        willSet {
            if (newValue != nil) {
                
                topMenu.createModelArray(newValue)
                updateTop(0, 0, newValue)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        modelAry = NSArray()

        setupView()
        
    }
    
    func updateTop(_ index:NSInteger, _ row:NSInteger, _ array:NSArray) {
        
        topSelectIndex = index
        if array.count > index {
            let model:XHWLDeviceTitleModel = array[index] as! XHWLDeviceTitleModel
            print("\(model.deviceAry)")
            tagAry = model.deviceAry
        }
    }
    
    func setupView() {
        
        bgImage = UIImageView()
        bgImage.image = UIImage(named:"menu_bg")
        self.addSubview(bgImage)
        
        topMenu = XHWLTopView.init(frame: CGRect.zero)
//        topMenu.createModelArray(keyAry)
        topMenu.btnBlock = {[weak self] index in
            
            self?.topSelectIndex = index
            self?.updateTop(index, 0, (self?.modelAry)!)
            self?.tableView.reloadData()
        }
        self.addSubview(topMenu)
        
        tableView = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.showsVerticalScrollIndicator = false
        self.addSubview(tableView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bgImage.frame = self.bounds
        
        let img = UIImage(named:"warning_subview_top_bg")!
        topMenu.frame =  CGRect(x:0, y:0, width:self.bounds.size.width, height:img.size.height)
        bgImage.frame = CGRect(x:14, y:56, width:self.bounds.size.width-28, height:self.frame.size.height-56)
        tableView.frame = CGRect(x:14, y:56, width:self.bounds.size.width-28, height:self.frame.size.height-56)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        

        return tagAry.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let subModel:XHWLDeviceSubTitleModel = tagAry[section] as! XHWLDeviceSubTitleModel
        let dataAry = subModel.deviceSubAry as NSArray
        
        print("\(dataAry)")
        if dataAry.count > 0 {
           
            if dataAry.count%3 == 0 {
                return dataAry.count/3
            }
            return dataAry.count/3+1
        }
        
         return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: XHWLChargeProviderCell = XHWLChargeProviderCell.cellWithTableView(tableView)
        
        let array:NSMutableArray = NSMutableArray()
        
        let subModel:XHWLDeviceSubTitleModel = tagAry[indexPath.section] as! XHWLDeviceSubTitleModel
        let dataAry = subModel.deviceSubAry as NSArray
        let model:XHWLDeviceModel = dataAry[indexPath.row*3] as! XHWLDeviceModel
        array.add(model)
        if (indexPath.row*3+1) < dataAry.count {
            let model:XHWLDeviceModel = dataAry[indexPath.row*3+1] as! XHWLDeviceModel
            array.add(model)
        }
        if (indexPath.row*3+2) < dataAry.count {
            
            let model:XHWLDeviceModel = dataAry[indexPath.row*3+2] as! XHWLDeviceModel
            array.add(model)
        }
        
        cell.createView(array)
        
        cell.onClickCell = { index in
            self.clickCell(self.topSelectIndex, indexPath, index)
        }
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headV:XHWLHeadView = XHWLHeadView()
        headV.frame = CGRect(x:0, y:0, width:self.tableView.bounds.size.width, height:30)
        if modelAry.count > 0 {
            let model:XHWLDeviceTitleModel = modelAry[topSelectIndex] as! XHWLDeviceTitleModel
            if model.deviceAry.count > 0 {
                let subModel:XHWLDeviceSubTitleModel = model.deviceAry[section] as! XHWLDeviceSubTitleModel
                headV.showText(subModel.deviceSubTitle)// "冷水泵"
            }
        }
        
        return headV
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
