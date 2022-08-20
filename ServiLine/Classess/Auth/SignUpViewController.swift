//
//  SignUpViewController.swift
//  ServiLine
//
//  Created by Rohit Singh Dhakad on 11/03/22.
//

import UIKit

class SignUpViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet var imgVwUser: UIImageView!
    @IBOutlet var lblUserType: UILabel!
    @IBOutlet var tfName: UITextField!
    @IBOutlet var tfEmail: UITextField!
    @IBOutlet var tfConfirmEmail: UITextField!
    @IBOutlet var tfPassword: UITextField!
    @IBOutlet var lblNation: UILabel!
    @IBOutlet var lblCommunity: UILabel!
    @IBOutlet var lblProvince: UILabel!
    @IBOutlet var lblMuncipality: UILabel!
    @IBOutlet var lblServiceSector: UILabel!
    @IBOutlet var vwServiceSector: UIView!
    @IBOutlet var vwVerify: UIView!
    @IBOutlet var lblVerifyDesc: UILabel!
    
    
    //Variables
    var imagePicker = UIImagePickerController()
    var pickedImage:UIImage?
    var strType = ""
    var strNationID = ""
    var strCommunityID = ""
    var strProvinceID = ""
    var strMunicipalID = ""
    var strSectorID = ""
    var otp = ""
    var userID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.vwVerify.isHidden = true
        self.tfPassword.isSecureTextEntry = true
        self.imagePicker.delegate = self
        self.vwServiceSector.isHidden = true
        self.pickedImage = UIImage.init(named: "default_profile")
        self.imgVwUser.image = UIImage.init(named: "default_profile")
    }
    
    @IBAction func btnShowHidePassword(_ sender: Any) {
        if self.tfPassword.isSecureTextEntry == false{
            self.tfPassword.isSecureTextEntry = true
        }else{
            self.tfPassword.isSecureTextEntry = false
        }
    }
    
    @IBAction func btnOpenCamera(_ sender: Any) {
        if self.strType.lowercased() == "provider"{
            self.setImage()
        }else{
            objAlert.showAlert(message: "Solo el proveedor puede seleccionar una imagen", title: "", controller: self)
        }
        
    }
    
    
    @IBAction func btnOnDone(_ sender: Any) {
        self.vwVerify.isHidden = true
        //onBackPressed()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OTPVerifyViewController")as! OTPVerifyViewController
        vc.orignalOTP = self.otp
        vc.strUserID = self.userID
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func openSelectionScreen(strIsComingFrom:String, strTitle:String){
         let vc = self.storyboard?.instantiateViewController(withIdentifier: "PopUpViewController")as! PopUpViewController
         vc.isComingFrom = strIsComingFrom
        if strIsComingFrom == "6"{
            vc.isMultiple = "Yes"
        }
        vc.strTitle = strTitle
        if strIsComingFrom == "1"{
            vc.closerForSelectionButton = { dict
                in
                print(dict)
                if dict.count != 0{
                    if dict["type"] as! String == "Usuario"{
                        self.vwServiceSector.isHidden = true
                        self.strType = "User"
                        self.lblUserType.text = dict["type"] as? String
                        self.pickedImage = UIImage.init(named: "default_profile")
                        self.imgVwUser.image = UIImage.init(named: "default_profile")
                    }else if dict["type"] as! String == "Profesional"{
                        self.vwServiceSector.isHidden = false
                        self.strType = "Provider"
                        self.lblUserType.text = dict["type"] as? String
                    }
                    else{
                        self.lblUserType.text = "Usuario/Profesional"
                    }
                    
                }
            }
        }else{
            vc.strNationID = self.strNationID
            vc.strCommunityID = self.strCommunityID
            vc.strProvinceID = self.strProvinceID
            vc.strMunicipalID = self.strMunicipalID
            
          //  print(self.strNationID,self.strCommunityID,self.strProvinceID,self.strMunicipalID)
            
            
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
                        self.lblProvince.text = "Provincia"
                        self.lblMuncipality.text = "Municipio/Ciudad"
                    }
                    
                    if let communityID = dict["Community_id"]as? String{
                        self.strCommunityID = communityID
                        self.lblCommunity.text = dict["Community"]as? String
                        self.strProvinceID = ""
                        self.strMunicipalID = ""
                        self.lblProvince.text = "Provincia"
                        self.lblMuncipality.text = "Municipio/Ciudad"
                    }
                    
                    if let Province = dict["Province_id"]as? String{
                        self.strProvinceID = Province
                        self.lblProvince.text = dict["Province"]as? String
                        self.strMunicipalID = ""
                        self.lblMuncipality.text = "Municipio/Ciudad"
                    }
                    
                    if let MunicipalID = dict["Municipal_id"]as? String{
                        self.strMunicipalID = MunicipalID
                        self.lblMuncipality.text = dict["Municipal"]as? String
                    }
                    
                    if let SectorID = dict["Sector_id"]as? String{
                        self.strSectorID = SectorID
                        self.lblServiceSector.text = dict["Sector"]as? String                    }
                }
            }
        }
         if #available(iOS 13.0, *) {
             self.isModalInPresentation = true // available in IOS13
         }
         self.modalPresentationStyle = .overCurrentContext
         self.present(vc, animated: true,completion: nil)
     }
     
    @IBAction func btnOnregister(_ sender: Any) {
        self.validateForSignUp()
    }
    
    //MARK:- All Validations
    func validateForSignUp(){
        self.tfName.text = self.tfName.text!.trim()
        self.tfEmail.text = self.tfEmail.text!.trim()
        self.tfConfirmEmail.text = self.tfConfirmEmail.text!.trim()
        self.tfPassword.text = self.tfPassword.text!.trim()
        
        if self.lblUserType.text == "Usuario/Profesional"  {
            objAlert.showAlert(message: "Selecciona tipo de perfil", title:MessageConstant.k_AlertTitle, controller: self)
        }
        else if (tfName.text?.isEmpty)! {
            objAlert.showAlert(message: "Entrar nombre", title:MessageConstant.k_AlertTitle, controller: self)
        }else if (tfEmail.text?.isEmpty)! {
            objAlert.showAlert(message: "Escribir email", title:MessageConstant.k_AlertTitle, controller: self)
        }else if !objValidationManager.validateEmail(with: tfEmail.text!){
            objAlert.showAlert(message: "Introducir correo electrónico valido", title:MessageConstant.k_AlertTitle, controller: self)
        }else if (tfConfirmEmail.text?.isEmpty)! {
            objAlert.showAlert(message: "Por favor escribe confirm email.", title:MessageConstant.k_AlertTitle, controller: self)
        }else if tfConfirmEmail.text! != self.tfEmail.text! {
            objAlert.showAlert(message: "Email no coincide", title:MessageConstant.k_AlertTitle, controller: self)
        }else if (tfPassword.text?.isEmpty)! {
            objAlert.showAlert(message: "Contraseña", title:MessageConstant.k_AlertTitle, controller: self)
        }else if (lblNation.text! == "País") {
            objAlert.showAlert(message: "Selecciona País!!!", title:MessageConstant.k_AlertTitle, controller: self)
        }else if (lblCommunity.text! == "Comunidad") {
            objAlert.showAlert(message: "Selecciona Comunidad!!!", title:MessageConstant.k_AlertTitle, controller: self)
        }else if (lblProvince.text! == "Provincia") {
            objAlert.showAlert(message: "Selecciona Provincia!!!", title:MessageConstant.k_AlertTitle, controller: self)
        }else if (lblMuncipality.text! == "Municipio/Ciudad") {
            objAlert.showAlert(message: "Selecciona Municipio!!!", title:MessageConstant.k_AlertTitle, controller: self)
        }else if self.strType != "User"{
            if  (lblServiceSector.text! == "Sector Profesional de Servicio"){
                objAlert.showAlert(message: "Selección Sector Profesional", title:MessageConstant.k_AlertTitle, controller: self)
            }else{
                self.callWebserviceForSignUp()
            }
        }else{
            self.callWebserviceForSignUp()
        }
    }
    
    @IBAction func btnOnUserSelection(_ sender: Any) {
        self.openSelectionScreen(strIsComingFrom: "1", strTitle: "")
    }
    
    @IBAction func btnOnPresentOptions(_ sender: UIButton) {
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
                self.openSelectionScreen(strIsComingFrom: "6", strTitle: "Sector de Servicios")
            }
           
        default:
            break
        }
    }
    
    @IBAction func btnOnLogin(_ sender: Any) {
        self.pushVc(viewConterlerId: "LoginViewController")
    }
    
}


