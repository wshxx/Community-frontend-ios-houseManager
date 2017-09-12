//
//  XHWLCountView.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/10.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLCountView: UIView , UITableViewDelegate, UITableViewDataSource {
    
    var bgImage:UIImageView!
    var tableView:UITableView!
    var dataAry:NSArray!
    var topMenu:XHWLTopView!
    
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
        
        //        tipImg = UIImageView()
        //        tipImg.frame = CGRect(x:0, y:0, width:55, height:55)
        //        tipImg.center = CGPoint(x: self.bounds.size.width/2.0, y: self.bounds.size.height/2.0-20)
        //        self.addSubview(tipImg)
        
        //        tipLabel = UILabel()
        //        tipLabel.textAlignment = NSTextAlignment.center
        //        tipLabel.textColor = UIColor().colorWithHexString(colorStr: "32b7e2")
        //        tipLabel.font = font_15
        //        self.addSubview(tipLabel)
        
        let array:NSArray = ["实时进度"]
        topMenu = XHWLTopView.init(frame: CGRect.zero)
        topMenu.createArray(array: array)
        topMenu.btnBlock = { index in

        }
        self.addSubview(topMenu)
        
        tableView = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.addSubview(tableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return dataAry.count
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = XHWLActualTimeCell.cellWithTableView(tableView: tableView)
        cell.textLabel?.text = dataAry[indexPath.row] as? String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.dismissBlock(indexPath.row)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        var height:CGFloat = CGFloat(44*dataAry.count)
//        if height >= self.bounds.size.height-64 {
//            height = self.bounds.size.height-64
//        }
//        
//        tableView.frame = CGRect(x:0, y:64, width:Int(self.bounds.size.width), height:Int(height))
        
        bgImage.frame = self.bounds
        //        tipLabel.frame = CGRect(x:10, y:self.bounds.size.height-80, width:self.bounds.size.width-20, height:40)
        topMenu.frame = CGRect(x:0, y:0, width:self.bounds.size.width, height:44)
        tableView.frame = CGRect(x:0, y:44, width:self.bounds.size.width, height:self.frame.size.height-44)
    }
}
