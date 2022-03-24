//
//  StatusResult.swift
//  TestingApp
//
//  Created by Adham Albanna on 24/03/2022.
//

import Foundation

class StatusResult {
    private var success :Bool
    var statusCode :Int?
    
    //if have more issue from server
    private var errors : [String] = []
    
    //if have one Single from server
    var message : String = ""

    var data : Any
 
    var isSuccess :Bool {
        get{
          return success
        }
        set{
            success = newValue
        }
    }
    
    var errorMessege :String{
        get{
            if errors.isEmpty {
                return message
            }
            
            
            var errorMessage :String = ""
            if errors.isEmpty {
                errorMessage.append(message)
            }
            for value in errors {
                errorMessage.append(contentsOf: value + "\n")
                
            }
            
            return errorMessage
        }
        
        set{
            errors.append(newValue)
        }
    }
    
    init(json: [String:Any], key:String?){
         success = json["success"] as? Bool ?? false
         errors = json["errors"] as? [String] ?? []
         message = json["message"] as? String ?? ""
         statusCode = json["status_code"] as? Int ?? 200

        if(key != nil){
         data  = json[key!] ?? json
        }else{
            data = json
        }
    }
   
}
