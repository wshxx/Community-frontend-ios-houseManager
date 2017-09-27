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

//let XHWLHttpURL :String = "http://120.77.83.190:8080/ssh/v1"
//let XHWLImgURL :String = "http://120.77.83.190:8080/ssh"
//let XHWLHttpURL :String = "http://10.51.37.54:8080/ssh/v1"
//let XHWLHttpURL :String = "http://10.51.37.74:4000/ssh/v1"
// 内网
//let XHWLImgURL: String = "http://192.168.200.116:8006/ssh"
//let XHWLHttpURL: String = "http://192.168.200.116:8006/ssh/v1"
// 外网 上线
let XHWLImgURL: String = "http://202.105.104.105:8006/ssh"
let XHWLHttpURL: String = "http://202.105.104.105:8006/ssh/v1"

@objc protocol XHWLHttpToolDelegate:NSObjectProtocol {
    
    @objc func requestSuccess(_ requestKey:NSInteger, result request:Any)
    @objc func requestFail(_ requestKey:NSInteger, _ error:NSError)
    @objc optional func requestCancel(_ requestKey:NSInteger)
//    @objc optional func requestSuccess(_ requestKey:NSInteger, operation operation:AFHTTPRequestOperation)

}

class XHWLHttpTool: NSObject {
    
    /**
     *  超时时间
     */
    var validTime:NSInteger? = 30 // 默认超时时间为10妙
    weak var delegate:XHWLHttpToolDelegate?
    var requestKey:XHWLRequestKeyID?
    var _isCancelled:Bool = false
    
    
    // 单例
//    class var sharedInstance: XHWLHttpTool {
//        struct Static {
//            static let instance = XHWLHttpTool()
//        }
//        return Static.instance
//    }
    
    func initWithKey(_ requestKey:XHWLRequestKeyID, _ delegate:XHWLHttpToolDelegate) {
        
        self.requestKey = requestKey
        self.delegate = delegate
    }
    
    // 获取请求URL
    func requestWithKey() -> String {
        
        print("\(self.requestKey)")
        
        if self.requestKey == XHWLRequestKeyID.XHWL_NAVPARAME {
            return XHWLRequestKeyDefine.shared.trandIdDict.object(forKey: self.requestKey ?? 0) as! String
        }
        else {
            let transId = XHWLRequestKeyDefine.shared.trandIdDict.object(forKey: self.requestKey ?? 0) as! String
            
            if transId.isEmpty {
                return XHWLHttpURL
            } else {
                return "\(XHWLHttpURL)/\(transId)"
            }
        }
    }
    
    // GET 请求方式
    func getHttpTool(_ parameters: NSArray) {

        var requestUrl:String = ""
        if self.requestKey == XHWLRequestKeyID.XHWL_NONE {
            requestUrl = requestWithKey()
        } else {
            print("requestUrl = \(requestUrl) \n")
            let paramStr:String = parameters.componentsJoined(by: "/") as String
            requestUrl = requestWithKey()
            if !paramStr.isEmpty {
                requestUrl = "\(requestUrl)/\(paramStr)"
            }
        }
        
        print("requestUrl = \(requestUrl) \n param = \(parameters)")
        
        Alamofire.request(requestUrl, method: .get, parameters:nil, encoding: URLEncoding.default)
            .responseJSON { response in
                
                XHMLProgressHUD.shared.hide()
                
//                print(response.request)  // original URL request
//                print(response.response) // HTTP URL response
//                print(response.data)     // server data
//                print(response.result)   // result of response serialization
                
                switch response.result {
                case .success(let value):
                    
                    print("success:\(value)")
                    
                    if self.requestKey != .XHWL_LOGOUT && self.requestKey != .XHWL_GETVERCODE && self.requestKey != .XHWL_SCANCODE {
                        if (value as! [String : AnyObject])["result"] is NSNull {
                            
                            let message:String = (value as! [String : AnyObject])["message"] as! String
                            message.ext_debugPrintAndHint()
                            return
                        }
                    }
                    
                    self.delegate?.requestSuccess(self.requestKey!.rawValue, result:value as! [String : AnyObject])
                    
                case .failure(let error):
                    print("error:\(error)")
                    
                    "请求失败！".ext_debugPrintAndHint()
                    self.delegate?.requestFail(self.requestKey!.rawValue, error as NSError)
                }
        }
    }

