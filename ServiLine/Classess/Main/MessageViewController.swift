//
//  MessageViewController.swift
//  ServiLine
//
//  Created by Rohit Singh Dhakad on 11/03/22.
//

import UIKit

class MessageViewController: UIViewController {

    @IBOutlet var tblVw: UITableView!
    
    var arrMessageList = [ConversationListModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tblVw.estimatedRowHeight = 160
        self.tblVw.delegate = self
        self.tblVw.dataSource = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.call_GetChatList(strUserID: objAppShareData.UserDetail.strUserId)
    }

    @IBAction func btnOnOpenSideMenu(_ sender: Any) {
        self.sideMenuController?.revealMenu()
    }
   

}


extension MessageViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrMessageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageTableViewCell")as! MessageTableViewCell
        
        let obj = self.arrMessageList[indexPath.row]
        
        let profilePic = obj.strUserImage
        if profilePic != "" {
            let url = URL(string: profilePic)
            cell.imgVwUser.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo"))
        }
        
        cell.lblUserName.text = obj.strName
        cell.lblTimeAgo.text = obj.strTimeAgo
        cell.lblMsg.text = obj.strLastMsg
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pushVc(viewConterlerId: "ChatDetailViewController")
    }
}


extension MessageViewController{
    
    func call_GetChatList(strUserID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let parameter = ["user_id":strUserID]as [String:Any]
        
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_getConversationList, params: parameter, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            print(response)
            
            if status == MessageConstant.k_StatusCode{
                if let arrData  = response["result"] as? [[String:Any]]{
                    
                    self.arrMessageList.removeAll()
                    for dictdata in arrData{
                        let obj = ConversationListModel.init(dict: dictdata)
                        self.arrMessageList.append(obj)
                    }
                    
                    self.arrMessageList.reverse()
                    
                    if self.arrMessageList.count == 0{
                        self.tblVw.displayBackgroundText(text: "No Record Found!")
                    }else{
                        self.tblVw.displayBackgroundText(text: "")
                    }
                    
                    self.tblVw.reloadData()
                }
            }else{
                objWebServiceManager.hideIndicator()
                
                if (response["result"]as? String) != nil{
                    self.tblVw.reloadData()
                    self.tblVw.displayBackgroundText(text: "No Record Found!")
                }else{
                    objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
                }
            }
        } failure: { (Error) in
            print(Error)
            objWebServiceManager.hideIndicator()
        }
    }
}
