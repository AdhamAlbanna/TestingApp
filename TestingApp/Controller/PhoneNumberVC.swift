//
//  PhoneNumberVC.swift
//  TestingApp
//
//  Created by Adham Albanna on 24/03/2022.
//

import UIKit
import FirebaseAuth

class PhoneNumberVC: UIViewController {

    @IBOutlet weak var phoneNumber: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func sendCode(_ sender: Any) {
        PhoneAuthProvider.provider()
            .verifyPhoneNumber("+970"+phoneNumber.text!, uiDelegate: nil) { verificationID, error in
              if let error = error {
                print(error.localizedDescription)
                return
              }
                let vc = self.storyboard!.instantiateViewController(withIdentifier: "VerifyNumberVC") as! VerifyNumberVC
                self.navigationController?.pushViewController(vc, animated: true)
          }
    }

}
