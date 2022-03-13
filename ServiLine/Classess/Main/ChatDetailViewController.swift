//
//  ChatDetailViewController.swift
//  Paing
//
//  Created by Rohit Singh Dhakad on 31/05/21.
//

import UIKit
import Alamofire

class ChatDetailViewController: UIViewController,UINavigationControllerDelegate,UIScrollViewDelegate {

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
    
    @IBOutlet var cvSticker: UICollectionView!
    @IBOutlet var subVwContainCV: UIView!
    @IBOutlet var subVwSelection: UIView!
    @IBOutlet var sbVwMainSticker: UIView!
    @IBOutlet var btnAddSticker: UIButton!
    
    @IBOutlet var vwContainFullImage: UIView!
    @IBOutlet var imgvwFullForDownload: UIImageView!
    @IBOutlet var btnSendSticker: UIButton!
    
    @IBOutlet var vwBlockUser: UIView!
    @IBOutlet var scrollVwFullImageDownload: UIScrollView!
    
    
    //MARK:- Variables
    var imagePicker = UIImagePickerController()
    var pickedImage:UIImage?
    
    let txtViewCommentMaxHeight: CGFloat = 100
    let txtViewCommentMinHeight: CGFloat = 34

   // var arrChatMessages = [ChatDetailModel]()
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
    
    var arrImagesSticker = [UIImage.init(named: "sone"),UIImage.init(named: "stwo"),UIImage.init(named: "sthree"),UIImage.init(named: "four"),UIImage.init(named: "five"),UIImage.init(named: "six"),UIImage.init(named: "seven"),UIImage.init(named: "eight")]
    
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
        self.subVwContainCV.isHidden = true
        
        self.vwContainFullImage.isHidden = true
        
