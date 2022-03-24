//
//  VerifyNumberVC.swift
//  TestingApp
//
//  Created by Adham Albanna on 24/03/2022.
//

import UIKit

class VerifyNumberVC: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnOk(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainTabBar") as! MainTabBar
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "userLogin")
        self.present(vc, animated: true, completion: nil)
    }

}
