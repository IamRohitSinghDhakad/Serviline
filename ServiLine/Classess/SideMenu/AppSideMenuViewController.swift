//
//  AppSideMenuViewController.swift
//  Paing
//
//  Created by Akshada on 21/05/21.
//

import UIKit
import SDWebImage

class SideMenuOptions: Codable {
    var menuName: String = ""
    var menuImageName: String = ""
    var menuSelectedImageName: String = ""
    init(menuName: String, menuImageName: String, menuSelectedImageName: String) {
        self.menuName = menuName
        self.menuImageName = menuImageName
        self.menuSelectedImageName = menuSelectedImageName
    }
}

class Preferences {
    static let shared = Preferences()
    var enableTransitionAnimation = false
}

class AppSideMenuViewController: UIViewController {
    
    @IBOutlet var imgVwUser: UIImageView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var selectionMenuTrailingConstraint: NSLayoutConstraint!
    
    var selectedIndexpath = 0
    var strBadgeCount : Int?
    var strBadgeCountForTicket : Int?
    
    private let menus: [SideMenuOptions] = [SideMenuOptions(menuName: "Inicio", menuImageName: "home", menuSelectedImageName: "home_selected"),
                                            SideMenuOptions(menuName: "Perfil", menuImageName: "profile", menuSelectedImageName: "user_selected"),
                                            SideMenuOptions(menuName: "Mensajes", menuImageName: "msh", menuSelectedImageName: "chat_selected"),
                                            SideMenuOptions(menuName: "Favoritos", menuImageName: "favorite", menuSelectedImageName: "afilication_selected"),
                                            SideMenuOptions(menuName: "Notificaciones", menuImageName: "noti", menuSelectedImageName: "lock_selected"),
                                            SideMenuOptions(menuName: "Bloqueados", menuImageName: "blocked", menuSelectedImageName: "noti_selected"),
                                            SideMenuOptions(menuName: "Ajuste Mensajes", menuImageName: "setting_msg", menuSelectedImageName: "setting_selected"),
                                            SideMenuOptions(menuName: "Denunciados", menuImageName: "report", menuSelectedImageName: "blog_selected"),
                                            SideMenuOptions(menuName: "Info", menuImageName: "adjust", menuSelectedImageName: "top2"),
                                            SideMenuOptions(menuName: "Preguntas", menuImageName: "support_ticket", menuSelectedImageName: "top2"),
                                            SideMenuOptions(menuName: "Cerrar sesión", menuImageName: "logout", menuSelectedImageName: "logout_selected")]
    
    
    //MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        configureView()
        
        // Along with auto layout, these are the keys for enabling variable cell height
        tableView.estimatedRowHeight = 60.0
       // tableView.rowHeight = UITableView.automaticDimension
        
        controllerMenuSetup()
    
        sideMenuController?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let badgeCount = UserDefaults.standard.value(forKey: "badge")as? Int{
            self.strBadgeCount = badgeCount
        }
        
        if let badgeCountForTicket = UserDefaults.standard.value(forKey: "badgeTicket")as? Int{
            self.strBadgeCountForTicket = badgeCountForTicket
        }
                
        let profilePic = objAppShareData.UserDetail.strProfilePicture
        if profilePic != "" {
            let url = URL(string: profilePic)
            self.imgVwUser.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo"))
        }
        
        self.lblName.text = objAppShareData.UserDetail.strUserName
        
