//
//  HomeViewController.swift
//  ServiLine
//
//  Created by Rohit Singh Dhakad on 11/03/22.
//

import UIKit

class HomeViewController: UIViewController, GetLocationProtocol {
   
    @IBOutlet var vwHeaderBottomCorners: UIView!
    @IBOutlet var vwMsg: UIView!
    @IBOutlet var lblSelectedSector: UILabel!
    @IBOutlet var lblLocation: UILabel!
    @IBOutlet var txtVw: RDTextView!
    @IBOutlet var imgVwShowHidePopUp: UIImageView!
    @IBOutlet var vwSecorreqPopUp: UIView!
    
    var strSectorID = ""
    var strNationID = ""
    var strProvienceID = ""
    var strMuncipalID = ""
    var strCommunityID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imgVwShowHidePopUp.image = UIImage.init(named: "unchecked")
        self.vwSecorreqPopUp.isHidden = true
        
        if let checkValue = UserDefaults.standard.value(forKey: "home_instruction")as? String{
            if checkValue == "Show"{
                self.vwMsg.isHidden = false
            }else{
                self.vwMsg.isHidden = true
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.vwHeaderBottomCorners.roundedCorners(corners: [.bottomLeft, .bottomRight],  radius: 10)
    }

    
    @IBAction func btnOnOk(_ sender: Any) {
        self.vwSecorreqPopUp.isHidden = true
        self.lblSelectedSector.text = "Select Sector"
        self.lblLocation.text = "Select Location"
        self.txtVw.text = ""
        self.strSectorID = ""
        self.strNationID = ""
        self.strCommunityID = ""
        self.strProvienceID = ""
        self.strMuncipalID = ""
    }
    

    @IBAction func btnOnOpenSideMenu(_ sender: Any) {
        self.sideMenuController?.revealMenu()
    }
    
    @IBAction func btnOnDoNotShowAgainPopUp(_ sender: Any) {
        
        if self.imgVwShowHidePopUp.image == UIImage.init(named: "unchecked"){
            self.imgVwShowHidePopUp.image = UIImage.init(named: "checkBox")
        }else{
            self.imgVwShowHidePopUp.image = UIImage.init(named: "unchecked")
        }
    }
    
    @IBAction func btnOnOKPopUpMsg(_ sender: Any) {
        if self.imgVwShowHidePopUp.image == UIImage.init(named: "checkBox"){
            UserDefaults.standard.setValue("dontShow", forKey: "home_instruction")
        }else{
            UserDefaults.standard.setValue("Show", forKey: "home_instruction")
        }
        self.vwMsg.isHidden = true
    }
    
    
    @IBAction func btnOnClickHere(_ sender: Any) {
        pushVc(viewConterlerId: "NewSectorViewController")
    }
    
    @IBAction func btnOnSend(_ sender: Any) {
        if self.lblSelectedSector.text == "Select Sector"{
            objAlert.showAlert(message: "Please select Service Sector", title: "Alert", controller: self)
            
        }else if self.lblLocation.text == "Select Location"{
            objAlert.showAlert(message: "Please select Location", title: "Alert", controller: self)
        }else if self.txtVw.text == ""{
            objAlert.showAlert(message: "Please enter message", title: "Alert", controller: self)
        }else{
            self.call_WsSendServiceReq(strText: self.txtVw.text!, strUserID: objAppShareData.UserDetail.strUserId)
        }
    }
    
    @IBAction func btnOnSelectSector(_ sender: Any) {
        let sb = UIStoryboard.init(name: "Auth", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "PopUpViewController")as! PopUpViewController
        vc.isComingFrom = "6"
        vc.strTitle = "Sector"
        vc.closerForSelectionTable = { dict
            in
            print(dict)
            if dict.count != 0{
                
                self.lblSelectedSector.text = dict["Sector"]as? String
                self.strSectorID = dict["Sector_id"]as? String ?? ""
            }
        }
        
        if #available(iOS 13.0, *) {
            self.isModalInPresentation = true // available in IOS13
        }
        self.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true,completion: nil)
    }
    
    @IBAction func btnOnSelectLocation(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectLocationViewController")as! SelectLocationViewController
        vc.getLocationDelegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    func getLocationDetails(strData: [String : Any]) {
        print(strData)
        
        if let strLocation = strData["string"]as? String{
            self.lblLocation.text = strLocation
        }
        
        if let nation_id = strData["nation_id"]as? String{
            self.strNationID = nation_id
        }
        
        if let provience_id = strData["provience_id"]as? String{
            self.strProvienceID = provience_id
        }
        
        if let comunity_id = strData["comunity_id"]as? String{
            self.strCommunityID = comunity_id
        }
        
        if let muncipal_id = strData["muncipal_id"]as? String{
            self.strMuncipalID = muncipal_id
        }
    }
}


extension HomeViewController{
    
    //MARK:- Nation
    func call_WsSendServiceReq(strText:String, strUserID:String){
        
        self.view.endEditing(true)
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()

        
        let dictParam = ["user_id":strUserID,
                         "sector_id":self.strSectorID,
                         "nation_id":self.strNationID,
                         "community_id":self.strCommunityID,
                         "province_id":self.strProvienceID,
                         "municipality_id":self.strMuncipalID,
                         "message":strText] as [String:Any]
        
        print(dictParam)
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_ServiceRequest, queryParams: [:], params: dictParam, strCustomValidation: "", showIndicator: false) { response in
            
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            if status == MessageConstant.k_StatusCode{
                if let user_details  = response["result"] as? [[String:Any]] {
  
                    self.vwSecorreqPopUp.isHidden = false
                   
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
