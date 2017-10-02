//
//  RemoteOpenDoorVC.swift
//  XHWLHouseOwner
//
//  Created by 柳玉豹 on 2017/9/21.
//  Copyright © 2017年 xinghaiwulian. All rights reserved.
//

import UIKit

class RemoteOpenDoorVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, XHWLNetworkDelegate {
    @IBOutlet weak var doorPickerView: UIPickerView!
    @IBOutlet weak var conformBtn: UIButton!

    var doors:NSMutableArray! = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        doorPickerView.dataSource = self
        doorPickerView.delegate = self
        //设置选择框的默认值
        doorPickerView.selectRow(self.selectedRow,inComponent:0,animated:true)
        doorPickerView.showsSelectionIndicator = false
        // Do any additional setup after loading the view.
        
        let backBtn:UIButton = UIButton()
        backBtn.frame = CGRect(x: 15, y: 20, width: 60, height: 44)
        backBtn.addTarget(self, action: #selector(onBack), for: .touchUpInside)
        backBtn.setImage(UIImage(named:"scan_back"), for: .normal)
        self.view.addSubview(backBtn)
        
        let titleLabel:UILabel = UILabel()
        titleLabel.frame = CGRect(x:0, y:0, width:self.view.bounds.size.width-150, height:44)
        titleLabel.center = CGPoint(x:self.view.bounds.size.width/2.0, y:42)
        titleLabel.text = "远程开门"
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.white
        titleLabel.font = font_14
        self.view.addSubview(titleLabel)
        
        getDoorList()
    }
    
    func onBack(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return doors.count
    }
    
//    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
//        <#code#>
//    }
    
    var selectedRow = 0
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
//        let pickedView = UIView()
        let pickedBtn = UIButton()
        
        let doorModel:XHWLDoorModel = self.doors[row] as! XHWLDoorModel
        let buildingModel:XHWLBuildingModel = doorModel.sysBuilding as XHWLBuildingModel
        let projectModel:XHWLProjectModel = buildingModel.sysProject as XHWLProjectModel
        
        pickedBtn.setTitle(doorModel.name+buildingModel.name, for: .normal)
        pickedBtn.setTitleColor(UIColor.white, for: .normal)
        if row == selectedRow{
            pickedBtn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
            pickedBtn.setBackgroundImage(UIImage(named: "Common_pickBg"), for: .normal)
        }else{
            pickedBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        }
        pickedBtn.titleLabel?.textAlignment = .center
        pickedBtn.isEnabled = false
        return pickedBtn
//        let viewlabel = UILabel()
//        viewlabel.text = self.doors[row]["name"]
////        viewlabel.textColor = UIColor(red: 82/255.0, green: 239/255.0, blue: 254/255.0, alpha: 1.0)
//        viewlabel.textColor = UIColor.white
//        if row == selectedRow{
//            viewlabel.font = UIFont.systemFont(ofSize: 20)
//        }else{
//            viewlabel.font = UIFont.systemFont(ofSize: 16)
//        }
//        viewlabel.textAlignment = .center
//        return viewlabel
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedRow = row
        self.doorPickerView.reloadAllComponents()
    }
    
    // 获取门列表
    func getDoorList() {
        if UserDefaults.standard.object(forKey: "project") != nil {
            let data:NSData = UserDefaults.standard.object(forKey: "user") as! NSData
            let dict:NSDictionary = data.mj_JSONObject() as! NSDictionary
            let userModel:XHWLUserModel = XHWLUserModel.mj_object(withKeyValues: dict)
            
            let projectData:NSData = UserDefaults.standard.object(forKey: "project") as! NSData// 项目
            let projectModel:XHWLProjectModel = XHWLProjectModel.mj_object(withKeyValues: projectData.mj_JSONObject())
            
            let params = ["wyAccountId": userModel.wyAccount.id,
                          "projectId":projectModel.id]
            XHWLNetwork.shared.postDoorListClick(params as NSDictionary, self)
        } else {
            
            "当前无项目".ext_debugPrintAndHint()
        }
    }
    
    //选中开门
    @IBAction func conformBtnClicked(_ sender: UIButton) {
//        self.conformBtn.isEnabled = false
        
        print("\(selectedRow)")
        let doorModel:XHWLDoorModel = self.doors[selectedRow] as! XHWLDoorModel
        let buildingModel:XHWLBuildingModel = doorModel.sysBuilding as XHWLBuildingModel
        let projectModel:XHWLProjectModel = buildingModel.sysProject as XHWLProjectModel
        
        let params = ["reqId": "test",
                      "upid":projectModel.entranceCode, // 项目编号（使用unitList数组中sysProject实体的entranceCode字段）
            "bldgId": buildingModel.code, // 楼栋编号（使用unitList数组中sysBuilding实体的code字段）
            "unitId": doorModel.code, // 单元编号（使用unitList数组中的code字段）
            "personType": "YZ"] // 人员类型（直接写YZ）
        
        
        XHWLNetwork.shared.postOpenDoorClick(params as NSDictionary, self)
    }
    
    //network代理的方法
    func requestSuccess(_ requestKey:NSInteger, _ response:[String : AnyObject]) {
        switch requestKey {
        case XHWLRequestKeyID.XHWL_OPENDOOR.rawValue:
//            self.conformBtn.isEnabled = true
            onRemoteOpenDoor(response)
            break
        case XHWLRequestKeyID.XHWL_DOORLIST.rawValue:
            
            self.doors = NSMutableArray()
            let dict:NSDictionary =  response["result"] as! NSDictionary
            let ary:NSArray = dict["unitList"] as! NSArray
            self.doors.addObjects(from: XHWLDoorModel.mj_objectArray(withKeyValuesArray:ary) as! [Any])
            self.doorPickerView.reloadAllComponents()
            selectedRow = 0
            
            break
        default:
            break
        }
        
    }
    
    //network代理的方法
    func requestFail(_ requestKey:NSInteger, _ error:NSError) {
//        self.conformBtn.isEnabled = true
    }
    
    func onRemoteOpenDoor(_ response:[String : AnyObject]){
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + TimeInterval(1)){
            self.dismiss(animated: true, completion: nil)
        }
        self.noticeSuccess("开门成功！", autoClearTime:1)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
