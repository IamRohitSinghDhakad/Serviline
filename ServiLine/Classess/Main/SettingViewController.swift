//
//  SettingViewController.swift
//  ServiLine
//
//  Created by Rohit Singh Dhakad on 11/03/22.
//

import UIKit

class SettingViewController: UIViewController {

    @IBOutlet var tblVw: UITableView!
    @IBOutlet var vwSubVw: UIView!
    
    var arrOptions = [String]()
    var userType =  String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.vwSubVw.isHidden = true
        
        userType = objAppShareData.UserDetail.strUserType
        print(userType)
        if userType == "provider" || userType == "Provider"{
            self.arrOptions = ["Contacto y sugerencias", "Política de Privacidad", "Condiciones de Uso", "Política de Cookies","Info Social, Fiscal y Jurídica", "Eliminar perfil","Membresía", "Acerca de", "Salir"]
        }else{
            self.arrOptions = ["Contacto y sugerencias", "Política de Privacidad", "Condiciones de Uso", "Política de Cookies","Info Social, Fiscal y Jurídica", "Eliminar perfil", "Acerca de", "Salir"]
        }
        
        

    }
    

    @IBAction func btnOnOpenSideMenu(_ sender: Any) {
        self.sideMenuController?.revealMenu()
    }
   
    @IBAction func btnOnYesDeleteProfile(_ sender: Any) {
        self.vwSubVw.isHidden = true
        self.pushVc(viewConterlerId: "DeleteProfileViewController")
    }
    
    @IBAction func btnOnNoDeleteProfile(_ sender: Any) {
        self.vwSubVw.isHidden = true
    }
}


extension SettingViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.arrOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell")as! SettingTableViewCell
        
        cell.lblTitle.text = self.arrOptions[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "WebViewShowViewController")as! WebViewShowViewController
            vc.strIsComingFrom = "Contacto y sugerencias"
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "WebViewShowViewController")as! WebViewShowViewController
            vc.strIsComingFrom = "Política de Privacidad"
            self.navigationController?.pushViewController(vc, animated: true)
        case 2:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "WebViewShowViewController")as! WebViewShowViewController
            vc.strIsComingFrom = "Condiciones de Uso"
            self.navigationController?.pushViewController(vc, animated: true)
        case 3:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "WebViewShowViewController")as! WebViewShowViewController
            vc.strIsComingFrom = "Política de Cookies"
            self.navigationController?.pushViewController(vc, animated: true)
        case 4:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "WebViewShowViewController")as! WebViewShowViewController
            vc.strIsComingFrom = "Info Social, Fiscal y Jurídica"
            self.navigationController?.pushViewController(vc, animated: true)
        case 5:
            self.vwSubVw.isHidden = false
        case 6:
            if userType == "provider" || userType == "Provider"{
                self.pushVc(viewConterlerId: "MembershipViewController")
            }else{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "WebViewShowViewController")as! WebViewShowViewController
                vc.strIsComingFrom = "Acerca de"
                self.navigationController?.pushViewController(vc, animated: true)
            }
           
        case 7:
            if userType == "provider" || userType == "Provider"{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "WebViewShowViewController")as! WebViewShowViewController
                vc.strIsComingFrom = "Acerca de"
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                objAlert.showAlertCallBack(alertLeftBtn: "SI", alertRightBtn: "No", title: "", message: "Quieres salir?", controller: self) {
                    exit(0)
                }
            }
         
        default:
            objAlert.showAlertCallBack(alertLeftBtn: "SI", alertRightBtn: "No", title: "", message: "Quieres salir?", controller: self) {
                exit(0)
            }
           
        }
    }
    
    
    
}
