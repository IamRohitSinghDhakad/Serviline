//
//  ProfileViewController.swift
//  ServiLine
//
//  Created by Rohit Singh Dhakad on 11/03/22.
//

import UIKit
import SDWebImage

class ProfileViewController: UIViewController {
    
    
    @IBOutlet var vwContainButtons: UIView!
    @IBOutlet var imgVwUser: UIImageView!
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var lblTags: UILabel!
    @IBOutlet var cvImages: UICollectionView!
    @IBOutlet var lblHyperLink: UILabel!
    @IBOutlet var lblDescription: UILabel!
    @IBOutlet var cvHgtConstant: NSLayoutConstraint!
    
    //Variables
    var arrayPhotoCollection: [UserImageModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.vwContainButtons.isHidden = true
        self.cvImages.delegate = self
        self.cvImages.dataSource = self
        
            // self.arrImages = [UIImage.init(named: "bg"), UIImage.init(named: "bg")]
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let strUserID = objAppShareData.UserDetail.strUserId
        self.call_GetProfile(strUserID: strUserID)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let height = cvImages.collectionViewLayout.collectionViewContentSize.height
        self.cvHgtConstant.constant = height
        self.view.layoutIfNeeded()
    }
    
    @IBAction func btnOnOpenSideMenu(_ sender: Any) {
        self.sideMenuController?.revealMenu()
    }
    

    
    @IBAction func btnOnUpdateProfile(_ sender: Any) {
        self.pushVc(viewConterlerId: "EditProfileViewController")
    }
    
    @IBAction func btnOnAddImages(_ sender: Any) {
        
    }
    
}


extension ProfileViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let height = self.arrayPhotoCollection.count * 128
        self.cvHgtConstant.constant = CGFloat(height)
        return self.arrayPhotoCollection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ViewProfileCollectionViewCell", for: indexPath)as! ViewProfileCollectionViewCell
        
        
        let obj = self.arrayPhotoCollection[indexPath.row]
        let profilePic = obj.strFile
        if profilePic != "" {
            let url = URL(string: profilePic)
            print(url)
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


extension ProfileViewController{
    
    
    func call_GetProfile(strUserID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let parameter = ["user_id":strUserID,
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
                    
                    
                    self.lblHyperLink.text = obj.strWebsite
                    print(obj.strNation + "," + obj.strProvince + "," + obj.strMunicipality + "," + obj.strCommunity)
                    self.lblTags.text = obj.strNation + "," + obj.strProvince + "," + obj.strMunicipality + "," + obj.strCommunity
                    self.lblDescription.text = obj.strAboutMe
                    
                    
                    self.call_GetUserImage(strUserID: strUserID)
                    
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
