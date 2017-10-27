//
//  XHWLMcuListVC.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/10/19.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLMcuListVC: XHWLBaseVC, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate {
    
    var parentNode:MCUResourceNode? /**< 父节点*/
    var tableView:UITableView = UITableView()
    var resourceArray:NSMutableArray = NSMutableArray()
    var backBlock:(NSArray, Bool)->Void = {param in }
    var projectMcuModel:XHWLMcuModel!
    var bgImage:UIImageView!
    var isBackData:Bool = false
    var isSingleSelect:Bool = false {
        willSet {
            if isSingleSelect {
                self.okBtn.isHidden = true
                tableView = UITableView(frame: CGRect(x:0, y:64, width:Screen_width, height:CGFloat(Screen_height-64)))
            } else {
                self.okBtn.isHidden = false
                
                tableView = UITableView(frame: CGRect(x:0, y:64, width:Screen_width, height:CGFloat(Screen_height-64-49)))
            }
        }
    }
    var selectAry:NSMutableArray = NSMutableArray()
    var selectNode:MCUResourceNode?
    
    lazy fileprivate var okBtn:UIButton = {
        let jumpBtn = UIButton()
        jumpBtn.setTitle("确定", for: .normal)
        jumpBtn.setTitleColor(color_09fbfe, for: UIControlState.normal)
        jumpBtn.titleLabel?.font = font_14
        jumpBtn.setBackgroundImage(UIImage(named:"btn_background"), for: UIControlState.normal)
        jumpBtn.addTarget(self, action: #selector(onOKClick), for: .touchUpInside)
        jumpBtn.bounds = CGRect(x:0, y:0, width:Screen_width*0.4, height:30)
        jumpBtn.center = CGPoint(x:Screen_width/2.0, y:self.tableView.frame.maxY+50)
        
        return jumpBtn
    }()
    
    func onOKClick() {

        let isLogin:Bool = UserDefaults.standard.bool(forKey: "isLogin")
        if isLogin == true {
            if selectAry.count <= 0 {
                "请先选择要展示的视频".ext_debugPrintAndHint()
                return
            }
            
            if self.isBackData == true {
                self.backBlock(selectAry, self.isSingleSelect)
                self.navigationController?.popViewController(animated: true)
            } else {
                let vc = XHWLMcuShowVC() // selectAry
                vc.selectAry = selectAry
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let isLogin:Bool = UserDefaults.standard.bool(forKey: "isLogin")
        if isLogin == false {
            loginButtonClicked()
        }
        
        self.initUI()
        setupData()
        setupList()
    }
    
    func setupData() {
        let array:NSArray = [["nodeType":2, "nodeID":"118", "nodeName":"深圳中海华庭"],
                             ]
        let modelAry:NSArray = XHWLMcuModel.mj_objectArray(withKeyValuesArray: array)
        
        if UserDefaults.standard.object(forKey: "project") != nil {
            let projectData:NSData = UserDefaults.standard.object(forKey: "project") as! NSData// 项目
            let projectModel:XHWLProjectModel = XHWLProjectModel.mj_object(withKeyValues: projectData.mj_JSONObject())
            
            for i in 0..<modelAry.count {
                let model:XHWLMcuModel = modelAry[i] as! XHWLMcuModel
                if projectModel.name == model.nodeName {
                    projectMcuModel = model
                    return
                }
            }
        }
    }
    
    func setupList() {
        
        let isLogin:Bool = UserDefaults.standard.bool(forKey: "isLogin")
        if isLogin == true {
            if projectMcuModel != nil {
                self.requestResource(projectMcuModel.nodeID, projectMcuModel.nodeType)
            } else {
                "当前项目无资源".ext_debugPrintAndHint()
            }
        }
    }
    
    // MARK: - 点击登录按钮
    /**
     *  点击登录按钮
     */
    func loginButtonClicked() {
        
        let password:String = MSP_PASSWORD.md5
        
        //调用 登录平台接口,完成登录操作
        //注意:登录密码必须是经过MD5加密的
        MCUVmsNetSDK.shareInstance().loginMsp(withUsername: MSP_USERNAME, password: password, success: { (responseDic) in
            
            let obj:NSDictionary = responseDic as! NSDictionary
            let status:String = obj["status"] as! String
            
            if (status.compare("200").rawValue == 0) {
                UserDefaults.standard.set(true, forKey: "isLogin")
                UserDefaults.standard.synchronize()
                self.setupList()
            } else {
                
                "登陆失败".ext_debugPrintAndHint()
                print("登陆失败")
                UserDefaults.standard.set(false, forKey: "isLogin")
                UserDefaults.standard.synchronize()
                //返回码为200,代表登录成功.返回码为202,203,204时,分别代表的意思是初始密码登录,密码强度不符合要求,密码过期.这三种情况都需要修改密码.请开发者使用当前账号登录BS端平台,按要求进行密码修改后,再进行APP的开发测试工作.其他返回码,请根据平台返回提示信息进行提示或处理
                //    [SVProgressHUD showErrorWithStatus:responseDic[@"description"]];
            }
        }) { (error) in
            
            "服务器连接失败".ext_debugPrintAndHint()
            print("登陆请求失败")
        }
    }
    
    func initUI() {
        self.title = "云瞳监控列表"
        
        bgImage = UIImageView()
        bgImage.bounds = CGRect(x:0, y:0, width:Screen_width*13/16.0, height:Screen_height*2/3.0)
        bgImage.center = CGPoint(x:self.view.frame.size.width/2.0, y:self.view.frame.size.height/2.0)
        bgImage.image = UIImage(named:"subview_bg")
        self.view.addSubview(bgImage)
        
        tableView = UITableView(frame: CGRect(x:0, y:64, width:Screen_width, height:CGFloat(Screen_height-64)))
        tableView.bounds = CGRect(x:0, y:0, width:Screen_width*13/16.0, height:Screen_height*2/3.0)
        tableView.center = CGPoint(x:self.view.frame.size.width/2.0, y:self.view.frame.size.height/2.0)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
        tableView.showsVerticalScrollIndicator = false
        tableView.tableFooterView = UIView()
        self.view.addSubview(tableView)
        
        if isSingleSelect == false {
            self.view.addSubview(self.okBtn)
        }
    }
    
    // MARK: - UITableViewDelegate & UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resourceArray.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:XHWLMcuCell = XHWLMcuCell.cellWithTableView(tableView)
        
        let node:XHWLMcuModel = resourceArray[indexPath.row] as! XHWLMcuModel
        cell.node = node
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.isSingleSelect == true {

            let node:XHWLMcuModel = self.resourceArray[indexPath.row] as! XHWLMcuModel
            self.backBlock([node], self.isSingleSelect)
            self.navigationController?.popViewController(animated: true)
        } else {
            
            let node:XHWLMcuModel = self.resourceArray[indexPath.row] as! XHWLMcuModel
            if node.isSelected == true {
                node.isSelected = false
                self.resourceArray.replaceObject(at: indexPath.row, with: node)
                selectAry.remove(node)
            } else {
                if selectAry.count < 2 {
                    node.isSelected = true
                    self.resourceArray.replaceObject(at: indexPath.row, with: node)
                    selectAry.add(node)
                } else {
                    "一次最多只能展示两个视频".ext_debugPrintAndHint()
                }
            }
            self.tableView.reloadData()
        }
    }
    
    /**
     *  请求资源点列表数据
     */
    
    //  1.  nodeID:8 nodeType:1
    
    // 深圳中海华庭: 2.  nodeID:22 nodeType:1
    //    3.  nodeID:8 nodeType:2
    //    4.  nodeID:118  nodeType:2
    
    func requestResource(_ nodeID:String, _ nodeType:Int) {
        
        MCUVmsNetSDK.shareInstance().requestResource(withSysType: 1,
                                                     nodeType: nodeType,
                                                     currentID: nodeID ,
                                                     numPerPage: 100,
                                                     curPage: 1,
                                                     success: { (object) in
                                                        
                                                        let obj:NSDictionary = object as! NSDictionary
                                                        let status:String = obj["status"] as! String
                                                        
                                                        if (status.compare("200").rawValue == 0) {
                                                            let array = obj["resourceNodes"] as! NSArray
                                                            self.resourceArray = NSMutableArray()
                                                            for i in 0..<array.count {
                                                                let model:MCUResourceNode = array[i] as! MCUResourceNode
                                                                let mcuModel:XHWLMcuModel = XHWLMcuModel()
                                                                mcuModel.nodeName = model.nodeName
                                                                mcuModel.nodeType = NSInteger(model.nodeType.rawValue)
                                                                mcuModel.nodeID = model.nodeID
                                                                mcuModel.parentNodeID = model.parentNodeID
                                                                mcuModel.sysCode = model.sysCode
                                                                mcuModel.userCapability = model.userCapability
                                                                mcuModel.cascadeFlag = model.cascadeFlag
                                                                mcuModel.isOnline = model.isOnline
                                                                mcuModel.isSelected = false
                                                                self.resourceArray.add(mcuModel)
                                                            }
                                                            
                                                            self.selectAry = NSMutableArray()
                                                            
                                                            print("self.resourceArray: \(self.resourceArray)")
                                                            if self.resourceArray.count > 0 {
                                                                self.tableView.reloadData()
                                                            } else {
                                                                //                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                                //                        [SVProgressHUD showErrorWithStatus:@"暂无资源"];
                                                                //                        });
                                                            }
                                                        }
        }) { (error) in
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
//            let node:MCUResourceNode = self.resourceArray[row] as! MCUResourceNode
            
//            self.backBlock(node.sysCode)
            //            self.navigationController?.popViewController(animated: true)
            
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
    
    // MARK: - private method
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
                
//                parentNode: Optional(MCUResourceNode description:<MCUResourceNode: 0x12d83dcc0>
//                nodeID:8
//                nodeName:中海物业集团
//                parentNodeID:0
//                nodeType:1
//                sysCode:(null)
//                userCapability:(null)
//                cascadeFlag:0
//                isOnline:0)
            } else {
                self.showDescription(object: obj)
            }
        }) { (error) in
            
        }
    }
    
