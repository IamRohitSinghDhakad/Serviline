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
    @IBOutlet var vwRating: FloatRatingView!
    @IBOutlet var lblRating: UILabel!
    @IBOutlet var imgVwFavorite: UIImageView!
    @IBOutlet var imgVwRating: UIImageView!
    @IBOutlet var imgVwBlock: UIImageView!
    @IBOutlet var imgVwReport: UIImageView!
    @IBOutlet var btnYesPopUp: UIButton!
    @IBOutlet var vwBlockUser: UIView!
    @IBOutlet var btnUnblock: UIButton!
    @IBOutlet var btnMessage: UIButton!
    
    @IBOutlet var cvHgtConstant: NSLayoutConstraint!
    @IBOutlet var cvImages: UICollectionView!
    
    //Variables
    var arrayPhotoCollection: [UserImageModel] = []
    var objUserDetail:userDetailModel?
    var strUserID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.vwBlockUser.isHidden = true
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
            let ratingCount:Int = Int(self.objUserDetail!.isRating) ?? 0
            if ratingCount >= 3{
                objAlert.showAlert(message: "Límite de valoración.", title: "", controller: self)
            }else{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "RatingViewController")as! RatingViewController
                vc.obj = self.objUserDetail
                self.navigationController?.pushViewController(vc, animated: true)
            }
           
        case 1:
            self.btnYesPopUp.tag = 1
            if self.objUserDetail?.isFavorite == "1"{
                self.lblMessage.text = "Deseas eliminar \(self.objUserDetail?.strUserName ?? "") de favorito?"
            }else{
                self.lblMessage.text = "Quieres añadir \(self.objUserDetail?.strUserName ?? "") a favoritos?"
            }
            self.vwPopUp.isHidden = false
        case 2:
            self.call_BlockUnblockUser(strUserID: objAppShareData.UserDetail.strUserId, strToUserID: self.strUserID)
        default:
            self.btnYesPopUp.tag = 3
            
            if self.objUserDetail?.isReport == "1"{
                self.lblMessage.text = "¿Estás seguro de que quieres eliminar? \(self.objUserDetail?.strUserName ?? "") del informe"
            }else{
                self.lblMessage.text = "Quieres hacer una denuncia \(self.objUserDetail?.strUserName ?? "")?"
            }
            self.vwPopUp.isHidden = false
          
        }
    }
    @IBAction func btnOnUnblockUser(_ sender: Any) {
        self.call_BlockUnblockUser(strUserID: objAppShareData.UserDetail.strUserId, strToUserID: self.strUserID)
    }
    
    
    @IBAction func btnOnMessage(_ sender: Any) {
        self.pushVc(viewConterlerId: "ChatDetailViewController")
    }
    
    
    @IBAction func btnOnCancelPopUp(_ sender: Any) {
        self.vwPopUp.isHidden = true
    }
    
   
    @IBAction func btnOpenWebsite(_ sender: Any) {
        
        if self.lblWebsite.text != ""{
            
            if self.lblWebsite.text!.contains("https://"){
                
            }else{
                var makeUrl = self.lblWebsite.text!.lowercased()
                makeUrl = makeUrl.trim()
                makeUrl = makeUrl.replacingOccurrences(of: "www.", with: "https://")
                print(makeUrl)
                let url = URL(string: makeUrl)
                if UIApplication.shared.canOpenURL(url!) {
                    UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                }else{
                    objAlert.showAlert(message: "URL no válida", title: "Alert", controller: self)
                }
            }
            
        }else{
            
        }
       
        
    }
    
    @IBAction func btnYesPopUp(_ sender: UIButton) {
        
        switch sender.tag {
        case 1:
             self.call_AddRemoveFromFavoriteList(strUserID: objAppShareData.UserDetail.strUserId, strToUserID: self.strUserID)
        case 3:
            if self.objUserDetail?.isReport == "1"{
                self.call_ReportUaser(strUserID: objAppShareData.UserDetail.strUserId, strToUserID: self.objUserDetail?.strUserId ?? "")
            }else{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ReportUserViewController")as! ReportUserViewController
                vc.objUserDetail = self.objUserDetail
                self.navigationController?.pushViewController(vc, animated: true)
            }
           
        default:
            break
        }
        self.vwPopUp.isHidden = true
    }
    
}

