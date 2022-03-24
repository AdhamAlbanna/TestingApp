//
//  API.swift
//  TestingApp
//
//  Created by Adham Albanna on 24/03/2022.
//

import Foundation
import Alamofire
import UIKit


enum API {
    //to see output into command text
    private static let DEBUG = true
    private  static let TAG = "API - Service "
    
    static let APP_ID = "e9a4wwy59etoi7h"
    static let DOMAIN_URL = "http://ahmedqazzaz.com/unitone/";
    

    //auth
    case home

    
    

    private var values : (url: String ,reqeustType: HTTPMethod,key :String?){
        get{
            switch self {
            case .home:
                return (API.DOMAIN_URL + "home", .get, "data")
                
            }
        }
    }

    func startRequest(uiViewController:UIViewController? = nil,showIndicator:Bool = false ,nestedParams :String = "",params :[String:Any] = [:],header : [String:String] = [:],completion : @escaping (API,StatusResult)->Void){
        var params = params
        var header = header
        var nestedParams = nestedParams
        

        header["Content-Type"] = "application/json"
        if let authToken = UserSession.userInfo?.id {
            header["Authorization"] = "\(authToken)"
        }
        
        
        var httpHeader = HTTPHeaders(header)
        if API.DEBUG {
            printRequest(nested: nestedParams,params: params, header: header)
        }
        
//        let currentViewCountroller = UIViewController.topmostViewController
        
        //        currentViewCountroller.isInterntConnected(){_ in
        //            self.startRequest(nestedParams:nestedParams,params: params, completion:completion)
        //        }
        
//        if showIndicator{
//            currentViewCountroller?.showIndicator()
//        }
        
        startRequest(api: self,nestedParams: nestedParams,params: params,header: httpHeader) { (result,status,message,statusCode) in
            if API.DEBUG {
                self.printResponse(result: result)
            }
            
//            if showIndicator{
//                currentViewCountroller?.hideIndicator()
//            }
            
            let statusResult = StatusResult(json: result,key: self.values.key)
            
            if !status {
                statusResult.isSuccess = status
                statusResult.errorMessege = message
            }
            
            
//            if statusCode == 401 {
//                currentViewCountroller!.singOutWithPermently(message: statusResult.errorMessege)
//            }else{
//                completion(self,statusResult)
//            }
            completion(self,statusResult)
        }
    }
    
    private func printRequest(nested :String, params :[String:Any] = [:],header : [String:String] = [:]){
        print(API.TAG + "url : \(self.values.url)/\(nested)" )
        print(API.TAG + "params : \(params)" )
        print(API.TAG + "header : \(header)" )
        
    }
        private func printResponse(result: [String:Any]) {
        print(API.TAG + "result : \(result)" )
    }
    
    private func startRequest(api :API,nestedParams :String = "",params : [String:Any] = [:],header: HTTPHeaders = [:], completion:@escaping ([String:Any],Bool,String,Int)->Void){
        
        AF.request(api.values.url+nestedParams, method: api.values.reqeustType, parameters: params.isEmpty ? nil:params,encoding: JSONEncoding.default, headers: header.isEmpty ? nil:header)
            //.validate(statusCode: 200..<441)
            .responseJSON { response  in
                if API.DEBUG {
                    if let statusCode = response.response?.statusCode {
                        print(API.TAG + "status code : \(statusCode)" )
                    }
                }
                switch(response.result)
                {
                case .success(let value):
                    if let resp = value as? [String:Any] {
                        completion(resp,true,"",response.response!.statusCode )
                    }else {
                        completion([:],false,"no data was found in response",response.response!.statusCode)
                    }
                    if API.DEBUG {
                        debugPrint(value)
                    }
                case .failure(let error) :
                    if API.DEBUG {
                        print(response.error.debugDescription)
                        print(error.errorDescription)
                        
                    }
                    completion([:],false,error.localizedDescription,response.response?.statusCode ?? 0)
                }
                
            }.cURLDescription { cUrl in
                print(cUrl)
            }
    }
    
    
    ///file
    func startRequestWithFile(uiViewController:UIViewController? = nil,showIndicator:Bool = false,nestedParams :String = "" ,params :[String:String] = [:],data :[String:Data] = [:],headers : [String:String] = [:],completion : @escaping (API,StatusResult)->Void){
        var params = params;
        var headers = headers;
        
        headers["Content-Type"] = "application/json"
        headers["Accept-Language"] = "ar"
        headers["X-Use-Legacy-Auth"] = "true"
        if let authToken = UserSession.userInfo?.id {
            headers["Authorization"] = "\(authToken)"
        }
        
        if API.DEBUG {
            printRequest(nested: nestedParams, params: params, header: headers)
            print("data size 'file Numbers' \(data.count)")
            
        }
        
//        let currentViewCountroller = UIViewController.topmostViewController!
        
        //            if  !currentViewCountroller.isConnectedToNetwork() {
        //                currentViewCountroller.isInterntConnected(){_ in
        //                    self.startRequest(params: params, completion:completion)
        //                }
        //                return
        //            }
        
        
//        if showIndicator{
//            currentViewCountroller.showIndicator()
//        }
        
        startRequest(api: self,nestedParams :nestedParams ,params: params,data: data,headers: HTTPHeaders(headers)) { (result,status,message) in
            if API.DEBUG {
                self.printResponse(result: result)
            }
            
//            if showIndicator{
//                currentViewCountroller.hideIndicator()
//            }
            
            let statusResult = StatusResult(json: result, key: self.values.key)
            
            if !status {
                statusResult.isSuccess = status
                statusResult.errorMessege = message
            }
            completion(self,statusResult)
        }
    }

    private func startRequest(api :API,nestedParams :String = "",params : [String:String] = [:],data : [String:Data] = [:],headers: HTTPHeaders = [:], completion:@escaping ([String:Any],Bool,String)->Void){
        print("full domain \(api.values.url + nestedParams)")
        
        AF.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in params {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key )
            }
            
            
            for (key, value) in data {
                multipartFormData.append(value, withName: key,fileName: "\(key).jpg", mimeType: "image/jpeg")
            }
            
        }, to: api.values.url + nestedParams , method:api.values.reqeustType ,headers: headers).uploadProgress {(progress) in
            print("file upload progress \(progress)%")
            
        }.responseJSON { (response) in
            
            if API.DEBUG {
                if let statusCode = response.response?.statusCode {
                    print(API.TAG + "status code : \(statusCode)" )
                }
            }
            
            switch(response.result)
            {
            case .success(let value):
                if let resp = value as? [String:Any] {
                    completion(resp,true,"")
                }else {
                    completion([:],false,"no data was found in response")
                }
                if API.DEBUG {
                    debugPrint(value)
                }
            case .failure(let error) :
                if API.DEBUG {
                    print(response.error.debugDescription)
                    print(error.errorDescription)
                }
                completion([:],false,error.localizedDescription)
            }
        }
    }
}