    // POST 请求方式
    func postHttpTool(_ parameters: Parameters) {
        
        let requestUrl:String = requestWithKey()
        print("requestUrl = \(requestUrl) \n param = \(parameters)")
   
        Alamofire.request(requestUrl, method: .post, parameters: parameters, encoding: URLEncoding.default)
            .responseJSON { response in
                
                XHMLProgressHUD.shared.hide()
                
                //                print(response.request)  // original URL request
                //                print(response.response) // HTTP URL response
                //                print(response.data)     // server data
                //                print(response.result)   // result of response serialization
                
                //当请求后response是我们自定义的，这个变量用于接受服务器响应的信息
                //使用switch判断请求是否成功，也就是response的result
                switch response.result {
                case .success(let value):
                    print("success:\(value)")
                    
                    if self.requestKey != .XHWL_RESETPWD &&
                        self.requestKey != .XHWL_VERCODENEXT &&
                        self.requestKey != .XHWL_FORGETPWD &&
                        self.requestKey != .XHWL_VISITREGISTER &&
                        self.requestKey != .XHWL_MODIFYUSER
                    {
                        
                        if (value as! [String : AnyObject])["result"] is NSNull {//is NSNull
                            
                            let message:String = (value as! [String : AnyObject])["message"] as! String
                            message.ext_debugPrintAndHint()
                            return
                        }
                    }
                    
                    self.delegate?.requestSuccess(self.requestKey!.rawValue, result:value as! [String : AnyObject])
                    
                case .failure(let error):
                    print("error:\(error)")
                    
                    "请求失败！".ext_debugPrintAndHint()
                    self.delegate?.requestFail(self.requestKey!.rawValue, error as NSError)
                }
        }
    }
    
    func uploadHttpTool(_ params:[String:String], _ data: [Data], _ name: [String]){
        
        let headers = ["content-type":"multipart/form-data"]
        let requestUrl:String = requestWithKey()
        print("requestUrl = \(requestUrl) \n param = \(params)")
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                
                for i in 0..<params.count {
                    
                    let dict = params as NSDictionary
                    let param = dict.allValues[i] as! String
                    
                    multipartFormData.append((param.data(using: String.Encoding.utf8)!), withName: dict.allKeys[i] as! String)
                }
                
//                let file = Bundle.main.path(forResource: "别人进行云对讲0000", ofType: "png")!
//                let fileUrl = URL(fileURLWithPath: file)
                
                for i in 0..<data.count { // "image.png"  "appPhoto" "appPhoto\(i)"
                    multipartFormData.append(data[i], withName:"appPhoto\(i)", fileName: name[i], mimeType: "image/png")
//                    multipartFormData.append(fileUrl, withName: "image/png")
//                    multipartFormData.append
                }
        },
            to: requestUrl,
            method:.post,
            headers: headers,
            encodingCompletion: { encodingResult in
                
                XHMLProgressHUD.shared.hide()
                
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        
                        if let value = response.result.value as? [String: AnyObject]{
                            
                            print("success:\(value)")
                            self.delegate?.requestSuccess(self.requestKey!.rawValue, result:value)
                        }
                    }
                case .failure(let encodingError):
                    print("error:\(encodingError)")
                    "请求失败！".ext_debugPrintAndHint()
                    self.delegate?.requestFail(self.requestKey!.rawValue, encodingError as NSError)
                }
        }
        )
    }

    // GET 请求方式
