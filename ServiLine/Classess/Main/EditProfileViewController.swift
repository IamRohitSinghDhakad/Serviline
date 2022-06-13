//
//  EditProfileViewController.swift
//  ServiLine
//
//  Created by Rohit Singh Dhakad on 13/03/22.
//

import UIKit

//MARK:- Protocol
protocol ProfileUpdateProtocol: AnyObject {
    func isUpdatedDelegate(isUpdate:Bool)
}

class EditProfileViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet var tfName: UITextField!
    @IBOutlet var tfEmail: UITextField!
    @IBOutlet var tfPwd: UITextField!
    @IBOutlet var tfWebsite: UITextField!
    @IBOutlet var txtVw: RDTextView!
    @IBOutlet var lblNation: UILabel!
    @IBOutlet var lblCommunity: UILabel!
    @IBOutlet var lblProvision: UILabel!
    @IBOutlet var lblMuncipal: UILabel!
    @IBOutlet var imgVwUser: UIImageView!
    @IBOutlet var lblSector: UILabel!
    @IBOutlet var vwSector: UIView!
    
    var isUpdatedDelegate:ProfileUpdateProtocol?
    
    var objUserDetail:userDetailModel?
    var imagePicker = UIImagePickerController()
    var pickedImage:UIImage?
    
    var strNationID = ""
    var strCommunityID = ""
    var strProvinceID = ""
    var strMunicipalID = ""
    var strSectorID = ""
    var strType = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.vwSector.isHidden = true
        self.imagePicker.delegate = self
        self.tfPwd.isSecureTextEntry = true
        self.setUserData()
        // Do any additional setup after loading the view.
    }
    
    
    func setUserData(){
        guard let userData = self.objUserDetail else {return}
        
        let profilePic = userData.strProfilePicture
        if profilePic != "" {
            let url = URL(string: profilePic)
            self.imgVwUser.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo"))
        }
        
        self.strType = userData.strUserType
        
        if self.strType == "Provider" || self.strType == "provider"{
            self.vwSector.isHidden = false
        }else{
            self.vwSector.isHidden = true
        }
        
        self.tfName.text = userData.strUserName
        self.tfPwd.text = userData.strPassword
        self.tfEmail.text = userData.strEmail
        self.tfWebsite.text = userData.strWebsite
        self.lblNation.text = userData.strNation
        self.lblCommunity.text = userData.strCommunity
        self.lblProvision.text = userData.strProvince
        self.lblMuncipal.text = userData.strMunicipality
        self.lblSector.text = userData.strSectorName
        self.txtVw.text = userData.strAboutMe
        
        self.strNationID = userData.strNationID
        self.strCommunityID = userData.strCommunityID
        self.strProvinceID = userData.strProvienceID
        self.strMunicipalID = userData.strMunicipalityId
        self.strSectorID = userData.strSectorID
    }
    
    @IBAction func btnOnUpdate(_ sender: Any) {
        self.validateForCompleteProfile()
    }
    
    @IBAction func btnOnBackHeader(_ sender: Any) {
        onBackPressed()
    }
    
    @IBAction func btnOnOpenCamera(_ sender: Any) {
        self.setImage()
    }
    
    @IBAction func btnOnShowPwd(_ sender: Any) {
        self.tfPwd.isSecureTextEntry = self.tfPwd.isSecureTextEntry == true ? false : true
    }
    
    @IBAction func btnOnAction(_ sender: UIButton) {
        
        switch sender.tag {
        case 0:
            self.openSelectionScreen(strIsComingFrom: "2", strTitle: "País")
            print("Nation is ")
        case 1:
            if self.strNationID == ""{
                objAlert.showAlert(message: "Selecciona País!!!", title: "Alert", controller: self)
            }else{
                self.openSelectionScreen(strIsComingFrom: "3", strTitle: "Comunidad")
            }
            print("Community is ")
        case 2:
            if self.strCommunityID == ""{
                objAlert.showAlert(message: "Selecciona Comunidad!!!", title: "Alert", controller: self)
            }else{
                self.openSelectionScreen(strIsComingFrom: "4", strTitle: "Provincia")
            }
            print("Province is ")
        case 3:
            
            if self.strProvinceID == ""{
                objAlert.showAlert(message: "Selecciona Provincia!!!", title: "Alert", controller: self)
            }else{
                self.openSelectionScreen(strIsComingFrom: "5", strTitle: "Municipio/Ciudad")
            }
            print("Muncipal City is ")
        case 4:
            if self.strProvinceID == ""{
                objAlert.showAlert(message: "Selecciona Municipio!!!", title: "Alert", controller: self)
            }else{
                self.openSelectionScreen(strIsComingFrom: "6", strTitle: "Sector")
            }
           
        default:
            break
        }
    }
    
    func openSelectionScreen(strIsComingFrom:String, strTitle:String){
        let vc = UIStoryboard.init(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "PopUpViewController")as! PopUpViewController
         vc.isComingFrom = strIsComingFrom
        if strIsComingFrom == "6"{
            vc.isMultiple = "Yes"
        }
         vc.strTitle = strTitle
            vc.strNationID = self.strNationID
            vc.strCommunityID = self.strCommunityID
            vc.strProvinceID = self.strProvinceID
            vc.strMunicipalID = self.strMunicipalID
            
            print(self.strNationID,self.strCommunityID,self.strProvinceID,self.strMunicipalID)
            
            
            vc.closerForSelectionTable = { dict
                in
                print(dict)
                if dict.count != 0{
                    if let nationID = dict["nation_id"]as? String{
                        self.strNationID = nationID
                        self.lblNation.text = dict["nation"]as? String
                        
                        self.strCommunityID = ""
                        self.strProvinceID = ""
                        self.strMunicipalID = ""
                        self.lblCommunity.text = "Comunidad"
                        self.lblProvision.text = "Provincia"
                        self.lblMuncipal.text = "Municipio/Ciudad"
                    }
                    
                    if let communityID = dict["Community_id"]as? String{
                        self.strCommunityID = communityID
                        self.lblCommunity.text = dict["Community"]as? String
                        self.strProvinceID = ""
                        self.strMunicipalID = ""
                        self.lblProvision.text = "Provincia"
                        self.lblMuncipal.text = "Municipio/Ciudad"
                    }
                    
                    if let Province = dict["Province_id"]as? String{
                        self.strProvinceID = Province
                        self.lblProvision.text = dict["Province"]as? String
                        self.strMunicipalID = ""
                        self.lblMuncipal.text = "Municipio/Ciudad"
                    }
                    
                    if let MunicipalID = dict["Municipal_id"]as? String{
                        self.strMunicipalID = MunicipalID
                        self.lblMuncipal.text = dict["Municipal"]as? String
                    }
                    
                    if let SectorID = dict["Sector_id"]as? String{
                        self.strSectorID = SectorID
                        self.lblSector.text = dict["Sector"]as? String
                }
            }
     }
        if #available(iOS 13.0, *) {
            self.isModalInPresentation = true // available in IOS13
        }
        self.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true,completion: nil)
  }
    
    //MARK:- All Validations
    func validateForCompleteProfile(){
        self.tfName.text = self.tfName.text!.trim()
        self.tfEmail.text = self.tfEmail.text!.trim()
        self.tfPwd.text = self.tfPwd.text!.trim()
        self.tfWebsite.text = self.tfWebsite.text!.trim()
    
        if (tfName.text?.isEmpty)! {
            objAlert.showAlert(message: "Entrar nombre", title:MessageConstant.k_AlertTitle, controller: self)
        }else if (tfEmail.text?.isEmpty)! {
            objAlert.showAlert(message: "Escribir email", title:MessageConstant.k_AlertTitle, controller: self)
        }else if !objValidationManager.validateEmail(with: tfEmail.text!){
            objAlert.showAlert(message: "Introducir correo electrónico valido", title:MessageConstant.k_AlertTitle, controller: self)
        }else if (tfPwd.text?.isEmpty)! {
            objAlert.showAlert(message: "Contraseña", title:MessageConstant.k_AlertTitle, controller: self)
        }else if (lblNation.text! == "País") {
            objAlert.showAlert(message: "Selecciona País!!!", title:MessageConstant.k_AlertTitle, controller: self)
        }
        else if (lblCommunity.text! == "Comunidad") || self.lblCommunity.text == ""{
            objAlert.showAlert(message: "Selecciona Comunidad!!!", title:MessageConstant.k_AlertTitle, controller: self)
        }else if (lblProvision.text! == "Provincia") || self.lblProvision.text == ""{
            objAlert.showAlert(message: "Selecciona Provincia!!!", title:MessageConstant.k_AlertTitle, controller: self)
        }else if (lblMuncipal.text! == "Municipio/Ciudad") || self.lblMuncipal.text == ""{
            objAlert.showAlert(message: "Selecciona Municipio!!!", title:MessageConstant.k_AlertTitle, controller: self)
        }
        else if self.strType == "Provider" || self.strType == "provider"{
            if (lblSector.text! == "Sector") {
                objAlert.showAlert(message: "Selección Sector Profesional", title:MessageConstant.k_AlertTitle, controller: self)
            }else{
                self.callWebserviceForCompleteProfile()
            }
        }else{
                self.callWebserviceForCompleteProfile()
        }
    }
}

