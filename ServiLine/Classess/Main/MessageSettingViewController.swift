//
//  MessageSettingViewController.swift
//  ServiLine
//
//  Created by Rohit Singh Dhakad on 11/03/22.
//

import UIKit

class MessageSettingViewController: UIViewController {
    
    @IBOutlet var imgVwFirst: UIImageView!
    @IBOutlet var imgVwSecond: UIImageView!
    @IBOutlet var imgVwThird: UIImageView!
    
    var strNotificationStatus :String?
    var secondImageStatus = "0"
    var thirdImageStatus = "0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        self.imgVwSecond.image = UIImage.init(named: "checkBox")
        self.imgVwThird.image = UIImage.init(named: "checkBox")
        
        secondImageStatus = "0"
        thirdImageStatus = "0"
        self.imgVwThird.image = UIImage.init(named: "unchecked")
        self.imgVwSecond.image = UIImage.init(named: "unchecked")
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.call_GetProfile(strUserID: objAppShareData.UserDetail.strUserId)
    }
    
    @IBAction func btnOnOpenSideMenu(_ sender: Any) {
        self.sideMenuController?.revealMenu()
    }
    
    @IBAction func btnOnAction(_ sender: UIButton) {
        
        switch sender.tag {
        case 0:
            if self.strNotificationStatus == "0"{
                self.call_UpdateNotification(strUserID: objAppShareData.UserDetail.strUserId, strNotificationSTatus: "1")
            }else{
                self.call_UpdateNotification(strUserID: objAppShareData.UserDetail.strUserId, strNotificationSTatus: "0")
            }
        case 1:
            if  secondImageStatus == "0"{
                UserDefaults.standard.setValue(1, forKey: "isShowPopUp")
                self.imgVwSecond.image = UIImage.init(named: "checkBox")
                self.imgVwSecond.setImageColor(color: UIColor.init(named: "Pink") ?? UIColor.gray)
                secondImageStatus = "1"
            }else{
                UserDefaults.standard.setValue(0, forKey: "isShowPopUp")
                self.imgVwSecond.image = UIImage.init(named: "unchecked")
                self.imgVwSecond.setImageColor(color: UIColor.gray)
                secondImageStatus = "0"
            }
            
        default:
            
            if  thirdImageStatus == "0"{
                self.imgVwThird.image = UIImage.init(named: "checkBox")
                self.imgVwThird.setImageColor(color: UIColor.init(named: "Pink") ?? UIColor.gray)
                thirdImageStatus = "1"
                UserDefaults.standard.setValue(0, forKey: "isMakingSound")
            }else{
                self.imgVwThird.image = UIImage.init(named: "unchecked")
                self.imgVwThird.setImageColor(color: UIColor.gray)
                thirdImageStatus = "0"
                UserDefaults.standard.setValue(1, forKey: "isMakingSound")
            }        }
    }
    
    
}


extension MessageSettingViewController{
    
    
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
            
            
            if status == MessageConstant.k_StatusCode{
                
                if let user_details  = response["result"] as? [String:Any] {
                    
                    let obj = userDetailModel.init(dict: user_details)
                    
                    self.strNotificationStatus = obj.strNotificationStatus
                    
                    if obj.strNotificationStatus == "0"{
                        self.imgVwFirst.image = UIImage.init(named: "checkBox")
                        self.imgVwFirst.setImageColor(color: UIColor.init(named: "Pink")!)
                    }else{
                        self.imgVwFirst.image = UIImage.init(named: "unchecked")
                        self.imgVwFirst.setImageColor(color: UIColor.gray)
                    }
                    
                    
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
    
    
    
    
    
    //MARK:-Add Remove On Fav List
    func call_UpdateNotification(strUserID:String,strNotificationSTatus:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        
        let parameter = ["user_id":strUserID,
                         "notification_status":strNotificationSTatus]as [String:Any]
        print(parameter)
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_completeProfile, queryParams: [:], params: parameter, strCustomValidation: "", showIndicator: false) { response in
            
            print(response)
            
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            if status == MessageConstant.k_StatusCode{
                if let dictData  = response["result"] as? [String:Any]{
                    
                    let obj = userDetailModel.init(dict: dictData)
                    
                    self.strNotificationStatus = obj.strNotificationStatus
                    
                    if obj.strNotificationStatus == "0"{
                        
                        self.imgVwFirst.image = UIImage.init(named: "checkBox")
                        self.imgVwFirst.setImageColor(color: UIColor.init(named: "Pink")!)
                    }else{
                        self.imgVwFirst.image = UIImage.init(named: "unchecked")
                        self.imgVwFirst.setImageColor(color: UIColor.gray)
                    }
                }
            }else{
                if response["result"]as? String == "Any blocked users not found"{
                    //                    self.btnMessage.isHidden = false
                    //                    self.vwBlockUser.isHidden = true
                }
                objWebServiceManager.hideIndicator()
                
            }
        } failure: { (Error) in
            objWebServiceManager.hideIndicator()
        }
    }
    
    
}
