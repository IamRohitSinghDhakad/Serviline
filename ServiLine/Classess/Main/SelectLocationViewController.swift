//
//  SelectLocationViewController.swift
//  ServiLine
//
//  Created by Rohit Singh Dhakad on 13/03/22.
//

import UIKit


//MARK:- Protocol
protocol GetLocationProtocol: AnyObject {
    func getLocationDetails(strLocation:String)
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
            self.openSelectionScreen(strIsComingFrom: "2")
        case 1:
            self.openSelectionScreen(strIsComingFrom: "3")
        case 2:
            self.openSelectionScreen(strIsComingFrom: "4")
        case 3:
            self.openSelectionScreen(strIsComingFrom: "5")
        default:
            break
        }
    }
    
    @IBAction func btnOnDone(_ sender: Any) {
        
        if strNationID == ""{
            objAlert.showAlert(message: "Please select nation first", title: "Alert", controller: self)
        }else if strCommunityID == ""{
            objAlert.showAlert(message: "Please select community first", title: "Alert", controller: self)
        }else if strProvinceID == ""{
            objAlert.showAlert(message: "Please select Province first", title: "Alert", controller: self)
        }else if strMunicipalID == ""{
            objAlert.showAlert(message: "Please select Municipal first", title: "Alert", controller: self)
        }else{
            let strFinal = self.lblNation.text! + "," + self.lblCommunity.text! + "," + self.lblProvince.text! + "," + self.lblMuncipality.text!
            self.getLocationDelegate?.getLocationDetails(strLocation: strFinal)
            onBackPressed()
        }
    }
    
    
    func openSelectionScreen(strIsComingFrom:String){
        let vc = UIStoryboard.init(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "PopUpViewController")as! PopUpViewController
         vc.isComingFrom = strIsComingFrom
        
            vc.strNationID = self.strNationID
            vc.strCommunityID = self.strCommunityID
            vc.strProvinceID = self.strProvinceID
            vc.strMunicipalID = self.strMunicipalID
            
            print(self.strNationID,self.strCommunityID,self.strProvinceID,self.strMunicipalID)
            
            
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
                        self.lblProvince.text = "Provience"
                        self.lblMuncipality.text = "Muncipality"
                    }
                    
                    if let communityID = dict["Community_id"]as? String{
                        self.strCommunityID = communityID
                        self.lblCommunity.text = dict["Community"]as? String
                        self.strProvinceID = ""
                        self.strMunicipalID = ""
                        self.lblProvince.text = "Provience"
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
