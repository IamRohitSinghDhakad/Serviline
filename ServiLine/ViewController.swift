//
//  ViewController.swift
//  ServiLine
//
//  Created by Rohit Singh Dhakad on 10/03/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var lblText:UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblText.text = "Plataforma exclusiva\npara contactar con sectores\ny profesionales de servicios"
        // Do any additional setup after loading the view.
    }
    @IBAction func btnOnSignUp(_ sender: Any) {
        
       // let sb = UIStoryboard.init(name: "Auth", bundle: nil)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PrivacyCheckViewController")as! PrivacyCheckViewController
        vc.strIsComingFrom = "1"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

    @IBAction func btnOnSignIn(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PrivacyCheckViewController")as! PrivacyCheckViewController
        vc.strIsComingFrom = "2"
        self.navigationController?.pushViewController(vc, animated: true)    }
}

