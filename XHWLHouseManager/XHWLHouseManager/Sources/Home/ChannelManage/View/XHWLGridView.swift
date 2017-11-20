
//
//  XHWLGridView.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/11/17.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

let LxGridViewCellReuseIdentifier = "LxGridViewCellReuseIdentifier"
let HOME_BUTTON_RADIUS: CGFloat = 21
let HOME_BUTTON_BOTTOM_MARGIN: CGFloat = 9


class XHWLGridView: UIView , LxGridViewDataSource, LxGridViewDelegateFlowLayout, LxGridViewCellDelegate {
    
    var dataArray = [[String:AnyObject?]]()
    var _gridView: LxGridView?
    let _gridViewFlowLayout = LxGridViewFlowLayout()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        for i in 0..<7 {
            
            var dataDict = [String:AnyObject?]()
            dataDict["index"] = "App \(i)" as AnyObject
            dataDict["icon_image"] = UIImage(named: "\(i%2)")
            dataArray.append(dataDict)
        }
        
        _gridViewFlowLayout.sectionInset = UIEdgeInsets(top: 18, left: 30, bottom: 18, right: 30)
        _gridViewFlowLayout.minimumLineSpacing = 9
        _gridViewFlowLayout.itemSize = CGSize(width: 66, height: 88)
        
        _gridView = LxGridView(frame: CGRect.zero, collectionViewLayout: _gridViewFlowLayout)
        _gridView?.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        _gridView?.delegate = self
        _gridView?.dataSource = self
        _gridView?.isScrollEnabled = false
        _gridView?.backgroundColor = UIColor.white
        self.addSubview(_gridView!)
        
        _gridView?.register(LxGridViewCell.classForCoder(), forCellWithReuseIdentifier: LxGridViewCellReuseIdentifier)
        
        _gridView?.translatesAutoresizingMaskIntoConstraints = false
        
        let gridViewTopMargin = NSLayoutConstraint(item: _gridView!, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        let gridViewRightMargin = NSLayoutConstraint(item: _gridView!, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0)
        let gridViewBottomMargin = NSLayoutConstraint(item: _gridView!, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        let gridViewLeftMargin = NSLayoutConstraint(item: _gridView!, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0)
        self.addConstraints([gridViewTopMargin, gridViewRightMargin, gridViewBottomMargin, gridViewLeftMargin])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- delegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LxGridViewCellReuseIdentifier, for: indexPath as IndexPath) as! LxGridViewCell
        
        cell.delegate = self
        cell.editing = _gridView!.editing
        
        let dataDict = dataArray[indexPath.item] as [String:AnyObject?]
        cell.title = dataDict["index"] as? String
        cell.iconImageView?.image = dataDict["icon_image"] as? UIImage
        
        return cell
    }

    func collectionView(_ collectionView: LxGridView, itemAtIndexPath sourceIndexPath: IndexPath, willMoveToIndexPath destinationIndexPath: IndexPath) {
        
        let dataDict = dataArray[sourceIndexPath.item]
        dataArray.remove(at: sourceIndexPath.item)
        dataArray.insert(dataDict, at: destinationIndexPath.item)
    }
    
    func deleteButtonClickedInGridViewCell(gridViewCell: LxGridViewCell) {
        
        if let gridViewCellIndexPath = _gridView!.indexPath(for: gridViewCell) {
            
            dataArray.remove(at: gridViewCellIndexPath.item)
            _gridView?.performBatchUpdates({ [unowned self] () -> Void in
                self._gridView?.deleteItems(at: [gridViewCellIndexPath])
                }, completion: nil)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if  dataArray.count-1 == indexPath.row {
            _gridView?.editing = false
        }
    }
}
