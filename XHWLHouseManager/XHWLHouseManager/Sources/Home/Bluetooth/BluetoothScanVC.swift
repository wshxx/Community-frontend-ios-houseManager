//
//  BluetoothScanVC.swift
//  XHWLHouseOwner
//
//  Created by 柳玉豹 on 2017/9/19.
//  Copyright © 2017年 xinghaiwulian. All rights reserved.

import UIKit
import CoreBluetooth
import CardReaderSDK

class BluetoothScanVC: UIViewController, UITableViewDelegate, UITableViewDataSource, XHWLNetworkDelegate {
//    let macNo = "20c38ff4ffe0"
//    let cardNo = "41516039624d0cb4c0f1b5e7"
    
    @IBOutlet weak var remainText: UILabel!
    var countDownTimer: Timer?//用于倒计时
    var messageTimer: Timer?//用于message倒计时
    var messageTime = 60
    var cardTimeAlert: UIAlertController?  //用于弹出刷卡时间倒计时
    var backBlock:(()->()) = {param in }
    
    @IBOutlet weak var bluetoothTableView: UITableView!
    @IBOutlet weak var noFoundLabel: UILabel!
    @IBOutlet weak var retryBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var bigCheck: UIImageView!
    @IBOutlet weak var scanStateLabel: UILabel! //显示扫描或者扫描完成
    @IBOutlet weak var bluetoothLightIV: UIImageView!
    @IBOutlet weak var bluetoothView: UIView!
    
    var devices:NSMutableArray = NSMutableArray()
    var curDevice:XHWLBluetoothModel? = nil{
        didSet {
            if self.curDevice == nil {
                //                self.nextBtn.isEnabled = false
                //                self.btnBind.isEnabled = false
                //                self.btnOpen.isEnabled = false
                //                self.btnStop.isEnabled = false
            }else{
                //                self.nextBtn.isEnabled = true
                //                self.btnBind.isEnabled = true
                //                self.btnStop.isEnabled = true
                if self.curDevice?.currentCardStr == nil {
                    //                    self.btnOpen.isEnabled = false
                }else{
                    //                    self.btnOpen.isEnabled = true
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.bluetoothTableView.delegate = self
        self.bluetoothTableView.dataSource = self
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"scan_back"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(onBack))
        //初始化
        CardReaderAPI.Init()
        
        //开始扫描
        scan()
    }
    
    func onBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.devices.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let device:XHWLBluetoothModel = self.devices[indexPath.row] as! XHWLBluetoothModel
        self.curDevice = device
        
        self.bluetoothTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let device:XHWLBluetoothModel = self.devices[indexPath.row] as! XHWLBluetoothModel
        let cell = tableView.dequeueReusableCell(withIdentifier: "bluetoothCell") as! BluetoothTableViewCell
        
        cell.bluetoothName.text = device.name

        if device.address == self.curDevice?.address {
            cell.smallCheck.isHidden = false
        }else{
            cell.smallCheck.isHidden = true
        }
        
        return cell
    }
    
    
    @IBAction func retryBtnClicked(_ sender: UIButton) {
        self.nextBtn.setTitle("取消", for: .normal)
        scan()
    }
    
    //下一步按钮点击事件
    @IBAction func nextBtnClicked(_ sender: UIButton) {
        if sender.currentTitle == "下一步" {
            if !(self.devices.count>0) {
                self.noticeError("未扫描出设备，请重试！")
                stop()
            }else{
                self.showMessage("正在连接中...")
                bind()
            }
        }else{
            stop()
        }
        sender.setTitle("下一步", for: .normal)
    }
    
    //显示剩余秒数
    var remainingSeconds: Int = 0{
        willSet{
            remainText.text = "\(newValue)"
            if newValue <= 0{
                nextBtn.setTitle("下一步", for: .normal)
                self.stop()
            }
        }
    }
    
    @IBAction func returnBtnClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //是否正在计数
    var isCounting = false{
        willSet{
            if newValue{
                countDownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(XHWLForgetPwdView.updateTimer(_:)), userInfo: nil, repeats: true)
                remainingSeconds = 10
            }else{
                countDownTimer?.invalidate()
                countDownTimer = nil
            }
//            sendVeriBtn.isEnabled = !newValue //设置按钮的isEnabled属性
        }
    }
    
    //更新剩余秒数
    func updateTimer(_ timer: Timer){
        remainingSeconds -= 1
    }
    
