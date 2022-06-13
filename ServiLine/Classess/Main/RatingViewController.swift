//
//  RatingViewController.swift
//  ServiLine
//
//  Created by Rohit Singh Dhakad on 12/03/22.
//

import UIKit

class RatingViewController: UIViewController {
    

    @IBOutlet var imgVwUser: UIImageView!
    @IBOutlet var lblUserDesc: UILabel!
    @IBOutlet var vwRating: FloatRatingView!
    
    var obj:userDetailModel?
    var rating = "0.0"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.vwRating.delegate = self
        self.vwRating.type = .halfRatings
        let profilePic = self.obj!.strProfilePicture
        if profilePic != "" {
            let url = URL(string: profilePic)
            self.imgVwUser.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo"))
        }
        
        self.lblUserDesc.text = "Cómo calificarías \(obj?.strUserName ?? "") trabajo y perfil."
        
        
    }
    

    @IBAction func btnOnRatingView(_ sender: Any) {
        onBackPressed()
    }
    
    @IBAction func btnOnDone(_ sender: Any) {
        self.call_RateValue(strRating: self.rating)
    }
    
}


extension RatingViewController: FloatRatingViewDelegate{
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Double) {
        print(rating)
        self.rating = "\(rating)"
        
    }
    
}


//MARK:- Rating
extension RatingViewController{
    
    //MARK:-Add Remove On Fav List
    func call_RateValue(strRating:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()

        
        let parameter = ["user_id":objAppShareData.UserDetail.strUserId,
                         "vendor_id":obj?.strUserId ?? "",
                         "rating":self.rating,
                         "review":""]as [String:Any]
        print(parameter)
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_GiveRating, queryParams: [:], params: parameter, strCustomValidation: "", showIndicator: false) { response in
            
            print(response)
            
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
                        
            if status == MessageConstant.k_StatusCode{
                if let dictData  = response["result"] as? [[String:Any]]{
                    if message == "success"{

                        objAlert.showAlertSingleButtonCallBack(alertBtn: "OK", title: "", message: "\(self.obj?.strName ?? "") ha sido calificado", controller: self) {
                            self.onBackPressed()
                        }

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