//    func getHttpTool(url:String, parameters: NSArray,  success:@escaping (_ responseObject: [String : AnyObject])->(), failture:@escaping (_ error : NSError)->()) {
//        
//        var requestUrl:String = ""
//        if XHWLHttpURL.compare("").rawValue == 0 {
//            requestUrl = url
//        } else {
//            requestUrl = "\(XHWLHttpURL)/\(url)"
//        }
//        
//        let paramStr:String = parameters.componentsJoined(by: "/") as String
//        requestUrl = "\(requestUrl)/\(paramStr)"
//        
//        print("requestUrl = \(requestUrl) \n")
//        
//        Alamofire.request(requestUrl, method: .get, parameters: [:], encoding: URLEncoding.default)
//            .responseJSON { response in
//                
//                switch response.result {
//                case .success(let value):
//                    print("success:\(value)")
//                    success(value as! [String : AnyObject])
//                    
//                case .failure(let error):
//                    failture(error as NSError)
//                    print("error:\(error)")
//                    "请求失败！".ext_debugPrintAndHint()
//                }
//        }
//    }
//    
//    // POST 请求方式  block:@escaping ((DataResponse<Any>)->()))
//    func postHttpTool(url:String, parameters: Parameters, success:@escaping (_ responseObject: [String : AnyObject])->(), failture:@escaping (_ error : NSError)->()) {
//        
//        var requestUrl:String = ""
//        if XHWLHttpURL.compare("").rawValue == 0 {
//            
//            requestUrl = url
//        } else {
//            
//            requestUrl = "\(XHWLHttpURL)/\(url)"
//        }
//        
//        print("requestUrl = \(requestUrl) \n param = \(parameters)")
//        
//        Alamofire.request(requestUrl, method: .post, parameters: parameters, encoding: URLEncoding.default)
//            .responseJSON { response in
//
////                print(response.request)  // original URL request
////                print(response.response) // HTTP URL response
////                print(response.data)     // server data
////                print(response.result)   // result of response serialization
//                
//                //当请求后response是我们自定义的，这个变量用于接受服务器响应的信息
//                //使用switch判断请求是否成功，也就是response的result
//                switch response.result {
//                case .success(let value):
//                    print("success:\(value)")
//                    success(value as! [String : AnyObject])
//                    
//                case .failure(let error):
//                    failture(error as NSError)
//                    print("error:\(error)")
//                    
//                    "请求失败！".ext_debugPrintAndHint()
//                }
//        }
//    }
    
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
//    func uploadHttpTool(url : String, params:[String:String], data: [Data], name: [String],success : @escaping (_ response : [String : AnyObject])->(), failture : @escaping (_ error : Error)->()){
//        
//        let headers = ["content-type":"multipart/form-data"]
//        var requestUrl:String = ""
//        if XHWLHttpURL.compare("").rawValue == 0 {
//            
//            requestUrl = url
//        } else {
//            
//            requestUrl = "\(XHWLHttpURL)/\(url)"
//        }
//        
//        print("requestUrl = \(requestUrl) \n param = \(params)")
//        
//        Alamofire.upload(
//            multipartFormData: { multipartFormData in
//                
//                for i in 0..<params.count {
//                    
//                    let dict = params as NSDictionary
//                    let param = dict.allValues[i] as! String
//                    
//                    multipartFormData.append((param.data(using: String.Encoding.utf8)!), withName: dict.allKeys[i] as! String)
//                }
// 
//                for i in 0..<data.count { // "image.png"  "appPhoto"
//                    multipartFormData.append(data[i], withName:"appPhoto\(i)", fileName: name[i], mimeType: "image/png")
//                }
//        },
//            to: requestUrl,
//            method:.post,
//            headers: headers,
//            encodingCompletion: { encodingResult in
//                switch encodingResult {
//                case .success(let upload, _, _):
//                    upload.responseJSON { response in
//                        if let value = response.result.value as? [String: AnyObject]{
//                           
//                            // let json = JSON(value)
//                            print(value)
//                            success(value)
//                        }
//                    }
//                case .failure(let encodingError):
//                    print(encodingError)
//                    failture(encodingError)
//                }
//        }
//        )
//    }
}