        let profilePic = self.strUserImage
        if profilePic != "" {
            let url = URL(string: profilePic)
          //  self.imgVwUser.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "splashLogo"))
        }
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(sender:)))
        self.tblChat.addGestureRecognizer(longPress)
        
      //  self.call_GetChatList(strUserID: objAppShareData.UserDetail.strUserId, strSenderID: self.strSenderID)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
      //  self.call_GetProfile(strUserID: self.strSenderID)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        self.tblChat.scrollToBottom()
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
//            let vc = UIStoryboard(name: "UserProfile", bundle: nil).instantiateViewController(withIdentifier: "UserProfileViewController") as? UserProfileViewController
//            vc?.userID = userID
//            vc?.isComingFromChat = true
//            self.timer?.invalidate()
//            self.timer = nil
//            self.navigationController?.pushViewController(vc!, animated: true)
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
        if self.strMsgID != -1{
            
            objAlert.showAlertCallBack(alertLeftBtn: "no", alertRightBtn: "si", title: "", message: "¿Quieres borrar este mensaje?", controller: self) {
               
                self.vwContainFullImage.isHidden = true
           //     let userIDForDelete = self.arrChatMessages[self.strMsgID].strMsgIDForDelete
           //     self.call_DeleteChatMsgSinle(strUserID: objAppShareData.UserDetail.strUserId, strMsgID: userIDForDelete)
            }
        }else{
            
        }
       
    }
    
    @IBAction func btnDownloadFullImg(_ sender: Any) {
        
        if self.strSelectedImageUrl != ""{
            
            if let url = URL(string: strSelectedImageUrl),
               let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            }
            
            objAlert.showAlertCallBack(alertLeftBtn: "", alertRightBtn: "OK", title: "", message: "Imagen guardada con éxito", controller: self) {
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
      //  self.call_GetChatList(strUserID: objAppShareData.UserDetail.strUserId, strSenderID: self.strSenderID)
    }
    
    @IBAction func btnBackOnHeader(_ sender: Any) {
        self.timer?.invalidate()
        self.timer = nil
        onBackPressed()
        
    }
    @IBAction func btnOpenCamera(_ sender: Any) {
        self.setImage()
    }
    
    @IBAction func btnOpenStickerView(_ sender: Any) {
        self.subVwSelection.isHidden = true
        self.subVwContainCV.isHidden = false
    }
    @IBAction func btnOpenAudio(_ sender: Any) {
        self.subVwSelection.isHidden = true
        self.sbVwMainSticker.isHidden = true
        self.subVwContainCV.isHidden = true
    }
    
    @IBAction func btnOpenVideo(_ sender: Any) {
        self.subVwSelection.isHidden = true
        self.sbVwMainSticker.isHidden = true
        self.subVwContainCV.isHidden = true
    }
    
    @IBAction func btnAddOnSticker(_ sender: Any) {
        self.sbVwMainSticker.isHidden = false
        self.subVwSelection.isHidden = false
    }
    
    @IBAction func btnSendMessage(_ sender: Any) {
//        if (txtVwChat.text?.isEmpty)!{
//
//            self.txtVwChat.text = "."
//            self.txtVwChat.text = self.txtVwChat.text.trimmingCharacters(in: .whitespacesAndNewlines)
//            self.txtVwChat.isScrollEnabled = false
//            self.txtVwChat.frame.size.height = self.txtViewCommentMinHeight
//            self.txtVwChat.text = ""
//
//            if self.txtVwChat.text.count > 0{
//
//                self.txtVwChat.isScrollEnabled = false
//
//            }else{
//                self.txtVwChat.isScrollEnabled = false
//            }
//
//        }else{
//
//
//            self.txtVwChat.frame.size.height = self.txtViewCommentMinHeight
//            DispatchQueue.main.async {
//                let text  = self.txtVwChat.text.encodeEmoji
//                self.sendMessageNew(strText: text)
//            }
//            if self.txtVwChat.text.count > 0{
//                self.txtVwChat.isScrollEnabled = false
//
//            }else{
//                self.txtVwChat.isScrollEnabled = false
//            }
//        }
        
    }
    @IBAction func btnCloseStickerSubVw(_ sender: Any) {
        self.subVwSelection.isHidden = true
        self.sbVwMainSticker.isHidden = true
        self.subVwContainCV.isHidden = true
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

//extension ChatDetailViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return self.arrImagesSticker.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChatStickerCollectionViewCell", for: indexPath)as! ChatStickerCollectionViewCell
//
//        cell.imgVwSticker.image = self.arrImagesSticker[indexPath.row]
//
//        if self.selectedIndex == indexPath.row{
//            cell.vwBorder.borderWidth = 1
//            cell.vwBorder.borderColor = UIColor.init(named: "AppSkyBlue")
//        }else{
//            cell.vwBorder.borderWidth = 0
//            cell.vwBorder.borderColor = UIColor.clear
//        }
//
//
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        self.selectedIndex = indexPath.row
//        self.pickedImage = self.arrImagesSticker[indexPath.row]
//        self.cvSticker.reloadData()
//    }
//
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        let noOfCellsInRow = 3
//
//        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
//
//        let totalSpace = flowLayout.sectionInset.left
//            + flowLayout.sectionInset.right
//            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
//
//        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
//
//        return CGSize(width: size, height: size)
//    }
//}

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
        if let editedImage = info[.editedImage] as? UIImage {
            self.pickedImage = editedImage
            self.imgVwFull.image = self.pickedImage
            imagePicker.dismiss(animated: true, completion: nil)
        } else if let originalImage = info[.originalImage] as? UIImage {
            self.pickedImage = originalImage
            self.imgVwFull.image = pickedImage
            imagePicker.dismiss(animated: true, completion: nil)
        }
        
        self.subVw.isHidden = false
    }
    
    func cornerImage(image: UIImageView, color: UIColor ,width: CGFloat){
        image.layer.cornerRadius = image.layer.frame.size.height / 2
        image.layer.masksToBounds = false
        image.layer.borderColor = color.cgColor
        image.layer.borderWidth = width
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
           // AppSharedClass.shared.showAlert(title: "Alert", message: "Please enter some text", view: self)
            return
        }else{
         //   self.call_SendTextMessageOnly(strUserID: objAppShareData.UserDetail.strUserId, strText: strText)
           //asd self.call_WSSendMessage(strSenderID: self.getSenderID, strMessage: self.txtVwChat.text)
        }
        self.txtVwChat.text = ""
    }
    
}


