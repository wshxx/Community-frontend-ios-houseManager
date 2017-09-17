//
//  XHWLDeviceStatisticsView.swift
//  XHWLHouseManager
//
//  Created by admin on 2017/9/16.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit
import PieCharts

class XHWLDeviceStatisticsView: UIView , PieChartDelegate  {

    var bgImage:UIImageView!
    var chartView: PieChart!
    var onClickBlock:(NSInteger)->() = {param in }
    
    fileprivate static let alpha: CGFloat = 0.5
    let colors = [
        UIColor.yellow.withAlphaComponent(alpha),
        UIColor.green.withAlphaComponent(alpha),
        UIColor.purple.withAlphaComponent(alpha),
        UIColor.cyan.withAlphaComponent(alpha),
        UIColor.darkGray.withAlphaComponent(alpha),
        UIColor.red.withAlphaComponent(alpha),
        UIColor.magenta.withAlphaComponent(alpha),
        UIColor.orange.withAlphaComponent(alpha),
        UIColor.brown.withAlphaComponent(alpha),
        UIColor.lightGray.withAlphaComponent(alpha),
        UIColor.gray.withAlphaComponent(alpha),
        ]
    fileprivate var currentColorIndex = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        
        setupView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func viewDidAppear() {
        
        chartView.layers = [createPlainTextLayer(), createTextWithLinesLayer()]
        chartView.delegate = self
        chartView.models = createModels() // order is important - models have to be set at the end
    }
    
    func setupView() {
        
        bgImage = UIImageView()
        bgImage.image = UIImage(named:"menu_bg")
        self.addSubview(bgImage)
        
        
        chartView = PieChart.init(frame: CGRect(x:0, y:self.bounds.size.height-350, width:self.bounds.size.width, height:350))
        chartView.innerRadius = 70
        chartView.outerRadius = 100
        chartView.selectedOffset = 0
        chartView.animDuration = 0.5
        chartView.referenceAngle = 270
        chartView.tintColor = UIColor.white
        self.addSubview(chartView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bgImage.frame = self.bounds
        chartView.frame = CGRect(x:0, y:0, width:375, height:350)
    }
    
    // MARK: - PieChartDelegate
    
    func onSelected(slice: PieSlice, selected: Bool) {
        print("Selected: \(selected), slice: \(slice)")
        
        self.onClickBlock(1)
    }
    
    // MARK: - Models
    
    fileprivate func createModels() -> [PieSliceModel] {
        
        let models = [
            PieSliceModel(value: 10, color: colors[0]),
            PieSliceModel(value: 2, color: colors[1]),
            PieSliceModel(value: 2, color: colors[2])
        ]
        
        currentColorIndex = models.count
        return models
    }
    
    
    // MARK: - Layers
    // 圈内的文本
    fileprivate func createPlainTextLayer() -> PiePlainTextLayer {
        
        let textLayerSettings = PiePlainTextLayerSettings()
        textLayerSettings.viewRadius = 55
        textLayerSettings.hideOnOverflow = true
        textLayerSettings.label.font = UIFont.systemFont(ofSize: 14)
        textLayerSettings.label.textColor = UIColor.white
        
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        textLayerSettings.label.textGenerator = {slice in
            return formatter.string(from: slice.data.percentage * 100 as NSNumber).map{"\($0)%"} ?? ""
        }
        
        let textLayer = PiePlainTextLayer()
        textLayer.settings = textLayerSettings
        return textLayer
    }
    
    //圈外的文本和线
    fileprivate func createTextWithLinesLayer() -> PieLineTextLayer {
        let lineTextLayer = PieLineTextLayer()
        var lineTextLayerSettings = PieLineTextLayerSettings()
        lineTextLayerSettings.lineColor = UIColor.lightGray
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        lineTextLayerSettings.label.font = UIFont.systemFont(ofSize: 14)
        lineTextLayerSettings.label.textColor = UIColor.white
        lineTextLayerSettings.label.textGenerator = {slice in
            return formatter.string(from: slice.data.model.value as NSNumber).map{"\($0)"} ?? ""
        }
        
        lineTextLayer.settings = lineTextLayerSettings
        return lineTextLayer
    }
    
    // 点击加号
//    func onPlusTap(sender: UIButton) {
//        let newModel = PieSliceModel(value: 4 * Double(CGFloat.random()), color: colors[currentColorIndex])
//        chartView.insertSlice(index: 0, model: newModel)
//        currentColorIndex = (currentColorIndex + 1) % colors.count
//        if currentColorIndex == 2 {currentColorIndex += 1} // avoid same contiguous color
//    }
}


extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func randomColor() -> UIColor {
        return UIColor(red: .random(), green: .random(), blue: .random(), alpha: 1.0)
    }
}

