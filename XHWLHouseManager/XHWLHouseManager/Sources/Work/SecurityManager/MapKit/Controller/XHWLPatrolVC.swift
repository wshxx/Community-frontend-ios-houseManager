//
//  XHWLPatrolVC.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/10/24.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLPatrolVC: XHWLBaseVC {

    var mapkitView:UIView!
    var countView:UIView!
    var mapkitVC:XHWLMapKitVC!
    var countVC:XHWLCountVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "巡更定位"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"Patro_switch_list"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(onSwitchClick))

        setupView()
//        mapkitVC.onLoadData()
    }
    
    func setupView() {
        
        mapkitVC = XHWLMapKitVC()
        mapkitVC.view.frame = self.view.bounds
        mapkitVC.view.isHidden = false
        mapkitVC.delegate = self
        mapkitView = mapkitVC.view
        self.addChildViewController(mapkitVC)
        self.view.addSubview(mapkitVC.view)
        
        countVC = XHWLCountVC()
        countVC.view.frame = self.view.bounds
        countVC.view.isHidden = true
        countView = countVC.view
        self.addChildViewController(countVC)
        self.view.addSubview(countVC.view)
    }
    
    func onSwitchClick() {

        mapkitView.isHidden = !mapkitView.isHidden
        countView.isHidden = !countView.isHidden
        
        if mapkitView.isHidden == false {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"Patro_switch_list"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(onSwitchClick))
        } else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"Patro_switch_mapkit"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(onSwitchClick))
            countVC.onLoadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension XHWLPatrolVC: XHWLMapKitVCDelegate {

    func mapkitWithShowDetail(_ mapkit:XHWLMapKitVC,  _ model:XHWLMapKitModel) {
        let vc:XHWLProgressDetailVC = XHWLProgressDetailVC()
        vc.userId = model.userId
        vc.name = model.nickname
        vc.progress = model.speed
        print("\(model.userId)")
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


