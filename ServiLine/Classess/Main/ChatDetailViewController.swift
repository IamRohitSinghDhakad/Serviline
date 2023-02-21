//
//  ChatDetailViewController.swift
//  Paing
//
//  Created by Rohit Singh Dhakad on 31/05/21.
//

import UIKit
import Alamofire
import AVKit
import MobileCoreServices
import UniformTypeIdentifiers
import AVKit
import AVFoundation
import SDWebImage

//enum AssetType: String {
//    case image = "image"
//    case video = "video"
//}

class ChatDetailViewController: UIViewController,UINavigationControllerDelegate,UIScrollViewDelegate,UIDocumentPickerDelegate {

    @IBOutlet var vwCornerHeader: UIView!
    @IBOutlet var imgVwUser: UIImageView!
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var tblChat: UITableView!
    @IBOutlet var txtVwChat: RDTextView!
    @IBOutlet var hgtConsMaximum: NSLayoutConstraint!
    @IBOutlet var hgtConsMinimum: NSLayoutConstraint!
    @IBOutlet var btnSendTextMessage: UIButton!
    @IBOutlet var lblOnLineStatus: UILabel!
    //SUbVw
    @IBOutlet var subVw: UIView!
    @IBOutlet var imgVwFull: UIImageView!
    @IBOutlet var vwContainRightTickImageSubVw: UIView!
    @IBOutlet var subVwSelection: UIView!
    @IBOutlet var sbVwMainSticker: UIView!
    @IBOutlet var btnAddSticker: UIButton!
    @IBOutlet var vwContainFullImage: UIView!
    @IBOutlet var imgvwFullForDownload: UIImageView!
    @IBOutlet var imgVwRadioVideo: UIImageView!
    @IBOutlet var imgVwRadioFile: UIImageView!
    @IBOutlet var imgVwRadioImage: UIImageView!
    @IBOutlet var btnOnSelect: UIButton!
    @IBOutlet var vwBlockUser: UIView!
    @IBOutlet var scrollVwFullImageDownload: UIScrollView!

    
    
    
    //MARK:- Variables
    var imagePicker = UIImagePickerController()
    var pickedImage:UIImage?
    var pickedDoc:Data?
    var docExtension = ""
    var myDocUrl = ""
    
    var controller = UIImagePickerController()
    let videoFileName = "/video.mp4"
    var videoUrl = ""
    var videoData = Data()
    
    
    let txtViewCommentMaxHeight: CGFloat = 100
    let txtViewCommentMinHeight: CGFloat = 34

    var arrChatMessages = [ChatDetailModel]()
    var strUserName = ""
    var strUserImage = ""
    var strSenderID = ""
    var isBlocked = ""
    var timer: Timer?
    var strOnlineStatus = ""
    var isSendMessage = true
    var selectedIndex = -1
    var arrCount = Int()
    var initilizeFirstTimeOnly = Bool()
    var strSelectedImageUrl = ""
    var strMsgID = -1
    
    
    private lazy var downloader = FilesDownloader()
    
    //MARK: - Override Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.scrollVwFullImageDownload.delegate = self
        self.scrollVwFullImageDownload.minimumZoomScale = 1.0
        self.scrollVwFullImageDownload.maximumZoomScale = 10.0
       // self.vwBlockUser.isHidden = true
        
        self.tblChat.delegate = self
        self.tblChat.dataSource = self
        self.txtVwChat.delegate = self
        
    //    self.cvSticker.delegate = self
  //      self.cvSticker.dataSource = self
        
        self.imagePicker.delegate = self
        self.lblUserName.text = strUserName
        
        self.strOnlineStatus = "Online"
        
        self.subVw.isHidden = true
        self.subVwSelection.isHidden = true
        self.sbVwMainSticker.isHidden = true
        
        self.imgVwRadioImage.image = UIImage.init(named: "radio_button")
        self.imgVwRadioFile.image = UIImage.init(named: "radio_button")
        self.imgVwRadioVideo.image = UIImage.init(named: "radio_button")
       
        
        self.vwContainFullImage.isHidden = true
        
