//
//  XHWLMcuLogView.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/10/20.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLMcuLogView: UIView , UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = UICollectionViewCell.init(frame: CGRect(x:0, y:0, width:12, height:23))
        
        return cell
    }
    

    var bgImage:UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
        bgImage = UIImageView()
        bgImage.image = UIImage(named:"subview_bg")
        self.addSubview(bgImage)
        
        let collect:UICollectionView = UICollectionView()
        collect.delegate = self
        collect.dataSource = self
        self.addSubview(collect)
        
//        playAry = NSMutableArray()
//        for i in 0..<2 {
//            let orginX:CGFloat = 5
//            let orginY:CGFloat = CGFloat(i*200+30)
//            let width:CGFloat = self.bounds.size.width-10
//            let height:CGFloat = 150.0
//
//            let first = XHWLMcuView(frame:CGRect(x:orginX, y:orginY, width:width, height:height))
//            first.delegate = self
//            first.tag = comTag+i
//            self.addSubview(first)
//            playAry.add(first)
//        }
    }

}
