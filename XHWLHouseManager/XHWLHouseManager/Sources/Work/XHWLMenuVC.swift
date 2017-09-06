//
//  XHWLMenuVC.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/5.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLMenuVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        setupView()
        
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTapClick))
        self.view.addGestureRecognizer(tap)
    }
    
    func onTapClick() {
        self.view.isHidden = true
    }
    
    func setupView() {
        let subView = UIView.init(frame: CGRect(x:0, y:0, width:200, height:Screen_height))
        subView.backgroundColor = UIColor.white
        self.view.addSubview(subView)
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
