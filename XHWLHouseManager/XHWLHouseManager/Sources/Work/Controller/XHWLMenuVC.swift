//
//  XHWLMenuVC.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/27.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLMenuVC: XHWLBaseVC  {

    var menuView : XHWLMenuView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        let btn:UIButton = UIButton()
//        btn.frame = CGRect(x:0, y:0, width:20, height:20)
//        self.view.addSubview(btn)
        
//       self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"home_menu"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(onOpenMenu))
        self.title = "个人信息"
        
        menuView = XHWLMenuView(frame:CGRect(x:0, y:0, width:Screen_width*13/16.0, height:Screen_height*2/3.0))
        menuView.center = CGPoint(x:self.view.bounds.size.width/2.0, y:self.view.bounds.size.height/2.0)
//        menuView.isHidden = true
        menuView.backBlock = {index in
            if index == 0 {
                AlertMessage.showAlertMessage(vc: self, alertMessage: "确定要退出吗？") {
                    AppDelegate.shared().onLogout()
                }
            } else if index == 1 {
                let vc : XHWLLoginVC = XHWLLoginVC()
                vc.isWindowToLogin = false
                self.navigationController?.pushViewController(vc, animated: true)
            }
     
        }
        self.view.addSubview(menuView)
    }
    
  

//    func action() {
//        actionArr = ["相册", "拍照"]
//        let sheet:HZActionSheet = HZActionSheet.init(title: nil,
//                                                     delegate: self,
//                                                     cancelButtonTitle: "取消",
//                                                     destructiveButtonIndexSet: nil,
//                                                     otherButtonTitles: actionArr as! [Any]!)
//        sheet.titleColor = UIColor.black
//        sheet.show(in: self.view)
//    }
//
//    // pragma mark  ActionSheetDelegate
//    func sheet(_ actionSheet: HZActionSheet!, click buttonIndex: Int) {
//        if ((actionArr != nil) && buttonIndex >= actionArr.count) {
//
//            return;
//        }
//
//        let string:String = actionArr[buttonIndex] as! String
//        print("\(string)")
//
//        if (buttonIndex == 0) {// @"退回"
//
//            openAlbum()
//        } else if (buttonIndex == 1){ // "删除
//
//            openCarme()
//        }
//    }
    
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
