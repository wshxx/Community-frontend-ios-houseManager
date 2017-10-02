//
//  XHWLMessageView.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/10/1.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLMessageView: UIView , UITableViewDelegate, UITableViewDataSource {
    
    var bgImage:UIImageView!
    var tableView:UITableView!
    var dataAry:NSMutableArray! = NSMutableArray()
    var clickCell:(NSInteger)->(Void) = {param in }
    
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
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
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
        
        let cell: XHWLRegistrationCell = XHWLRegistrationCell.cellWithTableView(tableView: tableView)
        //        let model:XHWLRegisterationModel = dataAry[indexPath.row] as! XHWLRegisterationModel
        //        cell.setRegisterModel(model)
        let model:XHWLAbnormalPassModel = dataAry[indexPath.row] as! XHWLAbnormalPassModel
        cell.abnormalModel = model
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.clickCell(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
