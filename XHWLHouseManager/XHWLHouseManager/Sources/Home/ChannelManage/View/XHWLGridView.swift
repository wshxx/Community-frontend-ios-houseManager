
//
//  XHWLGridView.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/11/17.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

let LxGridViewCellReuseIdentifier = "LxGridViewCellReuseIdentifier"
let LxGridViewCellReuseIdentifier2 = "LxGridViewCellReuseIdentifier2"
let HOME_BUTTON_RADIUS: CGFloat = 21
let HOME_BUTTON_BOTTOM_MARGIN: CGFloat = 9

//let PRESS_TO_MOVE_MIN_DURATION = 0.1
//let MIN_PRESS_TO_BEGIN_EDITING_DURATION = 0.6

class XHWLGridView: UIView , LxGridViewDataSource, LxGridViewDelegateFlowLayout, LxGridViewCellDelegate {
    
    var dataArray = NSMutableArray()
    var _gridView: LxGridView?
    let _gridViewFlowLayout = LxGridViewFlowLayout()
    var isHasDel:Bool = true
    var isHasAdd:Bool = true
    var _displayLink: CADisplayLink?
    var _remainSecondsToBeginEditing = MIN_PRESS_TO_BEGIN_EDITING_DURATION
    var addBlock:()->() = {param in }
    var deleteBlock:(IndexPath)->() = {param in }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        _gridViewFlowLayout.sectionInset = UIEdgeInsets(top: 18, left: 15, bottom: 18, right: 15)
        _gridViewFlowLayout.minimumLineSpacing = 10
        _gridViewFlowLayout.itemSize = CGSize(width: 55, height: 50)
        
        _gridView = LxGridView(frame: CGRect.zero, collectionViewLayout: _gridViewFlowLayout)
        _gridView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        _gridView?.delegate = self
        _gridView?.dataSource = self
//        _gridView?.isScrollEnabled = false
        _gridView?.backgroundColor = UIColor.clear
        self.addSubview(_gridView!)
        
        _gridView?.register(LxGridViewCell.classForCoder(), forCellWithReuseIdentifier: LxGridViewCellReuseIdentifier)
        _gridView?.register(LxOtherGridViewCell.classForCoder(), forCellWithReuseIdentifier: LxGridViewCellReuseIdentifier2)
        
        _gridView?.translatesAutoresizingMaskIntoConstraints = false
        
//        let gridViewTopMargin = NSLayoutConstraint(item: _gridView!, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
//        let gridViewRightMargin = NSLayoutConstraint(item: _gridView!, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0)
//        let gridViewBottomMargin = NSLayoutConstraint(item: _gridView!, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
//        let gridViewLeftMargin = NSLayoutConstraint(item: _gridView!, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0)
//        self.addConstraints([gridViewTopMargin, gridViewRightMargin, gridViewBottomMargin, gridViewLeftMargin])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        _gridView?.frame = self.bounds
        
        var num:Int = 0
        let rowNum:Int = Int(self.bounds.size.width-30) / 60
        if (dataArray.count + 2) % rowNum == 0 {
            num = (dataArray.count + 2) / rowNum
        } else {
            num = (dataArray.count + 2) / rowNum + 1
        }
        var height:CGFloat = CGFloat(num)*60.0 + 36
        
        _gridView?.contentSize = CGSize(width:0, height:height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- delegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if isHasAdd {
            return dataArray.count + 2
        }
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item < dataArray.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LxGridViewCellReuseIdentifier, for: indexPath as IndexPath) as! LxGridViewCell
            cell.delegate = self
            cell.editing = _gridView!.editing
            let roleModel:XHWLChannelRoleModel = dataArray[indexPath.item] as! XHWLChannelRoleModel
            cell.title = roleModel.wyUserName
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LxGridViewCellReuseIdentifier2, for: indexPath as IndexPath) as! LxOtherGridViewCell
            if dataArray.count == indexPath.item {
                cell.iconImageView?.image = UIImage(named:"channel_increase")
            } else if (dataArray.count + 1) == indexPath.item {
                cell.iconImageView?.image = UIImage(named:"channel_decrease")
            }
            return cell
        }
    }

    func collectionView(_ collectionView: LxGridView, itemAtIndexPath sourceIndexPath: IndexPath, willMoveToIndexPath destinationIndexPath: IndexPath) {
        
        let dataDict = dataArray[sourceIndexPath.item]
        dataArray.remove(at: sourceIndexPath.item)
        dataArray.insert(dataDict, at: destinationIndexPath.item)
    }
    
    func deleteButtonClickedInGridViewCell(gridViewCell: LxGridViewCell) {
        
        if let gridViewCellIndexPath = _gridView!.indexPath(for: gridViewCell) {
            
            self.deleteBlock(gridViewCellIndexPath)
//            dataArray.remove(at: gridViewCellIndexPath.item)
//            _gridView?.deleteItems(at: [gridViewCellIndexPath])
//            _gridView?.reloadData()
//            _gridView?.performBatchUpdates({ [unowned self] () -> Void in
//                self._gridView?.deleteItems(at: [gridViewCellIndexPath])
//                }, completion: nil)
        }
    }

    func showDeleteView() {
        if _displayLink == nil {
            _displayLink = CADisplayLink(target: self, selector: #selector(displayLinkTriggered))
            _displayLink?.frameInterval = 6
            _displayLink?.add(to: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
            
            _remainSecondsToBeginEditing = MIN_PRESS_TO_BEGIN_EDITING_DURATION
        }
    }
    
    func hideDeleteView() {
        _displayLink?.invalidate()
        _displayLink = nil
        _gridView!.editing = false
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.item < dataArray.count {
            
        } else if dataArray.count == indexPath.item {
            if _gridView!.editing {
                hideDeleteView()
            }
            self.addBlock()
        } else if (dataArray.count + 1) == indexPath.item {
            if _gridView!.editing {
                 hideDeleteView()
            } else {
                showDeleteView()
            }
        }
    }
    
    func displayLinkTriggered(displayLink: CADisplayLink) {
        
        if _remainSecondsToBeginEditing <= 0 {
            _gridView!.editing = true
//            editing = true
            _displayLink?.invalidate()
            _displayLink = nil
        }
        
        _remainSecondsToBeginEditing = _remainSecondsToBeginEditing - 0.1
    }
}
