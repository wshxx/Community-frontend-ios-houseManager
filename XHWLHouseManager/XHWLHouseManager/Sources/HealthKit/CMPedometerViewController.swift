//
//  CMPedometerViewController.swift
//  CMMotionDemo
//
//  Created by 周际航 on 2017/5/9.
//  Copyright © 2017年 com.maramara. All rights reserved.
//

import UIKit
import CoreMotion

class CMPedometerViewController: UIViewController {
    
    fileprivate lazy var showLabel:UILabel = UILabel()
    
    fileprivate var pedometer = CMPedometer()
    fileprivate var totalSteps: Int = 0
    fileprivate var isStartUpdate: Bool = false
    
    fileprivate var timer: Timer?
    fileprivate var isTimerTaskRun: Bool = false
    
    deinit {
        self.pedometer.stopUpdates()
        "deinit".ext_debugPrint()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
}
// MARK: - 扩展 UI
private extension CMPedometerViewController {
    func setup() {
        self.setupView()
        self.setupConstraints()
        
        self.startUpdatePedometer() // "连续监听计步器数据"
        
        self.setupTimer()
        //self.queryPedometerData10Mins() // "单次查询 10分钟内总步数"
        //self.test2()// "每秒定时查询 <10分钟内总步数>"
    }
    
    func setupView() {
        self.view.backgroundColor = UIColor.white
        
        self.view.addSubview(self.showLabel)
        self.showLabel.backgroundColor = UIColor.gray
        
    }
    
    func setupConstraints() {
        self.showLabel.frame = CGRect(x: 20, y: 200, width: 200, height: 100)
    }
    
    func test2() {
        if self.isTimerTaskRun {
            "停止定时查询".ext_debugPrintAndHint()
            self.removeTimer()
            self.isTimerTaskRun = false
        } else {
            "开始定时查询".ext_debugPrintAndHint()
            self.setupTimer()
            self.isTimerTaskRun = true
        }
    }
    
    // 开始监控
    func startUpdatePedometer() {
        guard !self.isStartUpdate else {
            self.showLabel.text = "停止监听计步器数据"
            self.pedometer.stopUpdates()
            self.isStartUpdate = false
            return
        }
        self.isStartUpdate = true
        
        guard CMPedometer.isStepCountingAvailable() else {
            self.showLabel.text = "本机不支持计步器"
            return
        }
        
        self.showLabel.text = "开始监听计步器数据"
        
        self.queryPedometerDate()
        
//        self.pedometer.startUpdates(from: Date()) { [weak self] (data, error) in
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0) {
//                guard error == nil else {
//                    self?.showLabel.text = "CMPedometer - startUpdate error:\(String(describing: error))"
//                    return
//                }
//                guard let pedometerData = data else {
//                    self?.showLabel.text = "CMPedometer - startUpdate data is nil"
//                    return
//                }
//                
//                let steps = pedometerData.numberOfSteps.intValue
//                let oldSteps = self?.totalSteps ?? 0
//                let temp = steps - oldSteps
//                self?.totalSteps = steps
//                self?.showLabel.text = "new steps: \(temp)"
//            }
//        }
        
//        self.pedometer.startUpdates(from: Date()) { [weak self] (data, error) in
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0) {
//                guard error == nil else {
//                    "CMPedometer - startUpdate error:\(String(describing: error))".ext_debugPrintAndHint()
//                    self?.showLabel.text = "CMPedometer - startUpdate error:\(String(describing: error))"
//                    return
//                }
//                guard let pedometerData = data else {
//                    "CMPedometer - startUpdate data is nil".ext_debugPrintAndHint()
//                    self?.showLabel.text = "CMPedometer - startUpdate data is nil"
//                    return
//                }
//                
//                let steps = pedometerData.numberOfSteps.intValue
//                let oldSteps = self?.totalSteps ?? 0
//                let temp = steps - oldSteps
//                self?.totalSteps = steps
//                "new steps: \(temp)".ext_debugPrintAndHint()
//                self?.showLabel.text = "new steps: \(temp)"
//            }
//        }
    }
    
