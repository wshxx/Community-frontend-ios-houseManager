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

    var doors = [
        ["name": "测试大门", "upid":"DaMen2", "doorId":"83886523"],
        ["name": "未来海岸1单元大门", "upid":"DaMen2", "doorId":"83886523"],
        ["name": "中海华庭4单元大门", "upid":"DaMen2", "doorId":"83886523"]
    ]
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
    
    var selectedRow = 1
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
//        let pickedView = UIView()
        let pickedBtn = UIButton()
        pickedBtn.setTitle(self.doors[row]["name"], for: .normal)
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
    
    //选中开门
    @IBAction func conformBtnClicked(_ sender: UIButton) {
        self.conformBtn.isEnabled = false
        let params = ["reqId": "test", "upid": doors[selectedRow]["upid"], "doorId": doors[selectedRow]["doorId"]]
        XHWLNetwork.shared.postOpenDoorClick(params as NSDictionary, self)
    }
    
    //network代理的方法
    func requestSuccess(_ requestKey:NSInteger, _ response:[String : AnyObject]) {
        switch requestKey {
        case XHWLRequestKeyID.XHWL_OPENDOOR.rawValue:
            onRemoteOpenDoor(response)
            break
        default:
            break
        }
        
    }
    
    //network代理的方法
    func requestFail(_ requestKey:NSInteger, _ error:NSError) {
        
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
