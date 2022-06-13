//
//  DeleteProfileViewController.swift
//  ServiLine
//
//  Created by Rohit Singh Dhakad on 12/04/22.
//

import UIKit

class DeleteProfileViewController: UIViewController {
    
    
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
            self.imgVwUser.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo"))
        }        
        
        self.lblDescription.text = "Quieres borrar la cuenta?\n " + objAppShareData.UserDetail.strUserName + " por alguna situación que haya sufrido u observado\n Escribanos brevemente sus razones y \nnosotros estudiaremos el caso"

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
            objAlert.showAlert(message: "Introduzca mensaje", title: "Alert", controller: self)
        }
        else{
            self.call_DeleteProfile(strUserID: objAppShareData.UserDetail.strUserId)
        }
      
        
    }
   

}



extension DeleteProfileViewController{
    
    //MARK:-Add Remove On Fav List
    func call_DeleteProfile(strUserID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        /*
         Call<ResponseBody> update_profile(@Query("user_id") String user_id,
                                               @Query("deletedRemark") String deletedRemark,
                                               @Query("deletedTime") String deletedTime);
         yyyy/MM/dd HH:mm:ss
         */
        
        
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let dateTime: String = formatter.string(from: Date())
        
        let parameter = ["user_id":strUserID,
                         "deletedTime":dateTime,
                         "deletedRemark":self.txtVw.text!]as [String:Any]
        print(parameter)
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_completeProfile, queryParams: [:], params: parameter, strCustomValidation: "", showIndicator: false) { response in
            
            print(response)
            
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
                        
            if status == MessageConstant.k_StatusCode{
                if let dictData  = response["result"] as? [String:Any]{
                    if message == "success"{

                        AppSharedData.sharedObject().signOut()

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
