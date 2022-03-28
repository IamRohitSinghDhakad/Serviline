//
//  FavoriteViewController.swift
//  ServiLine
//
//  Created by Rohit Singh Dhakad on 11/03/22.
//

import UIKit

class FavoriteViewController: UIViewController {

    @IBOutlet var tblVw: UITableView!
    
    var arrFavList = [FavoriteListModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tblVw.delegate = self
        self.tblVw.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.call_GetFavoriteList(strUserID: objAppShareData.UserDetail.strUserId)
    }
    
    
    @IBAction func btnOnOpenSideMenu(_ sender: Any) {
        self.sideMenuController?.revealMenu()
    }


}


extension FavoriteViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrFavList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteTableViewCell")as! FavoriteTableViewCell
        
        let obj = self.arrFavList[indexPath.row]
        
        let profilePic = obj.strUserImage
        if profilePic != "" {
            let url = URL(string: profilePic)
            cell.imgVwUser.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo"))
        }
        
        cell.lblUserName.text = obj.strName
        cell.lblDesc.text = obj.strBio
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pushVc(viewConterlerId: "OtherUserProfileViewController")
    }
}


extension FavoriteViewController{
    
    //MARK:- Call Webservice
    
    func call_GetFavoriteList(strUserID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let parameter = ["user_id":strUserID]as [String:Any]
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_FavoriteList, params: parameter, queryParams: [:], strCustomValidation: "") { (response) in
            
            print(response)
            
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
                        
            if status == MessageConstant.k_StatusCode{
                if let arrData  = response["result"] as? [[String:Any]]{
                    self.arrFavList.removeAll()
                    for dictdata in arrData{
                        let obj = FavoriteListModel.init(dict: dictdata)
                        self.arrFavList.append(obj)
                    }
                    self.tblVw.reloadData()
                }
            }else{
                objWebServiceManager.hideIndicator()
                
                if (response["result"]as? String) != nil{
                    self.arrFavList.removeAll()
                    self.tblVw.reloadData()
                    self.tblVw.displayBackgroundText(text: "No Record Found!")
                }else{
                    objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
                }
            }
        } failure: { (Error) in
            objWebServiceManager.hideIndicator()
        }
    }
    
}
