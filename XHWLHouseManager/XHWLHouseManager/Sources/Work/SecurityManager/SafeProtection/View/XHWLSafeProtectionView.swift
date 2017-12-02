//
//  XHWLSafeProtectionView.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/12.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit
import ELPickerView

class XHWLSafeProtectionView: UIView {
    
    var bgImage:UIImageView!
    var tipImg:UIImageView!
    var tipLabel:UILabel!
    var tableView:UITableView!
    var dataAry:NSMutableArray! = NSMutableArray()
    var dataSource:NSMutableArray! = NSMutableArray()
    var clickCell:(NSInteger, NSInteger, XHWLSafeProtectionModel)->(Void) = {param in }
    var selectIndex:NSInteger! = 0
    var topMenu:XHWLTopView!
    var handlerCode:String = ""
    var operatorCode:String = ""
    var remarks:String = ""
    var warningModel:XHWLSafeProtectionModel!
    lazy var customPickerView: ELCustomPickerView<String> = {
       let pickerV = ELCustomPickerView<String>(pickerType: .singleComponent, items: [])
        
        pickerV.rightButton.setTitle("确定", for: .normal)
        pickerV.leftButton.setTitle("取消", for: .normal)
        pickerV.title.text = "分配给"
        pickerV.foregroundView.picker.backgroundColor = UIColor.white
        pickerV.rightButton.setTitleColor(UIColor.black, for: .normal)
        pickerV.leftButton.setTitleColor(UIColor.black, for: .normal)
        
        return pickerV
    }()
//    var dataAry:NSArray = NSArray()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    // 请求接口
    func updateTop(_ index:NSInteger) {
        
//        if array.count > index {
//            let model:XHWLDeviceTitleModel = array[index] as! XHWLDeviceTitleModel
//            print("\(model.deviceAry)")
//            dataAry = model.deviceAry
//        }
    }
    