        let profilePic = self.strUserImage
        if profilePic != "" {
            let url = URL(string: profilePic)
           self.imgVwUser.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo"))
        }
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(sender:)))
        self.tblChat.addGestureRecognizer(longPress)
        
       // self.call_GetChatList(strUserID: objAppShareData.UserDetail.strUserId, strSenderID: self.strSenderID)
        if self.timer == nil{
            self.timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
      //  self.call_GetProfile(strUserID: self.strSenderID)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        self.tblChat.scrollToBottom()
    }
    
    func downloadFile(from url: URL) {
           downloader.download(from: url, delegate: self)
       }
    
    //Scroll Methods
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imgvwFullForDownload
     }
    
    //MARK: - Action Methods
    @IBAction func btnGoToUserProfile(_ sender: Any) {
        let userID = self.strSenderID
        if objAppShareData.UserDetail.strUserId == userID{
            
        }else{
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OtherUserProfileViewController") as? OtherUserProfileViewController
            vc?.strUserID = userID
          //  vc?.isComingFromChat = true
            self.timer?.invalidate()
            self.timer = nil
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
    
    @IBAction func btnActionSendSticker(_ sender: Any) {
        if self.pickedImage != nil && self.selectedIndex != -1{
            self.subVwSelection.isHidden = true
         //   self.callWebserviceForSendImage(strSenderID: objAppShareData.UserDetail.strUserId, strReceiverID: self.strSenderID, strType: "Sticker")
        }
    }
    
    @IBAction func btnHideSubVwSelection(_ sender: Any) {
        self.subVwSelection.isHidden = true
    }
    
    @IBAction func btnCloseFullImgVwDownload(_ sender: Any) {
        self.vwContainFullImage.isHidden = true
    }
    
    @IBAction func btnDeleteFullImageDownload(_ sender: Any) {
//        if self.strMsgID != -1{
//
//            objAlert.showAlertCallBack(alertLeftBtn: "no", alertRightBtn: "si", title: "", message: "¿Quieres borrar este mensaje?", controller: self) {
//
//                self.vwContainFullImage.isHidden = true
//           //     let userIDForDelete = self.arrChatMessages[self.strMsgID].strMsgIDForDelete
//           //     self.call_DeleteChatMsgSinle(strUserID: objAppShareData.UserDetail.strUserId, strMsgID: userIDForDelete)
//            }
//        }else{
//
//        }
       
    }
    
    @IBAction func btnDownloadFullImg(_ sender: Any) {
        
        if self.strSelectedImageUrl != ""{
            
            if let url = URL(string: strSelectedImageUrl),
               let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            }
            
            objAlert.showAlertCallBack(alertLeftBtn: "", alertRightBtn: "OK", title: "", message: "Descarga de imagen con éxito", controller: self) {
                self.vwContainFullImage.isHidden = true
            }
        }else{
            objAlert.showAlertCallBack(alertLeftBtn: "", alertRightBtn: "OK", title: "", message: "No se encontró la URL de la imagen", controller: self) {
                self.vwContainFullImage.isHidden = true
            }
        }
    }
    
    
    @objc func updateTimer() {
        //example functionality
        self.call_GetChatList(strUserID: objAppShareData.UserDetail.strUserId, strSenderID: self.strSenderID)
    }
    
    @IBAction func btnBackOnHeader(_ sender: Any) {
        self.timer?.invalidate()
        self.timer = nil
        onBackPressed()
        
    }
    @IBAction func btnOpenCamera(_ sender: Any) {
        self.setImage()
    }
    
    @IBAction func btnOnSelectMedia(_ sender: UIButton) {
        self.imgVwRadioImage.image = UIImage.init(named: "radio_button")
        self.imgVwRadioFile.image = UIImage.init(named: "radio_button")
        self.imgVwRadioVideo.image = UIImage.init(named: "radio_button")
        
        switch sender.tag {
        case 0:
            if self.imgVwRadioImage.image == UIImage.init(named: "radio_button"){
                self.imgVwRadioImage.image = UIImage.init(named: "radio_button_selected")
            }else{
                self.imgVwRadioImage.image = UIImage.init(named: "radio_button")
            }
            self.btnOnSelect.tag = 0
        case 1:
            if self.imgVwRadioFile.image == UIImage.init(named: "radio_button"){
                self.imgVwRadioFile.image = UIImage.init(named: "radio_button_selected")
            }else{
                self.imgVwRadioFile.image = UIImage.init(named: "radio_button")
            }
            self.btnOnSelect.tag = 1
        case 2:
            if self.imgVwRadioVideo.image == UIImage.init(named: "radio_button"){
                self.imgVwRadioVideo.image = UIImage.init(named: "radio_button_selected")
            }else{
                self.imgVwRadioVideo.image = UIImage.init(named: "radio_button")
            }
            self.btnOnSelect.tag = 2
        default:
            break
        }
    }
    
    @IBAction func btnOnSelect(_ sender: UIButton) {
        self.sbVwMainSticker.isHidden = true
        switch sender.tag {
        case 0:
            self.setImage()
        case 1:
            // Use this code if your are developing prior iOS 14
//            let types: [String] = [kUTTypePDF as String]
//            let documentPicker = UIDocumentPickerViewController(documentTypes: types, in: .import)
//            documentPicker.delegate = self
//            documentPicker.modalPresentationStyle = .formSheet
//            self.present(documentPicker, animated: true, completion: nil)

            // For iOS 14+
            if #available(iOS 14.0, *) {
                let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.item], asCopy: false)
                documentPicker.delegate = self
                documentPicker.modalPresentationStyle = .formSheet
                self.present(documentPicker, animated: true, completion: nil)

            } else {
                // Fallback on earlier versions
            }
//            documentPicker.delegate = self
//            documentPicker.modalPresentationStyle = .formSheet

          
        default:
            self.takeVideo()
        }
    }
    
    //================= UI Document Picker ==============//
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard controller.documentPickerMode == .open, let url = urls.first, url.startAccessingSecurityScopedResource() else { return }
            defer {
                DispatchQueue.main.async {
                    url.stopAccessingSecurityScopedResource()
                }
            }
            
            do {
                let document = try Data(contentsOf: url.absoluteURL)
                self.pickedDoc = document
                print("File Selected: " + url.path)
                print(url.pathExtension)
                self.docExtension = "file/\(url.pathExtension)"
                self.myDocUrl = url.path
                self.callWebserviceForSendDocument(strSenderID: objAppShareData.UserDetail.strUserId, strReceiverID: self.strSenderID, strType: "file")
            }
            catch {
                print("Error selecting file: " + error.localizedDescription)
            }
            
        }
//    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
//         // you get from the urls parameter the urls from the files selected
//        print(urls)
//    }
    
    
    @IBAction func btnAddOnSticker(_ sender: Any) {
        self.sbVwMainSticker.isHidden = false
        self.subVwSelection.isHidden = false
    }
    
    @IBAction func btnSendMessage(_ sender: Any) {
        
        if (txtVwChat.text?.isEmpty)!{

            self.txtVwChat.text = "."
            self.txtVwChat.text = self.txtVwChat.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            self.txtVwChat.isScrollEnabled = false
            self.txtVwChat.frame.size.height = self.txtViewCommentMinHeight
            self.txtVwChat.text = ""

            if self.txtVwChat.text!.count > 0{
                self.txtVwChat.isScrollEnabled = false
            }else{
                self.txtVwChat.isScrollEnabled = false
            }
        }else{
            self.txtVwChat.frame.size.height = self.txtViewCommentMinHeight
            DispatchQueue.main.async {
                let text  = self.txtVwChat.text!.encodeEmoji
                self.sendMessageNew(strText: text)
            }
            if self.txtVwChat.text!.count > 0{
                self.txtVwChat.isScrollEnabled = false

            }else{
                self.txtVwChat.isScrollEnabled = false
            }
        }
    }
    
    @IBAction func btnCloseStickerSubVw(_ sender: Any) {
        self.subVwSelection.isHidden = true
        self.sbVwMainSticker.isHidden = true
        self.selectedIndex = -1
    }
    
    /*
     if self.txtVwChat.text == ""{
         
     }else{
       //  self.offset = 0
         self.txtVwChat.frame.size.height = self.txtViewCommentMinHeight
         self.sendMessageNew()
     }
     **/
    
    @IBAction func btnOnDeleteChat(_ sender: Any) {
        
        objAlert.showAlertCallBack(alertLeftBtn: "No", alertRightBtn: "Si", title: "", message: "Quieres eliminar el chat con \(self.strUserName) ?", controller: self) {
            self.timer?.invalidate()
            self.timer = nil
         //   self.call_ClearConversation(strUserID: objAppShareData.UserDetail.strUserId)
        }
       // self.tblChat.reloadData()
    }
    
    //SUbVw
    @IBAction func btnActionSendImage(_ sender: Any) {
      //  self.callWebserviceForSendImage(strSenderID: objAppShareData.UserDetail.strUserId, strReceiverID: self.strSenderID, strType: "Image")
    }
    
    @IBAction func btnCancelSUbVw(_ sender: Any) {
        self.imgVwFull.image = nil
        self.subVw.isHidden = true
    }
}

