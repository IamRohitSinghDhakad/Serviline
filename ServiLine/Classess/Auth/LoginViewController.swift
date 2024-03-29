//
//  LoginViewController.swift
//  ServiLine
//
//  Created by Rohit Singh Dhakad on 10/03/22.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet var tfEmail: UITextField!
    @IBOutlet var tfPassword: UITextField!
    @IBOutlet var vwEmailVerify: UIView!
    @IBOutlet var lblVerifyDesc: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tfPassword.isSecureTextEntry = true
        self.vwEmailVerify.isHidden = true

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnOnForgotPassword(_ sender: Any) {
        self.pushVc(viewConterlerId: "ForgotPasswordViewController")
    }
    @IBAction func btnShowPassword(_ sender: Any) {
        if self.tfPassword.isSecureTextEntry == true{
            self.tfPassword.isSecureTextEntry = false
        }else{
            self.tfPassword.isSecureTextEntry = true
        }
    }
    
   
    @IBAction func btnOnRegisterHere(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController")as! SignUpViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnDoneVerfiy(_ sender: Any) {
        self.vwEmailVerify.isHidden = true
    }
    
    @IBAction func btnOnLogin(_ sender: Any) {
        
        self.tfEmail.text = self.tfEmail.text?.trim()
        self.tfPassword.text = self.tfPassword.text?.trim()
        
        if (self.tfEmail.text!.isEmpty){
            objAlert.showAlert(message: "Escribir email", title: "", controller: self)
        }else if (self.tfPassword.text!.isEmpty){
            objAlert.showAlert(message: "Contraseña", title: "", controller: self)
        }else{
            self.call_WsLogin()
        }
    }
}


//MARK:- Call Webservice
extension LoginViewController{
    
    
    func call_WsLogin(){
        
        self.view.endEditing(true)
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let dicrParam = ["email":self.tfEmail.text!,
                         "password":self.tfPassword.text!,
                         "register_id":objAppShareData.strFirebaseToken,
                         "device_type":"IOS"
        ]as [String:Any]
        
        print(dicrParam)
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_Login, queryParams: [:], params: dicrParam, strCustomValidation: "", showIndicator: false) { response in
  
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            if status == MessageConstant.k_StatusCode{
                
                if let user_details  = response["result"] as? [String:Any] {
                    
                    if user_details["status"]as! String == "1"{
                        
                        let email = user_details["email"]as! String
                        if user_details["email_verified"]as! String == "0"{
                            self.vwEmailVerify.isHidden = false
                            self.lblVerifyDesc.text = "por favor verifica tu email. hemos enviado los detalles de la verificación en \(email)."
                        }else{
                            self.vwEmailVerify.isHidden = true
                            objAppShareData.SaveUpdateUserInfoFromAppshareData(userDetail: user_details)
                            objAppShareData.fetchUserInfoFromAppshareData()
                            self.makeRootController()
                        }
                    }else{
                        objAlert.showAlert(message: "Su cuenta está desactivada indefinidamente.", title: "", controller: self)
                    }
                }
                else {
                    objAlert.showAlert(message: "Something went wrong!", title: "", controller: self)
                }
            }else{
                objWebServiceManager.hideIndicator()
                if let msgg = response["result"]as? String{
                    objAlert.showAlert(message: msgg, title: "", controller: self)
                }else{
                    objAlert.showAlert(message: message ?? "", title: "", controller: self)
                }
            }
            
            
        } failure: { (Error) in
          //  print(Error)
            objWebServiceManager.hideIndicator()
        }
        
        
    }
    
    
    
    func makeRootController(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let vc = (self.mainStoryboard.instantiateViewController(withIdentifier: "SideMenuController") as? SideMenuController)!
        let navController = UINavigationController(rootViewController: vc)
        navController.isNavigationBarHidden = true
        appDelegate.window?.rootViewController = navController
    }
}
