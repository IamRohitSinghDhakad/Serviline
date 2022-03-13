//
//  ForgotPasswordViewController.swift
//  ServiLine
//
//  Created by Rohit Singh Dhakad on 14/03/22.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    @IBOutlet var tfEmail: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func btnBackOnHeader(_ sender: Any) {
        onBackPressed()
    }
    
    @IBAction func btnOnSubmit(_ sender: Any) {
        onBackPressed()
    }
}