// MARK:- UIImage Picker Delegate
extension ChatDetailViewController: UIImagePickerControllerDelegate{
    
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
        
        picker.dismiss(animated: true, completion: nil)
        
        guard let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String else { return }
        
        if mediaType  == "public.image" {
            print("Image Selected")
            if let url = info[.imageURL] as? URL {
                
                let editedImage = info[.editedImage] as? UIImage
                self.pickedImage = editedImage
                self.imgVwFull.image = self.pickedImage
                
                self.callWebserviceForSendImage(strSenderID: objAppShareData.UserDetail.strUserId, strReceiverID: self.strSenderID, strType: "Image")
//                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditImageVideoViewController") as? EditImageVideoViewController
//                vc?.type = .image
//                vc?.assetURL = url
//                vc?.isComingFrom = ""
//                self.navigationController?.pushViewController(vc!, animated: true)
            }
        }
        
        if mediaType == "public.movie" {
            print("Video Selected")
            // Using the full key
            if let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
                
                let duration = AVURLAsset(url: url).duration.seconds
                    print(duration)
                
                self.videoUrl = "\(url)"
                
                self.callWebserviceForSendVideo(strSenderID: objAppShareData.UserDetail.strUserId, strReceiverID: self.strSenderID, strType: "video", strVidUrl: url)
                
                // Do something with the URL
//                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditImageVideoViewController") as? EditImageVideoViewController
//                vc?.type = .video
//                vc?.assetURL = url
//                vc?.isComingFrom = ""
//                self.navigationController?.pushViewController(vc!, animated: true)
            }

        }
    
        
        
//        if let editedImage = info[.editedImage] as? UIImage {
//            self.pickedImage = editedImage
//            self.imgVwFull.image = self.pickedImage
//            imagePicker.dismiss(animated: true, completion: nil)
//        } else if let originalImage = info[.originalImage] as? UIImage {
//            self.pickedImage = originalImage
//            self.imgVwFull.image = pickedImage
//            imagePicker.dismiss(animated: true, completion: nil)
//
//        }else{
//            if let selectedVideo:URL = (info[UIImagePickerController.InfoKey.mediaURL] as? URL) {
//                print(selectedVideo)
//                let duration = AVURLAsset(url: selectedVideo).duration.seconds
//                print(duration)
//                imagePicker.dismiss(animated: true, completion: nil)
//                // Do something with the URL
//                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditImageVideoViewController") as? EditImageVideoViewController
//                vc?.type = .video
//                vc?.assetURL = selectedVideo
//                vc?.isComingFrom = "VidoBlog"
//                self.navigationController?.pushViewController(vc!, animated: true)
//
//                //self.uploadVideoUrl(uploadUrl:] as! String)
//                // print(self.videoUrl)
//
//            }
//        }
        
        
    }
    
    func cornerImage(image: UIImageView, color: UIColor ,width: CGFloat){
        image.layer.cornerRadius = image.layer.frame.size.height / 2
        image.layer.masksToBounds = false
        image.layer.borderColor = color.cgColor
        image.layer.borderWidth = width
    }
    
}

//MARK:- Video Picker
extension ChatDetailViewController{
    
    func takeVideo(){
        let alert = UIAlertController(title: "Choose Video", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
                //already authorized
                DispatchQueue.main.async {
                    self.recordVid()
                }
            } else {
                AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                    if granted {
                        //access allowed
                        DispatchQueue.main.async {
                            self.recordVid()
                        }
                    } else {
                        //access denied
                        self.alertPromptToAllowCameraAccessViaSettings()
                    }
                })
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            DispatchQueue.main.async {
                self.openVideoGallery()
            }
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        imagePicker.delegate = self
        alert.popoverPresentationController?.sourceView = self.view // works for both iPhone & iPad
        present(alert, animated: true) {
            print("option menu presented")
        }
        
    }
    
    
    func recordVid(){
        // 1 Check if project runs on a device with camera available
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            // 2 Present UIImagePickerController to take video
            controller.sourceType = .camera
            controller.mediaTypes = ["public.movie"]
            controller.delegate = self
            controller.videoMaximumDuration = 30
            present(controller, animated: true, completion: nil)
        }
        else {
            print("Camera is not available")
            controller.sourceType = .savedPhotosAlbum
            controller.mediaTypes = ["public.movie"]
            controller.delegate = self
            controller.videoMaximumDuration = 30
            present(controller, animated: true, completion: nil)
        }
    }
    
    func alertPromptToAllowCameraAccessViaSettings() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Access the Camera", message: "Allow to access the camera from your device settings. Go to settings.", preferredStyle: .alert )
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
                if let appSettingsURL = NSURL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(appSettingsURL as URL)
                }
            }))
            alert.addAction(UIAlertAction.init(title: "No", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openVideoGallery() {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.mediaTypes = ["public.movie"]
        imagePicker.allowsEditing = true
        imagePicker.videoMaximumDuration = 30
        present(imagePicker, animated: true, completion: nil)
    }
    
    func captureOutput(captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAtURL fileURL: NSURL!, fromConnections connections: [AnyObject]!) {
        
        captureOutput.maxRecordedDuration = CMTimeMake(value: 10, timescale: 1)
        let seconds = 5.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            captureOutput.stopRecording()
            // Put your code which should be executed with a delay here
        }
        return
    }
    
    //MARK: - Helper methods
    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
    }
    
    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
        return input.rawValue
    }
    

}