//MARK:- UITableView Delegate and DataSource
extension ChatDetailViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblChat.dequeueReusableCell(withIdentifier: "ChatDetailTVCell")as! ChatDetailTVCell
        
//        let obj = self.arrChatMessages[indexPath.row]
//
//        if obj.strImageUrl != ""{
//            if obj.strSenderId == objAppShareData.UserDetail.strUserId{
//                cell.vwMyMsg.isHidden = true
//                cell.vwOpponent.isHidden = true
//                cell.vwOpponentImage.isHidden = true
//                cell.vwMyImage.isHidden = false
//
//                if obj.strType == "Sticker" || obj.strType == "sticker"{
//                    cell.vwContainImgBorderMySide.backgroundColor = .clear
//                    cell.imgVwMySide.contentMode = .scaleAspectFit
////                    cell.vwContainImgBorderMySide.isHidden = false
////                    cell.imgVwMySide.contentMode = .scaleAspectFill
//                }else{
//                    cell.vwContainImgBorderMySide.backgroundColor = UIColor.init(named: "AppSkyBlue")
//                    cell.imgVwMySide.contentMode = .scaleAspectFill
//                }
//
//                let profilePic = obj.strImageUrl
////                if profilePic != "" {
////                    let url = URL(string: profilePic)
////                    cell.imgVwopponent.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "splashLogo"), options: .refreshCached) { (image, error, cacheType, url) in
////                        if image != nil {
////                            cell.imgVwopponent.image = image
////                        }
////                        if let error = error {
////                            print("URL: \(url), error: \(error)")
////                        }
////                    }
//////                    cell.imgVwMySide.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo_square"))
////                }
//
//                cell.imgVwMySide.imageFromServerURL(urlString: profilePic, PlaceHolderImage: #imageLiteral(resourceName: "logo_square"))
//
//
//
//            }else{
//                cell.vwMyMsg.isHidden = true
//                cell.vwOpponent.isHidden = true
//                cell.vwOpponentImage.isHidden = false
//                cell.vwMyImage.isHidden = true
//
//
//                if obj.strType == "Sticker" || obj.strType == "sticker"{
//                    cell.vwContainImgBorderOpponentSide.backgroundColor = .clear
//                    cell.imgVwopponent.contentMode = .scaleAspectFit
////                    cell.vwContainImgBorderOpponentSide.isHidden = false
////                    cell.imgVwopponent.contentMode = .scaleAspectFill
//                }else{
//                    cell.vwContainImgBorderOpponentSide.backgroundColor = UIColor.init(named: "AppSkyBlue")
//                    cell.imgVwopponent.contentMode = .scaleAspectFill
//                }
//
//                let profilePic = obj.strImageUrl
//                cell.imgVwopponent.imageFromServerURL(urlString: profilePic, PlaceHolderImage: #imageLiteral(resourceName: "logo_square"))
//            }
//        }else{
//            if obj.strSenderId == objAppShareData.UserDetail.strUserId{
//                cell.vwOpponentImage.isHidden = true
//                cell.vwMyImage.isHidden = true
//                cell.vwMyMsg.isHidden = false
//                cell.lblMyMsg.text = obj.strOpponentChatMessage
//                cell.lblMyMsgTime.text = obj.strOpponentChatTime
//                cell.vwOpponent.isHidden = true
//            }else{
//                cell.vwOpponentImage.isHidden = true
//                cell.vwMyImage.isHidden = true
//                cell.lblOpponentMsg.text = obj.strOpponentChatMessage
//                cell.lblopponentMsgTime.text = obj.strOpponentChatTime
//                cell.vwOpponent.isHidden = false
//                cell.vwMyMsg.isHidden = true
//            }
//        }
//
//        cell.lblOpponentMsg.text = obj.strOpponentChatMessage
//        cell.lblopponentMsgTime.text = obj.strChatTime
//        cell.lblMyImageTime.text = obj.strChatTime
//        cell.lblOpponentImgTime.text = obj.strChatTime
//        cell.lblMyMsgTime.text = obj.strChatTime
//
//        cell.btnOpenImageOnFullviewMySide.tag = indexPath.row
//        cell.btnOpenImageOnFullviewMySide.addTarget(self, action: #selector(btnOpenImage), for: .touchUpInside)
//
//        cell.btnOpenImageOnFullViewOpponentSide.tag = indexPath.row
//        cell.btnOpenImageOnFullViewOpponentSide.addTarget(self, action: #selector(btnOpenImage), for: .touchUpInside)
        
        return cell
    }
    
    
    @objc func btnOpenImage(sender: UIButton){
        print(sender.tag)
//        self.strMsgID = sender.tag
//        let obj = self.arrChatMessages[sender.tag]
//        self.strSelectedImageUrl = obj.strImageUrl
//        let profilePic = obj.strImageUrl
//        if profilePic != "" {
//            let url = URL(string: profilePic)
//            self.imgvwFullForDownload.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo_square"))
//        }
//
//        self.vwContainFullImage.isHidden = false
    }

    
    @objc private func handleLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let touchPoint = sender.location(in: tblChat)