    func queryPedometerData10Mins() {
        guard CMPedometer.isStepCountingAvailable() else {
            "本机不支持计步器".ext_debugPrintAndHint()
            self.showLabel.text = "本机不支持计步器"
            return
        }
        
        let nowDate = Date()
        let tenMinuteBeforeDate = Date(timeIntervalSinceNow: -3600 * 10)
        self.pedometer.queryPedometerData(from: tenMinuteBeforeDate, to: nowDate) { (data, error) in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0) {
                guard error == nil else {
                    "CMPedometer - queryPedometerData error:\(String(describing: error))".ext_debugPrintAndHint()
                    self.showLabel.text = "CMPedometer - queryPedometerData error:\(String(describing: error))"
                    return
                }
                guard let pedometerData = data else {
                    "CMPedometer - queryPedometerData data is nil".ext_debugPrintAndHint()
                    self.showLabel.text = "CMPedometer - queryPedometerData data is nil"
                    return
                }
                
                let steps = pedometerData.numberOfSteps.intValue
                "10分钟内步数：\(steps)".ext_debugPrintAndHint()
                self.showLabel.text = "10分钟内步数：\(steps)"
            }
        }
    }
    
    /// 当前的0 点 0分 0 秒时间
    var currentDayzeroOfDate:Date{
        
//        let calendar:NSCalendar = NSCalendar.current as NSCalendar
////        currentCalendar()
//
//        //calendar.components(NSCalendarUnit(), fromDate: self)//UIntMax
//        
//        let unitFlags: NSCalendar.Unit = [
//            
//            NSCalendar.Unit.year,
//            NSCalendar.Unit.month,
//            NSCalendar.Unit.day,
//            .hour,
//            .minute,
//            .second ]
//        
//        //calendar.components(unitFlags, fromDate: self)//解析当前的时间 返回NSDateComponents 解析后的数据后面设置解析后的时间在反转
//        var components:DateComponents = calendar.components(unitFlags, from: Date())  // NSDateComponents() 不初始化, 直接返回解析的时间
//        components.timeZone = TimeZone.current
//        components.hour = 0
//        components.minute = 0
//        components.second = 0
//        print(" 2  \(components.year)  \(components.month)  \(components.day) \( components.hour)")
//        let date = calendar.date(from: components)
        
//        dateFormatter.locale = Locale.current() // 设置时区
        
        
        //        return date!
        
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString:String = formatter.string(from: Date())
        
        let df2: DateFormatter = DateFormatter()
        df2.dateFormat = "yyyy-MM-dd HH:mm:ss"
        df2.locale = Locale.current // 设置时区
        df2.timeZone = TimeZone.current // TimeZone(abbreviation: "CST")
        let dateStr:String = "\(dateString) 00:00:00"
        
        let date: Date = df2.date(from: dateStr)!
        
        let timeFormatter:DateFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let date1 = Date()
        let nowTime = timeFormatter.string(from: date1) as String
        let zeroTime = timeFormatter.string(from: date) as String
        
        print("\(zeroTime) =  \(nowTime) = \(date1)")
        
        return date
    }


    func queryPedometerDate() {
        
        print("\(self.currentDayzeroOfDate)")
        guard CMPedometer.isStepCountingAvailable() else {
            self.showLabel.text = "本机不支持计步器"
            return
        }
        
        let nowDate = Date()
        self.pedometer.queryPedometerData(from: self.currentDayzeroOfDate, to: nowDate) { (data, error) in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0) {
                guard error == nil else {
                    self.showLabel.text = "CMPedometer - queryPedometerData error:\(String(describing: error))"
                    return
                }
                guard let pedometerData = data else {
                    self.showLabel.text = "CMPedometer - queryPedometerData data is nil"
                    return
                }
                
                let steps = pedometerData.numberOfSteps.intValue
                self.showLabel.text = "今天走的步数：\(steps)"
            }
        }
    }
    
    // 定时器
    func setupTimer() {
        self.removeTimer()
        let timerARC = TimerARC()
        timerARC.updateTimerHandler = { [weak self] in
            self?.timerTask()
        }
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: timerARC, selector: #selector(timerARC.updateTimer), userInfo: nil, repeats: true)
        RunLoop.main.add(self.timer!, forMode: RunLoopMode.commonModes)
        self.timer?.fire()
    }
    
    func removeTimer() {
        self.timer?.invalidate()
        self.timer = nil;
    }
    
    @objc func timerTask() {
//        self.queryPedometerData10Mins() // 10 分钟
        
        self.queryPedometerDate()
    }
}