//MARK:- UItextViewHeightManage
extension ChatDetailViewController: UITextViewDelegate{
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        return newText.count <= 150
    }
    
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        self.strOnlineStatus = "Typing"
          if self.txtVwChat.text == "\n"{
              self.txtVwChat.resignFirstResponder()
          }
          else{
          }
          return true
      }
      
    func textViewDidEndEditing(_ textView: UITextView) {
        self.strOnlineStatus = "Online"
    }
      
      func textViewDidChange(_ textView: UITextView)
      {
          if self.txtVwChat.contentSize.height >= self.txtViewCommentMaxHeight
          {
              self.txtVwChat.isScrollEnabled = true
          }
          else
          {
              self.txtVwChat.frame.size.height = self.txtVwChat.contentSize.height
              self.txtVwChat.isScrollEnabled = false
          }
      }
      
    
    
    func sendMessageNew(strText:String){
        self.txtVwChat.isScrollEnabled = false
        self.txtVwChat.contentSize.height = self.txtViewCommentMinHeight
        self.txtVwChat.text = self.txtVwChat.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if self.txtVwChat.text == "" {
            objAlert.showAlert(message: "Introduzca mensaje", title: "", controller: self)
           // AppSharedClass.shared.showAlert(title: "Alert", message: "Please enter some text", view: self)
            return
        }else{
            self.call_SendTextMessageOnly(strUserID: objAppShareData.UserDetail.strUserId, strText: strText)
        }
        self.txtVwChat.text = ""
    }
    
}