//            if let indexPath = tblChat.indexPathForRow(at: touchPoint) {
//                print(indexPath.row)
//                // your code here, get the row for the indexPath or do whatever you want
//
//                let type = self.arrChatMessages[indexPath.row].strType
//                if type == "Text" || type == "text"{
//                    self.openActionSheet(index: indexPath.row)
//                }
//            }
        }
    }
    
    
    
    func openActionSheet(index:Int){
        
        let actionsheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        actionsheet.addAction(UIAlertAction(title: "Eliminar mensaje", style: UIAlertAction.Style.default, handler: { (action) -> Void in
         //Delete Message
            
            objAlert.showAlertCallBack(alertLeftBtn: "no", alertRightBtn: "si", title: "", message: "¿Quieres borrar este mensaje?", controller: self) {
            //    let msgID = self.arrChatMessages[index].strMsgIDForDelete
              //  let rec_ID = self.arrChatMessages[index].strReceiverID
            //    self.call_DeleteChatMsgSinle(strUserID: objAppShareData.UserDetail.strUserId, strMsgID: msgID)
                
            }
        }))
        
        actionsheet.addAction(UIAlertAction(title: "Copiar mensaje", style: UIAlertAction.Style.default, handler: { (action) -> Void in
            //Copy Message
       //    UIPasteboard.general.string = self.arrChatMessages[index].strOpponentChatMessage
            objAlert.showAlert(message: "Texto copiado", title: "Alert", controller: self)
            
        }))
        actionsheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.destructive, handler: { (action) -> Void in
            
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
//extension ChatDetailViewController{
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
//    func call_GetChatList(strUserID:String, strSenderID:String){
//
//        if !objWebServiceManager.isNetworkAvailable(){
//            objWebServiceManager.hideIndicator()
//            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
//            return
//        }
//
//      //  objWebServiceManager.showIndicator()
//
//        let parameter = ["receiver_id":strSenderID,
//                         "sender_id":strUserID,
//                         "chat_status":self.strOnlineStatus]as [String:Any]
//
//
//        objWebServiceManager.requestGet(strURL: WsUrl.url_getChatList, params: parameter, queryParams: [:], strCustomValidation: "") { (response) in
//            objWebServiceManager.hideIndicator()
//            let status = (response["status"] as? Int)
//            let message = (response["message"] as? String)
//
//            print(response)
//
//            if status == MessageConstant.k_StatusCode{
//
//                if let dictChatStatus = response["online_status"] as? [String:Any]{
//                    if let chatStatus = dictChatStatus["chat_status"] as? String{
//                        self.lblOnLineStatus.text = chatStatus.contains("Typing") ? "Escribiendo..." : chatStatus.contains("Online") ? "En línea" : chatStatus
//                    }else{
//                        self.lblOnLineStatus.text = ""
//                    }
//                }
//
//                if let arrData  = response["result"] as? [[String:Any]] {
//                    var newArrayChatMessages: [ChatDetailModel] = []
//                    for dict in arrData {
//                        let obj = ChatDetailModel.init(dict: dict)
//                        newArrayChatMessages.append(obj)
//                    }
//
//                    if self.arrChatMessages.count == 0 {
//                        //Add initially all
//                        self.arrChatMessages.removeAll()
//                        self.tblChat.reloadData()
//
//                        for i in 0..<arrData.count{
//                            let dictdata = arrData[i]
//                            let obj = ChatDetailModel.init(dict: dictdata)
//                            self.arrChatMessages.insert(obj, at: i)
//    //
//    //                        self.arrChatMessages.append(obj)
//                            self.tblChat.insertRows(at: [IndexPath(item: i, section: 0)], with: .none)
//                        }
//                        DispatchQueue.main.async {
//                            self.tblChat.scrollToBottom()
//                        }
//
//                    }
//                    else {
//                        let previoudIds = self.arrChatMessages.map { $0.strMsgIDForDelete }
//                        let newIds = newArrayChatMessages.map { $0.strMsgIDForDelete }
//
//                        let previoudIdsSet = Set(previoudIds)
//                        let newIdsSet = Set(newIds)
//
//                        let unique = (previoudIdsSet.symmetricDifference(newIdsSet)).sorted()
//
//                        for uniqueId in unique {
//                            if previoudIds.contains(uniqueId) {
//                                //Remove the element
//                                if let idToDelete = self.arrChatMessages.firstIndex(where: { $0.strMsgIDForDelete == uniqueId }) {
//                                    self.arrChatMessages.remove(at: idToDelete)
//                                    self.tblChat.deleteRows(at: [IndexPath(item: idToDelete, section: 0)], with: .none)
//
//                                }
//                            }
//                            else if newIds.contains(uniqueId) {
//                                // Add new element
//                                let filterObj = newArrayChatMessages.filter({ $0.strMsgIDForDelete == uniqueId })
//                                if filterObj.count > 0 {
//                                    let index = self.arrChatMessages.count
//                                    self.arrChatMessages.insert(filterObj[0], at: index)
//                                    self.tblChat.insertRows(at: [IndexPath(item: index, section: 0)], with: .none)
//                                    self.tblChat.scrollToBottom()
//                                }
//
//                            }
//                        }
//
//                    }
//
//
////                    for i in 0..<self.arrChatMessages.count{
////                        self.tblChat.deleteRows(at: [IndexPath(item: i, section: 0)], with: .automatic)
////                    }
//
//
//
//
//                    if self.initilizeFirstTimeOnly == false{
//                        self.initilizeFirstTimeOnly = true
//                        self.arrCount = self.arrChatMessages.count
////                        self.tblChat.reloadData()
//                    }
//
////                    self.tblChat.scrollToBottom()
////                    if self.isSendMessage{
////                        self.isSendMessage = false
////                        self.tblChat.scrollToBottom()
////                    }
//
//                    if self.arrCount == self.arrChatMessages.count{
//
//                    }else{
////                        self.tblChat.reloadData()
//                        self.updateTableContentInset()
//                    }
//
//
//                    if self.arrChatMessages.count == 0{
//                        self.tblChat.displayBackgroundText(text: "¡Sin conversación todavía!")
//                    }else{
//                        self.tblChat.displayBackgroundText(text: "")
//                    }
//
////                    if self.isSendMessage{
////                        self.isSendMessage = false
////                        self.tblChat.scrollToBottom()
////                    }else{
////
////                    }
//
//                }
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
//
//
//    //MARK:- Send Text message Only
//
//    func call_SendTextMessageOnly(strUserID:String, strText:String){
//
//        if !objWebServiceManager.isNetworkAvailable(){
//            objWebServiceManager.hideIndicator()
//            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
//            return
//        }
//
//       // objWebServiceManager.showIndicator()
//
//        let dicrParam = ["receiver_id":self.strSenderID,//Opponent ID
//                         "sender_id":strUserID,//My ID
//                         "type":"Text",
//                         "chat_message":strText]as [String:Any]
//
//        objWebServiceManager.requestPost(strURL: WsUrl.url_insertChat, queryParams: [:], params: dicrParam, strCustomValidation: "", showIndicator: false) { (response) in
//            objWebServiceManager.hideIndicator()
//            let status = (response["status"] as? Int)
//            let message = (response["message"] as? String)
//
//            print(response)
//
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
//
//
//        } failure: { (Error) in
//            print(Error)
//            objWebServiceManager.hideIndicator()
//        }
//   }
//
//    //MARK:- Delete Singhe Message
//    func call_DeleteChatMsgSinle(strUserID:String, strMsgID:String){
//
//        if !objWebServiceManager.isNetworkAvailable(){
//            objWebServiceManager.hideIndicator()
//            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
//            return
//        }
//
//        objWebServiceManager.showIndicator()
//
//        let parameter = ["user_id":strUserID,
//                         "id":strMsgID]as [String:Any]
//
//
//        objWebServiceManager.requestGet(strURL: WsUrl.url_deleteChatSingleMessage, params: parameter, queryParams: [:], strCustomValidation: "") { (response) in
//            objWebServiceManager.hideIndicator()
//            let status = (response["status"] as? Int)
//            let message = (response["message"] as? String)
//
//            print(response)
//
//            if status == MessageConstant.k_StatusCode{
//                self.initilizeFirstTimeOnly = false
//                //self.call_GetChatList(strUserID: strUserID, strSenderID: self.strSenderID)
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
//    func callWebserviceForSendImage(strSenderID:String,strReceiverID:String,strType:String){
//
//        if !objWebServiceManager.isNetworkAvailable(){
//            objWebServiceManager.hideIndicator()
//
//            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
//            return
//        }
//        objWebServiceManager.showIndicator()
//        self.view.endEditing(true)
//
//        var imageData = [Data]()
//        var imgData : Data?
//        if self.pickedImage != nil{
//           // imgData = (self.pickedImage?.jpegData(compressionQuality: 1.0))!
//            imgData = (self.pickedImage?.pngData())// jpegData(compressionQuality: 1.0))!
//        }
//        else {
//            imgData = (self.imgVwUser.image?.pngData()) //jpegData(compressionQuality: 1.0))!
//        }
//        imageData.append(imgData!)
//
//        let imageParam = ["chat_image"]
//
//        print(imageData)
//
//        let dicrParam = ["sender_id":strSenderID,
//                         "receiver_id":strReceiverID,
//                         "chat_message":"",
//                         "type":strType
//        ]as [String:Any]
//
//        print(dicrParam)
//
//        objWebServiceManager.uploadMultipartWithImagesData(strURL: WsUrl.url_insertChat, params: dicrParam, showIndicator: true, customValidation: "", imageData: imgData, imageToUpload: imageData, imagesParam: imageParam, fileName: "chat_image", mimeType: "image/png") { (response) in
//            objWebServiceManager.hideIndicator()
//            print(response)
//            let status = (response["status"] as? Int)
//            let message = (response["message"] as? String)
//
//
//            if let result = response["result"]as? String{
//                if result == "successful"{
//                    self.subVw.isHidden = true
//                    self.subVwContainCV.isHidden = true
//                    self.subVwSelection.isHidden = true
//                    self.sbVwMainSticker.isHidden = true
//
//                    self.isSendMessage = true
//                    self.initilizeFirstTimeOnly = false
//                   // self.call_GetChatList(strUserID: objAppShareData.UserDetail.strUserId, strSenderID: self.strSenderID)
//                }
//            }else{
//                objWebServiceManager.hideIndicator()
//                objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
//            }
//
//        } failure: { (Error) in
//            print(Error)
//        }
//    }
//
//
//
//
//   }

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
