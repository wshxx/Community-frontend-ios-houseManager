//
//  XHWLNavigationController.swift
//  XHWLHouseManager
//
//  Created by admin on 2017/8/30.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import Foundation
import UIKit

class XHWLNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appearance = UIBarButtonItem.appearance()
        appearance.setBackButtonTitlePositionAdjustment(UIOffset.init(horizontal: 0.0, vertical: -60), for: .default)
        self.navigationBar.isTranslucent = true
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationBar.barTintColor = UIColor.white
        
        
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.init(red: 38/255.0, green: 38/255.0, blue: 38/255.0, alpha: 1.0), NSFontAttributeName : UIFont.systemFont(ofSize: 16.0)]
        self.navigationBar.tintColor = UIColor.init(red: 38/255.0, green: 38/255.0, blue: 38/255.0, alpha: 1.0)
        self.navigationItem.title = ""
    }
    
}
