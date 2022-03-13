//
//  PrivacyCheckViewController.swift
//  ServiLine
//
//  Created by Rohit Singh Dhakad on 10/03/22.
//

import UIKit

class PrivacyCheckViewController: UIViewController {

    var strIsComingFrom: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func btnOnContinue(_ sender: Any) {
        
        switch self.strIsComingFrom {
        case "1":
            pushVc(viewConterlerId: "LoginViewController")
        default:
            pushVc(viewConterlerId: "SignUpViewController")
        }
    }
    

}
