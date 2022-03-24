//
//  UserSession.swift
//  TestingApp
//
//  Created by Adham Albanna on 24/03/2022.
//

import Foundation

struct UserSession {
    
    static var userInfo : Session? {
        set {
            guard newValue != nil else {
                UserDefaults.standard.removeObject(forKey: "UserSession")
                return;
            }
            let encodedData = try? PropertyListEncoder().encode(newValue)
            UserDefaults.standard.set(encodedData, forKey:"UserSession")
            UserDefaults.standard.synchronize();
        }
        get {
            if let data = UserDefaults.standard.value(forKey:"UserSession") as? Data {
                return try? PropertyListDecoder().decode(Session.self, from:data)
                
            }
            return nil
        }
    }
}
