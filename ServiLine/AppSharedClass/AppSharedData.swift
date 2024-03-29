//
//  AppSharedData.swift
//  Somi
//
//  Created by Rohit Singh Dhakad on 25/03/21.
//

import UIKit


let objAppShareData : AppSharedData  = AppSharedData.sharedObject()


class AppSharedData: NSObject {

    //MARK: - Shared object
    
    private static var sharedManager: AppSharedData = {
        let manager = AppSharedData()
        return manager
    }()
    
    // MARK: - Accessors
    class func sharedObject() -> AppSharedData {
        return sharedManager
    }
    
    //MARK:- Variables
    var UserDetail = userDetailModel(dict: [:])
    var strFirebaseToken = ""
    var isFromNotification = Bool()
    var isNotificationDict = [String:Any]()
    var dictHomeLocationInfo = [String:Any]()
    var isItemPurchased = Bool()
    
    //IAP
    static let kProductMonthly = "com.ios.ServiLine_monthly_purchase"
    static let kPurchasedProductId = "kPurchasedProductId"
    
    open var isLoggedIn: Bool {
        get {
            if (UserDefaults.standard.value(forKey:  UserDefaults.KeysDefault.userInfo) as? [String : Any]) != nil {
                objAppShareData.fetchUserInfoFromAppshareData()
                return true
            }
            return false
        }
    }
    
    // MARK: - saveUpdateUserInfoFromAppshareData ---------------------
    func SaveUpdateUserInfoFromAppshareData(userDetail:[String:Any])
    {
        let outputDict = self.removeNSNull(from:userDetail)
        UserDefaults.standard.set(outputDict, forKey: UserDefaults.KeysDefault.userInfo)
        
    }
    
    // MARK: - FetchUserInfoFromAppshareData -------------------------
    func fetchUserInfoFromAppshareData()
    {
        if let userDic = UserDefaults.standard.value(forKey:  UserDefaults.KeysDefault.userInfo) as? [String : Any]{
            UserDetail = userDetailModel.init(dict: userDic)
        }
    }
    
    func removeNSNull(from dict: [String: Any]) -> [String: Any] {
        var mutableDict = dict
        let keysWithEmptString = dict.filter { $0.1 is NSNull }.map { $0.0 }
        for key in keysWithEmptString {
            mutableDict[key] = ""
            print(key)
        }
        return mutableDict
    }
    
    //MARK: - Sign Out
    
    func signOut() {
        UserDefaults.standard.removeObject(forKey: UserDefaults.KeysDefault.userInfo)
        UserDetail = userDetailModel(dict: [:])
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let vc = (UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController)!
        let navController = UINavigationController(rootViewController: vc)
        navController.isNavigationBarHidden = true
        appDelegate.window?.rootViewController = navController
    }
    
    func call_updateMembership(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            return
        }
        
        objWebServiceManager.showIndicator()
        
        
        let parameter = ["user_id":self.UserDetail.strUserId,
                         ]as [String:Any]
        print(parameter)
        
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_CompleteMembership + self.UserDetail.strUserId, queryParams: [:], params: parameter, strCustomValidation: "", showIndicator: false) { response in
            
            print(response)
            
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            
        } failure: { (Error) in
            objWebServiceManager.hideIndicator()
        }
    }
    
}
