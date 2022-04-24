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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.vwSubVw.isHidden = true
        
        self.arrOptions = ["Contact and Suggestions", "Privacy Policy", "Condition of Use", "Cookies Policy", "Delete Profile", "About us", "Exit"]

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
            vc.strIsComingFrom = "Contact and Suggestion"
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "WebViewShowViewController")as! WebViewShowViewController
            vc.strIsComingFrom = "Privacy Check"
            self.navigationController?.pushViewController(vc, animated: true)
        case 2:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "WebViewShowViewController")as! WebViewShowViewController
            vc.strIsComingFrom = "Condition Of Use"
            self.navigationController?.pushViewController(vc, animated: true)
        case 3:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "WebViewShowViewController")as! WebViewShowViewController
            vc.strIsComingFrom = "Cookies Privacy"
            self.navigationController?.pushViewController(vc, animated: true)
        case 4:
            self.vwSubVw.isHidden = false
        case 5:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "WebViewShowViewController")as! WebViewShowViewController
            vc.strIsComingFrom = "About Us"
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            objAlert.showAlertCallBack(alertLeftBtn: "Yes", alertRightBtn: "No", title: "", message: "Are you sure you want to exit?", controller: self) {
                exit(0)
            }
           
        }
    }
    
    
    
}
