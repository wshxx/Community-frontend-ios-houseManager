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

class BluetoothVC: UIViewController,UITableViewDelegate, UITableViewDataSource {

    let macNo = "20c38ff4ffe0"
    let cardNo = "41516039624d0cb4c0f1b5e7"
    @IBOutlet weak var addDoorOpenView: UIView!
    
    var devices:[DeviceRecord] = []
    var curDevice:DeviceRecord? = nil
//    {
//        didSet {
//            if self.curDevice == nil {
//                self.btnBind.isEnabled = false
//                self.btnOpen.isEnabled = false
//                self.btnStop.isEnabled = false
//            }else{
//                self.btnBind.isEnabled = true
//                self.btnStop.isEnabled = true
//                if self.curDevice?.cardNo == nil {
//                    self.btnOpen.isEnabled = false
//                }else{
//                    self.btnOpen.isEnabled = true
//                }
//            }
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"scan_back"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(onBack))
        self.bluetoothTableView.delegate = self
        self.bluetoothTableView.dataSource = self
        initDevices()
        
        //初始化
        CardReaderAPI.Init()
        
    }
    
    func onBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func initDevices(){
        let device = DeviceRecord("测试",mac: "20c38ff4ffe0")
        device.cardNo = "b6e997df0864cbd51411dcd5"
        self.devices.append(device)
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
    
    
    
//    //开始扫描
//    func scan(){
//        self.curDevice = nil
//        self.devices = []
//        self.bluetoothTableView.reloadData()
//        
//        CardReaderAPI.StartScan({ (adv) in
//            var isFound = false
//            for item in self.devices {
//                if(item.mac == adv.mac){
//                    isFound = true
//                }
//            }
//            
//            if !isFound {
//                print("name: \(adv.name)")
//                let device = DeviceRecord(adv.name, mac: adv.mac)
//                self.devices.append(device)
//                if self.curDevice == nil {
//                    self.curDevice = device
//                }
//                
//                self.bluetoothTableView.reloadData()
//            }
//        }, callback: {(err)->Void in
//            if err != nil {
//                self.noticeError(err!.description!)
//            }else{
//                print("扫描结束")
//            }
//        })
//    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.devices.count
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let device = self.devices[indexPath.row]
        self.curDevice = device
        
        self.bluetoothTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let device = self.devices[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "localBluetoothCell") as! LocalBlueToothTableViewCell
        cell.localDeviceName.text = device.name
        cell.getWhcihCellBlock = { curCell in
            //            self.pleaseWaitWithMsg("正在开门中……")
            XHMLProgressHUD.shared.show()
            
            self.open(device: device)
        }
//        cell.localOpenDoorBtn.addTarget(self, action: #selector(self.open(_:)), for: .touchUpInside)
        
        return cell
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
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "BluetoothScanVC")
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    //开门
    func open(device: DeviceRecord){
        // autoDisconnect: false，不自动断开连接，可以手动屌用Stop方法断开连接
        CardReaderAPI.OpenDoor(device.mac, cardNO: device.cardNo!, timeOut: 10, autoDisconnect: true, callback: {(err) -> Void in
            
            XHMLProgressHUD.shared.hide()
            if err == nil {
                
//                self.noticeSuccess("开门成功")
                "开门成功".ext_debugPrintAndHint()
                
            }else{
                self.noticeError(err!.description!)
            }
        })
    }
    
    @IBAction func returnBtnClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
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
