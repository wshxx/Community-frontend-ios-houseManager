//
//  XHWLBluetoothAuthView.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/14.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit
import CoreBluetooth
import CardReaderSDK

class XHWLBluetoothAuthView: UIView , UITableViewDelegate, UITableViewDataSource {
    
    var bgImage:UIImageView!
    var tipImg:UIImageView!
    var tipLabel:UILabel!
    var tableView:UITableView!
    var clickCell:(NSInteger)->(Void) = {param in }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //初始化
        CardReaderAPI.Init()
        
        self.curDevice = nil
        
        setupView()
    }
    
//    class func nsdataToHexString(_ data:Data?) ->String?{
//        if data == nil || data!.count == 0{
//            return nil
//        }
//        var hexString = ""
//        let buff = UnsafeMutablePointer<UInt8>.allocate(capacity: data!.count)
//        (data! as NSData).getBytes(buff, length: data!.count)
//        
//        for i in 0..<data!.count{
//            hexString += String(format: "%02x",buff[i])
//        }
//        buff.deallocate(capacity: data!.count)
//        return hexString
//    }
    
    class DeviceRecord {
        init(_ name: String, mac: String) {
            self.name = name
            self.mac = mac
        }
        
        var name: String
        var mac: String
        var cardNo: String?
    }
    
    var devices:[DeviceRecord] = []
    var curDevice:DeviceRecord? = nil {
        didSet {
            if self.curDevice == nil {
//                self.btnBind.isEnabled = false
//                self.btnOpen.isEnabled = false
//                self.btnStop.isEnabled = false
            }else{
//                self.btnBind.isEnabled = true
//                self.btnStop.isEnabled = true
                if self.curDevice?.cardNo == nil {
//                    self.btnOpen.isEnabled = false
                }else{
//                    self.btnOpen.isEnabled = true
                }
            }
        }
    }
    
    func setupView() {
        
        bgImage = UIImageView()
        bgImage.image = UIImage(named:"menu_bg")
        self.addSubview(bgImage)
        
        tableView = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.addSubview(tableView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bgImage.frame = self.bounds
        tableView.frame = CGRect(x:0, y:0, width:self.bounds.size.width, height:self.frame.size.height)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return devices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let device = self.devices[indexPath.row]

        let ID: String = "rowCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: ID)
        if (cell == nil) {
            cell =  UITableViewCell.init(style: UITableViewCellStyle.subtitle, reuseIdentifier: ID)
        }
        
        cell?.textLabel?.numberOfLines = 0
        cell?.textLabel?.text = device.name
        cell?.detailTextLabel?.text = device.mac
        
        print("\(String(describing: cell?.textLabel?.text)) ")
        if device.mac == self.curDevice?.mac {
            cell?.accessoryType = .checkmark
        }else{
            cell?.accessoryType = .none
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
//        self.clickCell(indexPath.row)
        
        let device = self.devices[indexPath.row]
        self.curDevice = device
        
        self.tableView.reloadData()
        
        self.bind()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 扫描
    func scan() {
        self.curDevice = nil
        self.devices = []
        self.tableView.reloadData()
        
        CardReaderAPI.StartScan({ (adv) in
            
            var isFound = false
            for item in self.devices {
                if(item.mac == adv.mac){
                    isFound = true
                }
            }
            
            if !isFound {
                print("name: \(adv.name) \n rssi= \(adv.rssi) \n group= \(adv.group) \n version = \(adv.version) \n model = \(adv.model) ")
                let device = DeviceRecord("name: \(adv.name) \n rssi= \(adv.rssi) \n group= \(adv.group) \n version = \(adv.version) \n model = \(adv.model) ", mac: adv.mac)
//                let device = DeviceRecord(adv.name, mac: adv.mac)
                self.devices.append(device)
                if self.curDevice == nil {
                    self.curDevice = device
                }
                
                print("devices: \(self.devices.count)")
                self.tableView.reloadData()
            }
        }, callback: {(err)->Void in
            if err != nil {
                "err!.description!".ext_debugPrintAndHint()
            }else{
                print("扫描结束")
            }
        })
    }
    
    // 绑定
    func bind() {
        let record = self.curDevice!
        let mac = record.mac
        //超时时间不应大于60s
        CardReaderAPI.Bind(mac, timeOut: 60, process: { (code) -> Void in
            switch code {
            case 1:
                "请在60S内刷卡".ext_debugPrintAndHint()
                break
            case 2:
                "已刷卡,请再次刷此卡".ext_debugPrintAndHint()
                break
            case 3:
                "两次刷卡不一致,请重试".ext_debugPrintAndHint()
                break
            default:
                "未知错误".ext_debugPrintAndHint()
                break
            }
        }, callback: {(err, cardNO) -> Void in
            if err == nil {
                record.cardNo = cardNO//16进制数据
                
                print("card str:\(cardNO)")
                
                self.curDevice = record
                "绑定成功".ext_debugPrintAndHint()
            }else{
                 "err!.description!".ext_debugPrintAndHint()
            }
        })
    }
    
    // 开门
    func open() {
        let record = self.curDevice!
        let mac = self.curDevice?.mac
        // autoDisconnect: false，不自动断开连接，可以手动屌用Stop方法断开连接
        CardReaderAPI.OpenDoor(mac!, cardNO: record.cardNo!, timeOut: 10, autoDisconnect: true, callback: {(err) -> Void in
            if err == nil {
                "开门成功".ext_debugPrintAndHint()
            }else{
                err!.description!.ext_debugPrintAndHint()
            }
        })
    }
    
    // 停止
    func stop(_ sender: Any) {
        CardReaderAPI.Stop(true)
    }
}
