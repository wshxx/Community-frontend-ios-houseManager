//
//  XHWLIssueReportListVC.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/15.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLIssueReportListVC: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    var bgImg:UIImageView!
    var subBgImg:UIImageView!
    var tableView:UITableView!
    var dataAry:NSMutableArray! = NSMutableArray()
    var dataSource:NSMutableArray! = NSMutableArray()
    var isDeal:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        setupView()
        onSetupNav()
        loadList()
    }
    
    func onSetupNav() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"scan_back"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(onBack))
        
        let array:NSArray = ["水泵房", "排污泵"]
        let topMenu:XHWLTopView = XHWLTopView.init(frame: CGRect.zero)
        topMenu.createArray(array: array)
        topMenu.bounds = CGRect(x:0, y:0, width:Screen_width-100, height:44)
        topMenu.center = CGPoint(x:Screen_width/2.0, y:22)
        topMenu.btnBlock = {[weak self] index in
            //self?.warningView.selectIndex = index
            //self?.warningView.tableView.reloadData()
        }
        self.navigationItem.titleView = topMenu
    }
    
    func onBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupView() {
        
        bgImg = UIImageView()
        bgImg.frame = self.view.bounds
        bgImg.image = UIImage(named:"home_bg")
        self.view.addSubview(bgImg)
        
        let img = UIImage(named:"menu_bg")!
        subBgImg = UIImageView()
        subBgImg.image = img
        subBgImg.bounds = CGRect(x:0, y:0, width:img.size.width, height:img.size.height)
        subBgImg.center = CGPoint(x:self.view.bounds.size.width/2.0, y:self.view.bounds.size.height/2.0)
        self.view.addSubview(subBgImg)

        tableView = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.plain)
        tableView.bounds = CGRect(x:0, y:0, width:img.size.width, height:img.size.height)
        tableView.center = CGPoint(x:self.view.bounds.size.width/2.0, y:self.view.bounds.size.height/2.0)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.view.addSubview(tableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isDeal {
            return self.dataSource.count
        }
        
        return dataAry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let ID: String = "XHWLWarningView"
        var cell = tableView.dequeueReusableCell(withIdentifier: ID)
        if cell == nil {
            cell =  UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: ID)
        }
        
        if isDeal {
            cell?.contentView.backgroundColor = UIColor.clear
            let model = dataSource[indexPath.row] as! XHWLIssueReportModel
            cell?.textLabel?.text = model.inspectionPoint
        } else {
            
            let model = dataAry[indexPath.row] as! XHWLIssueReportModel
            cell?.textLabel?.text = model.inspectionPoint
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func loadList() {
        
        let data:NSData = UserDefaults.standard.object(forKey: "user") as! NSData
        let userModel:XHWLUserModel = XHWLUserModel.mj_object(withKeyValues: data.mj_JSONObject())

        XHWLHttpTool.sharedInstance.getHttpTool(url: "wyBusiness/complaint",
                                                parameters: [userModel.wyAccount.token],
                                                success: { (response) in
            
            let errorCode:NSInteger = response["errorCode"] as! NSInteger
            if errorCode == 200 {
                let result0:NSArray = response["result"]!["0"] as! NSArray
                self.dataAry.addObjects(from:XHWLIssueReportModel.mj_objectArray(withKeyValuesArray: result0) as! [Any])
                
                
                let result1:NSArray = response["result"]!["1"] as! NSArray
                self.dataSource.addObjects(from:XHWLIssueReportModel.mj_objectArray(withKeyValuesArray:result1) as! [Any])
                
                self.tableView.reloadData()
            }
            
        }, failture: { (error) in
            
        })
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
