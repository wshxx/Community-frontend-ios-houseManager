//
//  XHWLHttpTool.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/8/31.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit
import Foundation
import Alamofire

//let XHWLHttpURL :String = "http://112.74.19.135:1111/ssh/v1"
//let XHWLHttpURL :String = "http://192.168.2.101:9002"
//let XHWLHttpURL :String = "http://192.168.1.154:8080"
let XHWLHttpURL :String = "http://112.74.19.135:1111"

class XHWLHttpTool: NSObject {
    
    // 单例
    class var sharedInstance: XHWLHttpTool {
        struct Static {
            static let instance = XHWLHttpTool()
        }
        return Static.instance
    }
    
    // GET 请求方式
    func getHttpTool(url:String, parameters: Parameters,  success:@escaping (_ responseObject: [String : AnyObject])->(), failture:@escaping (_ error : NSError)->()) {
        
        var requestUrl:String = ""
        if XHWLHttpURL.compare("").rawValue == 0 {
            
            requestUrl = url
        } else {
            
            requestUrl = "\(XHWLHttpURL)/\(url)"
        }
        Alamofire.request(requestUrl, method: .get, parameters: parameters, encoding: URLEncoding.default)
            .responseJSON { response in
                
                switch response.result {
                case .success(let value):
                    print("error:\(value)")
                    success(value as! [String : AnyObject])
                    
                case .failure(let error):
                    failture(error as NSError)
                    print("error:\(error)")
                }
        }
    }
    
    // POST 请求方式  block:@escaping ((DataResponse<Any>)->()))
    func postHttpTool(url:String, parameters: Parameters, success:@escaping (_ responseObject: [String : AnyObject])->(), failture:@escaping (_ error : NSError)->()) {
        
        var requestUrl:String = ""
        if XHWLHttpURL.compare("").rawValue == 0 {
            
            requestUrl = url
        } else {
            
            requestUrl = "\(XHWLHttpURL)/\(url)"
        }
        Alamofire.request(requestUrl, method: .post, parameters: parameters, encoding: URLEncoding.default)
            .responseJSON { response in

                print(response.request)  // original URL request
                print(response.response) // HTTP URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                //当请求后response是我们自定义的，这个变量用于接受服务器响应的信息
                //使用switch判断请求是否成功，也就是response的result
                switch response.result {
                case .success(let value):
                    print("success:\(value)")
                    success(value as! [String : AnyObject])
                    
                case .failure(let error):
                    failture(error as NSError)
                    print("error:\(error)")
                }
        }
    }
}
