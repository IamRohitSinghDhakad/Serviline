//
//  EditImageVideoViewController.swift
//  Paing
//
//  Created by Akshada on 05/06/21.
//

import UIKit
import AVKit

//enum AssetType: String {
//    case image = "image"
//    case video = "video"
//}

class EditImageVideoViewController: UIViewController,UIScrollViewDelegate {
    
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var vwPreview: UIView!
    @IBOutlet weak var imgVwPreview: UIImageView!
    @IBOutlet var scrollViewForZoom: UIScrollView!
    
    var player: AVPlayer!
    var playerViewController: AVPlayerViewController!
    
    var assetURL: URL?
    var type: AssetType?
    var isComingFrom:String?
    
    //MARK: - Override Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollViewForZoom.delegate = self
        self.scrollViewForZoom.minimumZoomScale = 1.0
        self.scrollViewForZoom.maximumZoomScale = 10.0
        // Do any additional setup after loading the view.
        self.setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.type! == .video {
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = self.vwPreview.bounds //bounds of the view in which AVPlayer should be displayed
            playerLayer.videoGravity = .resizeAspect
            self.vwPreview.layer.addSublayer(playerLayer)
            
            player.play()
        }
    }
    
    //Scroll Methods
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imgVwPreview
     }
    
    //MARK: - Setup
    func setupView() {
        self.imgVwPreview.isHidden = true
//        self.getThumbImg(model: userImgModel)
        if self.type! == .video {
            self.lblHeader.text = "Añadir Video"
            self.imgVwPreview.isHidden = true
            guard let url = assetURL else {
                return
            }
            let asset = AVAsset(url: url)
            let playerItem = AVPlayerItem(asset: asset)
            self.player = AVPlayer(playerItem: playerItem)
            
            
//            // Create an AVPlayer, passing it the HTTP Live Streaming URL.
//            self.player = AVPlayer(url: url)
//            self.playerViewController = AVPlayerViewController()
//            self.playerViewController.player = player
//            present(self.playerViewController, animated: true) {
//                self.player.play()
//            }
        }
        else {
            self.lblHeader.text = "Añadir imagen"
            self.imgVwPreview.isHidden = false
            guard let url = assetURL else {
                return
            }
            let selectedImage = UIImage(contentsOfFile: url.path)
            self.imgVwPreview.image = selectedImage
        }
        
    }
    
    //MARK: - Action Methods
    
    @IBAction func actionClose(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionSelect(_ sender: Any) {
        self.call_UploadImageVideo()
    }
    
    
}

extension EditImageVideoViewController {
    // MARK:- Get Profile
    
    func call_UploadImageVideo() {
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        
        var assetData: [Data] = []
        if self.type! == .video {
            do {
                let data = try Data(contentsOf: self.assetURL!, options: Data.ReadingOptions.alwaysMapped)
                assetData.append(data)
            } catch {
                print(error)
                objWebServiceManager.hideIndicator()
                objAlert.showAlert(message: error.localizedDescription, title: "Alert", controller: self)
                return
            }
        }
        else if self.type! == .image {
            do {
                let data = try Data(contentsOf: self.assetURL!, options: Data.ReadingOptions.alwaysMapped)
                assetData.append(data)
            } catch {
                print(error)
                objWebServiceManager.hideIndicator()
                objAlert.showAlert(message: error.localizedDescription, title: "Alert", controller: self)
                return
            }
        }
        
        if assetData.count > 0 {
            var parameter = [String:Any]()
//            let fileName = "File\(objAppShareData.UserDetail.strUserId)_\(Date().toMillis())"
            var fileName = ""
            
            
            var strUrl = ""
            if self.isComingFrom == "VidoBlog"{
                fileName = "video"
                strUrl = WsUrl.url_AddVideoBlog
                parameter = ["user_id" : objAppShareData.UserDetail.strUserId] as [String:Any]
            }else{
                fileName = "file"
                strUrl = WsUrl.url_AddUserImage
                parameter = ["user_id" : objAppShareData.UserDetail.strUserId, "type" : self.type!.rawValue] as [String:Any]
            }
            
            print(assetData)
            
            objWebServiceManager.uploadMultipartWithImagesData(strURL: strUrl, params: parameter, showIndicator: true, customValidation: "", imageData: nil, imageToUpload: assetData, imagesParam: [fileName], fileName: fileName, mimeType: (self.type! == .video) ? "video/mp4" : "image/jpeg") { (response) in
                objWebServiceManager.hideIndicator()
                let status = (response["status"] as? Int)
                let message = (response["message"] as? String)
                if status == MessageConstant.k_StatusCode {
                    
                    print(response)
                    
                    if let videoData = response["result"]as? [String:Any]{
                        DispatchQueue.main.async {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                    
                    if let userData  = response["result"] as? [[String:Any]] {
                        DispatchQueue.main.async {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                    else {
                        objWebServiceManager.hideIndicator()
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
        else {
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "Something went wrong!", title: "Alert", controller: self)
            return
        }
    }
}
