//
//  XHWLMcuResourceVC.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/1.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLMcuResourceVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate {

    var parentNode:MCUResourceNode? /**< 父节点*/
    var tableView:UITableView = UITableView()
    var resourceArray:NSArray = []
    var backBlock:(String)->Void = {param in }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = false
        self.initUI()
        if parentNode != nil {
            //获取组织树节点的子节点资源
            self.requestResource()
        } else {
            //首先要请求获取组织树节点的第一级节点资源
            self.requestRootResource()
        }
    }

    func initUI() {
        self.title = "资源列表"
        self.view.backgroundColor = UIColor.white
        
        tableView = UITableView(frame: self.view.bounds)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.white
        self.view.addSubview(tableView)
    }
    
//    #pragma mark - UITableViewDelegate & UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resourceArray.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier:String = "cellIdentifier"
        
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        
        if cell == nil {
            
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: cellIdentifier)
           
        }else{
            
            while cell?.contentView.subviews.last != nil {
                let subView:UIView = (cell?.contentView.subviews.last!)!
                subView.removeFromSuperview()
            }
            
        }
        let node:MCUResourceNode = resourceArray[indexPath.row] as! MCUResourceNode
        cell?.textLabel?.text = node.nodeName
        
        if (node.nodeType == ResourceNodeType.region || node.nodeType == ResourceNodeType.controlCenter) {
            cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator;
        } else {
            cell?.accessoryType = UITableViewCellAccessoryType.none;
        }
        return cell!;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        parentNode = resourceArray[indexPath.row] as! MCUResourceNode;
        if (parentNode?.nodeType == ResourceNodeType.controlCenter || parentNode?.nodeType == ResourceNodeType.region) {//节点为控制中心或区域,点击节点继续请求子节点资源
            let list: XHWLMcuResourceVC = XHWLMcuResourceVC()
            list.parentNode = parentNode;
            list.backBlock = { cameraSyscode in
                self.backBlock(cameraSyscode)
                self.navigationController?.popViewController(animated: true)
            }
            self.navigationController?.pushViewController(list, animated: true)
        }
        else {//节点为监控点,开始准备进行预览或者回放的操作
            self.alertPlayVideoChooseView(row: indexPath.row)
        }
    }
    
//    #pragma mark - private method
    /**
     *  请求根资源点数据
     */
    func requestRootResource() {
        //1 代表视频资源
        
        MCUVmsNetSDK.shareInstance().requestRootNode(withSysType: 1, success: { (object) in
            
            let obj:NSDictionary = object as! NSDictionary
            let status:String = obj["status"] as! String
            if (status.compare("200").rawValue == 0) {
                self.parentNode = obj["resourceNode"] as? MCUResourceNode
                self.requestResource()
                
            } else {
                self.showDescription(object: obj)
            }
        }) { (error) in
            
        }
    }
    
    /**
     *  请求资源点列表数据
     */
    func requestResource() {
//        [SVProgressHUD showWithStatus:@"加载中..."];
        MCUVmsNetSDK.shareInstance().requestResource(withSysType: 1,
                                                     nodeType: Int(parentNode!.nodeType.rawValue),
                                                     currentID: parentNode?.nodeID ,
                                                     numPerPage: 100, curPage: 1,
                                                     success: { (object) in
//            [self dismiss];
                                                        let obj:NSDictionary = object as! NSDictionary
                                                        let status:String = obj["status"] as! String
                                                        
            if (status.compare("200").rawValue == 0) {
                self.resourceArray = obj["resourceNodes"] as! NSArray
                if self.resourceArray.count > 0 {
                    self.tableView.reloadData()
                } else {
//                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                        [SVProgressHUD showErrorWithStatus:@"暂无资源"];
//                        [self performSelector:@selector(dismiss) withObject:nil afterDelay:delayTime];
//                        });
                }
            }
        }) { (error) in
//            [self dismiss];
//            NSLog(@"requestResource failed");
        }
    }
    
    /**
     *  监控点弹出选择框
     */
    func alertPlayVideoChooseView(row:NSInteger) {
        
        let alertView:UIAlertController = UIAlertController()
        
        let alertController = UIAlertController(title: "请选择",message: nil, preferredStyle: .alert)
        
        let oneAction: UIAlertAction = UIAlertAction.init(title: "预览", style: UIAlertActionStyle.default) { (action) in
            let node:MCUResourceNode = self.resourceArray[row] as! MCUResourceNode
            
            self.backBlock(node.sysCode)
            self.navigationController?.popViewController(animated: true)
            
//            let realPlayController: RealPlayViewController = RealPlayViewController()
//            realPlayController.cameraSyscode = node.sysCode;
//            self.navigationController?.pushViewController(realPlayController, animated: true)

        }
        let twoAction: UIAlertAction = UIAlertAction.init(title: "回放", style: UIAlertActionStyle.default) { (action) in
            let node:MCUResourceNode = self.resourceArray[row] as! MCUResourceNode;
            let playBackController:PlayBackViewController = PlayBackViewController()
            playBackController.cameraSyscode = node.sysCode;
            self.navigationController?.pushViewController(playBackController, animated: true)
        }
        let threeAction: UIAlertAction = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.default) { (action) in
            
        }
        alertController.addAction(oneAction)
        alertController.addAction(twoAction)
        alertController.addAction(threeAction)
        //显示提示框
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showDescription(object:Any) {
//        [SVProgressHUD showErrorWithStatus:object[@"description"]];
//        [self performSelector:@selector(dismiss) withObject:nil afterDelay:delayTime];
    }
    
//    - (void)dismiss {
//    [SVProgressHUD dismiss];
//    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
