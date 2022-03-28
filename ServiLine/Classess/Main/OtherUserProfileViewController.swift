//
//  OtherUserProfileViewController.swift
//  ServiLine
//
//  Created by Rohit Singh Dhakad on 12/03/22.
//

import UIKit

class OtherUserProfileViewController: UIViewController {

    @IBOutlet var vwPopUp: UIView!
    @IBOutlet var lblPopUpHeading: UILabel!
    @IBOutlet var lblMessage: UILabel!
    @IBOutlet var imgVwUser: UIImageView!
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var lblTags: UILabel!
    @IBOutlet var lblWebsite: UILabel!
    @IBOutlet var lblDescription: UILabel!
    
    @IBOutlet var cvHgtConstant: NSLayoutConstraint!
    @IBOutlet var cvImages: UICollectionView!
    
    //Variables
    var arrayPhotoCollection: [UserImageModel] = []
    var strUserID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.vwPopUp.isHidden = true
        self.cvImages.delegate = self
        self.cvImages.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.call_GetProfile(strUserID: objAppShareData.UserDetail.strUserId, strOtherUserID: self.strUserID)
    }
    
    
    @IBAction func btnOnBackHeader(_ sender: Any) {
        onBackPressed()
    }
    
    @IBAction func btnAction(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            pushVc(viewConterlerId: "RatingViewController")
        case 1:
            self.vwPopUp.isHidden = false
        case 2:
            self.vwPopUp.isHidden = false
        default:
            self.pushVc(viewConterlerId: "ReportUserViewController")
        }
    }
    
    
    @IBAction func btnOnMessage(_ sender: Any) {
        self.pushVc(viewConterlerId: "ChatDetailViewController")
    }
    
    
    @IBAction func btnOnCancelPopUp(_ sender: Any) {
        self.vwPopUp.isHidden = true
    }
    
   
    @IBAction func btnYesPopUp(_ sender: Any) {
        self.vwPopUp.isHidden = true
    }
    
}

extension OtherUserProfileViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let height = CGFloat((self.arrayPhotoCollection.count) * 50)
        self.cvHgtConstant.constant = CGFloat(height)
        return self.arrayPhotoCollection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ViewProfileCollectionViewCell", for: indexPath)as! ViewProfileCollectionViewCell
        
        
        let obj = self.arrayPhotoCollection[indexPath.row]
        let profilePic = obj.strFile
        if profilePic != "" {
            let url = URL(string: profilePic)
            cell.imgVw.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo"))
        }
        
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let noOfCellsInRow = 3

        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout

        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))

        return CGSize(width: size, height: size)
    }
}


extension OtherUserProfileViewController{
    
    
    func call_GetProfile(strUserID:String,strOtherUserID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let parameter = ["user_id":strOtherUserID,
                         "login_user_id":strUserID]as [String:Any]
        
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_getUserProfile, params: parameter, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            print(response)
            
            if status == MessageConstant.k_StatusCode{
                
                if let user_details  = response["result"] as? [String:Any] {
                       
                    
                    let obj = userDetailModel.init(dict: user_details)
                    
                    let profilePic = obj.strProfilePicture
                    if profilePic != "" {
                        let url = URL(string: profilePic)
                        self.imgVwUser.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo"))
                    }


                    let type = obj.strUserType

                    if type == "provider"{
                        self.lblUserName.text = obj.strUserName + " (Professional)"
                    }else{
                        self.lblUserName.text = obj.strUserName
                    }


                    self.lblWebsite.text = obj.strWebsite
                    print(obj.strNation + "," + obj.strProvince + "," + obj.strMunicipality + "," + obj.strCommunity)
                    self.lblTags.text = obj.strNation + "," + obj.strProvince + "," + obj.strMunicipality + "," + obj.strCommunity
                    self.lblDescription.text = obj.strAboutMe
                    
                    
                    self.call_GetUserImage(strUserID: strOtherUserID)
                    
                      //  objAppShareData.SaveUpdateUserInfoFromAppshareData(userDetail: user_details)
                      //  objAppShareData.fetchUserInfoFromAppshareData()
                    
                }
                
            }else{
                objWebServiceManager.hideIndicator()
                objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
                
            }
            
            
        } failure: { (Error) in
            print(Error)
            objWebServiceManager.hideIndicator()
        }
    }
    
    func call_GetUserImage(strUserID: String) {
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        let parameter = ["user_id" : strUserID] as [String:Any]
        
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_GetUserImage, params: parameter, queryParams: [:], strCustomValidation: "") { (response) in
            
            print(response)
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            
            if status == MessageConstant.k_StatusCode{
                
                if let arrData  = response["result"] as? [[String:Any]] {
                    self.arrayPhotoCollection.removeAll()
                    for dictdata in arrData {
                        let obj = UserImageModel.init(dict: dictdata)
                        self.arrayPhotoCollection.append(obj)
                    }
                   
                    self.cvImages.reloadData()
                }
                
            }else{
                objWebServiceManager.hideIndicator()
               // objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
                
            }
            
            
        } failure: { (Error) in
            objWebServiceManager.hideIndicator()
        }
    }
    
}
