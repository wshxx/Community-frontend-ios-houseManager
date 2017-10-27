//
//  XHWLMcuPictureListVC.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/10/23.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLMcuPictureListVC: XHWLBaseVC , XHWLShowImageVCDelegate , XHWLNetworkDelegate {
    
    
    var warningView:XHWLPictureListView!
    lazy fileprivate var deleteBtn:UIButton = {
        let jumpBtn = UIButton()
        jumpBtn.setTitle("删除", for: .normal)
        jumpBtn.setTitleColor(color_09fbfe, for: UIControlState.normal)
        jumpBtn.titleLabel?.font = font_14
        jumpBtn.setBackgroundImage(UIImage(named:"btn_background"), for: UIControlState.normal)
        jumpBtn.addTarget(self, action: #selector(onDelete), for: .touchUpInside)
        jumpBtn.bounds = CGRect(x:0, y:0, width:Screen_width*0.4, height:30)
        jumpBtn.center = CGPoint(x:Screen_width/2.0, y:self.warningView.frame.maxY+50)
        jumpBtn.isHidden = true
        self.view.addSubview(jumpBtn)
        
        return jumpBtn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "编辑", style:.plain, target: self, action: #selector(onEdit))
        self.title = "云瞳监控"
        
        setupView()
        setupLoadData()
    }
    
    func setupLoadData() {
        
        let data:NSData = UserDefaults.standard.object(forKey: "user") as! NSData
        let userModel:XHWLUserModel = XHWLUserModel.mj_object(withKeyValues: data.mj_JSONObject())
        
        if UserDefaults.standard.object(forKey: "project") != nil {
            let projectData:NSData = UserDefaults.standard.object(forKey: "project") as! NSData// 项目
            let projectModel:XHWLProjectModel = XHWLProjectModel.mj_object(withKeyValues: projectData.mj_JSONObject())
            
            let param:NSArray = [userModel.wyAccount.token,
                                 projectModel.id]
            XHWLNetwork.shared.getVideoImgListClick(param, self)
        }
    }
    
//    rows =         (
//    {
//    id = 2;
//    imageUrl = "http://202.105.104.105:8006/appImagesFloder/image_1509106853.png";
//    sysProject =                 {
//    ccProjectCode = "ZH-0755-0101";
//    code = 201;
//    divisionName = "\U5e7f\U4e1c\U7701";
//    entranceCode = SZ0101;
//    id = "5ba97a83-8e1f-11e7-a2f9-4ccc6aeb6282";
//    latitude = "102.1233";
//    longitude = 101;
//    name = "\U6df1\U5733\U4e2d\U6d77\U534e\U5ead";
//    parkingCode = "";
//    patrolCode = "";
//    };
//    wyAccount =                 {
//    id = "04e771c5-62aa-4aef-98f5-4df92a411956";
//    isFirstLogin = n;
//    loginTime = 1509084368000;
//    name = 13543753374;
//    password = 670b14728ad9902aecba32e22fa4f6bd;
//    talkbackUUID = "";
//    token = "f53718b2-bc88-4082-a749-b7da562cda75";
//    weChat = "";
//    workCode = xhwl3375;
//    wyRole =                     {
//    code = AGM001;
//    id = "59b0ef1a-92e6-11e7-9069-fc4596942686";
//    name = "\U5b89\U7ba1\U4e3b\U4efb";
//    };
//    wyRoleName = "\U5b89\U7ba1\U4e3b\U4efb";
//    };
//    }
//    );
    
    // MARK: - XHWLNetworkDelegate
    
    func requestSuccess(_ requestKey:NSInteger, _ response:[String : AnyObject]) {
        
        if requestKey == XHWLRequestKeyID.XHWL_VIDEOIMGLIST.rawValue {
            //            if response["result"] is NSNull {
            //                return
            //            }
            //            let dict:NSDictionary = response["result"] as! NSDictionary
            //            //            let userProgressArray:NSArray = XHWLPatrolDetailModel.mj_objectArray(withKeyValuesArray:dict["userProgress"] as! NSArray)
            //            //            self.dataAry = NSMutableArray()
            //            realModel = XHWLPatrolDetailModel.mj_object(withKeyValues: dict["userProgress"] )
            //            //            self.dataAry.addObjects(from: userProgressArray as! [Any])
            //            self.tableView.reloadData()
        }
    }
    
    func requestFail(_ requestKey: NSInteger, _ error: NSError) {
        
    }
    
    func setupView() {
        
        warningView = XHWLPictureListView(frame:CGRect(x:Screen_width*3/32.0, y:Screen_height/6.0, width:Screen_width*13/16.0, height:Screen_height*2/3.0))
        warningView.jumpBlock = { _ in
            let vc:XHWLShowImageVC = XHWLShowImageVC()
            vc.showImage = UIImage(named:"2")!
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
        self.view.addSubview(warningView)
        
        self.view.addSubview(self.deleteBtn)
    }
    
    func onDeleteImage(_ image:UIImage) {
//        warningView.dataAry.remove()
        warningView.collectionView.reloadData()
    }
    
    func onEdit() {
        
        warningView.isEdit = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "取消", style:.plain, target: self, action: #selector(onCancel))
        self.deleteBtn.isHidden = false
    }
    
    func onCancel() {
        
        warningView.isEdit = false
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "编辑", style:.plain, target: self, action: #selector(onEdit))
        self.deleteBtn.isHidden = true
    }
    
    func onDelete() {
        
        onCancel()
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