    //开始扫描
    func scan(){
        let array:NSMutableArray = NSMutableArray()
        for i in 0..<61 {
            let str = String.init(format: "别人进行云对讲%04d", arguments:[i])
            //            let path:String = Bundle.main.path(forResource:str , ofType: "png")!
            //            print("\(path)")
            //            let image:UIImage = UIImage.init(contentsOfFile: path)!
            let image:UIImage = UIImage(named: str)!
            array.add(image)
        }
        bluetoothLightIV.animationImages = array as? [UIImage]
        bluetoothLightIV.animationDuration = 1.0
        bluetoothLightIV.startAnimating()
        
        self.curDevice = nil
        self.devices = []
        self.bluetoothTableView.reloadData()
        
        //隐藏按钮和label
        isCounting = true   //开始计时
        self.scanStateLabel.text = "正在玩命扫描……"
        self.remainText.isHidden = false
        self.bigCheck.isHidden = true
        self.noFoundLabel.isHidden = true
        self.retryBtn.isEnabled = false
        self.retryBtn.alpha = 0
        
        CardReaderAPI.StartScan({ (adv) in
            var isFound = false
            
            for i in 0..<self.devices.count {
                let item:XHWLBluetoothModel = self.devices[i] as! XHWLBluetoothModel
                let array:NSArray = item.address.components(separatedBy: ":") as NSArray
                let mac:String = array.componentsJoined(by: "")
                if(mac == adv.mac){
                    isFound = true
                }
            }
            
            if !isFound {
                print("name: \(adv.name), \(adv.mac)")
                let device:XHWLBluetoothModel = XHWLBluetoothModel()
                device.name = adv.name
                device.rssi = "\(adv.rssi)"
                device.model = "\(adv.model)"
                device.version = "\(adv.version)"
                
                let array:NSMutableArray = NSMutableArray()
                let macStr:String = "\(adv.mac)"
                var i:Int = 0
                let count:Int = NSString.init(string: macStr).length
                
                while  i < count {
                    
                    let start2 = macStr.index(macStr.startIndex, offsetBy: i)
                    let end2 = macStr.index(macStr.startIndex, offsetBy: i+2)
                    let myRange2 = start2..<end2
                    
                    let str = macStr.substring(with: myRange2) //输出d的索引到f索引的范围,注意..<符号表示输出不包含f
                    array.add(str)
                    i = i+2
                }
 
                device.address = array.componentsJoined(by: ":") //adv.mac.substring(to: "")
                device.communitySign = adv.group
                self.devices.add(device)
                
                if self.curDevice == nil {
                    self.curDevice = device
                }
                
                self.bluetoothTableView.reloadData()
            }
        }, callback: {(err)->Void in
            if err != nil {
                self.noticeError(err!.description!)
            }else{
                print("扫描结束")
            }
        })
    }
    
    //绑卡
    func bind(){
        let record = self.curDevice!
        let array:NSArray = record.address.components(separatedBy: ":") as NSArray
        let mac:String = array.componentsJoined(by: "").lowercased()
        print("\(mac)")
        //超时时间不应大于60s
        CardReaderAPI.Bind(mac, timeOut: 60, process: { (code) -> Void in
            switch code {
            case 1:
                self.showCardTimeMessage(remainTime: 60)
                break
            case 2:
                self.showCardTimeMessage(remainTime: 10)
                break
            case 3:
                self.showMessage("两次刷卡不一致,请重试")
                break
            default:
                self.showMessage("未知错误")
                break
            }
        }, callback: {(err, cardNO) -> Void in
            self.clearMessage()
            if err == nil {
                record.currentCardStr = cardNO!  //16进制数据
                print("card str: \(cardNO!) =  \(record.currentCardStr) ")
                self.curDevice = record
                
                //取出user的信息
                let data = UserDefaults.standard.object(forKey: "user") as? NSData
                let userModel = XHWLUserModel.mj_object(withKeyValues: data?.mj_JSONObject())
                
                let params = ["accountId":userModel?.wyAccount.id,
                              "identity": "wy",
                              "currentCardStr":record.currentCardStr,
                              "name":record.name,
                              "address":record.address,
                              "communitySign":record.communitySign,
                              "version":record.version,
                              "model":record.model,
                              "rssi":record.rssi,
                              "systemType":"ios"]
                
                XHWLNetwork.shared.postSaveCardLogClick(params as NSDictionary, self)
                
            }else{
                self.noticeError(err!.description!)
            }
        })
    }
    
