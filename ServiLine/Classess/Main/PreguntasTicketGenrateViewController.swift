//
//  PreguntasTicketGenrateViewController.swift
//  ServiLine
//
//  Created by Rohit Singh Dhakad on 17/12/22.
//

import UIKit

class PreguntasTicketGenrateViewController: UIViewController {

    @IBOutlet var imgVwUser: UIImageView!
    @IBOutlet var lblDescription: UILabel!
    @IBOutlet var txtVw: RDTextView!
    @IBOutlet var imVwUserReport: UIImageView!
    @IBOutlet var lblMsgReportUser: UILabel!
    @IBOutlet var vwPopUp: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vwPopUp.isHidden = true
        
        let myProfilePic = objAppShareData.UserDetail.strProfilePicture
        if myProfilePic != "" {
            let url = URL(string: myProfilePic)
            self.imgVwUser.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo"))
            self.imVwUserReport.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo"))
        }

        // Do any additional setup after loading the view.
    }
    @IBAction func btnOnGoBack(_ sender: Any) {
        onBackPressed()
    }
    @IBAction func btnCreateRequest(_ sender: Any) {
        self.txtVw.text = self.txtVw.text?.trim()
        
        if (self.txtVw.text!.isEmpty){
            objAlert.showAlert(message: "Introduzca mensaje", title: "Alert", controller: self)
        }
        else{
            call_GenrateRequest(strUserID: objAppShareData.UserDetail.strUserId, strReason: self.txtVw.text!)
        }
    }
    
    @IBAction func btnGoBackOnPopUp(_ sender: Any) {
        onBackPressed()
    }
}

extension PreguntasTicketGenrateViewController {
    
    
    func call_GenrateRequest(strUserID:String, strReason: String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let parameter = ["user_id":strUserID,
                         "reason":strReason]as [String:Any]
        
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_CreateTicketRequest, queryParams: [:], params: parameter, strCustomValidation: "", showIndicator: false) { response in
            
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            print(response)
            
            if status == MessageConstant.k_StatusCode{
                if let dictData  = response["result"] as? [String:Any]{
                    self.vwPopUp.isHidden = false
                }
            }else{
                
                objWebServiceManager.hideIndicator()
                //  self.vwNoRecordFound.isHidden = false
                
            }
        } failure: { (Error) in
            print(Error)
            objWebServiceManager.hideIndicator()
        }
    }
}
