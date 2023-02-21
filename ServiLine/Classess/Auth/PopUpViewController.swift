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
    @IBOutlet var lblTitle: UILabel!
    
    var arrOptions = [OptionsModelClass]()
    var arrOptionsFiltered = [OptionsModelClass]()
    var strTitle = ""
    
    var strType = ""
    var isComingFrom = ""
    var isMultiple = ""
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

        
        print(strNationID)
        print(strProvinceID)
        print(strCommunityID)
        print(strMunicipalID)
        
        self.lblTitle.text = self.strTitle
        
        self.tfSearch.delegate = self
        self.tfSearch.addTarget(self, action: #selector(searchContactAsPerText(_ :)), for: .editingChanged)
        
        self.imgVwRadio1.image = UIImage.init(named: "radio_button")
        self.imgVwRadio2.image = UIImage.init(named: "radio_button")
        
        self.tblVw.delegate = self
        self.tblVw.dataSource = self
        
        self.vwContainPopUp.isHidden = true
        self.vwContainTable.isHidden = true
        
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
        
         let filtered = self.arrOptionsFiltered.filter{ $0.isSelected == true }
            
        print(filtered)
        if filtered.count != 0{
            
            var arrId = [String]()
            var arrNames = [String]()
            for i in 0...filtered.count-1{
                arrId.append(filtered[i].strID)
                arrNames.append(filtered[i].strName)
            }
            
            let Id = arrId.joined(separator: ",")
            let name = arrNames.joined(separator: ",")
            
            print(Id)
            print(name)
            
            switch self.isComingFrom {
            case "2":
                dict["nation_id"] = Id
                dict["nation"] = name
                self.closerForSelectionTable?(dict)
            case "3":
                dict["Community_id"] = Id
                dict["Community"] = name
                self.closerForSelectionTable?(dict)
            case "4":
                dict["Province_id"] = Id
                dict["Province"] = name
                self.closerForSelectionTable?(dict)
            case "5":
                dict["Municipal_id"] = Id
                dict["Municipal"] = name
                self.closerForSelectionTable?(dict)
            default:
                dict["Sector_id"] = Id
                dict["Sector"] = name
                self.closerForSelectionTable?(dict)
            }
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
            self.strType = "Particular"
            self.imgVwRadio1.image = UIImage.init(named: "radio_button_selected")
        default:
            print("profession")
            self.strType = "Profesional"
            self.imgVwRadio2.image = UIImage.init(named: "radio_button_selected")
        }
    }
}


//MARK:- Searching
extension PopUpViewController{
    
    @objc func searchContactAsPerText(_ textfield:UITextField) {
            self.arrOptionsFiltered.removeAll()
            if textfield.text?.count != 0 {
                for dicData in self.arrOptions {
                    let isMachingWorker : NSString = (dicData.strName) as NSString
                    let range = isMachingWorker.lowercased.range(of: textfield.text!, options: NSString.CompareOptions.caseInsensitive, range: nil,   locale: nil)
                    if range != nil {
                        arrOptionsFiltered.append(dicData)
                    }
                }
            } else {
                self.arrOptionsFiltered = self.arrOptions
            }
            if self.arrOptionsFiltered.count == 0{
                self.tblVw.displayBackgroundText(text: "ningún record fue encontrado")
            }else{
                self.tblVw.displayBackgroundText(text: "")
            }
            self.tblVw.reloadData()
    }
    
}


