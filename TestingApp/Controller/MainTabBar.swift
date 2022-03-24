//
//  MainTabBar.swift
//  TestingApp
//
//  Created by Adham Albanna on 24/03/2022.
//

import UIKit
import STTabbar

class MainTabBar: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.selectedIndex = 2
        
        if let myTabbar = tabBar as? STTabbar {
            myTabbar.centerButtonActionHandler = {
                self.tabBarController?.selectedIndex = 2
            }
            myTabbar.centerButtonColor = .darkGray
            
        }
    }
}
