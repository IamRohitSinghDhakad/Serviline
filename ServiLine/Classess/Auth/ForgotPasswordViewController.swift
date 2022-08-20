//
//  ForgotPasswordViewController.swift
//  ServiLine
//
//  Created by Rohit Singh Dhakad on 14/03/22.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    @IBOutlet var tfEmail: UITextField!
    
    @IBOutlet var lblSuccessMsg: UILabel!
    @IBOutlet var vwSuccessForgotPassword: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.vwSuccessForgotPassword.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnOk(_ sender: Any) {
        self.onBackPressed()
    }
    
    @IBAction func btnBackOnHeader(_ sender: Any) {
        onBackPressed()
    }
    
    @IBAction func btnOnSubmit(_ sender: Any) {
        if (self.tfEmail.text!.isEmpty){
            objAlert.showAlert(message: "Escribir email", title: "", controller: self)
        }else{
            self.call_WsForgotPassword()
        }
    }
}


//MARK:- Call Webservice Forgot Password
extension ForgotPasswordViewController{
    
    func call_WsForgotPassword(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
    
        objWebServiceManager.showIndicator()
        
        let dicrParam = ["email":self.tfEmail.text!]as [String:Any]
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_forgotPassword, queryParams: [:], params: dicrParam, strCustomValidation: "", showIndicator: false) { (response) in
            objWebServiceManager.hideIndicator()
            var statusCode = Int()
            if let status = (response["status"] as? Int){
                statusCode = status
            }else  if let status = (response["status"] as? String){
                statusCode = Int(status)!
            }
            
            let message = (response["message"] as? String)
            if statusCode == MessageConstant.k_StatusCode{
                self.lblSuccessMsg.text = "Por favor revisa tu email \(self.tfEmail.text!)";
                self.vwSuccessForgotPassword.isHidden = false
                
              //  objAlert.showAlertCallBack(alertLeftBtn: "", alertRightBtn: "OK", title: "", message: message ?? "Enviar enlace de reenvío en su correo electrónico de registro.", controller: self) {
                //    self.onBackPressed()
               // }
                
            }else{
               
                objWebServiceManager.hideIndicator()
                objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
                
            }
           
            
        } failure: { (Error) in
            objWebServiceManager.hideIndicator()
        }

    
   }
    
}
