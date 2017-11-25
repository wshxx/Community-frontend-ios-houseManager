//
//  XHWLSelectGroupView.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/11/16.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLSelectGroupView: UIView , UITableViewDelegate, UITableViewDataSource {
    
    var bgImage:UIImageView!
    var tipImg:UIImageView!
    var tipLabel:UILabel!
    var tableView:UITableView!
    var dataAry:NSMutableArray! = NSMutableArray()
    var clickCell:(NSInteger)->(Void) = {param in }
    var selectAry:NSMutableArray = NSMutableArray()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    func setupView() {
        
        bgImage = UIImageView()
        bgImage.image = UIImage(named:"subview_bg")
        self.addSubview(bgImage)
        
        tableView = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
        tableView.tableFooterView = UIView()
//        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.showsVerticalScrollIndicator = false
        self.addSubview(tableView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bgImage.frame = self.bounds
        tableView.frame = CGRect(x:0, y:10, width:self.frame.size.width, height:self.frame.size.height-10)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataAry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: XHWLSelectGroupCell = XHWLSelectGroupCell.cellWithTableView(tableView)
        //        let model:XHWLRegisterationModel = dataAry[indexPath.row] as! XHWLRegisterationModel
        //        cell.setRegisterModel(model)
        let model:XHWLWorkerModel = dataAry[indexPath.row] as! XHWLWorkerModel
        //        cell.abnormalModel = model
//        cell.textLabel?.text = model.name
        cell.workerModel = model
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
//        if self.isSingleSelect == true {
//
//            let node:XHWLMcuModel = self.resourceArray[indexPath.row] as! XHWLMcuModel
//            self.backBlock([node], self.isSingleSelect)
//            self.navigationController?.popViewController(animated: true)
//        } else {
        
            let node:XHWLWorkerModel = self.dataAry[indexPath.row] as! XHWLWorkerModel
            if node.isSelected == true {
                node.isSelected = false
                self.dataAry.replaceObject(at: indexPath.row, with: node)
                selectAry.remove(node)
            } else {
//                if selectAry.count < 2 {
                    node.isSelected = true
                    self.dataAry.replaceObject(at: indexPath.row, with: node)
                    selectAry.add(node)
//                } else {
//                    "一次最多只能展示两个视频".ext_debugPrintAndHint()
//                }
            }
            self.tableView.reloadData()
//        }
        
//        self.clickCell(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
