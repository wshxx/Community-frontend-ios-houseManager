//
//  XHWLWorkView.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/16.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLWorkView: UIView , UITableViewDelegate, UITableViewDataSource {
    
    
    var tableView:UITableView!
    var dataAry:NSArray!
    var btnBlock:(NSInteger)->(Void) = { param in }
    var dismissBlock:(NSInteger)->(Void) = { param in }
    
    init(frame: CGRect, array:NSArray) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        dataAry = array
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("\(touches)")
        self.dismissBlock(-1)
    }
    
    func setupView() {
        self.backgroundColor = UIColor.clear
        
        tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.showsVerticalScrollIndicator = false
        self.addSubview(tableView)
        tableView.tableFooterView = UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataAry.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = XHWLWorkCell.cellWithTableView(tableView: tableView)
        let str = dataAry[indexPath.row] as? String
        cell.showText = str
        cell.onBtnClickBlock = {[weak self] param in
            
            self?.dismissBlock(indexPath.row)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //        self.dismissBlock(indexPath.row)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        tableView.frame = self.bounds
    }

}