//MARK:- UITableView Delegate and DataSource
extension ChatDetailViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrChatMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblChat.dequeueReusableCell(withIdentifier: "ChatDetailTVCell")as! ChatDetailTVCell
        
        let obj = self.arrChatMessages[indexPath.row]
        
        let imgUrl = obj.strImageUrl
        let docUrl = obj.strChatDocumentUrl
        let vidUrl = obj.strChatVideoUrl
        
        
        if imgUrl != "" || docUrl != "" || vidUrl != ""{
            if obj.strSenderId == objAppShareData.UserDetail.strUserId{
                cell.vwMyMsg.isHidden = true
                cell.vwOpponent.isHidden = true
                cell.vwOpponentImage.isHidden = true
                cell.vwMyImage.isHidden = false

                if obj.strType == "image" || obj.strType == "Image"{
                    let profilePic = obj.strImageUrl
                    if profilePic != ""{
                       // cell.imgVwMySide.imageFromServerURL(urlString: profilePic, PlaceHolderImage: #imageLiteral(resourceName: "logo"))
                        let url = URL(string: profilePic)
                        cell.imgVwMySide.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo"))
                    }else{
                        cell.imgVwMySide.image = nil
                    }
                   // cell.imgVwMySide.imageFromServerURL(urlString: profilePic, PlaceHolderImage: #imageLiteral(resourceName: "logo"))
                }else{
                    cell.imgVwMySide.imageFromServerURL(urlString: "", PlaceHolderImage: #imageLiteral(resourceName: "logo"))
                }
                
                if obj.strType == "video" || obj.strType == "Video"{
                  
                    if let vidUrll : URL = URL(string: obj.strChatVideoUrl){
                        self.getThumbnailImageFromVideoUrl(url: vidUrll) { image in
                          //  cell.imgVwMySide.imageFromServerURL(urlString: profilePic, PlaceHolderImage: #imageLiteral(resourceName: "logo"))
                            cell.imgVwMySide.image = image
                        }
                    }else{
                        print("Not able to convert")
                    }
                       
                    
                }else{
                    cell.imgVwMySide.imageFromServerURL(urlString: "", PlaceHolderImage: #imageLiteral(resourceName: "logo"))
                }
               

                if obj.strType == "file" || obj.strType == "File"{
                    cell.imgVwMySide.image = UIImage.init(named: "doc")

                }else{
                    cell.imgVwMySide.imageFromServerURL(urlString: "", PlaceHolderImage: #imageLiteral(resourceName: "logo"))
                }


            }else{
                cell.vwMyMsg.isHidden = true
                cell.vwOpponent.isHidden = true
                cell.vwOpponentImage.isHidden = false
                cell.vwMyImage.isHidden = true
                
                if obj.strType == "image"{
                    let profilePic = obj.strImageUrl
                    if profilePic != ""{
                        cell.imgVwopponent.imageFromServerURL(urlString: profilePic, PlaceHolderImage: #imageLiteral(resourceName: "logo"))
                    }else{
                        cell.imgVwopponent.image = nil
                    }
                  
                }else{
                    cell.imgVwMySide.imageFromServerURL(urlString: "", PlaceHolderImage: #imageLiteral(resourceName: "logo"))
                }
                
                
                
                if obj.strType == "file" || obj.strType == "File"{
                    cell.imgVwopponent.image = UIImage.init(named: "doc")

                }else{
                    cell.imgVwopponent.imageFromServerURL(urlString: "", PlaceHolderImage: #imageLiteral(resourceName: "logo"))
                }

               
            }
        }else{
            
            if obj.strSenderId == objAppShareData.UserDetail.strUserId{
                cell.vwOpponentImage.isHidden = true
                cell.vwMyImage.isHidden = true
                cell.vwMyMsg.isHidden = false
                cell.lblMyMsg.text = obj.strOpponentChatMessage
                cell.lblMyMsgTime.text = obj.strOpponentChatTime
                cell.vwOpponent.isHidden = true
            }else{
                cell.vwOpponentImage.isHidden = true
                cell.vwMyImage.isHidden = true
                cell.lblOpponentMsg.text = obj.strOpponentChatMessage
                cell.lblopponentMsgTime.text = obj.strOpponentChatTime
                cell.vwOpponent.isHidden = false
                cell.vwMyMsg.isHidden = true
            }
        }

        cell.lblOpponentMsg.text = obj.strOpponentChatMessage
        cell.lblopponentMsgTime.text = obj.strChatTime
        cell.lblMyImageTime.text = obj.strChatTime
        cell.lblOpponentImgTime.text = obj.strChatTime
        cell.lblMyMsgTime.text = obj.strChatTime

        cell.btnOpenImageOnFullviewMySide.tag = indexPath.row
        cell.btnOpenImageOnFullviewMySide.addTarget(self, action: #selector(btnOpenImage), for: .touchUpInside)

        cell.btnOpenImageOnFullViewOpponentSide.tag = indexPath.row
        cell.btnOpenImageOnFullViewOpponentSide.addTarget(self, action: #selector(btnOpenImage), for: .touchUpInside)
        
        return cell
    }
    
    private func createVideoThumbnail(from url: URL) -> UIImage? {

        let asset = AVAsset(url: url)
        let assetImgGenerate = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
       // assetImgGenerate.maximumSize = CGSize(width: frame.width, height: frame.height)
       // assetImgGenerate.maximumSize = CGSize()

        let time = CMTimeMakeWithSeconds(0.0, preferredTimescale: 600)
        do {
            let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
            let thumbnail = UIImage(cgImage: img)
            return thumbnail
        }
        catch {
          print(error.localizedDescription)
          return nil
        }

    }
    
    @objc func btnOpenImage(sender: UIButton){
        print(sender.tag)
        self.strMsgID = sender.tag
        
        switch self.arrChatMessages[sender.tag].strType {
        case "image", "Image":
            let obj = self.arrChatMessages[sender.tag]
            self.strSelectedImageUrl = obj.strImageUrl
            let profilePic = obj.strImageUrl
            if profilePic != "" {
                let url = URL(string: profilePic)
                self.imgvwFullForDownload.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo"))
            }

            self.vwContainFullImage.isHidden = false
        case "file", "File":
            objWebServiceManager.showIndicator()
            
           // self.downloadFileAF(strUrl: url)
            
            
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "WebViewShowViewController")as! WebViewShowViewController
//            vc.strIsComingFrom = "Document"
//            vc.strUrl =  self.arrChatMessages[sender.tag].strChatDocumentUrl.trim()
//            self.navigationController?.pushViewController(vc, animated: true)
//
            let url = URL(string: self.arrChatMessages[sender.tag].strChatDocumentUrl.trim())!
            FileDownloader.loadFileAsync(url: url) { (path,alreadyDownload, error) in
                if error == nil{
                    DispatchQueue.main.async {
                        if alreadyDownload == "File already exists"{
                            objAlert.showAlert(message: "Archivo ya descargado en su directorio \n Path:- Files/Serviline/", title: "Éxito", controller: self)
                        }else{
                            objAlert.showAlert(message: "Descarga de archivos con éxito en el directorio del documento.", title: "Éxito", controller: self)
                        }
                    }
                   
                }else{
                    DispatchQueue.main.async {
                        objAlert.showAlert(message: "File download error", title: "Failed", controller: self)
                    }
                }
                objWebServiceManager.hideIndicator()
            }
            
        case "video", "Video":
            let url = URL(string: self.arrChatMessages[sender.tag].strChatVideoUrl) ?? URL(fileURLWithPath: "")
            playVideo(url: url)
        default:
            break
        }
    }
    
    

    func playVideo(url: URL) {
            let player = AVPlayer(url: url)
            let vc = AVPlayerViewController()
            vc.player = player
            self.present(vc, animated: true) { vc.player?.play() }
        }
    
    @objc private func handleLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let touchPoint = sender.location(in: tblChat)
            if let indexPath = tblChat.indexPathForRow(at: touchPoint) {
                print(indexPath.row)
                // your code here, get the row for the indexPath or do whatever you want

                let type = self.arrChatMessages[indexPath.row].strType
                if type == "Text" || type == "text"{
                    self.openActionSheet(index: indexPath.row)
                }
            }
        }
    }
//
    
    
    func openActionSheet(index:Int){
        
        let actionsheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        actionsheet.addAction(UIAlertAction(title: "Borrar mensaje", style: UIAlertAction.Style.default, handler: { (action) -> Void in
         //Delete Message
            
            objAlert.showAlertCallBack(alertLeftBtn: "SI", alertRightBtn: "NO", title: "", message: "Quieres borrar mensaje?", controller: self) {
                let msgID = self.arrChatMessages[index].strMsgIDForDelete
               // let rec_ID = self.arrChatMessages[index].strReceiverID
                self.call_DeleteChatMsgSinle(strUserID: objAppShareData.UserDetail.strUserId, strMsgID: msgID)
                
            }
        }))
        
        actionsheet.addAction(UIAlertAction(title: "Copiar", style: UIAlertAction.Style.default, handler: { (action) -> Void in
            //Copy Message
            UIPasteboard.general.string = self.arrChatMessages[index].strOpponentChatMessage
            objAlert.showAlert(message: "Mensaje copiado", title: "Alert", controller: self)
            
        }))
        actionsheet.addAction(UIAlertAction(title: "Cancelar", style: UIAlertAction.Style.destructive, handler: { (action) -> Void in
            
        }))
        self.present(actionsheet, animated: true, completion: nil)
    }

    
    func updateTableContentInset() {
        let numRows = self.tblChat.numberOfRows(inSection: 0)
        var contentInsetTop = self.tblChat.bounds.size.height
        for i in 0..<numRows {
            let rowRect = self.tblChat.rectForRow(at: IndexPath(item: i, section: 0))
            contentInsetTop -= rowRect.size.height
            if contentInsetTop <= 0 {
                contentInsetTop = 0
                break
            }
        }
        self.tblChat.contentInset = UIEdgeInsets(top: contentInsetTop,left: 0,bottom: 0,right: 0)
    }
    
}


//Get Chat List
////MARK:- Call Webservice Chat List
extension ChatDetailViewController{
//
//
//    // MARK:- Get Profile
//
//    func call_GetProfile(strUserID: String) {
//
//        if !objWebServiceManager.isNetworkAvailable(){
//            objWebServiceManager.hideIndicator()
//            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
//            return
//        }
//
//      //  objWebServiceManager.showIndicator()
//
//        let parameter = ["user_id" : strUserID, "login_id" : objAppShareData.UserDetail.strUserId] as [String:Any]
//
//
//        objWebServiceManager.requestGet(strURL: WsUrl.url_getUserProfile, params: parameter, queryParams: [:], strCustomValidation: "") { (response) in
//
//            let status = (response["status"] as? Int)
//            let message = (response["message"] as? String)
//            objWebServiceManager.hideIndicator()
//            print(response)
//
//            if status == MessageConstant.k_StatusCode{
//
//                if let user_details  = response["result"] as? [String:Any] {
//                   print(user_details)
//                    var blockStatus = ""
//                    if let status = user_details["blocked"]as? String{
//                        blockStatus = status
//                    }else  if let status = user_details["blocked"]as? Int{
//                        blockStatus = "\(status)"
//                    }
//
//                    if blockStatus != "0"{
//                        self.vwBlockUser.isHidden = false
//                    }else{
//                        self.vwBlockUser.isHidden = true
//                        if self.timer == nil{
//                            self.timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
//                        }else{
//
//                        }
//
//                    }
//
//                }
//                else {
//                    objWebServiceManager.hideIndicator()
//                }
//
//            }else{
//                objWebServiceManager.hideIndicator()
//                objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
//
//            }
//        } failure: { (Error) in
//            print(Error)
//            objWebServiceManager.hideIndicator()
//        }
//    }
//
//

    func call_GetChatList(strUserID:String, strSenderID:String){

        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }

      //  objWebServiceManager.showIndicator()

        let parameter = ["receiver_id":strSenderID,
                         "sender_id":strUserID]as [String:Any]
      

        print(parameter)

      //  objWebServiceManager.requestGet(strURL: WsUrl.url_getChatList, params: parameter, queryParams: [:], strCustomValidation: "") { (response) in
        objWebServiceManager.requestPost(strURL: WsUrl.url_getChatList, queryParams: [:], params: parameter, strCustomValidation: "", showIndicator: false) { response in
 

            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)

            print(response)

            if status == MessageConstant.k_StatusCode{

                if let dictChatStatus = response["online_status"] as? [String:Any]{
                    if let chatStatus = dictChatStatus["chat_status"] as? String{
                        self.lblOnLineStatus.text = chatStatus.contains("Typing") ? "Escribiendo..." : chatStatus.contains("Online") ? "En línea" : chatStatus
                    }else{
                        self.lblOnLineStatus.text = ""
                    }
                }

                if let arrData  = response["result"] as? [[String:Any]] {
                    var newArrayChatMessages: [ChatDetailModel] = []
                    for dict in arrData {
                        let obj = ChatDetailModel.init(dict: dict)
                        newArrayChatMessages.append(obj)
                    }

                    if self.arrChatMessages.count == 0 {
                        //Add initially all
                        self.arrChatMessages.removeAll()
                        self.tblChat.reloadData()

                        for i in 0..<arrData.count{
                            let dictdata = arrData[i]
                            let obj = ChatDetailModel.init(dict: dictdata)
                            self.arrChatMessages.insert(obj, at: i)
    //
    //                        self.arrChatMessages.append(obj)
                            self.tblChat.insertRows(at: [IndexPath(item: i, section: 0)], with: .none)
                        }
                        DispatchQueue.main.async {
                            self.tblChat.scrollToBottom()
                        }

                    }
                    else {
                        let previoudIds = self.arrChatMessages.map { $0.strMsgIDForDelete }
                        let newIds = newArrayChatMessages.map { $0.strMsgIDForDelete }

                        let previoudIdsSet = Set(previoudIds)
                        let newIdsSet = Set(newIds)

                        let unique = (previoudIdsSet.symmetricDifference(newIdsSet)).sorted()

                        for uniqueId in unique {
                            if previoudIds.contains(uniqueId) {
                                //Remove the element
                                if let idToDelete = self.arrChatMessages.firstIndex(where: { $0.strMsgIDForDelete == uniqueId }) {
                                    self.arrChatMessages.remove(at: idToDelete)
                                    self.tblChat.deleteRows(at: [IndexPath(item: idToDelete, section: 0)], with: .none)

                                }
                            }
                            else if newIds.contains(uniqueId) {
                                // Add new element
                                let filterObj = newArrayChatMessages.filter({ $0.strMsgIDForDelete == uniqueId })
                                if filterObj.count > 0 {
                                    let index = self.arrChatMessages.count
                                    self.arrChatMessages.insert(filterObj[0], at: index)
                                    self.tblChat.insertRows(at: [IndexPath(item: index, section: 0)], with: .none)
                                    self.tblChat.scrollToBottom()
                                }
                            }
                        }
                    }

//                    for i in 0..<self.arrChatMessages.count{
//                        self.tblChat.deleteRows(at: [IndexPath(item: i, section: 0)], with: .automatic)
//                    }

                    if self.initilizeFirstTimeOnly == false{
                        self.initilizeFirstTimeOnly = true
                        self.arrCount = self.arrChatMessages.count
//                        self.tblChat.reloadData()
                    }

//                    self.tblChat.scrollToBottom()
//                    if self.isSendMessage{
//                        self.isSendMessage = false
//                        self.tblChat.scrollToBottom()
//                    }

                    if self.arrCount == self.arrChatMessages.count{

                    }else{
//                        self.tblChat.reloadData()
                        self.updateTableContentInset()
                    }


                    if self.arrChatMessages.count == 0{
                        self.tblChat.displayBackgroundText(text: "¡Sin conversación todavía!")
                    }else{
                        self.tblChat.displayBackgroundText(text: "")
                    }

//                    if self.isSendMessage{
//                        self.isSendMessage = false
//                        self.tblChat.scrollToBottom()
//                    }else{
//
//                    }

                }
            }else{
                objWebServiceManager.hideIndicator()

                if (response["result"]as? String) != nil{
                    self.tblChat.displayBackgroundText(text: "ningún record fue encontrado")
                }else{
                    objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
                }
            }
        } failure: { (Error) in
            print(Error)
            objWebServiceManager.hideIndicator()
        }
    }
//
//
//    //MARK:- Send Text message Only
//
    func call_SendTextMessageOnly(strUserID:String, strText:String){

        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }

       // objWebServiceManager.showIndicator()

        let dicrParam = ["receiver_id":self.strSenderID,//Opponent ID
                         "sender_id":strUserID,//My ID
                         "type":"Text",
                         "chat_message":strText]as [String:Any]
        print(dicrParam)

        objWebServiceManager.requestPost(strURL: WsUrl.url_insertChat, queryParams: [:], params: dicrParam, strCustomValidation: "", showIndicator: false) { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)

            print(response)
            
            if let result = response["result"]as? [String:Any]{
                if message == "success"{
                    self.isSendMessage = true
                    self.initilizeFirstTimeOnly = false
                    // self.call_GetChatList(strUserID: objAppShareData.UserDetail.strUserId, strSenderID: self.strSenderID)
                }
            }else{
                objWebServiceManager.hideIndicator()
                // objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
                
            }

//            if let result = response["result"]as? String{
//                if result == "successful"{
//                    self.isSendMessage = true
//                    self.initilizeFirstTimeOnly = false
//                   // self.call_GetChatList(strUserID: objAppShareData.UserDetail.strUserId, strSenderID: self.strSenderID)
//                }
//            }else{
//                objWebServiceManager.hideIndicator()
//               // objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
//
//            }


        } failure: { (Error) in
            print(Error)
            objWebServiceManager.hideIndicator()
        }
   }