//    \nnodeID:1\nnodeName:\U4e2d\U6d77\U7269\U4e1a\U603b\U90e8\nparentNodeID:8\nnodeType:2\nsysCode:(null)\nuserCapability:(null)\ncascadeFlag:0\nisOnline:0",
//   \nnodeID:22\nnodeName:\U4e2d\U6d77\U7269\U4e1a\U7ba1\U7406\U6709\U9650\U516c\U53f8\U6df1\U5733\U5206\U516c\U53f8\nparentNodeID:8\nnodeType:1\nsysCode:(null)\nuserCapability:(null)\ncascadeFlag:0\nisOnline:0",
//  \nnodeID:23\nnodeName:\U4e2d\U6d77\U7269\U4e1a\U7ba1\U7406\U6709\U9650\U516c\U53f8\U5317\U4eac\U5206\U516c\U53f8\nparentNodeID:8\nnodeType:1\nsysCode:(null)\nuserCapability:(null)\ncascadeFlag:0\nisOnline:0",
//  nodeID:25\nnodeName:\U4e2d\U6d77\U7269\U4e1a\U7ba1\U7406\U6709\U9650\U516c\U53f8\U6210\U90fd\U5206\U516c\U53f8\nparentNodeID:8\nnodeType:1\nsysCode:(null)\nuserCapability:(null)\ncascadeFlag:0\nisOnline:0",
//    "MCUResourceNode description:<MCUResourceNode: 0x12d8dba30>\nnodeID:26\nnodeName:\U4e2d\U6d77\U7269\U4e1a\U7ba1\U7406\U6709\U9650\U516c\U53f8\U4f5b\U5c71\U5206\U516c\U53f8\nparentNodeID:8\nnodeType:1\nsysCode:(null)\nuserCapability:(null)\ncascadeFlag:0\nisOnline:0",
//    "MCUResourceNode description:<MCUResourceNode: 0x12d8dcdf0>\nnodeID:27\nnodeName:\U4e2d\U6d77\U7269\U4e1a\U7ba1\U7406\U6709\U9650\U516c\U53f8\U5e7f\U5dde\U5206\U516c\U53f8\nparentNodeID:8\nnodeType:1\nsysCode:(null)\nuserCapability:(null)\ncascadeFlag:0\nisOnline:0",
//    "MCUResourceNode description:<MCUResourceNode: 0x12d8ddda0>\nnodeID:31\nnodeName:\U4e2d\U6d77\U7269\U4e1a\U7ba1\U7406\U6709\U9650\U516c\U53f8\U4e0a\U6d77\U5206\U516c\U53f8\nparentNodeID:8\nnodeType:1\nsysCode:(null)\nuserCapability:(null)\ncascadeFlag:0\nisOnline:0",
//    "MCUResourceNode description:<MCUResourceNode: 0x12d8decf0>\nnodeID:32\nnodeName:\U4e2d\U6d77\U7269\U4e1a\U7ba1\U7406\U6709\U9650\U516c\U53f8\U6c88\U9633\U5206\U516c\U53f8\nparentNodeID:8\nnodeType:1\nsysCode:(null)\nuserCapability:(null)\ncascadeFlag:0\nisOnline:0",
//    "MCUResourceNode description:<MCUResourceNode: 0x12d8e00f0>\nnodeID:34\nnodeName:\U4e2d\U6d77\U7269\U4e1a\U7ba1\U7406\U6709\U9650\U516c\U53f8\U897f\U5b89\U5206\U516c\U53f8\nparentNodeID:8\nnodeType:1\nsysCode:(null)\nuserCapability:(null)\ncascadeFlag:0\nisOnline:0",
//    "MCUResourceNode description:<MCUResourceNode: 0x12d8e10c0>\nnodeID:35\nnodeName:\U4e2d\U6d77\U7269\U4e1a\U7ba1\U7406\U6709\U9650\U516c\U53f8\U957f\U6625\U5206\U516c\U53f8\nparentNodeID:8\nnodeType:1\nsysCode:(null)\nuserCapability:(null)\ncascadeFlag:0\nisOnline:0",
//    "MCUResourceNode description:<MCUResourceNode: 0x12d8e31e0>\nnodeID:36\nnodeName:\U4e2d\U6d77\U7269\U4e1a\U7ba1\U7406\U6709\U9650\U516c\U53f8\U91cd\U5e86\U5206\U516c\U53f8\nparentNodeID:8\nnodeType:1\nsysCode:(null)\nuserCapability:(null)\ncascadeFlag:0\nisOnline:0"
    
  

    
    func requestResource() {
        
        print("parentNode: \(self.parentNode)")
        MCUVmsNetSDK.shareInstance().requestResource(withSysType: 1,
                                                     nodeType: Int(parentNode!.nodeType.rawValue),
                                                     currentID: parentNode?.nodeID ,
                                                     numPerPage: 100,
                                                     curPage: 1,
                                                     success: { (object) in
                                                        
                                                        let obj:NSDictionary = object as! NSDictionary
                                                        let status:String = obj["status"] as! String
                                                        
                                                        if (status.compare("200").rawValue == 0) {
//                                                            self.resourceArray = obj["resourceNodes"] as! NSArray
                                                            
                                                            print("self.resourceArray: \(self.resourceArray)")
                                                            if self.resourceArray.count > 0 {
                                                                self.tableView.reloadData()
                                                            } else {
                                                                //                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                                //                        [SVProgressHUD showErrorWithStatus:@"暂无资源"];
                                                                //                        });
                                                            }
                                                        }
        }) { (error) in
            //            NSLog(@"requestResource failed");
        }
    }
    
   
    
    func showDescription(object:Any) {
        //        [SVProgressHUD showErrorWithStatus:object[@"description"]];
        //        [self performSelector:@selector(dismiss) withObject:nil afterDelay:delayTime];
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
