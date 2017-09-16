//
//  XHWLProgressDetailView.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/15.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLProgressDetailView: UIView , UITableViewDelegate, UITableViewDataSource {
    
    var bgImage:UIImageView!
    var tableView:UITableView!
    var dataAry:NSArray!
    var progressView:XHWLProgressView!
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
    
    func setupView() {
        
        bgImage = UIImageView()
        bgImage.image = UIImage(named:"menu_bg")
        self.addSubview(bgImage)
        
        progressView = XHWLProgressView()
        self.addSubview(progressView)
        
        tableView = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.addSubview(tableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return dataAry.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = XHWLProgressDetailCell.cellWithTableView(tableView: tableView)
        cell.textLabel?.text = dataAry[indexPath.row] as? String
        
        cell.isTop = indexPath.row == 0
        cell.isBottom = indexPath.row == dataAry.count - 1
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.dismissBlock(indexPath.row)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bgImage.frame = self.bounds
        progressView.frame = CGRect(x:0, y:0, width:self.bounds.size.width, height:44)
        tableView.frame = CGRect(x:0, y:44, width:self.bounds.size.width, height:self.frame.size.height-44)
    }

}