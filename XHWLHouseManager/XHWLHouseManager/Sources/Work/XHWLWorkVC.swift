//
//  XHWLWorkVC.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/5.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLWorkVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.orange
        
        
        
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"tabbar_1"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(onScan))
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"tabbar_2"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(onScan))
        self.rt_disableInteractivePop = true
    }
    
    func onScan() {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let vc:XHWLSearchVC = XHWLSearchVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
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
