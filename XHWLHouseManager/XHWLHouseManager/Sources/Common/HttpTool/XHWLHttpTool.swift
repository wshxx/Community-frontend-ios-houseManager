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
    func getHttpTool(url:String, parameters: NSArray,  success:@escaping (_ responseObject: [String : AnyObject])->(), failture:@escaping (_ error : NSError)->()) {
        
        var requestUrl:String = ""
        if XHWLHttpURL.compare("").rawValue == 0 {
            requestUrl = url
        } else {
            requestUrl = "\(XHWLHttpURL)/\(url)"
        }
        
        let paramStr:String = parameters.componentsJoined(by: "/") as String
        requestUrl = "\(requestUrl)/\(paramStr)"
        
        print("requestUrl = \(requestUrl) \n")
        
        Alamofire.request(requestUrl, method: .get, parameters: [:], encoding: URLEncoding.default)
            .responseJSON { response in
                
                switch response.result {
                case .success(let value):
                    print("success:\(value)")
                    success(value as! [String : AnyObject])
                    
                case .failure(let error):
                    failture(error as NSError)
                    print("error:\(error)")
                    
                    "请求失败！".ext_debugPrintAndHint()
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
        
        print("requestUrl = \(requestUrl) \n param = \(parameters)")
        
        Alamofire.request(requestUrl, method: .post, parameters: parameters, encoding: URLEncoding.default)
            .responseJSON { response in

//                print(response.request)  // original URL request
//                print(response.response) // HTTP URL response
//                print(response.data)     // server data
//                print(response.result)   // result of response serialization
                
                //当请求后response是我们自定义的，这个变量用于接受服务器响应的信息
                //使用switch判断请求是否成功，也就是response的result
                switch response.result {
                case .success(let value):
                    print("success:\(value)")
                    success(value as! [String : AnyObject])
                    
                case .failure(let error):
                    failture(error as NSError)
                    print("error:\(error)")
                    
                    "请求失败！".ext_debugPrintAndHint()
                }
        }
    }
    
    //MARK: - 照片上传
    ///
    /// - Parameters:
    ///   - urlString: 服务器地址
    ///   - params: ["flag":"","userId":""] - flag,userId 为必传参数
    ///        flag - 666 信息上传多张  －999 服务单上传  －000 头像上传
    ///   - data: image转换成Data
    ///   - name: fileName
    ///   - success:
    ///   - failture:
    func uploadHttpTool(url : String, params:[String:String], data: [Data], name: [String],success : @escaping (_ response : [String : AnyObject])->(), failture : @escaping (_ error : Error)->()){
        
        let headers = ["content-type":"multipart/form-data"]
        var requestUrl:String = ""
        if XHWLHttpURL.compare("").rawValue == 0 {
            
            requestUrl = url
        } else {
            
            requestUrl = "\(XHWLHttpURL)/\(url)"
        }
        
        print("requestUrl = \(requestUrl) \n param = \(params)")
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                
                for i in 0..<params.count {
                    
                    let dict = params as NSDictionary
                    let param = dict.allValues[i] as! String
                    
                    multipartFormData.append((param.data(using: String.Encoding.utf8)!), withName: dict.allKeys[i] as! String)
                }
 
                for i in 0..<data.count { // "image.png"  "appPhoto"
                    multipartFormData.append(data[i], withName:"appPhoto\(i)", fileName: name[i], mimeType: "image/png")
                }
        },
            to: requestUrl,
            method:.post,
            headers: headers,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        if let value = response.result.value as? [String: AnyObject]{
                           
                            // let json = JSON(value)
                            print(value)
                            success(value)
                        }
                    }
                case .failure(let encodingError):
                    print(encodingError)
                    failture(encodingError)
                }
        }
        )
    }
}