// MARK:- UIImage Picker Delegate
extension SignUpViewController: UIImagePickerControllerDelegate{
    
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
            
            self.makeRounded()
            if self.imgVwUser.image == nil{
                // self.viewEditProfileImage.isHidden = true
            }else{
                // self.viewEditProfileImage.isHidden = false
            }
            imagePicker.dismiss(animated: true, completion: nil)
        } else if let originalImage = info[.originalImage] as? UIImage {
            self.pickedImage = originalImage
            self.imgVwUser.image = pickedImage
            self.makeRounded()
            // self.cornerImage(image: self.imgUpload,color:#colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1) ,width: 0.5 )
            if self.imgVwUser.image == nil{
                // self.viewEditProfileImage.isHidden = true
            }else{
                //self.viewEditProfileImage.isHidden = false
            }
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
extension SignUpViewController{
    

    func callWebserviceForSignUp(){
        
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
            "type":self.strType,
            "name":self.tfName.text!,
            "email":self.tfEmail.text!,
            "nation_id":self.strNationID,
            "community_id":self.strCommunityID,
            "province_id":self.strProvinceID,
            "password":self.tfPassword.text!,
            "municipality_id":self.strMunicipalID,
            "sector_id":self.strSectorID,
            "register_id":objAppShareData.strFirebaseToken,
            "device_type":"IOS"]as [String:Any]
        
       print(dicrParam)
        
        objWebServiceManager.uploadMultipartWithImagesData(strURL: WsUrl.url_SignUp, params: dicrParam, showIndicator: true, customValidation: "", imageData: imgData, imageToUpload: imageData, imagesParam: imageParam, fileName: "user_image", mimeType: "image/jpeg") { (response) in
            objWebServiceManager.hideIndicator()
            print(response)
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            if status == MessageConstant.k_StatusCode{
            
                let user_details  = response["result"] as? [String:Any]

                if let strOtp = user_details?["otp"]as? String{
                    self.otp = strOtp
                }else if let strOtp = user_details?["otp"]as? Int{
                    self.otp = "\(strOtp)"
                }
                
                if let strUserid = user_details?["user_id"]as? String{
                    self.userID = strUserid
                }else if let strUserid = user_details?["user_id"]as? Int{
                    self.userID = "\(strUserid)"
                }
                
                self.lblVerifyDesc.text = "por favor verifica tu email. hemos enviado los detalles de la verificación en \(self.tfEmail.text!)."
                self.vwVerify.isHidden = false

            }else{
                objWebServiceManager.hideIndicator()
                objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
            }
        } failure: { (Error) in
            print(Error)
        }
    }
    
    
}