    func setupView() {
        
        bgImage = UIImageView()
        bgImage.image = UIImage(named:"menu_bg")
        self.addSubview(bgImage)
        
        let data:NSData = UserDefaults.standard.object(forKey: "user") as! NSData
        let userModel:XHWLUserModel = XHWLUserModel.mj_object(withKeyValues: data.mj_JSONObject())
        
        var array:NSArray  = NSArray()
        if userModel.wyAccount.wyRole.name == "安管主任" {
            array = ["待分配", "待处理", "待销项", "已销项"]
        }
        else {
            array = ["重大事件", "待分配", "待处理", "待销项", "已销项"]
        }
        topMenu = XHWLTopView.init(frame: CGRect.zero)
        topMenu.createArray(array: array)
        topMenu.btnBlock = {[weak self] index in
            self?.selectIndex = index
            self?.updateTop(index)
            self?.tableView.reloadData()
        }
        self.addSubview(topMenu)
        
        tableView = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.showsVerticalScrollIndicator = false
        self.addSubview(tableView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let img = UIImage(named:"warning_subview_top_bg")!
//        topMenu.frame =  CGRect(x:0, y:0, width:img.size.width, height:img.size.height)
        topMenu.frame =  CGRect(x:0, y:0, width:self.bounds.size.width, height:img.size.height)
        bgImage.frame = CGRect(x:14.5, y:56, width:self.bounds.size.width-29, height:self.frame.size.height-56)
        tableView.frame = CGRect(x:14, y:topMenu.frame.maxY, width:self.bounds.size.width-28, height:self.frame.size.height-topMenu.frame.maxY-14)
    }
    
   
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension XHWLSafeProtectionView: XHWLRegistrationCellDelegate {
    // 底部弹出界面
    func registrationWithHandle(_ cell:XHWLRegistrationCell, _ warningModel:XHWLSafeProtectionModel) {

        self.warningModel = warningModel
        let data:NSData = UserDefaults.standard.object(forKey: "user") as! NSData
        let dict:NSDictionary = data.mj_JSONObject() as! NSDictionary
        let userModel:XHWLUserModel = XHWLUserModel.mj_object(withKeyValues: dict)
        
        guard let projectData:NSData = UserDefaults.standard.object(forKey: "project") as? NSData else {
            
            "当前无项目".ext_debugPrintAndHint()
            return
        }
        let projectModel:XHWLProjectModel = XHWLProjectModel.mj_object(withKeyValues: projectData.mj_JSONObject())
        
        let params:NSDictionary = [
            "token":userModel.wyAccount.token, //    string    否    用户登录token； web端不用传，app传；
            "projectCode":projectModel.projectCode, //
        ]
        XHWLNetwork.shared.postAccountInfoClick(params, self)
    }
}

// MARK: - XHWLNetworkDelegate
extension XHWLSafeProtectionView: XHWLNetworkDelegate {
    
    func requestSuccess(_ requestKey:NSInteger, _ response:[String : AnyObject]) {
        
        if requestKey == XHWLRequestKeyID.XHWL_ACCOUNTINFO.rawValue {
            print("\(response)")
            
            let dealArray:NSArray = XHWLChannelRoleModel.mj_objectArray(withKeyValuesArray:response["result"] as! NSArray )
            
            let array:NSMutableArray = NSMutableArray()
            for i in 0..<dealArray.count {
                let model = dealArray[i] as! XHWLChannelRoleModel
                array.add(model.name)
            }
          
            customPickerView.items = array as! [String] // ["黄浩婷", "张浩然", "徐柳飞", "阳城"]
            customPickerView.show(viewController: nil, animated: true)
            
            // 确定
            customPickerView.rightButtoTapHandler = { [weak self] (view, chosenIndex, chosenItem) in
                let hide = true
                let animated = true
                
                let model:XHWLChannelRoleModel = dealArray[chosenIndex] as! XHWLChannelRoleModel
                let str = "Did Tap Left Button. <Index: \(chosenIndex)> <chosenItem: \(chosenItem)> <Hide: \(hide)> <Animated: \(animated)>"
                //            self?.logLabel.text = str
                print(str + "asdbf \(model.name)")
                
                let data:NSData = UserDefaults.standard.object(forKey: "user") as! NSData
                let dict:NSDictionary = data.mj_JSONObject() as! NSDictionary
                let userModel:XHWLUserModel = XHWLUserModel.mj_object(withKeyValues: dict)
                
                let handlerCode:String = ""
                let operatorCode:String = model.id
                
                let params:NSDictionary = [
                    "token":userModel.wyAccount.token, //    string    否    用户登录token； web端不用传，app传；
                    "handlerCode":handlerCode, //    int    是    处理人工号
                    "operatorCode":operatorCode, //     boolean    是    分配人工号
                    "warningId":self?.warningModel.id, //     int    是    报事id
                    "remarks":self?.remarks //     String    否    备注
                ]
                XHWLNetwork.shared.postWarningListClick(params, self!)
                
                return (hide, animated)
            }
            // 取消
            customPickerView.leftButtoTapHandler = { [weak self] (view, chosenIndex, chosenItem) in
                let hide = true
                let animated = true
                let str = "Did Tap Left Button. <Index: \(chosenIndex)> <chosenItem: \(chosenItem)> <Hide: \(hide)> <Animated: \(animated)>"
                //            self?.logLabel.text = str
                print(str)
                return (hide, animated)
            }
        } else if requestKey == XHWLRequestKeyID.XHWL_SAFEGUARDSUBMIT.rawValue {
            
            print("\(response)")
            
           
        }
    }
    
    func requestFail(_ requestKey:NSInteger, _ error:NSError) {
        
    }
}

extension XHWLSafeProtectionView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataAry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: XHWLRegistrationCell = XHWLRegistrationCell.cellWithTableView(tableView: tableView)
       
        cell.delegate = self
        let model:XHWLSafeProtectionModel = dataAry[indexPath.row] as! XHWLSafeProtectionModel
        cell.warningModel = model
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let model:XHWLSafeProtectionModel = dataAry[indexPath.row] as! XHWLSafeProtectionModel
        self.clickCell(selectIndex, indexPath.row, model)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
}

