//
//  ReportUserViewController.swift
//  ServiLine
//
//  Created by Rohit Singh Dhakad on 12/03/22.
//

import UIKit

class ReportUserViewController: UIViewController {

    @IBOutlet var imgVwUser: UIImageView!
    @IBOutlet var lblDescription: UILabel!
    @IBOutlet var txtVw: RDTextView!
    @IBOutlet var imVwUserReport: UIImageView!
    @IBOutlet var lblMsgReportUser: UILabel!
    @IBOutlet var vwPopUp: UIView!
    
    var objUserDetail:userDetailModel?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.vwPopUp.isHidden = true
        
        let myProfilePic = objAppShareData.UserDetail.strProfilePicture
        if myProfilePic != "" {
            let url = URL(string: myProfilePic)
            self.imVwUserReport.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo"))
        }
        self.lblMsgReportUser.text = objAppShareData.UserDetail.strUserName + " se ha añadido y recibido tu informe"
        
        let profilePic = self.objUserDetail!.strProfilePicture
        if profilePic != "" {
            let url = URL(string: profilePic)
            self.imgVwUser.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo"))
        }
        
        self.lblDescription.text = "Quieres hacer una denuncia \(objUserDetail?.strUserName ?? "") Escribanos brevemente sus razones y nosotros estudiaremos el caso."

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnOnBackHeader(_ sender: Any) {
        onBackPressed()
    }
    
    @IBAction func btnOKPopUp(_ sender: Any) {
        self.vwPopUp.isHidden = true
        onBackPressed()
    }
    
    @IBAction func btnOnSend(_ sender: Any) {
        self.txtVw.text = self.txtVw.text?.trim()
        
        if (self.txtVw.text!.isEmpty){
            objAlert.showAlert(message: "por favor ingrese un texto", title: "", controller: self)
        }
        else{
            self.call_ReportUaser(strUserID: objAppShareData.UserDetail.strUserId, strToUserID: self.objUserDetail!.strUserId)
        }
      
        
    }
    

}


extension ReportUserViewController{
    
    //MARK:-Add Remove On Fav List
    func call_ReportUaser(strUserID:String, strToUserID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let parameter = ["user_id":strUserID,
                         "to_user_id":strToUserID,
                         "message":self.txtVw.text!]as [String:Any]
        print(parameter)
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_ReportAnUser, queryParams: [:], params: parameter, strCustomValidation: "", showIndicator: false) { response in
            
            print(response)
            
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
                        
            if status == MessageConstant.k_StatusCode{
                if let dictData  = response["result"] as? [String:Any]{
                    if message == "success"{

                        self.vwPopUp.isHidden = false

                    }
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
    
}
