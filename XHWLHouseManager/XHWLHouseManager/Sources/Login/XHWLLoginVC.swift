//
//  XHWLLoginVC.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/8/30.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit
import Alamofire

class XHWLLoginVC: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
 
                
       self.setupView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // 初始化界面
    func setupView() {
        let bgImageV:UIImageView = UIImageView(frame: self.view.bounds)
        bgImageV.image = UIImage(named: "xhwl_login_bgView")
        self.view.addSubview(bgImageV)
        
        let showV:XHWLTransitionView = XHWLTransitionView(frame: CGRect(x:0, y:0, width:349, height:299+90))
        showV.center = CGPoint(x: self.view.bounds.width/2.0, y: self.view.bounds.height/2.0-90/2.0)
        weak var weak_self:XHWLLoginVC?  = self
        showV.funcBackBlock = { topStr,bottomStr in
            
//            let vc:XHWLFirst = XHWLFirst()
            
//            let vc:XHWLPedometerVC = XHWLPedometerVC()
//            weak_self?.navigationController?.pushViewController(vc, animated: true)
            
            let vc = XHWLScanTestVC()
//            let vc = CMPedometerViewController()
//            let vc = XHWLLocationVC()
//            let vc = XHWLMcuResourceVC()
//            let vc = XHWLMcuShowVC()
//            let vc = XHWLHomeVC()
            weak_self?.navigationController?.pushViewController(vc, animated: true)
        }
        self.view.addSubview(showV)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onHiddenKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    func onHiddenKeyboard() {
        self.view.endEditing(true)
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
