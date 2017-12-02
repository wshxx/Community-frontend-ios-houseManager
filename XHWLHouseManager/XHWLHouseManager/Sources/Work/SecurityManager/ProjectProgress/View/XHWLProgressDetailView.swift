//
//  XHWLProgressDetailView.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/15.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLProgressDetailView: UIView , UITableViewDelegate, UITableViewDataSource , XHWLNetworkDelegate {

    var bgImage:UIImageView!
    var tableView:UITableView!
    var dataAry:NSMutableArray! = NSMutableArray()
    var progressView:XHWLProgressView!
    var dismissBlock:(NSInteger)->(Void) = { param in }
    var realModel:XHWLPatrolDetailModel!

    var userId:String! = "" {
        willSet {
            onLoad(newValue)
        }
    }
    var name:String! = "" {
        willSet {
            progressView.show(name: newValue, progress: progress)
        }
    }
    var progress:String! = "" {
        willSet {
            progressView.show(name: name, progress: newValue)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        
        setupView()
    }
    
    func onLoad(_ userId:String) {
        
        let data:NSData = UserDefaults.standard.object(forKey: "user") as! NSData
        let userModel:XHWLUserModel = XHWLUserModel.mj_object(withKeyValues: data.mj_JSONObject())
        
        let param:NSArray = [userModel.wyAccount.token,
                             userId]
        XHWLNetwork.shared.getPatrolDetailClick(param, self)
    }
    
    // MARK: - XHWLNetworkDelegate
    
    func requestSuccess(_ requestKey:NSInteger, _ response:[String : AnyObject]) {
        
        if requestKey == XHWLRequestKeyID.XHWL_PATROLDETAIL.rawValue {
            if response["result"] is NSNull {
                return
            }
            let dict:NSDictionary = response["result"] as! NSDictionary
            realModel = XHWLPatrolDetailModel.mj_object(withKeyValues: dict["userProgress"] )
            self.tableView.reloadData()

            progressView.show(name: name, progress: realModel.progress)
        }
    }
    
    func requestFail(_ requestKey: NSInteger, _ error: NSError) {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
        bgImage = UIImageView()
        bgImage.image = UIImage(named:"subview_bg")
        self.addSubview(bgImage)
        
        progressView = XHWLProgressView()
        self.addSubview(progressView)
        
        tableView = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionFooterHeight = 0.01
        tableView.backgroundColor = UIColor.clear
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.showsVerticalScrollIndicator = false
        self.addSubview(tableView)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if realModel == nil {
            return 0
        }
        
        let lineList:NSArray = realModel.lineList
        let totalChecksDetail:NSArray = realModel.totalChecksDetail
        if totalChecksDetail.count > 0 {
             return lineList.count + 1
        } else {
             return lineList.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        let lineList:NSArray = realModel.lineList
        if section < lineList.count {
            let lineModel:XHWLPatrolLineModel = XHWLPatrolLineModel.mj_object(withKeyValues: lineList[section])
            if lineModel.isFlod == true {
                return lineModel.currentTimePlanChecksList.count+1
            }
        } else {
            let totalChecksDetail:NSArray = realModel.totalChecksDetail
            return totalChecksDetail.count
        }
        
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let lineList:NSArray = realModel.lineList
        print("\(indexPath.section) = \(lineList.count)")
        if lineList.count > Int(indexPath.section) {
            let lineModel:XHWLPatrolLineModel = XHWLPatrolLineModel.mj_object(withKeyValues: lineList[indexPath.section])
            let detailAry:NSArray = lineModel.currentTimePlanChecksList

            if indexPath.row >= detailAry.count {
                let cell = XHWLMapKitSubViewCell.cellWithTableView(tableView: tableView)
                cell.lineModel = lineModel
                
                return cell
            } else {
                let modelAry:NSArray = XHWLPatrolTotalCheckModel.mj_objectArray(withKeyValuesArray: detailAry)
                let cellModel:XHWLPatrolTotalCheckModel = modelAry[indexPath.row] as! XHWLPatrolTotalCheckModel
                let cell = XHWLProgressDetailCell.cellWithTableView(tableView: tableView)
                cell.cellModel = cellModel
                
                return cell
            }
        } else {
            let totalChecksDetail:NSArray = realModel.totalChecksDetail
            let lineAry:NSArray = XHWLPatrolTotalCheckModel.mj_objectArray(withKeyValuesArray: totalChecksDetail)
            let lineModel:XHWLPatrolTotalCheckModel = lineAry[indexPath.row] as! XHWLPatrolTotalCheckModel
            let cell = XHWLProgressDetailCell.cellWithTableView(tableView: tableView)
            cell.lineModel = lineModel
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let lineList:NSMutableArray = realModel.lineList
        if section < lineList.count {
            let head:XHWLPatrolHeadView = XHWLPatrolHeadView.init(reuseIdentifier:"XHWLPatrolHeadView")
            let lineModel:XHWLPatrolLineModel = XHWLPatrolLineModel.mj_object(withKeyValues: lineList[section])
            head.headViewBlock = {[weak lineModel] cellModel in
                print("\(cellModel.isFlod)")
                
                lineModel?.isFlod = cellModel.isFlod
                let dict:NSDictionary = (lineModel?.mj_keyValues())!
                self.realModel.lineList.replaceObject(at: section, with: dict)
                self.tableView.reloadData()
            }
            head.cellModel = lineModel
            
            return head
        } else {
            
            return nil
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    //将分组尾设置为一个空的View
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
 
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let lineList:NSMutableArray = realModel.lineList
        if section < lineList.count {
            return 60
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let lineList:NSMutableArray = realModel.lineList
        if indexPath.section < lineList.count {
            let lineModel:XHWLPatrolLineModel = XHWLPatrolLineModel.mj_object(withKeyValues: lineList[indexPath.section])
            if indexPath.row == lineModel.currentTimePlanChecksList.count {
                
                var weekStr:String = ""
                if lineModel.mon == "1" {
                    weekStr = weekStr + "、星期一"
                }
                if lineModel.tue == "1" {
                    weekStr = weekStr + "、星期二"
                }
                if lineModel.wed == "1" {
                    
                    weekStr = weekStr + "、星期三"
                }
                if lineModel.thu == "1" {
                    weekStr = weekStr + "、星期四"
                }
                if lineModel.fri == "1" {
                    weekStr = weekStr + "、星期五"
                }
                if lineModel.sat == "1" {
                    weekStr = weekStr + "、星期六"
                }
                if lineModel.sun == "1" {
                    weekStr = weekStr + "、星期日"
                }
                if !weekStr.isEmpty {
                    weekStr = weekStr.substring(from: String.Index(1))
                }
                
                var addressStr:String = ""
                let detailAry:NSArray = XHWLPatrolTotalCheckModel.mj_objectArray(withKeyValuesArray: lineModel.currentTimeChecksDetail)
                
                for i in 0..<detailAry.count {
                    let model:XHWLPatrolTotalCheckModel = detailAry[i] as! XHWLPatrolTotalCheckModel
                    addressStr = addressStr + model.nodeName
                }
                let array :NSArray = [addressStr, lineModel.startDate + "～" + lineModel.endDate, weekStr]
                
                var maxHeight:CGFloat = 0
                for i in 0..<array.count {
                    let menuModel :String = array[i] as! String
                    
                    maxHeight = maxHeight + heightWithSize(menuModel) + CGFloat(array.count)*5
                }
                
                var num = 1
                if lineModel.planTime.count > 0 {
                    num = lineModel.planTime.count
                }
                maxHeight = maxHeight + 5 + CGFloat(num) * font_14.lineHeight
                
                return maxHeight
            }
        }
        return 50
    }
    
    
    func heightWithSize(_ menuModel :String) -> CGFloat {
        
        let sizeR:CGSize = menuModel.boundingRect(with: CGSize(width:CGFloat(Int(self.bounds.size.width-80-10)), height:CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:font_14], context: nil).size
        
        return sizeR.height + 5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.dismissBlock(indexPath.row)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bgImage.frame = self.bounds
        progressView.frame = CGRect(x:0, y:0, width:self.bounds.size.width, height:44)
        tableView.frame = CGRect(x:0, y:progressView.frame.maxY, width:self.bounds.size.width, height:self.frame.size.height-44)
    }

}
