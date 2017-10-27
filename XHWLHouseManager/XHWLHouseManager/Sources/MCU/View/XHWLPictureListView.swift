//
//  XHWLPictureListView.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/10/23.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLPictureListView: UIView ,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    var collectionView:UICollectionView!
    var bgImage:UIImageView!
    let CELL_ID:String! = "cell_id"
    let HEAD_ID:String! = "head_id"
    var jumpBlock:(UIImage)->() = { param in }
    var mArrOfSelectedData:NSMutableArray = NSMutableArray()
    var mArrOfSelectedItem:NSMutableArray = NSMutableArray()
    var isEdit:Bool = false {
        willSet {
            if newValue == true {
                collectionView.allowsMultipleSelection = true
                mArrOfSelectedData = NSMutableArray()
                mArrOfSelectedItem = NSMutableArray()
                let array:[MainPageSectionZeroCell] = collectionView.visibleCells as! [MainPageSectionZeroCell]
                for var cell:MainPageSectionZeroCell in array {
                    
                    cell.maskV.isHidden = false
                    cell.selectIV.isHidden = true
                }
                
                collectionView.reloadData()
            } else {
                mArrOfSelectedData = NSMutableArray()
                mArrOfSelectedItem = NSMutableArray()
                collectionView.allowsMultipleSelection = false
                let array:[MainPageSectionZeroCell] = collectionView.visibleCells as! [MainPageSectionZeroCell]
                for var cell:MainPageSectionZeroCell in array {
                    
                    cell.maskV.isHidden = true
                    cell.selectIV.isHidden = true
                    
                    let indexPath:IndexPath = collectionView.indexPath(for: cell)!
                    collectionView.deselectItem(at: indexPath, animated: false)
                }
                
                collectionView.reloadData()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        
        bgImage = UIImageView()
        bgImage.image = UIImage(named:"subview_bg")
        bgImage.frame = self.bounds
        self.addSubview(bgImage)
        
        createCollectionView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createCollectionView() {
        
        let flowLayout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: CGRect(x:0, y:0, width:self.bounds.size.width, height: self.bounds.size.height), collectionViewLayout:flowLayout)
        collectionView!.backgroundColor = UIColor.clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView!.delegate = self
        collectionView!.dataSource = self
        collectionView!.register(MainPageSectionZeroCell.self, forCellWithReuseIdentifier: CELL_ID)
//        collectionView!.register(MainPageSectionZeroHeadView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: HEAD_ID)
        
        self.addSubview(collectionView!)
    }
    
    //MARK: - UICollectionView 代理
    
    //分区数
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 3
    }
    
    //每个分区含有的 item 个数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    //返回 cell
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_ID, for: indexPath) as! MainPageSectionZeroCell
        
        return cell
    }
    
    //每个分区的内边距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(10, 10, 10, 10)
    }
    
    //最小 item 间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    //最小行间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    //item 的尺寸
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:self.bounds.size.width / 2.0 - 30 / 2.0, height:(self.bounds.size.width / 2.0 - 30 / 2.0)/2.0)
    }
    
    //item 对应的点击事件
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("index is \(indexPath.row)")
        if (isEdit) {
            
            let cell:MainPageSectionZeroCell = collectionView.cellForItem(at: indexPath) as! MainPageSectionZeroCell
            mArrOfSelectedItem.add(indexPath)
            
            let str:String = "str\(indexPath.row)"
            mArrOfSelectedData.add(str)
            
            cell.selectIV.isHidden = false
        } else {
            let img:UIImage = UIImage(named:"Patrol_selected")!
            self.jumpBlock(img)
        }
    }

//    #pragma mark 反选
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    
        if (isEdit) {
            
            let cell:MainPageSectionZeroCell = collectionView.cellForItem(at: indexPath) as! MainPageSectionZeroCell
            if mArrOfSelectedItem.contains(indexPath) {
                
                mArrOfSelectedItem.remove(indexPath)
                
                let str:String = "str\(indexPath.row)"
                mArrOfSelectedData.remove(str)
                
                cell.selectIV.isHidden = true
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("\(touches)")
    }
}

class MainPageSectionZeroCell: UICollectionViewCell {
    
    var selectIV:UIImageView!
    var imageBtn:UIImageView!
    var maskV:UIView!

    override init(frame: CGRect) {
        super.init(frame: frame);
        
        let image = UIImage(named: "1")
        imageBtn = UIImageView(frame: CGRect(x:0, y:0, width:frame.size.width, height:frame.size.height))
        imageBtn.image = image
        self.contentView.addSubview(imageBtn)
        
        maskV = UIView()
        maskV.frame = self.bounds
        maskV.isHidden = true
        maskV.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        self.contentView.addSubview(maskV)
        
        selectIV = UIImageView(frame: CGRect(x:self.bounds.size.width-30, y:10, width:20, height:20))
        selectIV.image = UIImage(named:"CloudEyes_select")
        selectIV.isHidden = true
        self.contentView.addSubview(selectIV)
        
//        let tap:UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(tapClick))
//        self.contentView.addGestureRecognizer(tap)
    }
    
    func tapClick() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class MainPageSectionZeroHeadView: UICollectionReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        self.backgroundColor = UIColor.white
        let label = UILabel(frame: CGRect(x:0, y:0, width:self.frame.width, height:self.frame.height))
        label.text = "标题"
        self.addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) has not been implemented")
    }
}

