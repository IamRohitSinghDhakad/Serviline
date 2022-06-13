//
//  ProfileViewController.swift
//  ServiLine
//
//  Created by Rohit Singh Dhakad on 11/03/22.
//

import UIKit
import SDWebImage

enum AssetType: String {
    case image = "image"
    case video = "video"
}

class ProfileViewController: UIViewController, UINavigationControllerDelegate,ProfileUpdateProtocol {
  
    
    
    @IBOutlet var vwContainButtons: UIView!
    @IBOutlet var imgVwUser: UIImageView!
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var lblTags: UILabel!
    @IBOutlet var cvImages: UICollectionView!
    @IBOutlet var lblHyperLink: UILabel!
    @IBOutlet var lblDescription: UILabel!
    @IBOutlet var cvHgtConstant: NSLayoutConstraint!
    @IBOutlet var vwRating: FloatRatingView!
    @IBOutlet var lblRatingValue: UILabel!
    
    //Variables
    var arrayPhotoCollection: [UserImageModel] = []
    var imagePicker = UIImagePickerController()
    var pickedImage:UIImage?
    var type: AssetType?
    var isShowingCheckBox:Bool?
    
    var objUserDetail:userDetailModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imagePicker.delegate = self
       
        self.cvImages.delegate = self
        self.cvImages.dataSource = self
        let strUserID = objAppShareData.UserDetail.strUserId
        self.call_GetProfile(strUserID: strUserID)
            // self.arrImages = [UIImage.init(named: "bg"), UIImage.init(named: "bg")]
        // Do any additional setup after loading the view.
    }
    
    func isUpdatedDelegate(isUpdate: Bool) {
        if isUpdate == true{
            let strUserID = objAppShareData.UserDetail.strUserId
            self.call_GetProfile(strUserID: strUserID)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.vwContainButtons.isHidden = true
        
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
    
    
    @IBAction func btnOnCancel(_ sender: Any) {
        self.isShowingCheckBox = false
        self.vwContainButtons.isHidden = true
        self.cvImages.reloadData()
    }
    
    @IBAction func btnOnDelete(_ sender: Any) {
        var arrID = [String]()
        let arr = self.arrayPhotoCollection.filter{$0.isSelected == true}
        for data in arr{
            arrID.append(data.strUserImageId)
        }
        
        if arrID.count == 0{
            
        }else{
            let finalString = arrID.joined(separator: ",")
            print(finalString)
            self.call_DeleteUserImage(id: finalString)
        }
       
    }
    
    
    @IBAction func btnOnUpdateProfile(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileViewController")as! EditProfileViewController
        vc.objUserDetail = self.objUserDetail
        vc.isUpdatedDelegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnOnAddImages(_ sender: Any) {
        self.setImage()
    }
    @IBAction func btnOpenWebsite(_ sender: Any) {
        if self.lblHyperLink.text != ""{
            
            if self.lblHyperLink.text!.contains("https://"){
                
            }else{
                var makeUrl = self.lblHyperLink.text!.lowercased()
                makeUrl = makeUrl.trim()
                makeUrl = makeUrl.replacingOccurrences(of: "www.", with: "https://")
                print(makeUrl)
                let url = URL(string: makeUrl)
                if UIApplication.shared.canOpenURL(url!) {
                    UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                }else{
                    objAlert.showAlert(message: "URL no válida", title: "", controller: self)
                }
            }
            
        }else{
            
        }
//        guard let url = URL(string: self.lblHyperLink.text!) else {
//            return
//         }
//        if UIApplication.shared.canOpenURL(url) {
//             UIApplication.shared.open(url, options: [:], completionHandler: nil)
//        }else{
//            objAlert.showAlert(message: "Url not valid please check!", title: "Alert", controller: self)
//        }
    }
    
}

//MARK:- Add Images
// MARK:- UIImage Picker Delegate
extension ProfileViewController: UIImagePickerControllerDelegate{
    
    func setImage(){
        imagePicker.allowsEditing = true
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.openCamera()
        }
        
        let galleryAction = UIAlertAction(title: "Gallery", style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.openGallery()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
        {
            UIAlertAction in
        }
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
        alert.popoverPresentationController?.sourceView = self.view
        self.present(alert, animated: true, completion: nil)
    }
    
    // Open camera
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.modalPresentationStyle = .fullScreen
            self .present(imagePicker, animated: true, completion: nil)
        } else {
            self.openGallery()
        }
    }
    
    // Open gallery
    func openGallery()
    {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.modalPresentationStyle = .fullScreen
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            self.pickedImage = editedImage
          //  self.imgVwUser.image = self.pickedImage
            //  self.cornerImage(image: self.imgUpload,color:#colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1) ,width: 0.5 )
            
            self.call_UploadImage()
            
            imagePicker.dismiss(animated: true, completion: nil)
        } else if let originalImage = info[.originalImage] as? UIImage {
            self.pickedImage = originalImage
          //  self.imgVwUser.image = pickedImage
          
            self.call_UploadImage()
            
            imagePicker.dismiss(animated: true, completion: nil)
        }
    }
    
    func cornerImage(image: UIImageView, color: UIColor ,width: CGFloat){
        image.layer.cornerRadius = image.layer.frame.size.height / 2
        image.layer.masksToBounds = false
        image.layer.borderColor = color.cgColor
        image.layer.borderWidth = width
        
    }
    
    func makeRounded() {
        
        self.imgVwUser.layer.borderWidth = 0
        self.imgVwUser.layer.masksToBounds = false
        //self.imgUpload.layer.borderColor = UIColor.blackColor().CGColor
        self.imgVwUser.layer.cornerRadius = self.imgVwUser.frame.height/2 //This will change with corners of image and height/2 will make this circle shape
        self.imgVwUser.clipsToBounds = true
    }
    
}


