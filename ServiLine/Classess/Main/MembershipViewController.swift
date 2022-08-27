//
//  MembershipViewController.swift
//  ServiLine
//
//  Created by Rohit Singh Dhakad on 07/05/22.
//

import UIKit
import StoreKit
import Alamofire

enum PricePackage: Int {
    case weekly = 0
    case monthly = 1
    case yearly = 2
    case restore = 3
}

class MembershipViewController: UIViewController {
    
    @IBOutlet var imgVwUser: UIImageView!
    @IBOutlet var lblAmount: UILabel!
    @IBOutlet var vwMembershipPopUp: UIView!
    
    var selectedPackage : PricePackage = .monthly
    var products: [SKProduct] = []
    var myProduct : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let profilePic = objAppShareData.UserDetail.strProfilePicture
        if profilePic != "" {
            let url = URL(string: profilePic)
           self.imgVwUser.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo"))
        }
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.itemPurchased),
            name: .IAPHelperPurchaseNotification,
            object: nil)


        self.call_GetMemebershipPlans()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func checkInternetForPurchase() {
        if (NetworkReachabilityManager()!.isReachable) {
            ActivityIndicatorViewController.sharedInstance.startIndicator()
            products = []
            self.makePurchase()
        }else{
            let alert = UIAlertController(title: "Alert", message: "please check internet", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            ActivityIndicatorViewController.sharedInstance.stopIndicator()
            
        }
    }

    @IBAction func btnBackOnHeader(_ sender: Any) {
        self.onBackPressed()
    }
    
    @IBAction func btnMakePayment(_ sender: Any) {
        
       checkInternetForPurchase()
        
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
                        let amount = dictData["price"]as? String ?? "5"
                        self.lblAmount.text = "suscríbete por \(amount)€ mensual"
                    }
                    
                }else{
                    
                }
                
                
            }else{
                if response["result"]as? String == "Any blocked users not found"{

                }
                objWebServiceManager.hideIndicator()
            
            }
        } failure: { (Error) in
            objWebServiceManager.hideIndicator()
        }
    }
}

extension MembershipViewController{
    
    func makePurchase() {
        ObjectIAPProducts.store.requestProducts{ [weak self] success, products in
            guard let self = self else {
                ActivityIndicatorViewController.sharedInstance.stopIndicator()
                return }
            if success {
                print("products: \(String(describing: products))")
                if products == nil {
                    ActivityIndicatorViewController.sharedInstance.stopIndicator()
                    return }
                if products!.count > 0 {
                    self.products = products!
                    
                    let product = products![self.myProduct]
                    
                    if ObjectIAPProducts.store.isProductPurchased(product.productIdentifier) {
                        ActivityIndicatorViewController.sharedInstance.stopIndicator()
                        
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "", message: "Artículo ya comprado", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                            
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                       
                    }else{
                      ObjectIAPProducts.store.buyProduct(products![self.myProduct])
                    }
                }
                else {
                    ActivityIndicatorViewController.sharedInstance.stopIndicator()
                }
            }
            else {
                ActivityIndicatorViewController.sharedInstance.stopIndicator()
            }
            
        }
    }
    
    @objc private func itemPurchased(notification: NSNotification){
        
        self.showToast(message: "Puchase Succesfull", font: .systemFont(ofSize: 12))
        let vc = self.mainStoryboard.instantiateViewController(withIdentifier: "WebViewShowViewController")as! WebViewShowViewController
        vc.strIsComingFrom = "membership"
        vc.strUrl = WsUrl.url_CompleteMembership + objAppShareData.UserDetail.strUserId
        self.navigationController?.pushViewController(vc, animated: true)    }
    
}
