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
    
    var arrOptions = [OptionsModelClass]()
    
    var isComingFrom = ""
    var strNationID = ""
    var strCommunityID = ""
    var strProvinceID = ""
    var strMunicipalID = ""
    var strSectorID = ""
    
    var closerForSelectionButton: (( _ strDict:[String:Any]) ->())?
    var closerForSelectionTable: (( _ strDict:[String:Any]) ->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tblVw.delegate = self
        self.tblVw.dataSource = self
        
        self.vwContainPopUp.isHidden = true
        self.vwContainTable.isHidden = true
        
        switch isComingFrom {
        case "1":
            self.vwContainPopUp.isHidden = false
        default:
            self.vwContainTable.isHidden = false
        }
        
        call_WsGetNation()
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
        case "Table":
          //  dict["update_subcat"] = self.selectedSubCat
            self.closerForSelectionTable?(dict)
        case "SeeAll":
            //dict["update_subcat"] = self.selectedSubCat
            self.closerForSelectionTable?(dict)
        case "Searching":
            //dict["update_subcat"] = self.selectedSubCat
            self.closerForSelectionTable?(dict)
        default:
            break
        }
        
        onBackPressed()
    }
    
    
    
    
    @IBAction func btnOnOKPopUp(_ sender: Any) {
        onBackPressed()
       // self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnSelectionPopUp(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            print("user")
        default:
            print("profession")
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
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
}


//Call Webservice
extension PopUpViewController{
    
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