extension ProfileViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      //  let height = self.arrayPhotoCollection.count * 128
//
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
        
        if self.isShowingCheckBox == true{
            cell.imgVwTick.isHidden = false
            if obj.isSelected == true{
                cell.imgVwTick.image = UIImage.init(named: "select")
            }else{
                cell.imgVwTick.image = UIImage.init(named: "unchecked")
            }
        }else{
            obj.isSelected = false
            cell.imgVwTick.isHidden = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if self.vwContainButtons.isHidden == true{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ShowImageFullViewController")as! ShowImageFullViewController
            vc.strImageUrl = self.arrayPhotoCollection[indexPath.row].strFile
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let obj = self.arrayPhotoCollection[indexPath.row]
            obj.isSelected = obj.isSelected == true ? false : true
            self.cvImages.reloadData()
        }
        
//        if obj.isSelected == true{
//
//        }else{
//
//        }
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
        
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_getUserProfile, queryParams: [:], params: parameter, strCustomValidation: "", showIndicator: true) { response in
            
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
                    
                    self.lblRatingValue.text = "(\(obj.strUserRating))"
                    self.vwRating.rating = obj.strUserRating
                    self.lblHyperLink.text = obj.strWebsite
                    print(obj.strNation + "," + obj.strProvince + "," + obj.strMunicipality + "," + obj.strCommunity)
                    self.lblTags.text = obj.strNation + "," + obj.strProvince + "," + obj.strMunicipality + "," + obj.strCommunity
                    self.lblDescription.text = obj.strAboutMe
                    
                    print(strUserID)
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
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_GetUserImage, queryParams: [:], params: parameter, strCustomValidation: "", showIndicator: false) { response in
        
      //  objWebServiceManager.requestGet(strURL: WsUrl.url_GetUserImage, params: parameter, queryParams: [:], strCustomValidation: "") { (response) in
            
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
                    self.setupLongGestureRecognizerOnCollection()
                    let height = self.cvImages.collectionViewLayout.collectionViewContentSize.height
                    self.cvHgtConstant.constant = CGFloat(height)
                    self.view.setNeedsLayout()
                }
                
            }else{
                objWebServiceManager.hideIndicator()
               // objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
                
            }
            
            
        } failure: { (Error) in
            objWebServiceManager.hideIndicator()
        }
    }
    
    
    
    
    func call_UploadImage() {
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        
        var imageData = [Data]()
        var imgData : Data?
        if self.pickedImage != nil{
           // imgData = (self.pickedImage?.jpegData(compressionQuality: 1.0))!
            imgData = (self.pickedImage?.pngData())// jpegData(compressionQuality: 1.0))!
        }
        else {
            imgData = (self.imgVwUser.image?.pngData()) //jpegData(compressionQuality: 1.0))!
        }
        imageData.append(imgData!)
        
        let imageParam = ["file"]
        
        print(imageData)
        
        let dictParam = ["user_id":objAppShareData.UserDetail.strUserId
        ]as [String:Any]
        
        print(dictParam)
            
//        objWebServiceManager.uploadMultipartWithImagesData(strURL: WsUrl.url_AddUserImage, params: dicrParam, showIndicator: false, customValidation: "", imageData: nil, imageToUpload: imageData, imagesParam: imageParam, fileName: "user_image", mimeType: (self.type! == .video) ? "video/mp4" : "image/jpeg") { (response) in
        objWebServiceManager.uploadMultipartWithImagesData(strURL: WsUrl.url_AddUserImage, params: dictParam, showIndicator: true, customValidation: "", imageData: imgData, imageToUpload: imageData, imagesParam: imageParam, fileName: "file", mimeType: "image/png") { (response) in
                objWebServiceManager.hideIndicator()
                let status = (response["status"] as? Int)
                let message = (response["message"] as? String)
                if status == MessageConstant.k_StatusCode {
                    print(response)
                    self.call_GetUserImage(strUserID: objAppShareData.UserDetail.strUserId)
                   
        
                    
                }else{
                    objWebServiceManager.hideIndicator()
                    objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
                    
                }
                
            } failure: { (Error) in
                print(Error)
                objWebServiceManager.hideIndicator()
            }

        }
    
    
    func call_DeleteUserImage(id: String) {
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let parameter = ["user_image_id" : id] as [String:Any]
        print(parameter)
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_DeleteUserImage, params: parameter, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            print(response)
            
            if status == MessageConstant.k_StatusCode{
                
                self.call_GetUserImage(strUserID: objAppShareData.UserDetail.strUserId)
                self.vwContainButtons.isHidden = true
                
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


extension ProfileViewController: UIGestureRecognizerDelegate{
    private func setupLongGestureRecognizerOnCollection() {
        let longPressedGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
        longPressedGesture.minimumPressDuration = 0.5
        longPressedGesture.delegate = self
        longPressedGesture.delaysTouchesBegan = true
        self.cvImages?.addGestureRecognizer(longPressedGesture)
    }
    
    @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        if (gestureRecognizer.state != .began) {
            return
        }

        let p = gestureRecognizer.location(in: self.cvImages)
        
      //  let p = gestureRecognizer.location(in: collectionView)

        if let indexPath = self.cvImages?.indexPathForItem(at: p) {
            print("Long press at item: \(indexPath.row)")
            let obj = self.arrayPhotoCollection[indexPath.row]
            obj.isSelected = true
            self.isShowingCheckBox = true
            self.vwContainButtons.isHidden = false
            self.cvImages.reloadData()
        }
    }
}
