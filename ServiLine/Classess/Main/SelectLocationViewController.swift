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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if objAppShareData.dictHomeLocationInfo.count != 0{
            if let nationID = objAppShareData.dictHomeLocationInfo["nation_id"]as? String{
                self.strNationID = nationID
                self.lblNation.text! = objAppShareData.dictHomeLocationInfo["nation"]as! String
            }
            if let communityID = objAppShareData.dictHomeLocationInfo["community_id"]as? String{
                self.strCommunityID = communityID
                self.lblCommunity.text! = objAppShareData.dictHomeLocationInfo["community"]as! String
            }
            if let provienceID = objAppShareData.dictHomeLocationInfo["provience_id"]as? String{
                self.strProvinceID = provienceID
                self.lblProvince.text! = objAppShareData.dictHomeLocationInfo["provience"]as! String
            }
            if let muncipalD = objAppShareData.dictHomeLocationInfo["muncipal_id"]as? String{
                self.strMunicipalID = muncipalD
                self.lblMuncipality.text! = objAppShareData.dictHomeLocationInfo["muncipal"]as! String
            }
            
        }
    }
    
    
    @IBAction func btnBackOnHeader(_ sender: Any) {
        onBackPressed()
    }
    
    @IBAction func btnOnAction(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            self.openSelectionScreen(strIsComingFrom: "2", strTitle: "País")
        case 1:
            if self.strNationID == ""{
                objAlert.showAlert(message: "Selecciona País!!!", title: "Alert", controller: self)
            }else{
                self.openSelectionScreen(strIsComingFrom: "3", strTitle: "Comunidad")
            }
        case 2:
            if strCommunityID == ""{
                objAlert.showAlert(message: "Selecciona Comunidad!!!", title: "Alert", controller: self)
            }else{
                self.openSelectionScreen(strIsComingFrom: "4", strTitle: "Provincia")
            }
        case 3:
            if strProvinceID == ""{
                objAlert.showAlert(message: "Selecciona Provincia!!!", title: "Alert", controller: self)
            }else{
                self.openSelectionScreen(strIsComingFrom: "5", strTitle: "Municipio/Ciudad")
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
        
        dict["nation"] = self.lblNation.text!
        dict["provience"] = self.lblProvince.text!
        dict["community"] = self.lblCommunity.text!
        dict["muncipal"] = self.lblMuncipality.text!
        
        objAppShareData.dictHomeLocationInfo = dict
        
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
                    
                    if objAppShareData.dictHomeLocationInfo["string"]as? String != ""{
                       
                        objAppShareData.dictHomeLocationInfo.removeAll()
                        
                        self.strCommunityID = ""
                        self.strProvinceID = ""
                        self.strMunicipalID = ""
                        self.lblCommunity.text = "Comunidad"
                        self.lblProvince.text = "Provincia"
                        self.lblMuncipality.text = "Municipio/Ciudad"
                    }
                }
                
                if let communityID = dict["Community_id"]as? String{
                    self.strCommunityID = communityID
                    self.lblCommunity.text = dict["Community"]as? String
                    
                    if objAppShareData.dictHomeLocationInfo["string"]as? String != ""{
                        self.strProvinceID = ""
                        self.strMunicipalID = ""
                        self.lblProvince.text = "Provincia"
                        self.lblMuncipality.text = "Municipio/Ciudad"
                    }

                }
                
                if let Province = dict["Province_id"]as? String{
                    self.strProvinceID = Province
                    self.lblProvince.text = dict["Province"]as? String
                    if objAppShareData.dictHomeLocationInfo["string"]as? String != ""{
                        self.strMunicipalID = ""
                        self.lblMuncipality.text = "Municipio/Ciudad"
                    }

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