//
    //MARK:- Delete Singhe Message
    func call_DeleteChatMsgSinle(strUserID:String, strMsgID:String){

        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }

        objWebServiceManager.showIndicator()

        let parameter = ["user_id":strUserID,
                         "message_id":strMsgID]as [String:Any]


        objWebServiceManager.requestPost(strURL: WsUrl.url_deleteChatSingleMessage, queryParams: [:], params: parameter, strCustomValidation: "", showIndicator: false) { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)

            print(response)

            if status == MessageConstant.k_StatusCode{
                self.initilizeFirstTimeOnly = false
                //self.call_GetChatList(strUserID: strUserID, strSenderID: self.strSenderID)

            }else{
                objWebServiceManager.hideIndicator()

                if (response["result"]as? String) != nil{
                    self.tblChat.displayBackgroundText(text: "no message found")
                }else{
                    objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
                }
            }
        } failure: { (Error) in
            print(Error)
            objWebServiceManager.hideIndicator()
        }
    }
//
//    //MARK:- Delete Singhe Message
//    func call_ClearConversation(strUserID:String){
//
//        if !objWebServiceManager.isNetworkAvailable(){
//            objWebServiceManager.hideIndicator()
//            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
//            return
//        }
//
//        objWebServiceManager.showIndicator()
//
//        let parameter = ["sender_id":strSenderID,//strUserID,
//                         "receiver_id":strUserID]as [String:Any]
//
//
//        objWebServiceManager.requestGet(strURL: WsUrl.url_clearConversation, params: parameter, queryParams: [:], strCustomValidation: "") { (response) in
//            objWebServiceManager.hideIndicator()
//            let status = (response["status"] as? Int)
//            let message = (response["message"] as? String)
//
//            print(response)
//
//            if (response["result"]as? String) != nil{
//                self.onBackPressed()
//            }
//
//            if status == MessageConstant.k_StatusCode{
//
//
//
//            }else{
//                objWebServiceManager.hideIndicator()
//
//                if (response["result"]as? String) != nil{
//                    self.tblChat.displayBackgroundText(text: "ningún record fue encontrado")
//                }else{
//                    objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
//                }
//            }
//        } failure: { (Error) in
//            print(Error)
//            objWebServiceManager.hideIndicator()
//        }
//    }
//}

