//
//  BluetoothVC.swift
//  XHWLHouseOwner
//
//  Created by 柳玉豹 on 2017/9/19.
//  Copyright © 2017年 xinghaiwulian. All rights reserved.
//

import UIKit
import CoreBluetooth
import CardReaderSDK

class BluetoothVC: UIViewController,UITableViewDelegate, UITableViewDataSource , XHWLNetworkDelegate {

    var deleteIndexPath:NSIndexPath?
    @IBOutlet weak var addDoorOpenView: UIView!
    
    var deviceAry:NSMutableArray! = NSMutableArray()
    var curDevice:XHWLBluetoothModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"scan_back"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(onBack))
        self.bluetoothTableView.delegate = self
        self.bluetoothTableView.dataSource = self
        loadBindCardLog()
        
        //初始化
        CardReaderAPI.Init()
    }
    
    func onBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func loadBindCardLog() {
        
        let data:NSData = UserDefaults.standard.object(forKey: "user") as! NSData
        let userModel:XHWLUserModel = XHWLUserModel.mj_object(withKeyValues: data.mj_JSONObject())
        
        XHWLNetwork.shared.getBindCardLogClick([userModel.wyAccount.id, "ios"], self) // accountId
    }
    
    // MARK: - XHWLNetworkDelegate
    func requestSuccess(_ requestKey:NSInteger, _ response:[String : AnyObject]) {
        
        if requestKey == XHWLRequestKeyID.XHWL_BINDCARDLOG.rawValue {
            
            
            let dict = response["result"] as! NSDictionary
            let dictAry:NSArray = dict["rows"] as! NSArray
            
            self.deviceAry = NSMutableArray()
            self.deviceAry.addObjects(from: XHWLBluetoothModel.mj_objectArray(withKeyValuesArray: dictAry) as! [Any])
            self.bluetoothTableView.reloadData()
        }
        else if requestKey == XHWLRequestKeyID.XHWL_DELETECARDLOG.rawValue {
            if response["state"] as! Bool == true{
                self.deviceAry.removeObject(at: (deleteIndexPath?.row)!)
                self.bluetoothTableView.deleteRows(at: [deleteIndexPath! as IndexPath], with: .fade)
//                self.bluetoothTableView.reloadData()
            }
        }
    }
    
    func requestFail(_ requestKey:NSInteger, _ error:NSError) {
        
    }
    
    class DeviceRecord {
        init(_ name: String, mac: String) {
            self.name = name
            self.mac = mac
        }
        
        var name: String
        var mac: String
        var cardNo: String?
    }
    
    @IBOutlet weak var bluetoothTableView: UITableView!
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.deviceAry!.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let bluetoothModel:XHWLBluetoothModel = self.deviceAry[indexPath.row] as! XHWLBluetoothModel
        self.curDevice = bluetoothModel
        
//        self.bluetoothTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let bluetoothModel:XHWLBluetoothModel = self.deviceAry[indexPath.row] as! XHWLBluetoothModel
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "localBluetoothCell") as! LocalBlueToothTableViewCell
        cell.localDeviceName.text = bluetoothModel.name
        cell.getWhcihCellBlock = { curCell in
            
            XHMLProgressHUD.shared.show()
            self.open(device: bluetoothModel)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // 要显示自定义的action,cell必须处于编辑状态
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .normal, title: "删除") { action, index in
            //取出user的信息
            let data = UserDefaults.standard.object(forKey: "user") as? NSData
            let userModel = XHWLUserModel.mj_object(withKeyValues: data?.mj_JSONObject())
            
            let bluetoothModel:XHWLBluetoothModel = self.deviceAry[indexPath.row] as! XHWLBluetoothModel
            
            let device = DeviceRecord(bluetoothModel.name, mac: bluetoothModel.address)
            device.cardNo = bluetoothModel.currentCardStr
            
            self.deleteIndexPath = indexPath as NSIndexPath
            
            let params = ["address": device.mac, "accountId": userModel?.wyAccount.id, "systemType":"ios"]
            
            XHWLNetwork.shared.postDeleteCardLogClick(params as NSDictionary, self)
        }
        delete.backgroundColor = UIColor.clear
        
        return [delete]
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        addDoorOpenView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addDoorOpenBtnClicked))
        tapGesture.numberOfTapsRequired = 1
        addDoorOpenView.addGestureRecognizer(tapGesture)
    }
    
    @IBAction func addDoorOpenBtnClicked(_ sender: UIButton) {
        //暂时跳到云对讲
        let vc:BluetoothScanVC = self.storyboard?.instantiateViewController(withIdentifier: "BluetoothScanVC") as! BluetoothScanVC
        vc.backBlock = { [weak self] _ in
            self?.loadBindCardLog()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //开门
    func open(device: XHWLBluetoothModel){
        // autoDisconnect: false，不自动断开连接，可以手动屌用Stop方法断开连接
        
        let array:NSArray = device.address.components(separatedBy: ":") as NSArray
        let mac:String = array.componentsJoined(by: "").lowercased()
        let cardNo:String =  device.currentCardStr.lowercased()
        print("\(mac) =  \(cardNo)")
        
        CardReaderAPI.OpenDoor(mac, cardNO:cardNo , timeOut: 10, autoDisconnect: true, callback: {(err) -> Void in
            
            XHMLProgressHUD.shared.hide()
            if err == nil {
                
                "开门成功".ext_debugPrintAndHint()
            }else{
                self.noticeError(err!.description!)
            }
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
