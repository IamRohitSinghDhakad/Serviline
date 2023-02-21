//
//  PreguntasViewController.swift
//  ServiLine
//
//  Created by Rohit Singh Dhakad on 13/12/22.
//

import UIKit

class PreguntasViewController: UIViewController {

    @IBOutlet var tblVw: UITableView!
    @IBOutlet var vwNoRecordFound: UIView!
    
    var arrPreguntasList = [PreguntasModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.vwNoRecordFound.isHidden = true
        self.tblVw.delegate = self
        self.tblVw.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UserDefaults.standard.setValue(0, forKey: "badgeTicket")
        self.call_GetReportList(strUserID: objAppShareData.UserDetail.strUserId)
    }
    
    
    @IBAction func btnOnOpenSideMenu(_ sender: Any) {
        self.sideMenuController?.revealMenu()
    }

    @IBAction func btnOnGoToPreguntasPage(_ sender: Any) {
        pushVc(viewConterlerId: "PreguntasTicketGenrateViewController")
    }
}

extension PreguntasViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrPreguntasList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PreguntasTableViewCell")as! PreguntasTableViewCell
        
        let obj = self.arrPreguntasList[indexPath.row]

        cell.lblTitle.text = obj.strReason
        let status = obj.strStatus
        
        if status == "0"{
            cell.lblStatus.text = "Cerrade"
        }else{
            cell.lblStatus.text = "Abierta"
        }
        
        cell.lblTimeAgo.text = obj.strTimeago
        cell.lblHeading.text = "ID - #\(obj.strTicketId)"
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let obj = self.arrPreguntasList[indexPath.row]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HistorialPreguntasViewController")as! HistorialPreguntasViewController
        vc.obj = obj
        self.navigationController?.pushViewController(vc, animated: true)
        
       // self.pushVc(viewConterlerId: "OtherUserProfileViewController")
    }
}



extension PreguntasViewController{
    
    
    func call_GetReportList(strUserID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let parameter = ["user_id":strUserID]as [String:Any]
        
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_GetTickets, queryParams: [:], params: parameter, strCustomValidation: "", showIndicator: false) { response in

            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            print(response)
            
            if status == MessageConstant.k_StatusCode{
                if let arrData  = response["result"] as? [[String:Any]]{
                    self.arrPreguntasList.removeAll()
                    for dictdata in arrData{
                        let obj = PreguntasModel.init(dict: dictdata)
                        self.arrPreguntasList.append(obj)
                    }
                    
                    if self.arrPreguntasList.count == 0{
                        self.vwNoRecordFound.isHidden = false
                    }else{
                        self.vwNoRecordFound.isHidden = true
                    }
                    self.tblVw.reloadData()
                }
            }else{
                
                objWebServiceManager.hideIndicator()
                self.vwNoRecordFound.isHidden = false
                
            }
        } failure: { (Error) in
            print(Error)
            objWebServiceManager.hideIndicator()
        }
    }
    
    
    //MARK:-Add Remove On Fav List
    func call_ReportUaser(strUserID:String, strToUserID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let parameter = ["user_id":strUserID,
                         "to_user_id":strToUserID,
                         "message":""]as [String:Any]
        print(parameter)
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_ReportAnUser, queryParams: [:], params: parameter, strCustomValidation: "", showIndicator: false) { response in
            
            print(response)
            
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
                        
            if status == MessageConstant.k_StatusCode{
                if let dictData  = response["result"] as? [String:Any]{
                    if message == "success"{


                    }
                }
            }else{
                if response["result"]as? String == "Any reports not found"{
                    self.call_GetReportList(strUserID: objAppShareData.UserDetail.strUserId)
                }
                objWebServiceManager.hideIndicator()
            
            }
        } failure: { (Error) in
            objWebServiceManager.hideIndicator()
        }
    }
}

