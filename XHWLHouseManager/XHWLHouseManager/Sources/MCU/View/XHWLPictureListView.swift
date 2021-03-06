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
    var jumpBlock:(XHWLMcuPictureModel)->() = { param in }
//    var mArrOfSelectedData:NSMutableArray = NSMutableArray()
//    var mArrOfSelectedItem:NSMutableArray = NSMutableArray()
    
    
    var collectAry:NSMutableArray = NSMutableArray()
    var deleteAry:NSMutableArray = NSMutableArray()
    var isEdit:Bool = false {
        willSet {
            if newValue == true {
                deleteAry = NSMutableArray()

                for i in 0..<collectAry.count {
                    let model:XHWLMcuPictureModel = collectAry[i] as! XHWLMcuPictureModel
                    model.isEdit = newValue
                    collectAry.replaceObject(at: i, with: model)
                }
                
                collectionView.reloadData()
            } else {
                deleteAry = NSMutableArray()

                for i in 0..<collectAry.count {
                    let model:XHWLMcuPictureModel = collectAry[i] as! XHWLMcuPictureModel
                    model.isEdit = newValue
                    collectAry.replaceObject(at: i, with: model)
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
        return 1
    }
    
    //每个分区含有的 item 个数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectAry.count
    }
    
    //返回 cell
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_ID, for: indexPath) as! MainPageSectionZeroCell
        let model:XHWLMcuPictureModel = collectAry[indexPath.row] as! XHWLMcuPictureModel
        cell.cellModel = model
        
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
            let model:XHWLMcuPictureModel = collectAry[indexPath.row] as! XHWLMcuPictureModel
            
            if deleteAry.contains(model) {
                model.isSelected = false
                deleteAry.remove(model)
                collectAry.replaceObject(at: indexPath.row, with: model)
            } else {
                model.isSelected = true
                deleteAry.add(model)
                collectAry.replaceObject(at: indexPath.row, with: model)
            }
            collectionView.reloadData()
        } else {
            let model:XHWLMcuPictureModel = collectAry[indexPath.row] as! XHWLMcuPictureModel
            self.jumpBlock(model)
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
    var cellModel:XHWLMcuPictureModel! {
        willSet {
            if newValue != nil {
                
                let url = URL(string: newValue.imageUrl)
                imageBtn.kf.setImage(with: url, placeholder: UIImage(named:"default_icon"), options: nil, progressBlock: nil, completionHandler: nil)
                if newValue.isEdit {
                    self.maskV.isHidden = false
                    if newValue.isSelected {
                        self.selectIV.isHidden = false
                    } else {
                        self.selectIV.isHidden = true
                    }
                } else {
                    self.maskV.isHidden = true
                    self.selectIV.isHidden = true
                }
            }
        }
    }

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

