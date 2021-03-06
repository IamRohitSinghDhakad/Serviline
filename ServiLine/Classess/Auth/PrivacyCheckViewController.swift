//
//  PrivacyCheckViewController.swift
//  ServiLine
//
//  Created by Rohit Singh Dhakad on 10/03/22.
//

import UIKit

class PrivacyCheckViewController: UIViewController {

    var strIsComingFrom: String?
    @IBOutlet var img1: UIImageView!
    @IBOutlet var img2: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.img1.image = UIImage.init(named: "square_white")
        self.img2.image = UIImage.init(named: "square_white")
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnCheckConditionUse(_ sender: Any) {
        if img1.image == UIImage.init(named: "square_white"){
            self.img1.image = UIImage.init(named: "checkbox_white")
        }else{
            self.img1.image = UIImage.init(named: "square_white")
        }
    }
    @IBAction func btnCheckPrivacyPolicy(_ sender: Any) {
        if img2.image == UIImage.init(named: "square_white"){
            self.img2.image = UIImage.init(named: "checkbox_white")
        }else{
            self.img2.image = UIImage.init(named: "square_white")
        }
    }
    
    @IBAction func btnOnConditionOfUse(_ sender: Any) {
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "WebViewShowViewController")as! WebViewShowViewController
        vc.strIsComingFrom = "Condiciones de Uso"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnOnPrivacyPolicy(_ sender: Any) {
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "WebViewShowViewController")as! WebViewShowViewController
        vc.strIsComingFrom = "Política de Privacidad"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func btnOnContinue(_ sender: Any) {
        
        if self.img1.image != UIImage.init(named: "checkbox_white"){
            objAlert.showAlert(message: "Por favor selecciona Condiciones de Uso", title: "", controller: self)
            
        }else  if self.img2.image != UIImage.init(named: "checkbox_white"){
            objAlert.showAlert(message: "Por favor selecciona Política de Privacidad", title: "", controller: self)
        }else{
            switch self.strIsComingFrom {
            case "1":
                pushVc(viewConterlerId: "SignUpViewController")
            default:
                pushVc(viewConterlerId: "LoginViewController")
               
            }
        }
    }
}
