//
//  XHWLProgressDetailView.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/15.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLProgressDetailView: UIView , UITableViewDelegate, UITableViewDataSource , XHWLPatrolHeadViewDelegate {

    var bgImage:UIImageView!
    var tableView:UITableView!
    var dataAry:NSMutableArray! = NSMutableArray()
    var progressView:XHWLProgressView!
    var dismissBlock:(NSInteger)->(Void) = { param in }
    var realModel:XHWLRealProgressModel! {
        willSet {
            if (newValue != nil) {
                
//                let ary1 = newValue.checkedList as NSArray
                let ary2 = newValue.planChecksList as NSArray
                let array = NSMutableArray()
//                array.addObjects(from: ary1 as! [Any])
                array.addObjects(from: ary2 as! [Any])
                
                dataAry = XHWLListModel.mj_objectArray(withKeyValuesArray: array)
                progressView.progressModel = newValue
                
                self.tableView.reloadData()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        
        setupView()
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
//        return dataAry.count
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
//        let realModel:XHWLListModel = (dataAry[section] as? XHWLListModel)!
        if self.realModel != nil && self.realModel.isFlod == true {
//            return dataAry.count
            return 5
        }
        
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 4 {
            let cell = XHWLMapKitSubViewCell.cellWithTableView(tableView: tableView)
            //        cell.textLabel?.text = dataAry[indexPath.row] as? String
            //        print("\(dataAry[indexPath.row])")
            //        let realModel:XHWLListModel = (dataAry[indexPath.row] as? XHWLListModel)!
            //        cell.isTop = indexPath.row == 0
            //        cell.isBottom = indexPath.row == dataAry.count - 1
            //        cell.setRealModel(realModel)

            return cell
        } else {
            let cell = XHWLProgressDetailCell.cellWithTableView(tableView: tableView)
            //        cell.textLabel?.text = dataAry[indexPath.row] as? String
//            print("\(dataAry[indexPath.row])")
//            let realModel:XHWLListModel = (dataAry[indexPath.row] as? XHWLListModel)!
//            cell.isTop = indexPath.row == 0
//            cell.isBottom = indexPath.row == dataAry.count - 1
//            cell.setRealModel(realModel)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let head = XHWLPatrolHeadView.init(reuseIdentifier:"XHWLPatrolHeadView")
//        let realModel:XHWLListModel = (dataAry[section] as? XHWLListModel)!
        head.delegate = self
//        head.cellModel = realModel
        head.cellModel = realModel

        return head
    }
    
    func headViewClicked(_ cellModel: XHWLRealProgressModel, _ headView: XHWLPatrolHeadView) {
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
