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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnOnForgotPassword(_ sender: Any) {
        self.pushVc(viewConterlerId: "ForgotPasswordViewController")
    }
    
   
    @IBAction func btnOnRegisterHere(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController")as! SignUpViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnOnLogin(_ sender: Any) {
        self.tfEmail.text = "shubhamshrimal4@gmail.com"
        self.tfPassword.text = "123456"
        self.call_WsLogin()
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let vc = (self.mainStoryboard.instantiateViewController(withIdentifier: "SideMenuController") as? SideMenuController)!
//        let navController = UINavigationController(rootViewController: vc)
//        navController.isNavigationBarHidden = true
//        appDelegate.window?.rootViewController = navController
    }
}


//MARK:- Call Webservice
extension LoginViewController{
    
    
    func call_WsLogin(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let dicrParam = ["email":self.tfEmail.text!,
                         "password":self.tfPassword.text!,
                         "ios_register_id":objAppShareData.strFirebaseToken]as [String:Any]
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_Login, params: dicrParam, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            if status == MessageConstant.k_StatusCode{
                if let user_details  = response["result"] as? [String:Any] {
                    objAppShareData.SaveUpdateUserInfoFromAppshareData(userDetail: user_details)
                    objAppShareData.fetchUserInfoFromAppshareData()
                    self.makeRootController()
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