//MARK:- Add Images
// MARK:- UIImage Picker Delegate
extension EditProfileViewController: UIImagePickerControllerDelegate{
    
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
            self.imgVwUser.image = self.pickedImage
            //  self.cornerImage(image: self.imgUpload,color:#colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1) ,width: 0.5 )
            
           // self.call_UploadImage()
            
            imagePicker.dismiss(animated: true, completion: nil)
        } else if let originalImage = info[.originalImage] as? UIImage {
            self.pickedImage = originalImage
            self.imgVwUser.image = pickedImage
          
           // self.call_UploadImage()
            
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

//Call Webserice
extension EditProfileViewController{
    

    func callWebserviceForCompleteProfile(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        objWebServiceManager.showIndicator()
        self.view.endEditing(true)
        
        var imageData = [Data]()
        var imgData : Data?
        if self.pickedImage != nil{
            imgData = (self.pickedImage?.jpegData(compressionQuality: 1.0))!
        }
        else {
            imgData = (self.imgVwUser.image?.jpegData(compressionQuality: 1.0))!
        }
        imageData.append(imgData!)
        
        let imageParam = ["user_image"]
        
        
        
        let dicrParam = [
            "user_id":objAppShareData.UserDetail.strUserId,
            "type":self.strType,
            "name":self.tfName.text!,
            "email":self.tfEmail.text!,
            "password":self.tfPwd.text!,
            "nation_id":self.strNationID,
            "community_id":self.strCommunityID,
            "province_id":self.strProvinceID,
            "municipality_id":self.strMunicipalID,
            "sector_id":self.strSectorID,
            "website":self.tfWebsite.text!,
            "bio":self.txtVw.text!,
            "ios_register_id":objAppShareData.strFirebaseToken]as [String:Any]
        
       print(dicrParam)
        
        objWebServiceManager.uploadMultipartWithImagesData(strURL: WsUrl.url_completeProfile, params: dicrParam, showIndicator: true, customValidation: "", imageData: imgData, imageToUpload: imageData, imagesParam: imageParam, fileName: "user_image", mimeType: "image/jpeg") { (response) in
            objWebServiceManager.hideIndicator()
            print(response)
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            if status == MessageConstant.k_StatusCode{
            
                if let user_details  = response["result"] as? [String:Any]{
                    
                    objAppShareData.SaveUpdateUserInfoFromAppshareData(userDetail: user_details)
                    objAppShareData.fetchUserInfoFromAppshareData()
                    
                    objAlert.showAlertSingleButtonCallBack(alertBtn: "OK", title: "Éxito", message: "actualización de perfil con éxito", controller: self) {
                        self.isUpdatedDelegate?.isUpdatedDelegate(isUpdate: true)
                        self.onBackPressed()
                    }
                }


            }else{
                objWebServiceManager.hideIndicator()
                objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
            }
        } failure: { (Error) in
            print(Error)
        }
    }
    
    
}