//MARK:- CallWebservice
//extension ChatDetailViewController{
//
    func callWebserviceForSendImage(strSenderID:String,strReceiverID:String,strType:String){

        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()

            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        objWebServiceManager.showIndicator()
        self.view.endEditing(true)
        
        var dicrParam = [String:Any]()
        var imageData = [Data]()
        var imgData : Data?
        var imageParam = [String]()
        var mimeType = ""
        var fileName = ""
        
       
           
            if self.pickedImage != nil{
               // imgData = (self.pickedImage?.jpegData(compressionQuality: 1.0))!
                imgData = (self.pickedImage?.pngData())// jpegData(compressionQuality: 1.0))!
            }
            else {
                imgData = (self.imgVwUser.image?.pngData()) //jpegData(compressionQuality: 1.0))!
            }
            imageData.append(imgData!)

             imageParam = ["chat_image"]

            mimeType = "image/png"
            fileName = "chat_image"
            print(imageData)

            dicrParam = ["sender_id":strSenderID,
                             "receiver_id":strReceiverID,
                             "chat_message":"",
                             "type":strType
            ]as [String:Any]
        

   

        print(dicrParam)

        objWebServiceManager.uploadMultipartWithImagesData(strURL: WsUrl.url_insertChat, params: dicrParam, showIndicator: true, customValidation: "", imageData: imgData, imageToUpload: imageData, imagesParam: imageParam, fileName: fileName, mimeType: mimeType) { (response) in
            objWebServiceManager.hideIndicator()
            print(response)
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)


            if let result = response["result"]as? [String:Any]{
               
                    self.subVw.isHidden = true
                    self.subVwSelection.isHidden = true
                    self.sbVwMainSticker.isHidden = true

                    self.isSendMessage = true
                    self.initilizeFirstTimeOnly = false
                   // self.call_GetChatList(strUserID: objAppShareData.UserDetail.strUserId, strSenderID: self.strSenderID)
        
            }else{
                objWebServiceManager.hideIndicator()
                objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
            }

        } failure: { (Error) in
            print(Error)
        }
    }

    
    //MARK:- upload Chat Video
    
    func callWebserviceForSendVideo(strSenderID:String,strReceiverID:String,strType:String,strVidUrl:URL){

        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()

            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        objWebServiceManager.showIndicator()
        self.view.endEditing(true)

        var videoData = [Data]()
        var vidData : Data?
        
     //   if self.pickedVideo != nil{
            do {
            vidData = try Data(contentsOf: strVidUrl, options: Data.ReadingOptions.alwaysMapped)
            print(vidData)
            } catch {
                print(error)
                objWebServiceManager.hideIndicator()
                objAlert.showAlert(message: error.localizedDescription, title: "Alert", controller: self)
                return
            }
     //   }
        
        videoData.append(vidData!)

        let imageParam = ["chat_video"]

        print(videoData)

        let dicrParam = ["sender_id":strSenderID,
                         "receiver_id":strReceiverID,
                         "chat_message":"",
                         "type":strType
        ]as [String:Any]

        print(dicrParam)

        objWebServiceManager.uploadMultipartWithImagesData(strURL: WsUrl.url_insertChat, params: dicrParam, showIndicator: true, customValidation: "", imageData: vidData, imageToUpload: videoData, imagesParam: imageParam, fileName: "chat_video", mimeType: "video/mp4") { (response) in
            
            objWebServiceManager.hideIndicator()
            print(response)
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)


            if let result = response["result"]as? [String:Any]{
               
                    self.subVw.isHidden = true
                    self.subVwSelection.isHidden = true
                    self.sbVwMainSticker.isHidden = true

                    self.isSendMessage = true
                    self.initilizeFirstTimeOnly = false
                   // self.call_GetChatList(strUserID: objAppShareData.UserDetail.strUserId, strSenderID: self.strSenderID)
                
            }else{
                objWebServiceManager.hideIndicator()
                objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
            }

        } failure: { (Error) in
            print(Error)
        }
    }

    
    //================== Upload Document ================//
    
    func callWebserviceForSendDocument(strSenderID:String,strReceiverID:String,strType:String){

        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()

            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        objWebServiceManager.showIndicator()
        self.view.endEditing(true)
        
        var dicrParam = [String:Any]()
        var imageData = [Data]()
        var imgData : Data?
        var imageParam = [String]()
        var mimeType = ""
        var fileName = ""
        
            
            if self.pickedDoc != nil{
               imgData = pickedDoc
            }
            else {
                imgData = pickedDoc
            }
        print(pickedDoc)
            imageData.append(imgData!)
            
            mimeType = self.docExtension

        fileName = "file.pdf"
             imageParam = ["chat_document"]


            dicrParam = ["sender_id":strSenderID,
                             "receiver_id":strReceiverID,
                           //  "chat_document":"",
                         "sender_path":self.myDocUrl,
                             "type":strType
            ]as [String:Any]
            

        print(dicrParam)

        objWebServiceManager.uploadMultipartWithDocumentData(strURL: WsUrl.url_insertChat, params: dicrParam, showIndicator: true, customValidation: "", imageData: imgData, imageToUpload: imageData, imagesParam: imageParam, fileName: fileName, mimeType: mimeType) { (response) in
            objWebServiceManager.hideIndicator()
            print(response)
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)


            if let result = response["result"]as? [String:Any]{
               
                    self.subVw.isHidden = true
                    self.subVwSelection.isHidden = true
                    self.sbVwMainSticker.isHidden = true

                    self.isSendMessage = true
                    self.initilizeFirstTimeOnly = false
                   // self.call_GetChatList(strUserID: objAppShareData.UserDetail.strUserId, strSenderID: self.strSenderID)
        
            }else{
                objWebServiceManager.hideIndicator()
                objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
            }

        } failure: { (Error) in
            print(Error)
        }
    }


   }

