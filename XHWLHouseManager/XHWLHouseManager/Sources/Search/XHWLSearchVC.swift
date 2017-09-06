//
//  XHWLSearchVC.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/5.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLSearchVC: UIViewController, UITableViewDelegate, UITableViewDataSource, XHWLSearchBarDelegate {

    var searchBar:XHWLSearchBar!
    var tableView: UITableView!
    var myArray:NSMutableArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        myArray = NSMutableArray()
        setupSearchBar()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func setupTableView() {
        
        let tableView: UITableView = UITableView()
        tableView.frame = CGRect(x:0, y:searchBar.frame.maxY, width:self.view.bounds.size.width, height:(self.view.bounds.size.height - searchBar.frame.maxY))
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.view.addSubview(tableView)
    }
    
    func setupSearchBar() {
        let chatbarHeight:CGFloat = XHWLSearchBar.defaultHeight()
        searchBar = XHWLSearchBar.init(frame: CGRect(x:0, y:chatbarHeight, width:self.view.frame.size.width, height:chatbarHeight))
        searchBar.autoresizingMask = UIViewAutoresizing.flexibleTopMargin
        searchBar.placeholder = "请输入关键字词"
        searchBar.delegate = self
        searchBar.backgroundColor = UIColor.orange
        searchBar.borderColor = UIColor.clear
        searchBar.textColor = UIColor.white
        searchBar.cancelColor = UIColor.blue
        
        self.view.addSubview(searchBar)
    }
    

//#pragma mark - JYSearchBarDelegate
// 点击搜索
    func searchBarSearchButtonClicked(searchBar: XHWLSearchBar) {
        searchBar.resignFirstResponder()
        if searchBar.searchTextField.text?.compare("").rawValue == 0 {
            
//            [ZYTokenManager SearchText:self.searchBar.searchTextField.text];//缓存搜索记录
            readNSUserDefaults()
            
        }else{
            print("请输入查找内容")
        }
    }
    
    func searchBarTextDidBeginEditing(searchBar: XHWLSearchBar) {
        
    }
    
    func searchBarCancelButtonClicked(searchBar: XHWLSearchBar) {
        searchBar.searchTextField.resignFirstResponder()
        self.navigationController?.popViewController(animated: true)
    }
    
    func readNSUserDefaults() {
        let userDefaultes:UserDefaults = UserDefaults.standard
        //读取数组NSArray类型的数据
        myArray = userDefaultes.object(forKey:"myArray") as! NSMutableArray
        tableView.reloadData()
        print("myArray======%\(myArray)")
    }

    //#pragma mark - UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section==0) {
            if (myArray.count>0) {
                return myArray.count+1+1;
            }else{
                return 1;
            }
        }else{
            return 0;
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            if(indexPath.row == 0){
                let cell: UITableViewCell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
                cell.textLabel?.text = "历史搜索"
                cell.textLabel?.textColor = UIColor.gray
                
                return cell
            } else if (indexPath.row == myArray.count+1) {
                let cell: UITableViewCell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
                cell.textLabel?.text = "清除历史记录"
                cell.textLabel?.textColor = UIColor.gray
                cell.textLabel?.textAlignment = NSTextAlignment.center
                return cell
            } else {
                let cell: UITableViewCell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
                let reversedArray:NSArray = myArray.reverseObjectEnumerator().allObjects as NSArray
                cell.textLabel?.text = reversedArray[indexPath.row-1] as? String
                return cell
            }
        }else{
            let cell: UITableViewCell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        
        if (indexPath.row == myArray.count+1) {//清除所有历史记录
            let alertController:UIAlertController = UIAlertController(title: "清除历史记录", message: nil, preferredStyle: UIAlertControllerStyle.alert)
            
            let cancelAction:UIAlertAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil)
            let deleteAction:UIAlertAction = UIAlertAction(title: "确认", style: UIAlertActionStyle.default, handler: { (action) in
//                [ZYTokenManager removeAllArray];
//                myArray = nil
                self.tableView.reloadData()
            })
            alertController.addAction(cancelAction)
            alertController.addAction(deleteAction)
            self.present(alertController, animated: true, completion: nil)
        }else{
            
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section==0) {
            return 0;
        }else{
            return 10;
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
