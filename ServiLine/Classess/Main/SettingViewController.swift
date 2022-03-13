//
//  SettingViewController.swift
//  ServiLine
//
//  Created by Rohit Singh Dhakad on 11/03/22.
//

import UIKit

class SettingViewController: UIViewController {

    @IBOutlet var tblVw: UITableView!
    
    var arrOptions = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.arrOptions = ["Contact and Suggestions", "Privacy Policy", "Condition of Use", "Cookies Policy", "Delete Profile", "About us", "Exit"]

    }
    

    @IBAction func btnOnOpenSideMenu(_ sender: Any) {
        self.sideMenuController?.revealMenu()
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
            pushVc(viewConterlerId: "WebViewShowViewController")
        case 1:
            pushVc(viewConterlerId: "WebViewShowViewController")
        case 2:
            pushVc(viewConterlerId: "WebViewShowViewController")
        case 3:
            pushVc(viewConterlerId: "WebViewShowViewController")
        case 4:
            objAlert.showAlert(message: "Are you want to delete your profile", title: "Alert", controller: self)
        case 5:
            pushVc(viewConterlerId: "WebViewShowViewController")
        default:
            pushVc(viewConterlerId: "WebViewShowViewController")
        }
    }
    
    
    
}
