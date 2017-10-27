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
//    var realModel:XHWLRealProgressModel! {
//        willSet {
//            if (newValue != nil) {
//
//////                let ary1 = newValue.checkedList as NSArray
////                let ary2 = newValue.planChecksList as NSArray
////                let array = NSMutableArray()
//////                array.addObjects(from: ary1 as! [Any])
////                array.addObjects(from: ary2 as! [Any])
////
////                dataAry = XHWLListModel.mj_objectArray(withKeyValuesArray: array)
////                progressView.progressModel = newValue
////
////                self.tableView.reloadData()
//            }
//        }
//    }
    var userId:String! = "" {
        willSet {
            onLoad(newValue)
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
//            let userProgressArray:NSArray = XHWLPatrolDetailModel.mj_objectArray(withKeyValuesArray:dict["userProgress"] as! NSArray)
//            self.dataAry = NSMutableArray()
            realModel = XHWLPatrolDetailModel.mj_object(withKeyValues: dict["userProgress"] )
//            self.dataAry.addObjects(from: userProgressArray as! [Any])
            self.tableView.reloadData()
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
//        return dataAry.count
        return lineList.count // self.realModel.totalChecksDetail.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        let lineList:NSArray = realModel.lineList
        let lineModel:XHWLPatrolLineModel = XHWLPatrolLineModel.mj_object(withKeyValues: lineList[section])
        if lineModel.isFlod == true {
            return lineModel.currentTimeChecksDetail.count+1
        }
        
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let lineList:NSArray = realModel.lineList
        let lineModel:XHWLPatrolLineModel = XHWLPatrolLineModel.mj_object(withKeyValues: lineList[indexPath.section])
        let detailAry:NSArray = lineModel.currentTimeChecksDetail
        let cellModel:XHWLPatrolTotalCheckModel = XHWLPatrolTotalCheckModel.mj_object(withKeyValues: detailAry[indexPath.row])
//        let realModel:XHWLPatrolDetailModel = (dataAry[section] as? XHWLPatrolDetailModel)!
        if indexPath.row == detailAry.count {
            let cell = XHWLMapKitSubViewCell.cellWithTableView(tableView: tableView)
            //        cell.textLabel?.text = dataAry[indexPath.row] as? String
            //        print("\(dataAry[indexPath.row])")
            //        let realModel:XHWLListModel = (dataAry[indexPath.row] as? XHWLListModel)!
            //        cell.isTop = indexPath.row == 0
            //        cell.isBottom = indexPath.row == dataAry.count - 1
            //        cell.setRealModel(realModel)
            cell.lineModel = lineModel

            return cell
        } else {
            let cell = XHWLProgressDetailCell.cellWithTableView(tableView: tableView)
            //        cell.textLabel?.text = dataAry[indexPath.row] as? String
//            print("\(dataAry[indexPath.row])")
//            let realModel:XHWLListModel = (dataAry[indexPath.row] as? XHWLListModel)!
//            cell.isTop = indexPath.row == 0
//            cell.isBottom = indexPath.row == dataAry.count - 1
//            cell.setRealModel(realModel)
//            let cellModel = lineModel.currentTimeChecksDetail[indexPath.row] as! XHWLPatrolTotalCheckModel
            cell.cellModel = cellModel
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let head:XHWLPatrolHeadView = XHWLPatrolHeadView.init(reuseIdentifier:"XHWLPatrolHeadView")
        
        let lineList:NSMutableArray = realModel.lineList
        let lineModel:XHWLPatrolLineModel = XHWLPatrolLineModel.mj_object(withKeyValues: lineList[section])
        head.headViewBlock = {[weak lineModel] cellModel in
            print("\(cellModel.isFlod)")
            
            lineModel?.isFlod = cellModel.isFlod
            let dict:NSDictionary = (lineModel?.mj_keyValues())!
            self.realModel.lineList.replaceObject(at: section, with: dict)
        }
//        head.delegate = self
//        head.cellModel = realModel
        head.cellModel = lineModel //realModel
//        self.realModel.totalChecksDetail

        return head
    }
    
    func headViewClicked(_ cellModel: XHWLPatrolDetailModel, _ headView: XHWLPatrolHeadView) {
//        headView.isUserInteractionEnabled = false
        
//        var indexPaths = [IndexPath]()
        print("\(cellModel.isFlod)")
        
        self.realModel.isFlod = cellModel.isFlod
//        cellModel.isFlod = !cellModel.isFlod
        
        
        self.tableView.reloadData()
        
//        let indexSection = IndexPath.init(row: 0, section: 0)
//        self.tableView.scrollToRow(at: indexSection as IndexPath, at: UITableViewScrollPosition.middle, animated:true)
//        for i in 0..<chapterModel.questions.count {
//            let indexPath = IndexPath.init(row: i , section: chapterModel.chapterId - 1)
//            indexPaths.append(indexPath as IndexPath)
//        }
        
//        let time = DispatchTime.now() + TableViewConfig.dispatchAfterTime
//        DispatchQueue.main.asyncAfter(deadline: time) {
//            if ChapterFoldingSectionState.ChapterSectionStateFlod == chapterModel.foldingState {
//                self.tableView.deleteRows(at: indexPaths as [IndexPath], with: UITableViewRowAnimation.top)
//
//            } else {
//                self.tableView.insertRows(at: indexPaths as [IndexPath], with: UITableViewRowAnimation.top)
//                let indexSection = IndexPath.init(row: 0, section: chapterModel.chapterId - 1)
//
//                self.tableView.scrollToRow(at: indexSection as IndexPath, at: UITableViewScrollPosition.middle, animated:true)
//
//            }
//            headView.isUserInteractionEnabled = true
//
//        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 4 {
            return 50*5
        }
        return 50
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
