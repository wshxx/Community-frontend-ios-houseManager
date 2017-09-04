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

let XHWLHttpURL :String = "http://112.74.19.135:1111/ssh/v1"

class XHWLHttpTool: NSObject {
    
    // 单例
    class var sharedInstance: XHWLHttpTool {
        struct Static {
            static let instance = XHWLHttpTool()
        }
        return Static.instance
    }
    
    // GET 请求方式
    func getHttpTool(url:String, parameters: Parameters, block:@escaping ((DataResponse<Any>)->())) {
        
        let requestUrl:String = "\(XHWLHttpURL)/\(url)"
        Alamofire.request(requestUrl, method: .get, parameters: parameters, encoding: URLEncoding.default)
            .responseJSON { response in
                
                block(response)
        }
    }
    
    // POST 请求方式
    func postHttpTool(url:String, parameters: Parameters, block:@escaping ((DataResponse<Any>)->())) {
        
        let requestUrl:String = "\(XHWLHttpURL)/\(url)"
        Alamofire.request(requestUrl, method: .post, parameters: parameters, encoding: URLEncoding.default)
            .responseJSON { response in
                
                block(response)
                
//                switch response.result {
//                case .success:
//                    
//                    print("Validation Successful")
//                case .failure(let error):
//                    print(error)
//                    
//                }
        }
    }
}
