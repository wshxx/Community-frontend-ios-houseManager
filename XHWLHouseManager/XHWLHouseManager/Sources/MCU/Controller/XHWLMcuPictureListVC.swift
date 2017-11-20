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
    var deleteImageAry:NSMutableArray! = NSMutableArray()
    var isSingleDelete:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "编辑", style:.plain, target: self, action: #selector(onEdit))
        self.title = "云瞳监控"
        
        setupView()
        setupLoadData()
    }
    
    func onDeleteData() {
        
        let data:NSData = UserDefaults.standard.object(forKey: "user") as! NSData
        let userModel:XHWLUserModel = XHWLUserModel.mj_object(withKeyValues: data.mj_JSONObject())
        
        var imageId:String = ""
        for i in 0..<deleteImageAry.count {
            let model:XHWLMcuPictureModel = deleteImageAry[i] as! XHWLMcuPictureModel
            imageId = imageId + "," + model.id
        }
        if !imageId.isEmpty {
            imageId = imageId.substring(from: String.Index(1))
        }
        let param:NSDictionary = ["token":userModel.wyAccount.token,
                                  "imageId":imageId]
        XHWLNetwork.shared.postDeleteVideoImgClick(param, self)
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

    // MARK: - XHWLNetworkDelegate
    
    func requestSuccess(_ requestKey:NSInteger, _ response:[String : AnyObject]) {
        
        if requestKey == XHWLRequestKeyID.XHWL_VIDEOIMGLIST.rawValue {
                        if response["result"] is NSNull {
                            return
                        }
            let dict:NSDictionary = response["result"] as! NSDictionary
            let array:NSArray = XHWLMcuPictureModel.mj_objectArray(withKeyValuesArray: dict["rows"])
            warningView.collectAry = NSMutableArray()
            warningView.collectAry.addObjects(from: array as! [Any])
            warningView.collectionView.reloadData()
        }
        else if requestKey == XHWLRequestKeyID.XHWL_DELETEVIDEOIMG.rawValue {
            
            "删除图片成功".ext_debugPrintAndHint()
            let model:XHWLMcuPictureModel = deleteImageAry[0] as! XHWLMcuPictureModel
//            warningView.collectAry.remove(model)
            warningView.collectAry.removeObjects(in: deleteImageAry as! [Any])
            warningView.collectionView.reloadData()
            if isSingleDelete {
                
            } else {
                onCancel()
            }
        }
    }
    
    func requestFail(_ requestKey: NSInteger, _ error: NSError) {
        
    }
    
    func setupView() {
        
        warningView = XHWLPictureListView(frame:CGRect(x:Screen_width*3/32.0, y:Screen_height/6.0, width:Screen_width*13/16.0, height:Screen_height*2/3.0))
        warningView.jumpBlock = { model in
            let vc:XHWLShowImageVC = XHWLShowImageVC()
            vc.pictureModel = model
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
        self.view.addSubview(warningView)
        self.view.addSubview(self.deleteBtn)
    }
    
    func onDeleteImage(_ model:XHWLMcuPictureModel) {
        isSingleDelete = true
        deleteImageAry = NSMutableArray()
        deleteImageAry.add(model)
        onDeleteData()
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
        
        if warningView.deleteAry.count > 0 {
            isSingleDelete = false
            deleteImageAry = NSMutableArray()
            deleteImageAry.addObjects(from: warningView.deleteAry as! [Any])
            onDeleteData()
        } else {
            "请先选择要删除的图片".ext_debugPrintAndHint()
        }
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
