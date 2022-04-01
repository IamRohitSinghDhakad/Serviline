//
//  SelectLocationViewController.swift
//  ServiLine
//
//  Created by Rohit Singh Dhakad on 13/03/22.
//

import UIKit


//MARK:- Protocol
protocol GetLocationProtocol: AnyObject {
    func getLocationDetails(strData:[String:Any])
}


class SelectLocationViewController: UIViewController {
    
    
    @IBOutlet var lblNation: UILabel!
    @IBOutlet var lblCommunity: UILabel!
    @IBOutlet var lblProvince: UILabel!
    @IBOutlet var lblMuncipality: UILabel!
    
    var arrOptions = [OptionsModelClass]()
    
    var getLocationDelegate:GetLocationProtocol?
    
    
    var strNationID = ""
    var strCommunityID = ""
    var strProvinceID = ""
    var strMunicipalID = ""
    var strNationTitle = ""
    var strCommunityTitle = ""
    var strProvinceTitle = ""
    var strMunicipalTitle = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func btnBackOnHeader(_ sender: Any) {
        onBackPressed()
    }
    
    @IBAction func btnOnAction(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            self.openSelectionScreen(strIsComingFrom: "2", strTitle: "Nation")
        case 1:
            if self.strNationID == ""{
                objAlert.showAlert(message: "Please select nation first", title: "Alert", controller: self)
            }else{
                self.openSelectionScreen(strIsComingFrom: "3", strTitle: "Community")
            }
        case 2:
            if strCommunityID == ""{
                objAlert.showAlert(message: "Please select community first", title: "Alert", controller: self)
            }else{
                self.openSelectionScreen(strIsComingFrom: "4", strTitle: "Provience")
            }
        case 3:
            if strProvinceID == ""{
                objAlert.showAlert(message: "Please select Province first", title: "Alert", controller: self)
            }else{
                self.openSelectionScreen(strIsComingFrom: "5", strTitle: "Muncipal")
            }
            
        default:
            break
        }
    }
    
    @IBAction func btnOnDone(_ sender: Any) {
        
        var  strFinal = ""
        if self.strNationID != ""{
            strFinal = self.lblNation.text! 
        }
        if self.strCommunityID != ""{
            strFinal = strFinal + "," + self.lblCommunity.text!
        }
        if self.strProvinceID != ""{
            strFinal = strFinal + "," +  self.lblProvince.text!
        }
        if self.strMunicipalID != ""{
            strFinal = strFinal + "," + self.lblMuncipality.text!
        }
        
        
        var dict = [String:Any]()
        dict["string"] = strFinal
        dict["nation_id"] = self.strNationID
        dict["provience_id"] = self.strProvinceID
        dict["community_id"] = self.strCommunityID
        dict["muncipal_id"] = self.strMunicipalID
        
        self.getLocationDelegate?.getLocationDetails(strData: dict)
        
        onBackPressed()
        
    }
    
    
    func openSelectionScreen(strIsComingFrom:String, strTitle:String){
        let vc = UIStoryboard.init(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "PopUpViewController")as! PopUpViewController
        
        
        vc.isComingFrom = strIsComingFrom
        vc.strTitle = strTitle
        
        vc.strNationID = self.strNationID
        vc.strCommunityID = self.strCommunityID
        vc.strProvinceID = self.strProvinceID
        vc.strMunicipalID = self.strMunicipalID
        
        
        
        vc.closerForSelectionTable = { dict
            in
            print(dict)
            if dict.count != 0{
                if let nationID = dict["nation_id"]as? String{
                    self.strNationID = nationID
                    self.lblNation.text = dict["nation"]as? String
                    
                    self.strCommunityID = ""
                    self.strProvinceID = ""
                    self.strMunicipalID = ""
                    self.lblCommunity.text = "Community"
                    self.lblProvince.text = "Province"
                    self.lblMuncipality.text = "Muncipality"
                }
                
                if let communityID = dict["Community_id"]as? String{
                    self.strCommunityID = communityID
                    self.lblCommunity.text = dict["Community"]as? String
                    self.strProvinceID = ""
                    self.strMunicipalID = ""
                    self.lblProvince.text = "Province"
                    self.lblMuncipality.text = "Muncipality"
                }
                
                if let Province = dict["Province_id"]as? String{
                    self.strProvinceID = Province
                    self.lblProvince.text = dict["Province"]as? String
                    self.strMunicipalID = ""
                    self.lblMuncipality.text = "Muncipality"
                }
                
                if let MunicipalID = dict["Municipal_id"]as? String{
                    self.strMunicipalID = MunicipalID
                    self.lblMuncipality.text = dict["Municipal"]as? String
                }
            }
        }
        
        if #available(iOS 13.0, *) {
            self.isModalInPresentation = true // available in IOS13
        }
        self.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true,completion: nil)
    }
}
