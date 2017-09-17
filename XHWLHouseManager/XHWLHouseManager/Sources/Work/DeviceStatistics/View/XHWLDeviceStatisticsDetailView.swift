//
//  XHWLDeviceStatisticsDetailView.swift
//  XHWLHouseManager
//
//  Created by admin on 2017/9/16.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLDeviceStatisticsDetailView: UIView, PieChartDelegate {
    
    var bgImage:UIImageView!
    var chartView: PieChart!

    // MARK: - Models
    
    fileprivate func createModels() -> [PieSliceModel] {
        let alpha: CGFloat = 0.5
        
        return [
            PieSliceModel(value: 2.1, color: UIColor.yellow.withAlphaComponent(alpha)),
            PieSliceModel(value: 3, color: UIColor.blue.withAlphaComponent(alpha)),
            PieSliceModel(value: 1, color: UIColor.green.withAlphaComponent(alpha)),
            PieSliceModel(value: 4, color: UIColor.cyan.withAlphaComponent(alpha)),
            PieSliceModel(value: 2, color: UIColor.red.withAlphaComponent(alpha)),
            PieSliceModel(value: 1.5, color: UIColor.magenta.withAlphaComponent(alpha)),
            PieSliceModel(value: 0.5, color: UIColor.orange.withAlphaComponent(alpha))
        ]
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func viewDidAppear() {
        
        chartView.layers = [createCustomViewsLayer(), createTextLayer()]
        chartView.delegate = self
        chartView.models = createModels() // order is important - models have to be set at the end
    }
    
    func setupView() {
        
        bgImage = UIImageView()
        bgImage.image = UIImage(named:"menu_bg")
        self.addSubview(bgImage)
        
        chartView = PieChart.init(frame: CGRect(x:0, y:self.bounds.size.height-350, width:self.bounds.size.width, height:350))
        chartView.innerRadius = 0
        chartView.outerRadius = 100
//        chartView.selectedOffset = 30
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
    }
    
    
    // MARK: - Layers
    
    fileprivate func createCustomViewsLayer() -> PieCustomViewsLayer {
        let viewLayer = PieCustomViewsLayer()
        
        let settings = PieCustomViewsLayerSettings()
        settings.viewRadius = 135
        settings.hideOnOverflow = false
        viewLayer.settings = settings
        
        viewLayer.viewGenerator = createViewGenerator()
        
        return viewLayer
    }
    
    fileprivate func createTextLayer() -> PiePlainTextLayer {
        let textLayerSettings = PiePlainTextLayerSettings()
        textLayerSettings.viewRadius = 60
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
    
    fileprivate func createViewGenerator() -> (PieSlice, CGPoint) -> UIView {
        return {slice, center in
            
            let container = UIView()
            container.frame.size = CGSize(width: 100, height: 40)
            container.center = center
            let view = UIImageView()
            view.frame = CGRect(x: 30, y: 0, width: 40, height: 40)
            container.addSubview(view)
            
            if slice.data.id == 3 || slice.data.id == 0 {
                let specialTextLabel = UILabel()
                specialTextLabel.textAlignment = .center
                if slice.data.id == 0 {
                    specialTextLabel.text = "views"
                    specialTextLabel.font = UIFont.boldSystemFont(ofSize: 18)
                } else if slice.data.id == 3 {
                    specialTextLabel.textColor = UIColor.white
                    specialTextLabel.text = "Custom"
                }
                specialTextLabel.sizeToFit()
                specialTextLabel.frame = CGRect(x: 0, y: 40, width: 100, height: 20)
                container.addSubview(specialTextLabel)
                container.frame.size = CGSize(width: 100, height: 60)
            }
            
            
            // src of images: www.freepik.com, http://www.flaticon.com/authors/madebyoliver
            let imageName: String? = {
                switch slice.data.id {
                case 0: return "fish"
                case 1: return "grapes"
                case 2: return "doughnut"
                case 3: return "water"
                case 4: return "chicken"
                case 5: return "beet"
                case 6: return "cheese"
                default: return nil
                }
            }()
            
            view.image = imageName.flatMap{UIImage(named: $0)}
            
            return container
        }
    }
}
