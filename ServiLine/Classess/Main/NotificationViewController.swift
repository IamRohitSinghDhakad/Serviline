//
//  NotificationViewController.swift
//  ServiLine
//
//  Created by Rohit Singh Dhakad on 11/03/22.
//

import UIKit

class NotificationViewController: UIViewController {

    @IBOutlet var tblVw: UITableView!
    
    var arrNotifications = [ConversationListModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tblVw.delegate = self
        self.tblVw.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.call_GetNotification(strUserId: objAppShareData.UserDetail.strUserId)
    }

    @IBAction func btnOnOpenSideMenu(_ sender: Any) {
        self.sideMenuController?.revealMenu()
    }
   

}

extension NotificationViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrNotifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageTableViewCell")as! MessageTableViewCell
        
        let obj = self.arrNotifications[indexPath.row]
        
        let profilePic = obj.strNotificationImage
        if profilePic != "" {
            let url = URL(string: profilePic)
            cell.imgVwUser.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo"))
        }
        
        cell.lblUserName.text = obj.strNotificationUserName
        cell.lblTimeAgo.text = obj.strTimeAgo
        cell.lblMsg.text = obj.strNotificationTitle
        
        return cell
    }
}


extension NotificationViewController{
    
    func call_GetNotification(strUserId:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let parameter = ["user_id":strUserId]as [String:Any]
        
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_getNotification, params: parameter, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            print(response)
            
            if status == MessageConstant.k_StatusCode{
                if let arrData  = response["result"] as? [[String:Any]]{
                    self.arrNotifications.removeAll()
                    
                    for dictdata in arrData{
                        let obj = ConversationListModel.init(dict: dictdata)
                        self.arrNotifications.append(obj)
                    }
                    self.tblVw.reloadData()
                }
            }else{
                objWebServiceManager.hideIndicator()
                
                if (response["result"]as? String) != nil{
                    self.tblVw.displayBackgroundText(text: "Aún no tienes ninguna notificación")
                }else{
                    objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
                }
                
               // objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
                
            }
            
            
        } failure: { (Error) in
            print(Error)
            objWebServiceManager.hideIndicator()
        }
    }
    
}
