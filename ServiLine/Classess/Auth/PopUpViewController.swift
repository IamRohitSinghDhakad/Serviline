//
//  PopUpViewController.swift
//  ServiLine
//
//  Created by Rohit Singh Dhakad on 11/03/22.
//

import UIKit

class PopUpViewController: UIViewController {

    @IBOutlet var vwContainTable: UIView!
    @IBOutlet var vwContainPopUp: UIView!
    @IBOutlet var tfSearch: UITextField!
    @IBOutlet var tblVw: UITableView!
    @IBOutlet var imgVwRadio1: UIImageView!
    @IBOutlet var imgVwRadio2: UIImageView!
    
    var arrOptions = [OptionsModelClass]()
    
    var strType = ""
    var isComingFrom = ""
    var strNationID = ""
    var strCommunityID = ""
    var strProvinceID = ""
    var strMunicipalID = ""
    var strSectorID = ""
    
    var strNationTitle = ""
    var strCommunityTitle = ""
    var strProvinceTitle = ""
    var strMunicipalTitle = ""
    var strSectorTitle = ""
    
    var closerForSelectionButton: (( _ strDict:[String:Any]) ->())?
    var closerForSelectionTable: (( _ strDict:[String:Any]) ->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imgVwRadio1.image = UIImage.init(named: "radio_button")
        self.imgVwRadio2.image = UIImage.init(named: "radio_button")
        
        
        self.tblVw.delegate = self
        self.tblVw.dataSource = self
        
        self.vwContainPopUp.isHidden = true
        self.vwContainTable.isHidden = true
        
        print(self.strNationID)
        print(self.strCommunityID)
        print(self.strProvinceID)
        print(self.strMunicipalID)
       
        
        switch isComingFrom {
        case "1":
            self.vwContainPopUp.isHidden = false
           
        case "2":
            self.vwContainTable.isHidden = false
            self.call_WsGetNation()
           
        case "3":
            self.vwContainTable.isHidden = false
            self.call_WsGetCommunity(strNationID: self.strNationID)
            
        case "4":
            self.vwContainTable.isHidden = false
            self.call_WsGetprovience(strNationID: self.strNationID, strCommunityID: self.strCommunityID)
            
        case "5":
            self.vwContainTable.isHidden = false
            self.call_WsGetMuncipal(strNationID: self.strNationID, strCommunityID: self.strCommunityID, strProvience: self.strProvinceID)
            
        default:
            self.call_WsGetSector()
            self.vwContainTable.isHidden = false
           
//            self.vwContainTable.isHidden = false
//
        }
        
       
    }
    @IBAction func btnOnDoneTable(_ sender: Any) {
       // self.navigationController?.dismiss(animated: true, completion: nil)
       
        var dict = [String:Any]()
        
        /*
       
         dict["update_subcat"] = self.selectedSubCat
         dict["price_min_value"] = self.strRangeFilterMinValue
         dict["price_max_value"] = self.strRangeFilterMaxValue
         dict["gender"] = self.strSelectedGender
         dict["selected_SubCategory"] = self.strSelectedSubCategory
         dict["selected_Countries"] = self.strSelectedCountries
         
        
         */
        
        switch self.isComingFrom {
        case "2":
            dict["nation_id"] = self.strNationID
            dict["nation"] = self.strNationTitle
            self.closerForSelectionTable?(dict)
        case "3":
            dict["Community_id"] = self.strCommunityID
            dict["Community"] = self.strCommunityTitle
            self.closerForSelectionTable?(dict)
        case "4":
            dict["Province_id"] = self.strProvinceID
            dict["Province"] = self.strProvinceTitle
            self.closerForSelectionTable?(dict)
        case "5":
            dict["Municipal_id"] = self.strMunicipalID
            dict["Municipal"] = self.strMunicipalTitle
            self.closerForSelectionTable?(dict)
        default:
            dict["Sector_id"] = self.strSectorID
            dict["Sector"] = self.strSectorTitle
            self.closerForSelectionTable?(dict)
        }
        
        onBackPressed()
    }
    
    
    
    
    @IBAction func btnOnOKPopUp(_ sender: Any) {
        var dict = [String:Any]()
        dict["type"] = self.strType
        self.closerForSelectionButton?(dict)
        onBackPressed()
       // self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnSelectionPopUp(_ sender: UIButton) {
        self.imgVwRadio1.image = UIImage.init(named: "radio_button")
        self.imgVwRadio2.image = UIImage.init(named: "radio_button")
        
        switch sender.tag {
        case 0:
            print("user")
            self.strType = "user"
            self.imgVwRadio1.image = UIImage.init(named: "radio_button_selected")
        default:
            print("profession")
            self.strType = "provider"
            self.imgVwRadio2.image = UIImage.init(named: "radio_button_selected")
        }
    }
    

}