    // MARK: - XHWLNetworkDelegate
    func requestSuccess(_ requestKey:NSInteger, _ response:[String : AnyObject]) {
        
        if requestKey == XHWLRequestKeyID.XHWL_SAVECARDLOG.rawValue {
            if response["state"] as! Bool == true {
                
                self.clearMessage()
                "绑定成功".ext_debugPrint()
//                self.noticeSuccess("绑定成功")
                self.backBlock()
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func requestFail(_ requestKey:NSInteger, _ error:NSError) {
        
    }
    
    //开门
    func open(){
        let record = self.curDevice!
        let mac = self.curDevice?.address
        // autoDisconnect: false，不自动断开连接，可以手动屌用Stop方法断开连接
        CardReaderAPI.OpenDoor(mac!, cardNO: record.currentCardStr, timeOut: 10, autoDisconnect: true, callback: {(err) -> Void in
            if err == nil {
                self.noticeSuccess("开门成功")
                print("************\(mac!)")
                print("************\(record.currentCardStr)")
            }else{
                self.noticeError(err!.description!)
            }
        })
    }

    //断开链接，停止扫描
    func stop(){
        bluetoothLightIV.stopAnimating()
        //显示按钮和label
        self.isCounting = false
        self.scanStateLabel.text = "   扫描已完成！"
        self.remainText.isHidden = true
        self.bigCheck.isHidden = false
        self.noFoundLabel.isHidden = false
        self.retryBtn.isEnabled = true
        self.retryBtn.alpha = 1
        CardReaderAPI.Stop(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     *计时器每秒触发事件
     **/
    func tickDown()
    {
        self.cardTimeAlert?.message = "倒计时开始，还有 \(self.messageTime) 秒..."
        // 将剩余时间减少1秒
        self.messageTime -= 1
        print(self.messageTime)
        // 如果剩余时间小于等于0
        if(self.messageTime <= 0)
        {
            // 取消定时器
            self.messageTimer?.invalidate()
            self.messageTimer = nil
            self.cardTimeAlert?.message = "时间到！"
        }
    }
    
    //显示刷卡倒计时alert
    func showCardTimeMessage(remainTime: Int){
        if messageTimer != nil{
            messageTimer?.invalidate()
            messageTimer = nil
        }
        self.messageTime = remainTime
        if self.alert != nil{
            self.alert?.dismiss(animated: true, completion: nil)
        }
        
        if self.cardTimeAlert != nil{
            self.cardTimeAlert?.dismiss(animated: true, completion: nil)
        }
        if  remainTime == 60{
            //刷卡倒计时开始
            self.cardTimeAlert = UIAlertController(title: "请刷卡", message: " \(self.messageTime) 秒...", preferredStyle: .alert)
        }else{
            //刷卡倒计时开始
            self.cardTimeAlert = UIAlertController(title: "请再次刷卡", message: " \(self.messageTime) 秒...", preferredStyle: .alert)
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: {
            action in
            print("刷卡倒计时取消")
            self.stop()
            // 取消定时器
            self.messageTimer?.invalidate()
            self.messageTimer = nil
            self.cardTimeAlert?.message = "时间到！"
            //跳转回来到父页面
            self.dismiss(animated: true, completion: nil)
        })
        self.cardTimeAlert?.addAction(cancelAction)
        self.present(self.cardTimeAlert!, animated: true, completion: nil)
        
        self.messageTimer = Timer.scheduledTimer(timeInterval: TimeInterval(1), target:self,
                                                 selector:#selector(self.tickDown),
                                                 userInfo:nil,repeats:true)
    }
    
    
    //显示刷卡不一致等alert
    var alert:UIAlertController?
    func showMessage(_ msg: String) {
        if self.alert != nil {
            self.alert?.dismiss(animated: true, completion: {
                self.alert = UIAlertController(title: "蓝牙开门", message: msg, preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: {
                    action in
                    print("点击了取消")
                    self.stop()
                    self.dismiss(animated: true, completion: nil)
                })
                self.alert?.addAction(cancelAction)
                self.present(self.alert!, animated: true, completion: nil)

            })
        }else{
            self.alert = UIAlertController(title: "蓝牙开门", message: msg, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: {
                action in
                print("点击了取消")
                self.stop()
                self.dismiss(animated: true, completion: nil)
            })
            self.alert?.addAction(cancelAction)
            self.present(self.alert!, animated: true, completion: nil)
//            YHAlertView.show(title: "YHAlertView", message: msg, cancelButtonTitle: "取消", otherButtonTitle: "确定") { (alertV:YHAlertView, index:Int) in
//                print("message:\(msg)")
//            }
            
        }
    }
    
    func clearMessage() {
        if self.alert != nil {
            self.alert?.dismiss(animated: true, completion: nil)
            self.alert = nil
        }
        if self.cardTimeAlert != nil{
            self.cardTimeAlert?.dismiss(animated: true, completion: nil)
            self.cardTimeAlert = nil
        }
    }
    

}
