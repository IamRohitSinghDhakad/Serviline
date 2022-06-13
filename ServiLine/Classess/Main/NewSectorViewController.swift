//
//  NewSectorViewController.swift
//  ServiLine
//
//  Created by Rohit Singh Dhakad on 13/03/22.
//

import UIKit

class NewSectorViewController: UIViewController {

    @IBOutlet var imgVwUser: UIImageView!
    @IBOutlet var txtVw: RDTextView!
    @IBOutlet var vwPopUp: UIView!
    @IBOutlet var imgVwUserPopUp: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.vwPopUp.isHidden = true
        let profilePic = objAppShareData.UserDetail.strProfilePicture
        if profilePic != "" {
            let url = URL(string: profilePic)
            self.imgVwUser.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo"))
            self.imgVwUserPopUp.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo"))
        }
    }
    
   
    @IBAction func btnOnBackHeader(_ sender: Any) {
        onBackPressed()
    }
    
    @IBAction func btnOkOnPopUp(_ sender: Any) {
        self.vwPopUp.isHidden = true
        self.onBackPressed()
    }
    
    @IBAction func btnOnSend(_ sender: Any) {
        self.txtVw.text = self.txtVw.text?.trim()
        if (self.txtVw.text!.isEmpty){
            objAlert.showAlert(message: "Introduzca mensaje", title: "", controller: self)
        }else{
            self.call_WsSendSectorReq(strText: self.txtVw.text!, strUserID: objAppShareData.UserDetail.strUserId)
        }
    }
    
}


extension NewSectorViewController{
    
    //MARK:- Nation
    func call_WsSendSectorReq(strText:String, strUserID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let dictParam = ["user_id":strUserID,
                         "message":strText] as [String:Any]
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_SectorReq, queryParams: [:], params: dictParam, strCustomValidation: "", showIndicator: false) { response in
            
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            if status == MessageConstant.k_StatusCode{
                if let user_details  = response["result"] as? [String:Any] {
  
                    self.vwPopUp.isHidden = false
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
    
}