//MARK:- Scroll to bottom
extension UITableView {

    func scrollToBottom(){

        DispatchQueue.main.async {
            let indexPath = IndexPath(
                row: self.numberOfRows(inSection:  self.numberOfSections-1) - 1,
                section: self.numberOfSections - 1)
            if self.hasRowAtIndexPath(indexPath: indexPath) {
                self.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }

    func scrollToTop() {

        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: 0)
            if self.hasRowAtIndexPath(indexPath: indexPath) {
                self.scrollToRow(at: indexPath, at: .top, animated: false)
           }
        }
    }

    func hasRowAtIndexPath(indexPath: IndexPath) -> Bool {
        return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfRows(inSection: indexPath.section)
    }
}


extension UIImageView {

 public func imageFromServerURL(urlString: String, PlaceHolderImage:UIImage) {

        if self.image == nil{
              self.image = PlaceHolderImage
        }

        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in

            if error != nil {
                print(error ?? "No Error")
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })

        }).resume()
    }
    
}

public extension Sequence {

    func uniq<Id: Hashable >(by getIdentifier: (Iterator.Element) -> Id) -> [Iterator.Element] {
        var ids = Set<Id>()
        return self.reduce([]) { uniqueElements, element in
            if ids.insert(getIdentifier(element)).inserted {
                return uniqueElements + CollectionOfOne(element)
            }
            return uniqueElements
        }
    }


    func uniq<Id: Hashable >(by keyPath: KeyPath<Iterator.Element, Id>) -> [Iterator.Element] {
      return self.uniq(by: { $0[keyPath: keyPath] })
   }
}

public extension Sequence where Iterator.Element: Hashable {

    var uniq: [Iterator.Element] {
        return self.uniq(by: { (element) -> Iterator.Element in
            return element
        })
    }

}


extension UIImageView {
  func enableZoom() {
    let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(startZooming(_:)))
    isUserInteractionEnabled = true
    addGestureRecognizer(pinchGesture)
  }

  @objc
  private func startZooming(_ sender: UIPinchGestureRecognizer) {
    let scaleResult = sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale)
    guard let scale = scaleResult, scale.a > 1, scale.d > 1 else { return }
    sender.view?.transform = scale
    sender.scale = 1
  }
}


extension ChatDetailViewController: FileDownloadingDelegate {
    func updateDownloadProgressWith(progress: Float) {
        // self.downloadProgressView.setProgress(progress, animated: true)
    }

    func downloadFinished(localFilePath tempFilePath: URL) {
        print("downloaded to \(tempFilePath)")
        // resave the file into your desired place using
        // let dataFromURL = NSData(contentsOf: location)
        // dataFromURL?.write(to: yourDesiredFileUrl, atomically: true)
    }

    func downloadFailed(withError error: Error) {
        // handle the error
    }
}
