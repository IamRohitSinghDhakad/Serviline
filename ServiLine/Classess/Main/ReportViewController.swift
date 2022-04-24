//
//  ReportViewController.swift
//  ServiLine
//
//  Created by Rohit Singh Dhakad on 11/03/22.
//

import UIKit

class ReportViewController: UIViewController {

    @IBOutlet var tblVw: UITableView!
    
    var arrReportUserList = [FavoriteListModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblVw.delegate = self
        self.tblVw.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.call_GetReportList(strUserID: objAppShareData.UserDetail.strUserId)
    }
    
    @IBAction func btnOnOpenSideMenu(_ sender: Any) {
        self.sideMenuController?.revealMenu()
    }

}

extension ReportViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrReportUserList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteTableViewCell")as! FavoriteTableViewCell
        
        let obj = self.arrReportUserList[indexPath.row]
        
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
        let objUserID = self.arrReportUserList[sender.tag].strOpponentUserID
        self.call_ReportUaser(strUserID: objAppShareData.UserDetail.strUserId, strToUserID: objUserID)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let objID = self.arrReportUserList[indexPath.row].strOpponentUserID
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OtherUserProfileViewController")as! OtherUserProfileViewController
        vc.strUserID = objID
        self.navigationController?.pushViewController(vc, animated: true)
        
       // self.pushVc(viewConterlerId: "OtherUserProfileViewController")
    }
}



extension ReportViewController{
    
    
    func call_GetReportList(strUserID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let parameter = ["user_id":strUserID]as [String:Any]
        
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_getReportList, queryParams: [:], params: parameter, strCustomValidation: "", showIndicator: false) { response in

            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            print(response)
            
            if status == MessageConstant.k_StatusCode{
                if let arrData  = response["result"] as? [[String:Any]]{
                    self.arrReportUserList.removeAll()
                    for dictdata in arrData{
                        let obj = FavoriteListModel.init(dict: dictdata)
                        self.arrReportUserList.append(obj)
                    }
                    
                    if self.arrReportUserList.count == 0{
                        self.tblVw.displayBackgroundText(text: "No Record Found!")
                    }else{
                        self.tblVw.displayBackgroundText(text: "")
                    }
                    self.tblVw.reloadData()
                }
            }else{
                objWebServiceManager.hideIndicator()
                if response["result"]as? String == "Any reports not found"{
                    self.arrReportUserList.removeAll()
                    self.tblVw.displayBackgroundText(text: "No Record Found!")
                    self.tblVw.reloadData()
                }else{
                    objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
                }
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
