//
//  XHWLPickerView.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/11.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLPickerView: UIView , UITableViewDelegate, UITableViewDataSource {

    var tableView:UITableView!
    var dataAry:NSArray!
    var bgImage:UIImageView!
    var btnBlock:(NSInteger)->(Void) = { param in }
    var dismissBlock:(NSInteger)->(Void) = { param in }
    
    init(frame: CGRect, array:NSArray) {
        super.init(frame: frame)
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
//          self.dismissBlock(-1)
//    }
    
    func setupView() {
        
        bgImage = UIImageView()
        bgImage.image = UIImage(named:"pop_bg")
        self.addSubview(bgImage)
        
        tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.clear
        self.addSubview(tableView)
        tableView.tableFooterView = UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataAry.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:XHWLPickerCell = XHWLPickerCell.cellWithTableView(tableView)
        cell.titleL.text = dataAry[indexPath.row] as? String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismissBlock(indexPath.row)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        tableView.bounds = CGRect(x:0, y:0, width:300, height:44*dataAry.count)
        tableView.center = CGPoint(x:self.bounds.size.width/2.0, y: self.bounds.size.height/2.0)
        
        bgImage.frame = tableView.frame
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