extension PopUpViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrOptionsFiltered.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OptionsTableViewCell")as! OptionsTableViewCell
        
        cell.lblTitle.text = self.arrOptionsFiltered[indexPath.row].strName
        
        if self.arrOptionsFiltered[indexPath.row].isSelected == true{
            cell.vwBorder.borderColor = UIColor.init(named: "Pink")
            cell.vwTick.isHidden = false
        }else{
            cell.vwBorder.borderColor = UIColor.lightGray
            cell.vwTick.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let obj = self.arrOptionsFiltered[indexPath.row]
        
        switch self.isComingFrom {
        case "2":
            self.strNationID = self.arrOptionsFiltered[indexPath.row].strID
            self.strNationTitle = self.arrOptionsFiltered[indexPath.row].strName
            self.arrOptionsFiltered.filter({$0.isSelected == true}).first?.isSelected = false
            obj.isSelected = true
        case "3":
            self.strCommunityID = self.arrOptionsFiltered[indexPath.row].strID
            self.strCommunityTitle = self.arrOptionsFiltered[indexPath.row].strName
            self.arrOptionsFiltered.filter({$0.isSelected == true}).first?.isSelected = false
            obj.isSelected = true
        case "4":
            self.strProvinceID = self.arrOptionsFiltered[indexPath.row].strID
            self.strProvinceTitle = self.arrOptionsFiltered[indexPath.row].strName
            self.arrOptionsFiltered.filter({$0.isSelected == true}).first?.isSelected = false
            obj.isSelected = true
        case "5":
            self.strMunicipalID = self.arrOptionsFiltered[indexPath.row].strID
            self.strMunicipalTitle = self.arrOptionsFiltered[indexPath.row].strName
            self.arrOptionsFiltered.filter({$0.isSelected == true}).first?.isSelected = false
            obj.isSelected = true
        default:
            self.strSectorID = self.arrOptionsFiltered[indexPath.row].strID
            self.strSectorTitle = self.arrOptionsFiltered[indexPath.row].strName
            if self.isMultiple == "Yes"{
                if obj.isSelected == true{
                    obj.isSelected = false
                }else{
                    obj.isSelected = true
                }
            }else{
                self.arrOptionsFiltered.filter({$0.isSelected == true}).first?.isSelected = false
                obj.isSelected = true
            }
           
        }
        
        
        
        
        
        
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
                    self.arrOptionsFiltered.removeAll()
                    for data in user_details{
                        let obj = OptionsModelClass.init(dict: data)
                        self.arrOptions.append(obj)
                        if self.strNationID == obj.strID{
                            obj.isSelected = true
                        }else{
                            obj.isSelected = false
                        }
                    }
                    
                    self.arrOptionsFiltered = self.arrOptions
                    
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
                    self.arrOptionsFiltered.removeAll()
                    for data in user_details{
                        let obj = OptionsModelClass.init(dict: data)
                        self.arrOptions.append(obj)
                        if self.strCommunityID == obj.strID{
                            obj.isSelected = true
                        }else{
                            obj.isSelected = false
                        }
                    }
                    self.arrOptionsFiltered = self.arrOptions
                    
                    self.tblVw.reloadData()
                }
                else {
                    objAlert.showAlert(message: "Something went wrong!", title: "", controller: self)
                }
            }else{
                objWebServiceManager.hideIndicator()
                if let msgg = response["result"]as? String{
                    objAlert.showAlertSingleButtonCallBack(alertBtn: "OK", title: "", message: msgg, controller: self) {
                        self.onBackPressed()
                    }
                   // objAlert.showAlert(message: msgg, title: "", controller: self)
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
                    self.arrOptionsFiltered.removeAll()
                    for data in user_details{
                        let obj = OptionsModelClass.init(dict: data)
                        self.arrOptions.append(obj)
                        if self.strProvinceID == obj.strID{
                            obj.isSelected = true
                        }else{
                            obj.isSelected = false
                        }
                    }
                    
                    self.arrOptionsFiltered = self.arrOptions
                    self.tblVw.reloadData()
                }
                else {
                    objAlert.showAlert(message: "Something went wrong!", title: "", controller: self)
                }
            }else{
                objWebServiceManager.hideIndicator()
                if let msgg = response["result"]as? String{
                    objAlert.showAlertSingleButtonCallBack(alertBtn: "OK", title: "", message: msgg, controller: self) {
                        self.onBackPressed()
                    }
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
                    self.arrOptionsFiltered.removeAll()
                    for data in user_details{
                        let obj = OptionsModelClass.init(dict: data)
                        self.arrOptions.append(obj)
                        if self.strMunicipalID == obj.strID{
                            obj.isSelected = true
                        }else{
                            obj.isSelected = false
                        }
                    }
                    
                    self.arrOptionsFiltered = self.arrOptions
                    
                    self.tblVw.reloadData()
                }
                else {
                    objAlert.showAlert(message: "Something went wrong!", title: "", controller: self)
                }
            }else{
                objWebServiceManager.hideIndicator()
                if let msgg = response["result"]as? String{
                    objAlert.showAlertSingleButtonCallBack(alertBtn: "OK", title: "", message: msgg, controller: self) {
                        self.onBackPressed()
                    }
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
                    self.arrOptionsFiltered.removeAll()
                    for data in user_details{
                        let obj = OptionsModelClass.init(dict: data)
                        self.arrOptions.append(obj)
                    }
                    
                    self.arrOptionsFiltered = self.arrOptions
                    
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
