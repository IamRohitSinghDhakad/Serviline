//
//  OTPVerifyViewController.swift
//  ServiLine
//
//  Created by Rohit Singh Dhakad on 16/06/22.
//

import UIKit

class OTPVerifyViewController: UIViewController {

    @IBOutlet var tfOne: UITextField!
    @IBOutlet var tfTwo: UITextField!
    @IBOutlet var tfThree: UITextField!
    @IBOutlet var tfFour: UITextField!
    
    var orignalOTP:String?
    var strUserID:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tfOne.delegate = self
        self.tfTwo.delegate = self
        self.tfThree.delegate = self
        self.tfFour.delegate = self
        // Do any additional setup after loading the view.
        self.setOTPWork()
    }
    
    func setOTPWork(){
        
        self.tfOne.delegate = self
        self.tfTwo.delegate = self
        self.tfThree.delegate = self
        self.tfFour.delegate = self
        
        self.tfOne.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        self.tfTwo.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        self.tfThree.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        self.tfFour.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        self.tfOne.becomeFirstResponder()
        self.hideKeyboardWhenTappedAround()
    }

    @IBAction func btnOnOK(_ sender: Any) {
        self._Validation()
    }
}

extension OTPVerifyViewController{
    
    func _Validation(){
        self.tfOne.text = self.tfOne.text?.trim()
        self.tfTwo.text = self.tfTwo.text?.trim()
        self.tfThree.text = self.tfThree.text?.trim()
        self.tfFour.text = self.tfFour.text?.trim()
        
        if (self.tfOne.text?.isEmpty)!{
            invalidOTP()
        }else if (self.tfTwo.text?.isEmpty)!{
            invalidOTP()
        }else if (self.tfThree.text?.isEmpty)!{
            invalidOTP()
        }else if (self.tfFour.text?.isEmpty)!{
            invalidOTP()
        }else{
            //Merging all verification code numbers
            var strCompleteCode = String()
            if self.tfOne.text?.count != 0{
                strCompleteCode = self.tfOne.text!
            }
            if self.tfTwo.text?.count != 0{
                strCompleteCode += self.tfTwo.text!
            }
            if self.tfThree.text?.count != 0{
                strCompleteCode += self.tfThree.text!
            }
            if self.tfFour.text?.count != 0{
                strCompleteCode += self.tfFour.text!
            }
            print(strCompleteCode)
            
            if orignalOTP == strCompleteCode{
                self.call_VerifyOtp(strUserID: self.strUserID ?? "0")
            }else{
                invalidOTP()
            }
        }
    }
    
    
    @objc func textFieldDidChange(textField: UITextField){
        let text = textField.text
        if  text?.count == 1 {
            switch textField{
            case self.tfOne:
                self.tfTwo.becomeFirstResponder()
            case self.tfTwo:
                self.tfThree.becomeFirstResponder()
            case self.tfThree:
                self.tfFour.becomeFirstResponder()
            case self.tfFour:
                self.tfFour.resignFirstResponder()
            default:
                break
            }
        }
        if  text?.count == 0 {
            switch textField{
            case self.tfOne:
                self.tfOne.becomeFirstResponder()
            case self.tfTwo:
                self.tfOne.becomeFirstResponder()
            case self.tfThree:
                self.tfTwo.becomeFirstResponder()
            case self.tfFour:
                self.tfThree.becomeFirstResponder()
            default:
                break
            }
        }
        else{
            
        }
    }
    
    func invalidOTP(){
        let alertView = UIAlertController(title:"" , message: "OTP no válido", preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertView, animated:true, completion:nil)
    }
    
}

extension OTPVerifyViewController {
    
    //MARK:-Add Remove On Fav List
    func call_VerifyOtp(strUserID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        
        let parameter = ["user_id":strUserID,
                         "email_verified":"1"]as [String:Any]
        print(parameter)
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_completeProfile, queryParams: [:], params: parameter, strCustomValidation: "", showIndicator: false) { response in
            
            print(response)
            
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            if status == MessageConstant.k_StatusCode{
                if let user_details  = response["result"] as? [String:Any]{
                    objAppShareData.SaveUpdateUserInfoFromAppshareData(userDetail: user_details)
                    objAppShareData.fetchUserInfoFromAppshareData()
                    self.makeRootController()
                  
                }
            }else{
                if response["result"]as? String == "Any blocked users not found"{
                    //                    self.btnMessage.isHidden = false
                    //                    self.vwBlockUser.isHidden = true
                }
                objWebServiceManager.hideIndicator()
                
            }
        } failure: { (Error) in
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
