//
//  AppDelegate.swift
//  ServiLine
//
//  Created by Rohit Singh Dhakad on 10/03/22.
//

import UIKit
import IQKeyboardManagerSwift
import Firebase
import FirebaseMessaging
import UserNotifications
import TPVVInLibrary



let ObjAppdelegate = UIApplication.shared.delegate as! AppDelegate
@main

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var navController: UINavigationController?
    
    private static var AppDelegateManager: AppDelegate = {
        let manager = UIApplication.shared.delegate as! AppDelegate
        return manager
    }()
    // MARK: - Accessors
    class func AppDelegateObject() -> AppDelegate {
        return AppDelegateManager
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let deviceID = UIDevice.current.identifierForVendor!.uuidString
        UserDefaults.standard.setValue(deviceID, forKey: UserDefaults.Keys.strVenderId)
        print(deviceID)
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        FirebaseApp.configure()
        self.registerForRemoteNotification()
        Messaging.messaging().delegate = self
        
        TPVVConfiguration.shared.appLicense = "vjqzC1kU9RuWP0Q3OXzO"
        
        TPVVConfiguration.shared.appEnviroment = EnviromentType.Test
        
        TPVVConfiguration.shared.appFuc = "356431767"
        
        TPVVConfiguration.shared.appTerminal = "001"
        
        TPVVConfiguration.shared.appCurrency = "978"
        
        
        
        /*
         Usuario: 356431767
         Password: prueba2022
         Número de Comercio (Ds_Merchant_MerchantCode): 356431767
         Número de Terminal (Ds_Merchant_Terminal): 001
         Moneda del Terminal (Ds_Merchant_Currency): 978
         Clave secreta de encriptación: sq7HjrUOBfKmC576ILgskD5srU870gJ7
         Empresa Bobili-Bobili Solutions Número comercio 356431767
         */
        
        (UIApplication.shared.delegate as? AppDelegate)?.self.window = window
        
        self.settingRootController()
        
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }

}

//Manage AutoLogin
extension AppDelegate {
    
    func LoginNavigation(){
        let sb = UIStoryboard(name: "Main", bundle: Bundle.main)
        navController = sb.instantiateViewController(withIdentifier: "LoginNav") as? UINavigationController
        self.window?.rootViewController = navController
        self.window?.makeKeyAndVisible()
    }
    
    func HomeNavigation() {
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyboard.instantiateViewController(withIdentifier: "Reveal")
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
    }
    
//    func settingRootController() {
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        /*let vc */ navController = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "AuthNav") as? UINavigationController
//        appDelegate.window?.rootViewController = navController
//        self.window?.makeKeyAndVisible()
//
//    }
    
    func settingRootController() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let vc = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
        //        let navController = UINavigationController(rootViewController: setViewController)
        appDelegate.window?.rootViewController = vc
    }
    
}


//MARK:- notification setup
extension AppDelegate:UNUserNotificationCenterDelegate{
    
    func registerForRemoteNotification() {
        // iOS 10 support
        if #available(iOS 10, *) {
            let authOptions : UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options:authOptions){ (granted, error) in
                UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
                Messaging.messaging().delegate = self
                let deafultCategory = UNNotificationCategory(identifier: "CustomSamplePush", actions: [], intentIdentifiers: [], options: [])
                let center = UNUserNotificationCenter.current()
                center.setNotificationCategories(Set([deafultCategory]))
            }
        }else {
            
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        UIApplication.shared.registerForRemoteNotifications()
        NotificationCenter.default.addObserver(self, selector:
            #selector(tokenRefreshNotification), name:
                                                Notification.Name.MessagingRegistrationTokenRefreshed, object: nil)
    }
}

