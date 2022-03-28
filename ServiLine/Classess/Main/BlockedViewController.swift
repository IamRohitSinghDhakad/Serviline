//
//  BlockedViewController.swift
//  ServiLine
//
//  Created by Rohit Singh Dhakad on 11/03/22.
//

import UIKit

class BlockedViewController: UIViewController {

    @IBOutlet var tblVw: UITableView!
    
    var arrBlockUserList = [FavoriteListModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblVw.delegate = self
        self.tblVw.dataSource = self

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
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.pushVc(viewConterlerId: "OtherUserProfileViewController")
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
        
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_getBlockList, params: parameter, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            print(response)
            
            if status == MessageConstant.k_StatusCode{
                if let arrData  = response["result"] as? [[String:Any]]{
                    self.arrBlockUserList.removeAll()
                    for dictdata in arrData{
                        let obj = FavoriteListModel.init(dict: dictdata)
                        self.arrBlockUserList.append(obj)
                    }
                    
                    self.tblVw.reloadData()
                }
            }else{
                objWebServiceManager.hideIndicator()
                
                if (response["result"]as? String) != nil{
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
