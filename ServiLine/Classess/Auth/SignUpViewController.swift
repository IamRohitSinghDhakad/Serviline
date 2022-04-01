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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.vwVerify.isHidden = true
        self.tfPassword.isSecureTextEntry = true
        self.imagePicker.delegate = self
        // Do any additional setup after loading the view.
        self.vwServiceSector.isHidden = true
    }
    
    @IBAction func btnShowHidePassword(_ sender: Any) {
        if self.tfPassword.isSecureTextEntry == false{
            self.tfPassword.isSecureTextEntry = true
        }else{
            self.tfPassword.isSecureTextEntry = false
        }
    }
    
    @IBAction func btnOpenCamera(_ sender: Any) {
        self.setImage()
    }
    
    
    @IBAction func btnOnDone(_ sender: Any) {
        self.vwVerify.isHidden = true
        onBackPressed()
    }
    
    
    func openSelectionScreen(strIsComingFrom:String, strTitle:String){
         let vc = self.storyboard?.instantiateViewController(withIdentifier: "PopUpViewController")as! PopUpViewController
         vc.isComingFrom = strIsComingFrom
        vc.strTitle = strTitle
        if strIsComingFrom == "1"{
            vc.closerForSelectionButton = { dict
                in
                print(dict)
                if dict.count != 0{
                    if dict["type"] as! String != "user"{
                        self.vwServiceSector.isHidden = false
                        self.strType = "Provider"
                    }else{
                        self.vwServiceSector.isHidden = true
                        self.strType = "User"
                    }
                    self.lblUserType.text = dict["type"] as? String
                }
            }
        }else{
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
                        self.lblCommunity.text = "Community"
                        self.lblProvince.text = "Province"
                        self.lblMuncipality.text = "Muncipality / City"
                    }
                    
                    if let communityID = dict["Community_id"]as? String{
                        self.strCommunityID = communityID
                        self.lblCommunity.text = dict["Community"]as? String
                        self.strProvinceID = ""
                        self.strMunicipalID = ""
                        self.lblProvince.text = "Province"
                        self.lblMuncipality.text = "Muncipality / City"
                    }
                    
                    if let Province = dict["Province_id"]as? String{
                        self.strProvinceID = Province
                        self.lblProvince.text = dict["Province"]as? String
                        self.strMunicipalID = ""
                        self.lblMuncipality.text = "Muncipality / City"
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
     //   self.callWebserviceForSignUp()
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let vc = (self.mainStoryboard.instantiateViewController(withIdentifier: "SideMenuController") as? SideMenuController)!
//        let navController = UINavigationController(rootViewController: vc)
//        navController.isNavigationBarHidden = true
//        appDelegate.window?.rootViewController = navController
        self.validateForSignUp()
    }
    
    //MARK:- All Validations
    func validateForSignUp(){
        self.tfName.text = self.tfName.text!.trim()
        self.tfEmail.text = self.tfEmail.text!.trim()
        self.tfConfirmEmail.text = self.tfConfirmEmail.text!.trim()
        self.tfPassword.text = self.tfPassword.text!.trim()
        
        if self.lblUserType.text == "User / Professional"  {
            objAlert.showAlert(message: "Please select UserType", title:MessageConstant.k_AlertTitle, controller: self)
        }
        else if (tfName.text?.isEmpty)! {
            objAlert.showAlert(message: "Please enter name", title:MessageConstant.k_AlertTitle, controller: self)
        }else if (tfEmail.text?.isEmpty)! {
            objAlert.showAlert(message: MessageConstant.BlankEmail, title:MessageConstant.k_AlertTitle, controller: self)
        }else if !objValidationManager.validateEmail(with: tfEmail.text!){
            objAlert.showAlert(message: MessageConstant.ValidEmail, title:MessageConstant.k_AlertTitle, controller: self)
        }else if (tfConfirmEmail.text?.isEmpty)! {
            objAlert.showAlert(message: "Please enter confirm email.", title:MessageConstant.k_AlertTitle, controller: self)
        }else if tfConfirmEmail.text! != self.tfEmail.text! {
            objAlert.showAlert(message: "Confirm email not match", title:MessageConstant.k_AlertTitle, controller: self)
        }else if (tfPassword.text?.isEmpty)! {
            objAlert.showAlert(message: MessageConstant.BlankPassword, title:MessageConstant.k_AlertTitle, controller: self)
        }else if (lblNation.text! == "Nation") {
            objAlert.showAlert(message: "Please select nation first", title:MessageConstant.k_AlertTitle, controller: self)
        }else if (lblCommunity.text! == "Community") {
            objAlert.showAlert(message: "Please select community first", title:MessageConstant.k_AlertTitle, controller: self)
        }else if (lblProvince.text! == "Province") {
            objAlert.showAlert(message: "Please select province first", title:MessageConstant.k_AlertTitle, controller: self)
        }else if (lblMuncipality.text! == "Muncipality / City") {
            objAlert.showAlert(message: "Please select muncipal first", title:MessageConstant.k_AlertTitle, controller: self)
        }else if self.strType != "User"{
            if  (lblServiceSector.text! == "Service Sector"){
                objAlert.showAlert(message: "Please select sector first", title:MessageConstant.k_AlertTitle, controller: self)
            }else{
                self.callWebserviceForSignUp()
            }
        }else{
            self.callWebserviceForSignUp()
        }
    }
    
    @IBAction func btnOnUserSelection(_ sender: Any) {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PopUpViewController") as! PopUpViewController
//        vc.isComingFrom = "1"
//        self.present(vc, animated: true, completion: nil)
        self.openSelectionScreen(strIsComingFrom: "1", strTitle: "")
    }
    
    @IBAction func btnOnPresentOptions(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            self.openSelectionScreen(strIsComingFrom: "2", strTitle: "Nation")
            print("Nation is ")
        case 1:
            if self.strNationID == ""{
                objAlert.showAlert(message: "Please select nation first", title: "Alert", controller: self)
            }else{
                self.openSelectionScreen(strIsComingFrom: "3", strTitle: "Community")
            }
            print("Community is ")
        case 2:
            if self.strCommunityID == ""{
                objAlert.showAlert(message: "Please select community first", title: "Alert", controller: self)
            }else{
                self.openSelectionScreen(strIsComingFrom: "4", strTitle: "Provience")
            }
            print("Province is ")
        case 3:
            
            if self.strProvinceID == ""{
                objAlert.showAlert(message: "Please select provience first", title: "Alert", controller: self)
            }else{
                self.openSelectionScreen(strIsComingFrom: "5", strTitle: "Muncipal")
            }
            print("Muncipal City is ")
        case 4:
            if self.strProvinceID == ""{
                objAlert.showAlert(message: "Please select Muncipal first", title: "Alert", controller: self)
            }else{
                self.openSelectionScreen(strIsComingFrom: "6", strTitle: "Sector")
            }
           
            print("Service sector is ")
        default:
            break
        }
    }
    
    @IBAction func btnOnLogin(_ sender: Any) {
        onBackPressed()
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
            "ios_register_id":objAppShareData.strFirebaseToken]as [String:Any]
        
       print(dicrParam)
        
        objWebServiceManager.uploadMultipartWithImagesData(strURL: WsUrl.url_SignUp, params: dicrParam, showIndicator: true, customValidation: "", imageData: imgData, imageToUpload: imageData, imagesParam: imageParam, fileName: "user_image", mimeType: "image/jpeg") { (response) in
            objWebServiceManager.hideIndicator()
           // print(response)
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            if status == MessageConstant.k_StatusCode{
            
                let user_details  = response["result"] as? [String:Any]

                self.lblVerifyDesc.text = "Please verify your email we have send verification details on \(self.tfEmail.text!)."
                self.vwVerify.isHidden = false
                
                
//                objAppShareData.SaveUpdateUserInfoFromAppshareData(userDetail: user_details ?? [:])
//                objAppShareData.fetchUserInfoFromAppshareData()
//
//                let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                let vc = (self.mainStoryboard.instantiateViewController(withIdentifier: "SideMenuController") as? SideMenuController)!
//                let navController = UINavigationController(rootViewController: vc)
//                navController.isNavigationBarHidden = true
//                appDelegate.window?.rootViewController = navController

            }else{
                objWebServiceManager.hideIndicator()
                objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
            }
        } failure: { (Error) in
            print(Error)
        }
    }
    
    
}