extension OtherUserProfileViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ShowImageFullViewController")as! ShowImageFullViewController
        vc.strImageUrl = self.arrayPhotoCollection[indexPath.row].strFile
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let noOfCellsInRow = 3

        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout

        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
        print(size)
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
        
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_getUserProfile, queryParams: [:], params: parameter, strCustomValidation: "", showIndicator: false) { response in

            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            print(response)
            
            if status == MessageConstant.k_StatusCode{
                
                if let user_details  = response["result"] as? [String:Any] {
                       
                    
                    let obj = userDetailModel.init(dict: user_details)
                    self.objUserDetail = obj
                    
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

                    self.lblRating.text = "(\(obj.strUserRating))"
                    self.vwRating.rating = obj.strUserRating
                    self.lblWebsite.text = obj.strWebsite
                    print(obj.strNation + "," + obj.strProvince + "," + obj.strMunicipality + "," + obj.strCommunity)
                    self.lblTags.text = obj.strNation + "," + obj.strProvince + "," + obj.strMunicipality + "," + obj.strCommunity
                    self.lblDescription.text = obj.strAboutMe
                    
                    if obj.isFavorite == "1"{
                        self.imgVwFavorite.image = UIImage.init(named: "favorite_black")
                        self.imgVwFavorite.setImageColor(color: UIColor.init(named: "Pink") ?? UIColor.gray)
                       
                    }else{
                        self.imgVwFavorite.image = UIImage.init(named: "favorite_black")
                        self.imgVwFavorite.setImageColor(color: UIColor.darkGray)
                        
                    }
                    
                    if obj.isRating != "0"{
                        self.imgVwRating.image = UIImage.init(named: "rating")
                        self.imgVwRating.setImageColor(color: UIColor.init(named: "Pink") ?? UIColor.gray)
                    }else{
                        self.imgVwRating.image = UIImage.init(named: "rating")
                        self.imgVwRating.setImageColor(color: UIColor.gray)
                    }
                    
                    if obj.isBlock == "1"{
                        self.vwBlockUser.isHidden = false
                        self.btnMessage.isHidden = true
                    }else{
                        self.vwBlockUser.isHidden = true
                        self.btnMessage.isHidden = false
                    }
                    
                    if obj.isReport == "1"{
                        self.imgVwReport.image = UIImage.init(named: "report_alert")
                        self.imgVwReport.setImageColor(color: UIColor.init(named: "Pink") ?? UIColor.gray)
                    }else{
                        self.imgVwReport.image = UIImage.init(named: "report_alert")
                        self.imgVwReport.setImageColor(color: UIColor.gray)
                    }
                    
                    
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
        
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_GetUserImage, queryParams: [:], params: parameter, strCustomValidation: "", showIndicator: false) { response in
            
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
                    let height = self.cvImages.collectionViewLayout.collectionViewContentSize.height
                    self.cvHgtConstant.constant = CGFloat(height)
                    self.view.setNeedsLayout()
                    //  self.view.layoutIfNeeded()
                }
                
            }else{
                objWebServiceManager.hideIndicator()
               // objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
                
            }
            
            
        } failure: { (Error) in
            objWebServiceManager.hideIndicator()
        }
    }
    
    
    
    //MARK:-Add Remove On Fav List
    func call_AddRemoveFromFavoriteList(strUserID:String, strToUserID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let parameter = ["user_id":strUserID,
                         "to_user_id":strToUserID]as [String:Any]
        print(parameter)
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_SaveInFavorite, queryParams: [:], params: parameter, strCustomValidation: "", showIndicator: false) { response in
            
            print(response)
            
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
                        
            if status == MessageConstant.k_StatusCode{
                if let dictData  = response["result"] as? [String:Any]{
                    if message == "success"{
                       // self.imgVwFavorite.image = UIImage.init(named: "favorite_black")
                        self.imgVwFavorite.setImageColor(color: UIColor.init(named: "Pink") ?? UIColor.gray)
                        self.objUserDetail?.isFavorite = "1"
                    }
                }
            }else{
                if response["result"]as? String == "Any favorites not found"{
                   // self.imgVwFavorite.image = UIImage.init(named: "favorite_black")
                    self.imgVwFavorite.setImageColor(color: UIColor.gray)
                    self.objUserDetail?.isFavorite = "0"
                }
                objWebServiceManager.hideIndicator()
            
            }
        } failure: { (Error) in
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
                        self.btnMessage.isHidden = true
                        self.vwBlockUser.isHidden = false
                        
                    }
                }
            }else{
                if response["result"]as? String == "Any blocked users not found"{
                    self.btnMessage.isHidden = false
                    self.vwBlockUser.isHidden = true
                }
                objWebServiceManager.hideIndicator()
            
            }
        } failure: { (Error) in
            objWebServiceManager.hideIndicator()
        }
    }
    
    
    //MARK:- Report a User
    
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
                    self.objUserDetail?.isReport = "0"
                }
                objWebServiceManager.hideIndicator()
            
            }
        } failure: { (Error) in
            objWebServiceManager.hideIndicator()
        }
    }
}


extension String {
    func isValidUrl() -> Bool {
        let regex = "((http|https|ftp)://)?((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
}

extension String {

    /// Return first available URL in the string else nil
    func checkForURL() -> NSRange? {
        guard let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) else {
            return nil
        }
        let matches = detector.matches(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count))

        for match in matches {
            guard Range(match.range, in: self) != nil else { continue }
            return match.range
        }
        return nil
    }

    func getURLIfPresent() -> String? {
        guard let range = self.checkForURL() else{
            return nil
        }
        guard let stringRange = Range(range,in:self) else {
            return nil
        }
        return String(self[stringRange])
    }
}
