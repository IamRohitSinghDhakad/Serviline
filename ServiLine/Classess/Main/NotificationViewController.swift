//
//  NotificationViewController.swift
//  ServiLine
//
//  Created by Rohit Singh Dhakad on 11/03/22.
//

import UIKit

class NotificationViewController: UIViewController {

    @IBOutlet var tblVw: UITableView!
    @IBOutlet var vwContainButtons: UIView!
    
    
    var arrNotifications = [ConversationListModel]()
    var isShowingCheckBox = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        self.tblVw.delegate = self
        self.tblVw.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.vwContainButtons.isHidden = true
        self.call_GetNotification(strUserId: objAppShareData.UserDetail.strUserId)
    }

    @IBAction func btnOnOpenSideMenu(_ sender: Any) {
        self.sideMenuController?.revealMenu()
    }
   
    @IBAction func btnOnCancel(_ sender: Any) {
        self.isShowingCheckBox = false
        self.vwContainButtons.isHidden = true
        self.tblVw.reloadData()
    }
    @IBAction func btnOnDelete(_ sender: Any) {
        var arrID = [String]()
        let arr = self.arrNotifications.filter{$0.isSelected == true}
        for data in arr{
            arrID.append(data.strNotificationId)
        }
        
        if arrID.count == 0{
            
        }else{
            let finalString = arrID.joined(separator: ",")
            print(finalString)
            self.call_DeleteUserNotification(id: finalString)
        }
       
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
        
        
        if self.isShowingCheckBox == true{
            cell.vwCheckUncheck.isHidden = false
            cell.imgVwCheckUncheck.isHidden = false
            
            if obj.isSelected == true{
                cell.imgVwCheckUncheck.image = UIImage.init(named: "select")
            }else{
                cell.imgVwCheckUncheck.image = UIImage.init(named: "unchecked")
            }
        }else{
            obj.isSelected = false
            cell.vwCheckUncheck.isHidden = true
            cell.imgVwCheckUncheck.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if self.vwContainButtons.isHidden == true{
            let senderID = self.arrNotifications[indexPath.row].strSenderID
            
            print(senderID)
            
            if senderID == "" || senderID == "0"{
                
            }else{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "OtherUserProfileViewController")as! OtherUserProfileViewController
                vc.strUserID = self.arrNotifications[indexPath.row].strSenderID
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else{
            let obj = self.arrNotifications[indexPath.row]
            obj.isSelected = obj.isSelected == true ? false : true
            self.tblVw.reloadData()
        }
        
        
        
        
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
        
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_getNotification, queryParams: [:], params: parameter, strCustomValidation: "", showIndicator: false) { response in
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
                    self.setupLongGestureRecognizerOnCollection()
                    self.tblVw.reloadData()
                }
            }else{
                objWebServiceManager.hideIndicator()
                
                if (response["result"]as? String) != nil{
                    self.tblVw.displayBackgroundText(text: "No Record Found!")
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
    
    func call_DeleteUserNotification(id: String) {
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let parameter = ["notification_id" : id] as [String:Any]
        print(parameter)
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_DeleteNotification, params: parameter, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            print(response)
            
            if status == MessageConstant.k_StatusCode{
                
               
                self.vwContainButtons.isHidden = true
                self.isShowingCheckBox = false
                self.call_GetNotification(strUserId: objAppShareData.UserDetail.strUserId)
                
            }else{
                objWebServiceManager.hideIndicator()
               // objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
                
            }
            
            
        } failure: { (Error) in
            print(Error)
            objWebServiceManager.hideIndicator()
        }
    }
    
}


extension NotificationViewController: UIGestureRecognizerDelegate{
        private func setupLongGestureRecognizerOnCollection() {
            let longPressedGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
            longPressedGesture.minimumPressDuration = 0.5
            longPressedGesture.delegate = self
            longPressedGesture.delaysTouchesBegan = true
            self.tblVw?.addGestureRecognizer(longPressedGesture)
        }
        
        @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
            if (gestureRecognizer.state != .began) {
                return
            }

            let p = gestureRecognizer.location(in: self.tblVw)
            
          //  let p = gestureRecognizer.location(in: collectionView)

            if let indexPath = self.tblVw?.indexPathForRow(at: p) {
                print("Long press at item: \(indexPath.row)")
                let obj = self.arrNotifications[indexPath.row]
                obj.isSelected = true
                self.isShowingCheckBox = true
                self.vwContainButtons.isHidden = false
                self.tblVw.reloadData()
            }
        }
}
