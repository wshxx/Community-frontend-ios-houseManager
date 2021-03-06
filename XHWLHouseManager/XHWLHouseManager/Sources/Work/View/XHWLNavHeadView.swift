//
//  XHWLNavHeadView.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/12.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLNavHeadView: UIView , UITableViewDelegate, UITableViewDataSource {
    
    var tableView:UITableView!
    var dataAry:NSArray!
    var bgImage:UIImageView!
    var btnBlock:(NSInteger)->(Void) = { param in }
    var dismissBlock:(NSInteger)->(Void) = { param in }
    
    init(frame: CGRect, array:NSArray) {
        super.init(frame: frame)
//        self.backgroundColor = UIColor.clear
        
        self.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        dataAry = array
        setupView()
        
//        let tap:UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(dismiss))
//        self.addGestureRecognizer(tap)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("\(touches)")
        self.dismissBlock(-1)
    }
    
//    func dismiss() {
//        self.dismissBlock(-1)
//    }
    
    func setupView() {
        
        bgImage = UIImageView()
        bgImage.image = UIImage(named:"pop_bg")
        self.addSubview(bgImage)
        
        
        tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.addSubview(tableView)
        tableView.tableFooterView = UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataAry.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ID: String = "XHWLPickerView"
        var cell = tableView.dequeueReusableCell(withIdentifier: ID)
        if cell == nil {
            cell =  UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: ID)
        }
        cell?.backgroundColor = UIColor.clear
        
        let model:XHWLProjectModel = (dataAry[indexPath.row] as? XHWLProjectModel)!
        cell?.textLabel?.textAlignment = NSTextAlignment.center
        cell?.textLabel?.font = font_14
        cell?.textLabel?.textColor = UIColor.white
        cell?.textLabel?.text = model.name
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismissBlock(indexPath.row)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var height:CGFloat = CGFloat(44*dataAry.count)
        if height >= self.bounds.size.height-64 {
            height = self.bounds.size.height-64
        }
        
        bgImage.frame = CGRect(x:0, y:64, width:Int(self.bounds.size.width), height:Int(height))
        tableView.frame = CGRect(x:0, y:64, width:Int(self.bounds.size.width), height:Int(height))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