extension PopUpViewController: UITableViewDelegate,UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OptionsTableViewCell")as! OptionsTableViewCell
        
        cell.lblTitle.text = self.arrOptions[indexPath.row].strName
        
        
        if self.arrOptions[indexPath.row].isSelected == true{
            cell.vwBorder.borderColor = UIColor.init(named: "Pink")
        }else{
            cell.vwBorder.borderColor = UIColor.lightGray
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let obj = self.arrOptions[indexPath.row]
        
        switch self.isComingFrom {
        case "2":
            self.strNationID = self.arrOptions[indexPath.row].strID
            self.strNationTitle = self.arrOptions[indexPath.row].strName
        case "3":
            self.strCommunityID = self.arrOptions[indexPath.row].strID
            self.strCommunityTitle = self.arrOptions[indexPath.row].strName
        case "4":
            self.strProvinceID = self.arrOptions[indexPath.row].strID
            self.strProvinceTitle = self.arrOptions[indexPath.row].strName
        case "5":
            self.strMunicipalID = self.arrOptions[indexPath.row].strID
            self.strMunicipalTitle = self.arrOptions[indexPath.row].strName
        default:
            self.strSectorID = self.arrOptions[indexPath.row].strID
            self.strSectorTitle = self.arrOptions[indexPath.row].strName
        }
        
        self.arrOptions.filter({$0.isSelected == true}).first?.isSelected = false
        obj.isSelected = true
        
        self.tblVw.reloadData()
    }
    
    
}


//Call Webservice
extension PopUpViewController{
    
    //MARK:- Nation
    func call_WsGetNation(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_GetNation, queryParams: [:], params: [:], strCustomValidation: "", showIndicator: false) { response in
            
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            if status == MessageConstant.k_StatusCode{
                if let user_details  = response["result"] as? [[String:Any]] {
                    self.arrOptions.removeAll()
                    for data in user_details{
                        let obj = OptionsModelClass.init(dict: data)
                        self.arrOptions.append(obj)
                    }
                    
                    self.tblVw.reloadData()
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
    
    //MARK:- Community
    func call_WsGetCommunity(strNationID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let dictParam = ["nation_id":strNationID] as [String:Any]
        print(dictParam)
        objWebServiceManager.requestPost(strURL: WsUrl.url_GetCommunity, queryParams: [:], params: dictParam, strCustomValidation: "", showIndicator: false) { response in
            
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            if status == MessageConstant.k_StatusCode{
                if let user_details  = response["result"] as? [[String:Any]] {
                    self.arrOptions.removeAll()
                    for data in user_details{
                        let obj = OptionsModelClass.init(dict: data)
                        self.arrOptions.append(obj)
                    }
                    
                    self.tblVw.reloadData()
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
    
    
    //MARK:- Provience
    func call_WsGetprovience(strNationID:String, strCommunityID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let dictParam = ["nation_id":strNationID,
                         "community_id":strCommunityID] as [String:Any]
        
        print(dictParam)
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_getProvince, queryParams: [:], params: dictParam, strCustomValidation: "", showIndicator: false) { response in
            
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            if status == MessageConstant.k_StatusCode{
                if let user_details  = response["result"] as? [[String:Any]] {
                    self.arrOptions.removeAll()
                    for data in user_details{
                        let obj = OptionsModelClass.init(dict: data)
                        self.arrOptions.append(obj)
                    }
                    
                    self.tblVw.reloadData()
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
    
    
    //MARK:- Muncipal
    func call_WsGetMuncipal(strNationID:String, strCommunityID:String, strProvience:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let dictParam = ["nation_id":strNationID,
                         "community_id":strCommunityID,
                         "province_id":strProvience] as [String:Any]
        print(dictParam)
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_getMunicipality, queryParams: [:], params: dictParam, strCustomValidation: "", showIndicator: false) { response in
            
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            if status == MessageConstant.k_StatusCode{
                if let user_details  = response["result"] as? [[String:Any]] {
                    self.arrOptions.removeAll()
                    for data in user_details{
                        let obj = OptionsModelClass.init(dict: data)
                        self.arrOptions.append(obj)
                    }
                    
                    self.tblVw.reloadData()
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
    
    
    //MARK:- Sector
    func call_WsGetSector(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_getSector, queryParams: [:], params: [:], strCustomValidation: "", showIndicator: false) { response in
            
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            if status == MessageConstant.k_StatusCode{
                if let user_details  = response["result"] as? [[String:Any]] {
                    self.arrOptions.removeAll()
                    for data in user_details{
                        let obj = OptionsModelClass.init(dict: data)
                        self.arrOptions.append(obj)
                    }
                    
                    self.tblVw.reloadData()
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