        self.tableView.updateRow(row: 4)
        self.tableView.updateRow(row: 9)
        
//        if let badgeCount = UserDefaults.standard.value(forKey: "badge")as? Int{
//            
//            if badgeCount != 0{
//                self.strBadgeCount = "\(badgeCount)"
//                print(badgeCount)
//                //cell.lblBadgeCount.isHidden = false
//                
//            }else{
//                print(badgeCount)
//                self.strBadgeCount = "\(badgeCount)"
//                //cell.lblBadgeCount.isHidden = true
//                self.tableView.updateRow(row: 5)
//            }
//        }else{
//            //cell.lblBadgeCount.isHidden = true
//           // self.tableView.updateRow(row: 5)
//        }

    }
    
    private func controllerMenuSetup() {
        sideMenuController?.cache(viewControllerGenerator: {
            self.storyboard?.instantiateViewController(withIdentifier: "ContentNavigation")
        }, with: "0")
        
        sideMenuController?.cache(viewControllerGenerator: {
            self.storyboard?.instantiateViewController(withIdentifier: "ProfileNavigation")
        }, with: "1")
        
        sideMenuController?.cache(viewControllerGenerator: {
            self.storyboard?.instantiateViewController(withIdentifier: "MessageNavigation")
        }, with: "2")
        
        sideMenuController?.cache(viewControllerGenerator: {
            self.storyboard?.instantiateViewController(withIdentifier: "FavoriteNavigation")
        }, with: "3")
        
        sideMenuController?.cache(viewControllerGenerator: {
            self.storyboard?.instantiateViewController(withIdentifier: "NotificationNavigation")
        }, with: "4")
        
        sideMenuController?.cache(viewControllerGenerator: {
            self.storyboard?.instantiateViewController(withIdentifier: "BlockedNavigation")
        }, with: "5")
        
        sideMenuController?.cache(viewControllerGenerator: {
            self.storyboard?.instantiateViewController(withIdentifier: "MessageSetting")
        }, with: "6")
        
        sideMenuController?.cache(viewControllerGenerator: {
            self.storyboard?.instantiateViewController(withIdentifier: "ReportNavigation")
        }, with: "7")
        sideMenuController?.cache(viewControllerGenerator: {
            self.storyboard?.instantiateViewController(withIdentifier: "SettingNavigation")
        }, with: "8")
        sideMenuController?.cache(viewControllerGenerator: {
            self.storyboard?.instantiateViewController(withIdentifier: "PreguntasNavigation")
        }, with: "9")
        
    }
    
    private func configureView() {
        SideMenuController.preferences.basic.menuWidth = view.frame.width * 0.7
        let sidemenuBasicConfiguration = SideMenuController.preferences.basic
        let showPlaceTableOnLeft = (sidemenuBasicConfiguration.position == .under) != (sidemenuBasicConfiguration.direction == .right)
        if showPlaceTableOnLeft {
            selectionMenuTrailingConstraint.constant = SideMenuController.preferences.basic.menuWidth - view.frame.width
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let sideMenuBasicConfiguration = SideMenuController.preferences.basic
        let showPlaceTableOnLeft = (sideMenuBasicConfiguration.position == .under) != (sideMenuBasicConfiguration.direction == .right)
        selectionMenuTrailingConstraint.constant = showPlaceTableOnLeft ? SideMenuController.preferences.basic.menuWidth - size.width : 0
        view.layoutIfNeeded()
    }
    
}

extension AppSideMenuViewController: SideMenuControllerDelegate {
    func sideMenuController(_ sideMenuController: SideMenuController,
                            animationControllerFrom fromVC: UIViewController,
                            to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return BasicTransitionAnimator(options: .transitionFlipFromLeft, duration: 0.6)
    }
    
    func sideMenuController(_ sideMenuController: SideMenuController, willShow viewController: UIViewController, animated: Bool) {
        print("[Example] View controller will show [\(viewController)]")
    }
    
    func sideMenuController(_ sideMenuController: SideMenuController, didShow viewController: UIViewController, animated: Bool) {
        print("[Example] View controller did show [\(viewController)]")
    }
    
    func sideMenuControllerWillHideMenu(_ sideMenuController: SideMenuController) {
        print("[Example] Menu will hide")
    }
    
    func sideMenuControllerDidHideMenu(_ sideMenuController: SideMenuController) {
        print("[Example] Menu did hide.")
    }
    
    func sideMenuControllerWillRevealMenu(_ sideMenuController: SideMenuController) {
        print("[Example] Menu will reveal.")
    }
    
