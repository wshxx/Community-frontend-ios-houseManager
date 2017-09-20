//
//  XHWLBluetoothOpenVC.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/14.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLBluetoothOpenVC: UIViewController {

    var bgImg:UIImageView!
    var topMenu:XHWLTopView!
    var warningView:XHWLBluetoothAuthView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.clear
        setupView()
        setupNav()
        

    }
    
  //  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //warningView.scan()
  //  }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        warningView.scan()
    }
    
    func setupNav() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"scan_back"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(onBack))
        
        self.title = "蓝牙授权"
    }
    
    func onBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupView() {
        
        bgImg = UIImageView()
        bgImg.frame = self.view.bounds
        bgImg.image = UIImage(named:"home_bg")
        self.view.addSubview(bgImg)
        
        let showImg:UIImage = UIImage(named:"menu_bg")!
        warningView = XHWLBluetoothAuthView()
        warningView.bounds = CGRect(x:0, y:0, width:showImg.size.width, height:showImg.size.height)
        warningView.center = CGPoint(x:self.view.frame.size.width/2.0, y:self.view.frame.size.height/2.0)
        warningView.clickCell = { row in
            
            let vc:XHWLSafeGuardVC = XHWLSafeGuardVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        self.view.addSubview(warningView)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "开门", style: UIBarButtonItemStyle.plain, target: self, action: #selector(XHWLBluetoothOpenVC.onOpen))
    }
    
    func onOpen() {
        warningView.open()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
