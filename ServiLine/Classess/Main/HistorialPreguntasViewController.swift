//
//  HistorialPreguntasViewController.swift
//  ServiLine
//
//  Created by Rohit Singh Dhakad on 17/12/22.
//

import UIKit

class HistorialPreguntasViewController: UIViewController {

    @IBOutlet var lblId: UILabel!
    @IBOutlet var lblDesc: UILabel!
    @IBOutlet var lblStatus: UILabel!
    @IBOutlet var tblVw: UITableView!
    @IBOutlet var vwPopUp: UIView!
    @IBOutlet var ttxtVwMsg: RDTextView!
    @IBOutlet var vwReply: UIView!
    @IBOutlet var vwNoRecordFound: UIView!
    
    var obj: PreguntasModel?
    var arrPreguntasList = [PreguntasModelChatList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.vwPopUp.isHidden = true
        self.lblDesc.text = obj?.strReason
        let status = obj?.strStatus
        
        if status == "0"{
            self.lblStatus.text = "Cerrade"
            self.vwReply.isHidden = true
        }else{
            self.lblStatus.text = "Abierta"
            self.vwReply.isHidden = false
        }
        self.lblId.text = "ID - #\(obj?.strTicketId ?? "")"
        
        self.tblVw.delegate = self
        self.tblVw.dataSource = self
        
        call_GetReportList(strTicketID: obj?.strTicketId ?? "")
        // Do any additional setup after loading the view.
    }

    @IBAction func btnBackOnHeader(_ sender: Any) {
        onBackPressed()
        
    }
    @IBAction func btnOnOpenChatBox(_ sender: Any) {
        self.vwPopUp.isHidden = false
    }
    
    
    @IBAction func btnHidePopUp(_ sender: Any) {
        self.ttxtVwMsg.text = ""
        self.vwPopUp.isHidden = true
    }
    
    @IBAction func btnOnSendChatMsg(_ sender: Any) {
        self.ttxtVwMsg.text = self.ttxtVwMsg.text?.trim()
        if (self.ttxtVwMsg.text!.isEmpty){
            objAlert.showAlert(message: "Introduzca mensaje", title: "Alert", controller: self)
        }
        else{
            self.call_InsertChatMsg(strTicketID: obj?.strTicketId ?? "", strMessage: self.ttxtVwMsg.text!)
        }
    }
}

extension HistorialPreguntasViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrPreguntasList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblVw.dequeueReusableCell(withIdentifier: "PreguntasChatListTableViewCell")as! PreguntasChatListTableViewCell
        
        let obj = self.arrPreguntasList[indexPath.row]

        cell.lblTimeAgo.text = obj.strTimeago
        let status = obj.strFromAdmin

        if status == "0"{
            cell.lblUserName.text = objAppShareData.UserDetail.strName
        }else{
            cell.lblUserName.text = "Administrador de Servi Line"
        }

        cell.lblMsg.text = obj.strMessage
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let obj = self.arrPreguntasList[indexPath.row]
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HistorialPreguntasViewController")as! HistorialPreguntasViewController
//        vc.obj = obj
//        self.navigationController?.pushViewController(vc, animated: true)
//
       // self.pushVc(viewConterlerId: "OtherUserProfileViewController")
    }
}



extension HistorialPreguntasViewController{
    
    
    func call_GetReportList(strTicketID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let parameter = ["ticket_id":strTicketID]as [String:Any]
        
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_GetTicketsMessages, queryParams: [:], params: parameter, strCustomValidation: "", showIndicator: false) { response in
            
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            print(response)
            
            if status == MessageConstant.k_StatusCode{
                if let arrData  = response["result"] as? [[String:Any]]{
                    self.arrPreguntasList.removeAll()
                    for dictdata in arrData{
                        let obj = PreguntasModelChatList.init(dict: dictdata)
                        self.arrPreguntasList.append(obj)
                    }
                    
                    print(self.arrPreguntasList.count)
                    
                    if self.arrPreguntasList.count == 0{
                        self.vwNoRecordFound.isHidden = false
                        self.vwReply.isHidden = true
                    }else{
                        self.vwNoRecordFound.isHidden = true
                        let status = self.obj?.strStatus
                        if status == "0"{
                            self.vwReply.isHidden = true
                        }else{
                            self.vwReply.isHidden = false
                        }
                    }
                    self.tblVw.reloadData()
                }
            }else{
                
                objWebServiceManager.hideIndicator()
                  self.vwNoRecordFound.isHidden = false
                self.vwReply.isHidden = true
                
            }
        } failure: { (Error) in
            print(Error)
            objWebServiceManager.hideIndicator()
        }
    }
    
    //=======================  SEND CHAT Message ===================//
    
    func call_InsertChatMsg(strTicketID:String, strMessage: String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let parameter = ["ticket_id":strTicketID,
                         "message":strMessage]as [String:Any]
        
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_InsertTicketMsg, queryParams: [:], params: parameter, strCustomValidation: "", showIndicator: false) { response in
            
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            print(response)
            
            if status == MessageConstant.k_StatusCode{
                self.ttxtVwMsg.text = ""
                if let dictData  = response["result"] as? [String:Any]{
                    self.vwPopUp.isHidden = true
                    self.call_GetReportList(strTicketID: self.obj?.strTicketId ?? "")
                }
            }else{
                
                objWebServiceManager.hideIndicator()
                //  self.vwNoRecordFound.isHidden = false
                
            }
        } failure: { (Error) in
            print(Error)
            objWebServiceManager.hideIndicator()
        }
    }
}
