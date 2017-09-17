//
//  XHWLDeviceStatisticsVC.swift
//  XHWLHouseManager
//
//  Created by admin on 2017/9/16.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLDeviceStatisticsVC: XHWLBaseVC {

    var warningView:XHWLDeviceStatisticsView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
    }
    override func viewDidAppear(_ animated: Bool) {
        
        warningView.viewDidAppear()
    }
    func setupView() {
        
        let showImg:UIImage = UIImage(named:"menu_bg")!
        warningView = XHWLDeviceStatisticsView()
        warningView.bounds = CGRect(x:0, y:0, width:338, height:68+showImg.size.height)
        warningView.center = CGPoint(x:self.view.frame.size.width/2.0, y:self.view.frame.size.height/2.0)
        warningView.onClickBlock = { index in

            let vc:XHWLDeviceStatisticsDetailVC = XHWLDeviceStatisticsDetailVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        self.view.addSubview(warningView)
        
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
