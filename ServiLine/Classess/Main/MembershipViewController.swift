//
//  MembershipViewController.swift
//  ServiLine
//
//  Created by Rohit Singh Dhakad on 07/05/22.
//

import UIKit
import TPVVInLibrary


class MembershipViewController: UIViewController {
    

    var orderID: String?
    var strAmount: String?
    var identifier:String?
    
    @IBOutlet var imgVwUser: UIImageView!
    @IBOutlet var lblAmount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let profilePic = objAppShareData.UserDetail.strProfilePicture
        if profilePic != "" {
            let url = URL(string: profilePic)
           self.imgVwUser.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo"))
        }
        
        TPVVConfiguration.shared.appLicense = "iWj7y0xGwx5dcYfdN7f" //"vjqzC1kU9RuWP0Q3OXzO" //
        
        TPVVConfiguration.shared.appEnviroment = EnviromentType.Real
        
        TPVVConfiguration.shared.appFuc = "356431767"
        
        TPVVConfiguration.shared.appTerminal = "001"
        
        TPVVConfiguration.shared.appCurrency = "978"
        
        TPVVConfiguration.shared.appURLOK = "https://ambitious.in.net/Arun/serviline/index.php/api/update_plan?user_id=\(objAppShareData.UserDetail.strUserId)"
        
        // TPVVConfiguration.shared.appURLKO = "https://ambitious.in.net/Arun/serviline/index.php/api/plan_failed?title=title&subtitle=testing"
        
        self.identifier = "356431767"
        self.call_GetMemebershipPlans()
    }
    

    @IBAction func btnBackOnHeader(_ sender: Any) {
        self.onBackPressed()
    }
    
    @IBAction func btnMakePayment(_ sender: Any) {
        
        let strOrderNo = self.randomString(of: 8)
        
      
     
        
        let wpView = WebViewPaymentController(orderNumber: strOrderNo, amount: Double(strAmount ?? "5.0")!,
                                              productDescription: "Monthly", transactionType: TPVVInLibrary.TransactionType.normal, identifier:TPVVConfiguration.shared.REQUEST_REFERENCE,
                                              extraParams: [:])

        wpView.delegate = self

        present(wpView, animated: true, completion: nil)
        
        
    }
    
}


//MARK:- Call API
extension MembershipViewController{
    
        
    func call_GetMemebershipPlans(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let parameter = ["user_id":objAppShareData.UserDetail.strUserId]as [String:Any]
        print(parameter)
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_GetPlan, queryParams: [:], params: parameter, strCustomValidation: "", showIndicator: false) { response in
            
            print(response)
            
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
                        
            if status == MessageConstant.k_StatusCode{
               
                if let arrData = response["result"] as? [[String:Any]]{
                    
                   // var purchaseAmount:Double?
                    
                    for dictData in arrData{
                        let amount = dictData["price"]as? String ?? ""
                       // purchaseAmount = Double(amount)
                        self.strAmount = amount
                        self.lblAmount.text = "\(self.strAmount ?? "5")€"
                    }
                    
                }else{
                    
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



extension MembershipViewController: WebViewPaymentResponseDelegate {

func responsePaymentKO(response: (WebViewPaymentResponseKO)) {
    //TPVVConfiguration.shared.appURLKO = "https://ambitious.in.net/Arun/serviline/index.php/api/plan_failed?title=title&subtitle=testing"
   
    
    }

func responsePaymentOK(response: (WebViewPaymentResponseOK)) {
   // TPVVConfiguration.shared.appURLOK = "https://ambitious.in.net/Arun/serviline/index.php/api/update_plan?user_id=\(objAppShareData.UserDetail.strUserId)"
    
    objAlert.showAlert(message: "Su pago se ha realizado con éxito.", title: "Éxito", controller: self)
    

    }
    
    
}
                            

extension MembershipViewController{
    
    func randomString(of length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var s = ""
        for _ in 0 ..< length {
            s.append(letters.randomElement()!)
        }
        return s
    }
}

