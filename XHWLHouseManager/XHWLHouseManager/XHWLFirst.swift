//
//  XHWLFirst.swift
//  XHWLHouseManager
//
//  Created by admin on 2017/8/30.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import Foundation
import UIKit

public class XHWLFirst: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    var tableView: UITableView!
    
    public let sectionTitleArray = ["Basic", "Embed", "Animation", "Irregular", "Customize click", "Remind", "Lottie"]
    public let sectionSubtitleArray = ["基本", "嵌套", "动画", "不规则", "自定义点击", "提醒", "Lottie"]
    public let titleArray = [
        [
            "UITabBarController style",
            "ESTabBarController like system style",
            "Mix ESTabBar and UITabBar",
            "UITabBarController style with 'More'",
            "ESTabBarController style with 'More'",
            "Mix ESTabBar and UITabBar with 'More'",
            "UITabBarController style with non-zero default index",
            "ESTabBarController style with non-zero default index"
        ],
        [
            "ESTabBarController embeds the UINavigationController style",
            "UINavigationController embeds the ESTabBarController style",
            ],
        [
            "Customize the selected color style",
            "Spring animation style",
            "Background color change style",
            "With a selected effect style",
            "Suggested clicks style",
            ],
        [
            "In the middle with a larger button style",
            ],
        [
            "Hijack button click event",
            "Add a special reminder box",
            ],
        [
            "System remind style",
            "Imitate system remind style",
            "Remind style with animation",
            "Remind style with animation(2)",
            "Customize remind style",
            ],
        [
            "Lottie",
            ],
        ]
    
    public let subtitleArray = [
        [
            "UITabBarController样式",
            "ESTabBarController仿系统样式",
            "ESTabBar和UITabBar混合样式",
            "带有'More'的UITabBarController样式",
            "带有'More'的ESTabBarController样式",
            "带有'More'的ESTabBar和UITabBar混合样式",
            "默认index非0的UITabBarController样式",
            "默认index非0的ESTabBarController样式"
        ],
        [
            "UINavigationController内嵌UITabBarController样式",
            "UITabBarController内嵌UINavigationController样式",
            ],
        [
            "自定义选中颜色样式",
            "弹簧动画样式",
            "背景颜色变化样式",
            "带有选中效果样式",
            "暗示用户点击样式",
            ],
        [
            "中间带有较大按钮样式",
            ],
        [
            "劫持按钮的点击事件",
            "添加一个特殊的提醒框",
            ],
        [
            "系统提醒样式",
            "仿系统提醒样式",
            "带动画提醒样式",
            "带动画提醒样式(2)",
            "自定义提醒样式",
            ],
        [
            "Lottie",
            ],
        ]

    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(white: 245.0 / 255.0, alpha: 1.0)
        self.navigationItem.title = "Example"
        
        self.tableView = UITableView(frame: self.view.bounds)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.view.addSubview(self.tableView)
    }
    
    // MARK: UITableViewDataSource
    public func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitleArray.count
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray[section].count
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68.0
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 42.0
    }
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitleArray[section] + " " + "(" + sectionSubtitleArray[section] + ")"
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell") ?? UITableViewCell.init(style: .subtitle, reuseIdentifier: "UITableViewCell")
        
        cell.textLabel?.textColor = UIColor.init(white: 0.0, alpha: 0.6)
        cell.textLabel?.font = UIFont.init(name: "ChalkboardSE-Bold", size: 14.0)
        cell.textLabel?.lineBreakMode = .byCharWrapping
        cell.textLabel?.text = "\(indexPath.section + 1).\(indexPath.row + 1) \(titleArray[indexPath.section][indexPath.row])"
        cell.textLabel?.numberOfLines = 2
        
        cell.detailTextLabel?.textColor = UIColor.init(white: 0.0, alpha: 0.5)
        cell.detailTextLabel?.font = UIFont.init(name: "ChalkboardSE-Bold", size: 11.0)
        cell.detailTextLabel?.text = "\(indexPath.section + 1).\(indexPath.row + 1) \(subtitleArray[indexPath.section][indexPath.row])"
        cell.detailTextLabel?.numberOfLines = 2
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.present(self.customStyle(), animated: true, completion: nil)
        
        
    }
    
    func customStyle() -> ESTabBarController {
        let tabBarController = ESTabBarController()
        let v1 = XHWLHome()
        let v2 = XHWLHome()
        let v3 = XHWLHome()
        let v4 = XHWLHome()
        let v5 = XHWLHome()
        
        v1.tabBarItem = ESTabBarItem.init(title: "Home", image: UIImage(named: "home"), selectedImage: UIImage(named: "home_1"))
        v2.tabBarItem = ESTabBarItem.init(title: "Find", image: UIImage(named: "find"), selectedImage: UIImage(named: "find_1"))
        v3.tabBarItem = ESTabBarItem.init(title: "Photo", image: UIImage(named: "photo"), selectedImage: UIImage(named: "photo_1"))
        v4.tabBarItem = ESTabBarItem.init(title: "Favor", image: UIImage(named: "favor"), selectedImage: UIImage(named: "favor_1"))
        v5.tabBarItem = ESTabBarItem.init(title: "Me", image: UIImage(named: "me"), selectedImage: UIImage(named: "me_1"))
        
        tabBarController.viewControllers = [v1, v2, v3, v4, v5]
        
        return tabBarController
    }

}
