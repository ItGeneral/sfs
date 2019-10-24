//
//  AlamofireHelper.swift
//  stock
//
//  Created by JiuHua on 2019/9/7.
//  Copyright © 2019 JiuHua. All rights reserved.
//

import Alamofire
import SwiftyJSON

class AlamofireHelper{
    class var shareInstance: AlamofireHelper {
        let alamofireHelper = AlamofireHelper()
        return alamofireHelper
    }
}

enum MethodType{
    case get
    case post
}

extension AlamofireHelper{
    
    // MARK: - 无参测试/get
    // MARK: - 发送POST请求
    func postRequest(url:String, params:[String:Any], completion:@escaping(_ response:[String:AnyObject]?,_ error:NSError?)->()) {
        let url = REQUEST_URL + url
        //let userInfo = PreferenceUtil.getAccountInfo()
        let headers: HTTPHeaders = [
            "Content-Type":"application/json;charset=utf-8",
            "Accept": "application/json",
            "sessionVisitor": ""
        ]
        Alamofire.request(url, method: .post, parameters: params,encoding: JSONEncoding.default, headers: headers)
            .responseJSON { (response) in
                if response.result.isSuccess{
                    completion(response.result.value as? [String:AnyObject],nil)
                }else{
                    completion(nil,response.result.error as NSError?)
                }
        }
    }
    
    // MARK: - 发送GET请求
    func getRequest(url:String,params:[String:String]?,completion:@escaping(_ response:[String:AnyObject]?,_ error:NSError?) -> ()){
        var url = REQUEST_URL + url
        var paramString = ""
        for param in params!{
            paramString += param.key + "=" + param.value + "&"
        }
        if paramString != ""{
            paramString = "?" + paramString.substring(NSRange.init(location: 0, length: paramString.length - 1))
        }
        url = url + paramString
        paramString = ""
        let headers: HTTPHeaders = [
            "Content-Type":"application/json;charset=utf-8",
            "Accept": "application/json",
            "sessionVisitor": ""
        ]
        Alamofire.request(url, method: .get, headers: headers)
            .responseJSON{ response in
                switch response.result {
                case .success( _):
                    if let value = response.result.value as? [String:AnyObject]{
                        completion(value,nil)
                    }
                case .failure( _):
                    completion(nil,response.result.error as NSError?)
                }
        }
    }
    
}