//MARK: - FireBase Methods / FCM Token
extension AppDelegate : MessagingDelegate{
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        objAppShareData.strFirebaseToken = fcmToken ?? ""
    }

    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        objAppShareData.strFirebaseToken = fcmToken
        ConnectToFCM()
    }
    
    @objc func tokenRefreshNotification(_ notification: Notification) {
        
        Messaging.messaging().token  { (token, error) in
            if let error = error {
                print("Error fetching remote instange ID: \(error)")
            }else if let token = token {
                print("Remote instance ID token: \(token)")
               // objAppShareData.strFirebaseToken = result.token
                print("objAppShareData.firebaseToken = \(token)")
            }
        }
        // Connect to FCM since connection may have failed when attempted before having a token.
        ConnectToFCM()
    }
    
    func ConnectToFCM() {
        
        Messaging.messaging().token { token, error in
            
            if let error = error {
                print("Error fetching remote instange ID: \(error)")
            }else if let token = token {
                print("Remote instance ID token: \(token)")
             //   objAppShareData.strFirebaseToken = result.token
                print("objAppShareData.firebaseToken = \(token)")
            }
        }
    }
    

    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        if let userInfo = notification.request.content.userInfo as? [String : Any]{
        print(userInfo)

            //Update BadgeCount
            if let badgeCount = UserDefaults.standard.value(forKey: "badge")as? Int{
                let newCount  = badgeCount + 1
                UserDefaults.standard.setValue(newCount, forKey: "badge")
            }else{
                UserDefaults.standard.setValue(1, forKey: "badge")
            }
            
            
         //   objAppShareData.notificationDict = userInfo
//            self.navWithNotification(type: notificationType, bookingID: bookingID)
        }
        var notiStatus = Int()
        var notiSoundStatus = Int()
        if let status = UserDefaults.standard.value(forKey: "isShowPopUp")as? Int{
            notiStatus = status
        }
        
        if let statusSound = UserDefaults.standard.value(forKey: "isMakingSound")as? Int{
            notiSoundStatus = statusSound
        }
        
        
        if notiStatus == 1{
            completionHandler([])
        }else{
            if notiSoundStatus == 0{
                completionHandler([.alert,.badge])
            }else{
                completionHandler([.alert,.sound,.badge])
            }
        }
    }
    
    
    
    func navWithNotification(type:String,bookingID:String){

    }

    //TODO: called When you tap on the notification in background
   @available(iOS 10.0, *)
   func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: () -> Void) {
       print(response)
       switch response.actionIdentifier {
       case UNNotificationDismissActionIdentifier:
           print("Dismiss Action")
       case UNNotificationDefaultActionIdentifier:
           print("Open Action")
           if let userInfo = response.notification.request.content.userInfo as? [String : Any]{
               print(userInfo)
               self.handleNotificationWithNotificationData(dict: userInfo)
           }
       case "Snooze":
           print("Snooze")
       case "Delete":
           print("Delete")
       default:
           print("default")
       }
       completionHandler()
   }
    
    func handleNotificationWithNotificationData(dict:[String:Any]){
        print(dict)
        let userID = dict["gcm.notification.user_request_id"]as? String ?? ""
        print(userID)
      //  objAppShareData.isFromNotification = true
       // objAppShareData.userReqID = dict["gcm.notification.user_request_id"] as? String ?? "0"
    //    self.HomeNavigation()
        
//        var strType = ""
//        var bookingID = ""
//        if let notiType = dict["notification_type"] as? String{
//            strType = notiType
//        }
//        if let type = dict["type"] as? Int{
//            strType = String(type)
//        }else if let type = dict["type"] as? String{
//            strType = type
//        }
//
//        if let id = dict["reference_id"] as? Int{
//            bookingID = String(id)
//        }else if let id = dict["reference_id"] as? String{
//            bookingID = id
//        }
//        objAppShareData.notificationDict = dict
//        objAppShareData.isFromNotification = true
//        objAppShareData.notificationType = strType
//        self.homeNavigation(animated: false)
    }
    
    func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
    
}

public extension UIWindow {
    
    var visibleViewController: UIViewController? {
        
        return UIWindow.getVisibleViewControllerFrom(vc: self.rootViewController)
        
    }
    
    static func getVisibleViewControllerFrom(vc: UIViewController?) -> UIViewController? {
        
        if let nc = vc as? UINavigationController {
            
            return UIWindow.getVisibleViewControllerFrom(vc: nc.visibleViewController)
            
        } else if let tc = vc as? UITabBarController {
            
            return UIWindow.getVisibleViewControllerFrom(vc: tc.selectedViewController)
            
        } else {
            
            if let pvc = vc?.presentedViewController {
                
                return UIWindow.getVisibleViewControllerFrom(vc: pvc)
                
            } else {
                
                return vc
                
            }
            
        }
        
    }
    
}
