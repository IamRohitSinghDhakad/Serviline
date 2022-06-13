//
//  BlockedViewController.swift
//  ServiLine
//
//  Created by Rohit Singh Dhakad on 11/03/22.
//

import UIKit

class BlockedViewController: UIViewController {

    @IBOutlet var tblVw: UITableView!
    @IBOutlet var vwNoRecordFound: UIView!
    
    var arrBlockUserList = [FavoriteListModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblVw.delegate = self
        self.tblVw.dataSource = self
        self.vwNoRecordFound.isHidden = true

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.call_GetBlockList(strUserID: objAppShareData.UserDetail.strUserId)
    }
    
    @IBAction func btnOnOpenSideMenu(_ sender: Any) {
        self.sideMenuController?.revealMenu()
    }

   

}


extension BlockedViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrBlockUserList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteTableViewCell")as! FavoriteTableViewCell
        
        let obj = self.arrBlockUserList[indexPath.row]
        
        let profilePic = obj.strUserImage
        if profilePic != "" {
            let url = URL(string: profilePic)
            cell.imgVwUser.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo"))
        }
        
        cell.lblUserName.text = obj.strName
        
        cell.btnRemove.tag = indexPath.row
        cell.btnRemove.addTarget(self, action: #selector(removeUser(sender:)), for: .touchUpInside)

        
        return cell
    }
    
    @objc func removeUser(sender: UIButton){
        let objUserID = self.arrBlockUserList[sender.tag].strOpponentUserID
        self.call_BlockUnblockUser(strUserID: objAppShareData.UserDetail.strUserId, strToUserID: objUserID)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OtherUserProfileViewController")as! OtherUserProfileViewController
        vc.strUserID = self.arrBlockUserList[indexPath.row].strOpponentUserID
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


extension BlockedViewController{
    
    
    func call_GetBlockList(strUserID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let parameter = ["user_id":strUserID]as [String:Any]
        
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_getBlockList, queryParams: [:], params: parameter, strCustomValidation: "", showIndicator: false) { response in

            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            print(response)
            self.arrBlockUserList.removeAll()
            
            if status == MessageConstant.k_StatusCode{
                if let arrData  = response["result"] as? [[String:Any]]{
                  
                    for dictdata in arrData{
                        let obj = FavoriteListModel.init(dict: dictdata)
                        self.arrBlockUserList.append(obj)
                    }
                    if self.arrBlockUserList.count != 0{
                       // self.tblVw.displayBackgroundText(text: "")
                        self.vwNoRecordFound.isHidden = true
                    }else{
                       // self.tblVw.displayBackgroundText(text: "No Record Found!")
                        self.vwNoRecordFound.isHidden = false
                    }
                   
                    self.tblVw.reloadData()
                }
            }else{
                objWebServiceManager.hideIndicator()
                self.vwNoRecordFound.isHidden = false
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
    
    
    //MARK:-Add Remove On Fav List
    func call_BlockUnblockUser(strUserID:String, strToUserID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let parameter = ["user_id":strUserID,
                         "to_user_id":strToUserID]as [String:Any]
        print(parameter)
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_BlockUnblockUser, queryParams: [:], params: parameter, strCustomValidation: "", showIndicator: false) { response in
            
            print(response)
            
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
                        
            if status == MessageConstant.k_StatusCode{
                if let dictData  = response["result"] as? [String:Any]{
                    if message == "success"{
//                        self.btnMessage.isHidden = true
//                        self.vwBlockUser.isHidden = false
                        
                    }
                }
            }else{
                if response["result"]as? String == "Any blocked users not found"{
                    self.call_GetBlockList(strUserID: strUserID)
//                    self.btnMessage.isHidden = false
//                    self.vwBlockUser.isHidden = true
                }
                objWebServiceManager.hideIndicator()
            
            }
        } failure: { (Error) in
            objWebServiceManager.hideIndicator()
        }
    }
}
