//
//  XHWLRosterManageVC.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/11/9.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLRosterManageVC: XHWLBaseVC, XHWLRosterAddViewDelegate {
    
    var warningView:XHWLRosterManageView!
    var rosterAddView:XHWLRosterAddView!
//    var selectIndex:NSInteger = 0
//    var dataAry:NSMutableArray! = NSMutableArray()
//    var dataSource:NSMutableArray! = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.title = "名单管理"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"Visitor_add"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(onAddClick))
        setupView()
//        onLoadData("黑名单")
    }
    
    func onAddClick() {
        rosterAddView.isHidden = false
    }
    
    func setupView() {
        
        warningView = XHWLRosterManageView()
        warningView.bounds = CGRect(x:0, y:0, width:Screen_width-20, height:Screen_height-160)
        warningView.center = CGPoint(x:self.view.frame.size.width/2.0, y:self.view.frame.size.height/2.0)
//        warningView.clickMenu = { [weak self] index in
//            self?.selectIndex = index
//            if index == 0 {
//                self?.onLoadData("黑名单")
//            } else if index == 1 {
//                self?.onLoadData("灰名单")
//            }
//        }
        warningView.clickCell = {[weak warningView] index, row, model in
            
//            let vc:XHWLSafeGuardVC = XHWLSafeGuardVC()
//            vc.isFinished = !(index == 0)
//            vc.model = model
//            vc.backReloadBlock =  { _ in
//                if (index == 0) {
//
//                    self.onLoadData()
//                } else {
//
//                    warningView?.tableView.reloadData()
//                }
//            }
//            self.navigationController?.pushViewController(vc, animated: true)
        }
        self.view.addSubview(warningView)
        
        rosterAddView = XHWLRosterAddView()
        rosterAddView.frame = UIScreen.main.bounds
        rosterAddView.isHidden = true
        rosterAddView.delegate = self
        let window: UIWindow = (UIApplication.shared.keyWindow)!
        window.addSubview(rosterAddView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        rosterAddView.removeFromSuperview()
    }
    
    // MARK - XHWLRosterAddViewDelegate
    func cancelWith(rosterAddView:XHWLRosterAddView) {
        rosterAddView.isHidden = true
    }
    
    func addWith(rosterAddView:XHWLRosterAddView) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