    func sideMenuControllerDidRevealMenu(_ sideMenuController: SideMenuController) {
        print("[Example] Menu did reveal.")
    }
}

extension AppSideMenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }
    
    // swiftlint:disable force_cast
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppSideMenuTableViewCell", for: indexPath) as! AppSideMenuTableViewCell
        
        cell.lblBadgeCount.isHidden = true
        
        switch indexPath.row {
        case 4:
            if self.strBadgeCount != 0 {
                if self.strBadgeCount == nil{
                    cell.lblBadgeCount.isHidden = true
                }else{
                    cell.lblBadgeCount.isHidden = false
                    cell.lblBadgeCount.text = "\(self.strBadgeCount ?? 1)"
                }
            }else{
                cell.lblBadgeCount.isHidden = true
            }
        case 9:
            if self.strBadgeCountForTicket != 0 {
                if self.strBadgeCountForTicket == nil{
                    cell.lblBadgeCount.isHidden = true
                }else{
                    cell.lblBadgeCount.isHidden = false
                    cell.lblBadgeCount.text = "\(self.strBadgeCountForTicket ?? 1)"
                }
            }else{
                cell.lblBadgeCount.isHidden = true
            }
        default:
            break
        }
       /*
        if indexPath.row == 4{
            if self.strBadgeCount != 0 {
                if self.strBadgeCount == nil{
                    cell.lblBadgeCount.isHidden = true
                }else{
                    cell.lblBadgeCount.isHidden = false
                    cell.lblBadgeCount.text = "\(self.strBadgeCount ?? 1)"
                }
            }else{
                cell.lblBadgeCount.isHidden = true
            }
        }
        
        if indexPath.row == 9{
            if self.strBadgeCountForTicket != 0 {
                if self.strBadgeCountForTicket == nil{
                    cell.lblBadgeCount.isHidden = true
                }else{
                    cell.lblBadgeCount.isHidden = false
                    cell.lblBadgeCount.text = "\(self.strBadgeCountForTicket ?? 1)"
                }
            }else{
                cell.lblBadgeCount.isHidden = true
            }
        }
        */
        cell.menuImage.image = UIImage(named: menus[indexPath.row].menuImageName)
        cell.menuName.text = menus[indexPath.row].menuName
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        
        self.selectedIndexpath = row
        
        if row == 10 {
            sideMenuController?.hideMenu()
            
            objAlert.showAlertCallBack(alertLeftBtn: "SI", alertRightBtn: "NO", title: "Cerrar sesión?", message: "De verdad quieres Cerrar sesión?", controller: self) {
               // self.call_WSLogout(strUserID: objAppShareData.UserDetail.strUserId)
                AppSharedData.sharedObject().signOut()
            }
            
        }
        else {
            sideMenuController?.setContentViewController(with: "\(row)", animated: Preferences.shared.enableTransitionAnimation)
            sideMenuController?.hideMenu()
            
            if let identifier = sideMenuController?.currentCacheIdentifier() {
                print("[Example] View Controller Cache Identifier: \(identifier)")
            }
        }
        
        self.tableView.reloadData()
    }
}

extension AppSideMenuViewController{
    
    //MARK:- Call WebService
    
    func call_WSLogout(strUserID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
    
        objWebServiceManager.showIndicator()
        
        let dicrParam = ["user_id":strUserID,
                        ]as [String:Any]
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_Logout, params: dicrParam, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            if status == MessageConstant.k_StatusCode{
                
                AppSharedData.sharedObject().signOut()
                
            }else{
                objWebServiceManager.hideIndicator()
                objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
            }
           
        } failure: { (Error) in
            print(Error)
            objWebServiceManager.hideIndicator()
        }
   }
    
}

extension UITableView
{
    func updateRow(row: Int, section: Int = 0)
    {
        let indexPath = IndexPath(row: row, section: section)
        
        self.beginUpdates()
        self.reloadRows(at: [indexPath], with: .automatic)
        self.endUpdates()
    }
    
}
