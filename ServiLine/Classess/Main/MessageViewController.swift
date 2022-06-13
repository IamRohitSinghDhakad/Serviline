//
//  MessageViewController.swift
//  ServiLine
//
//  Created by Rohit Singh Dhakad on 11/03/22.
//

import UIKit

class MessageViewController: UIViewController {

    @IBOutlet var tblVw: UITableView!
    @IBOutlet var vwContainsButton: UIView!
    @IBOutlet var vwNoRecordFound: UIView!
    
    var arrMessageList = [ConversationListModel]()
    var isShowingCheckBox = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblVw.estimatedRowHeight = 160
        self.tblVw.delegate = self
        self.tblVw.dataSource = self
        self.vwNoRecordFound.isHidden = true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.vwContainsButton.isHidden = true
        self.call_GetChatList(strUserID: objAppShareData.UserDetail.strUserId)
    }

    @IBAction func btnOnOpenSideMenu(_ sender: Any) {
        self.sideMenuController?.revealMenu()
    }
    
    @IBAction func btnOnCancel(_ sender: Any) {
        self.isShowingCheckBox = false
        self.vwContainsButton.isHidden = true
        self.tblVw.reloadData()
    }
    @IBAction func btnOnDelete(_ sender: Any) {
        var arrID = [String]()
        let arr = self.arrMessageList.filter{$0.isSelected == true}
        for data in arr{
            arrID.append(data.strSenderIDForChat)
        }
        
        if arrID.count == 0{
            
        }else{
            let finalString = arrID.joined(separator: ",")
            self.call_DeleteUserConversation(senderId: finalString)
        }
       
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
        }else{
            cell.imgVwUser.image = UIImage.init(named: "logo")
        }
        
        cell.lblUserName.text = obj.strName
        cell.lblTimeAgo.text = obj.strTimeAgo
        cell.lblMsg.text = obj.strLastMsg.decodeEmoji
        
        if obj.strMessageCount > 0{
            cell.lblMsgCount.isHidden = false
            cell.lblMsgCount.text = "\(obj.strMessageCount)"
        }else{
            cell.lblMsgCount.isHidden = true
        }
        
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
        
        if self.vwContainsButton.isHidden == true{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatDetailViewController")as! ChatDetailViewController
            vc.strSenderID = self.arrMessageList[indexPath.row].strSenderIDForChat
            vc.strUserImage = self.arrMessageList[indexPath.row].strUserImage
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let obj = self.arrMessageList[indexPath.row]
            obj.isSelected = obj.isSelected == true ? false : true
            self.tblVw.reloadData()
        }
       
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
        
        
       // objWebServiceManager.requestGet(strURL: WsUrl.url_getConversationList, params: parameter, queryParams: [:], strCustomValidation: "") { (response) in
        objWebServiceManager.requestPost(strURL: WsUrl.url_getConversationList, queryParams: [:], params: parameter, strCustomValidation: "", showIndicator: false) { response in
            
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
                    
                    self.setupLongGestureRecognizerOnCollection()
                   // self.arrMessageList.reverse()
                    
                    if self.arrMessageList.count == 0{
                        //self.tblVw.displayBackgroundText(text: "No Record Found!")
                        self.vwNoRecordFound.isHidden = false
                    }else{
                        //self.tblVw.displayBackgroundText(text: "")
                        self.vwNoRecordFound.isHidden = true
                    }
                    
                    self.tblVw.reloadData()
                }
            }else{
                objWebServiceManager.hideIndicator()
                self.vwNoRecordFound.isHidden = false
//
//                if (response["result"]as? String) != nil{
//                    self.tblVw.reloadData()
//                    self.tblVw.displayBackgroundText(text: "No Record Found!")
//                }else{
//                    objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
//                }
            }
        } failure: { (Error) in
            print(Error)
            objWebServiceManager.hideIndicator()
        }
    }
    
    
    
    func call_DeleteUserConversation(senderId: String) {
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let parameter = ["receiver_id" : senderId,
                         "sender_id": objAppShareData.UserDetail.strUserId] as [String:Any]
        print(parameter)
        
       // objWebServiceManager.requestGet(strURL: WsUrl.url_clearConversation, params: parameter, queryParams: [:], strCustomValidation: "") { (response) in
        objWebServiceManager.requestPost(strURL: WsUrl.url_clearConversation, queryParams: [:], params: parameter, strCustomValidation: "", showIndicator: false) { response in
            
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            _ = (response["message"] as? String)
            
            print(response)
            
            if status == MessageConstant.k_StatusCode{
                
               
                self.vwContainsButton.isHidden = true
                self.isShowingCheckBox = false
                self.call_GetChatList(strUserID: objAppShareData.UserDetail.strUserId)
                
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

extension MessageViewController: UIGestureRecognizerDelegate{
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
                let obj = self.arrMessageList[indexPath.row]
                obj.isSelected = true
                self.isShowingCheckBox = true
                self.vwContainsButton.isHidden = false
                self.tblVw.reloadData()
            }
        }
}
