//
//  XHWLPedometerVC.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/8/31.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit
import CoreMotion

// Privacy - Motion Usage Description 
class XHWLPedometerVC: UIViewController {

    //用于显示实时信息
    var textView: UITextView!
    
    //计步器对象
    var pedometer = CMPedometer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        textView = UITextView()
        textView.backgroundColor = UIColor.gray
        textView.frame = CGRect(x:0, y:100, width:self.view.bounds.size.width, height:self.view.bounds.height-100)
        self.view.addSubview(textView)
        
        //开始计步器更新
        startPedometerUpdates()
    }
    
    // 开始获取步数计数据
    func startPedometerUpdates() {
        //判断设备支持情况
        guard CMPedometer.isStepCountingAvailable() else {
            self.textView.text = "\n当前设备不支持获取步数\n"
            return
        }
        
        //获取今天凌晨时间
        let cal = Calendar.current
        var comps = cal.dateComponents([.year, .month, .day], from: Date())
        comps.hour = 0
        comps.minute = 0
        comps.second = 0
        let midnightOfToday = cal.date(from: comps)!
        
        //初始化并开始实时获取数据
        self.pedometer.startUpdates (from: midnightOfToday, withHandler: { pedometerData, error in
            //错误处理
            guard error == nil else {
                print(error!)
                return
            }
            
            //获取各个数据
            var text = "---今日运动数据---\n"
            if let numberOfSteps = pedometerData?.numberOfSteps {
                text += "步数: \(numberOfSteps)\n"
            }
            if let distance = pedometerData?.distance {
                text += "距离: \(distance)\n"
            }
            if let floorsAscended = pedometerData?.floorsAscended {
                text += "上楼: \(floorsAscended)\n"
            }
            if let floorsDescended = pedometerData?.floorsDescended {
                text += "下楼: \(floorsDescended)\n"
            }
            if let currentPace = pedometerData?.currentPace {
                text += "速度: \(currentPace)m/s\n"
            }
            if let currentCadence = pedometerData?.currentCadence {
                text += "速度: \(currentCadence)步/秒\n"
            }
            
            //在线程中更新文本框数据
            DispatchQueue.main.async{
                self.textView.text = text
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
