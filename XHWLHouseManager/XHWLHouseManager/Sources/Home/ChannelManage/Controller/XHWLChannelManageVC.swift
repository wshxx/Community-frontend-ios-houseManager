//
//  XHWLChannelManageVC.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/11/16.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLChannelManageVC: XHWLBaseVC , XHWLNetworkDelegate {

    var warningView:XHWLChannelListView!
    var dealArray:NSArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        self.title = "频道列表"
        setupView()
        onLoadData()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"Visitor_add"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(onAddClick))
    }
    
    func onAddClick() {
        let vc:XHWLSelectGroupVC = XHWLSelectGroupVC()
        vc.reloadData = {[weak self] _ in
            self?.onLoadData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func onLoadData() {
        
        let data:NSData = UserDefaults.standard.object(forKey: "user") as! NSData
        let userModel:XHWLUserModel = XHWLUserModel.mj_object(withKeyValues: data.mj_JSONObject())
        
        XHWLNetwork.shared.getChannelListClick([userModel.wyAccount.token] as NSArray, self)
    }
    
    // MARK: - XHWLNetworkDelegate
    
    func requestSuccess(_ requestKey:NSInteger, _ response:[String : AnyObject]) {
        
        if requestKey == XHWLRequestKeyID.XHWL_CHANNELLIST.rawValue {
            
            let dict = response["result"] as! NSDictionary
            let array = dict["rows"] as! NSArray
            if array.count <= 0 {
                return
            }
            let dealArray:NSArray = XHWLChannelModel.mj_objectArray(withKeyValuesArray:array)
            self.dealArray = dealArray
            self.warningView.dataAry = NSMutableArray()
            self.warningView.dataAry.addObjects(from: dealArray as! [Any])
            self.warningView.tableView.reloadData()
        }
    }
    
    func requestFail(_ requestKey:NSInteger, _ error:NSError) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let vc:XHWLChannelInfoVC = XHWLChannelInfoVC()
//        vc.channelModel = self.dealArray[index] as! XHWLChannelModel

        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setupView() {
        warningView = XHWLChannelListView()
        warningView.bounds = CGRect(x:0, y:0, width:Screen_width*13/16.0, height:Screen_height*2/3.0)
        warningView.center = CGPoint(x:self.view.frame.size.width/2.0, y:self.view.frame.size.height/2.0)
        warningView.clickCell = {index in
            
            let vc:XHWLChannelInfoVC = XHWLChannelInfoVC()
            vc.channelModel = self.dealArray[index] as! XHWLChannelModel
//            vc.backReloadBlock = {[weak self] _ in
//                self?.onLoadData()
//            }
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
