//
//  SignUpViewController.swift
//  ServiLine
//
//  Created by Rohit Singh Dhakad on 11/03/22.
//

import UIKit

class SignUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func btnOpenCamera(_ sender: Any) {
        
    }
    
    @IBAction func btnOnregister(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let vc = (self.mainStoryboard.instantiateViewController(withIdentifier: "SideMenuController") as? SideMenuController)!
        let navController = UINavigationController(rootViewController: vc)
        navController.isNavigationBarHidden = true
        appDelegate.window?.rootViewController = navController
    }
    
    /*
    func goToNextController() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if AppSharedData.sharedObject().isLoggedIn {
            let vc = (self.mainStoryboard.instantiateViewController(withIdentifier: "SideMenuController") as? SideMenuController)!
            let navController = UINavigationController(rootViewController: vc)
            navController.isNavigationBarHidden = true
            appDelegate.window?.rootViewController = navController
        }
        else {
            let vc = (self.authStoryboard.instantiateViewController(withIdentifier: "WelcomeViewController") as? WelcomeViewController)!
            let navController = UINavigationController(rootViewController: vc)
            navController.isNavigationBarHidden = true
            appDelegate.window?.rootViewController = navController
        }
    }
     */
    
    @IBAction func btnOnUserSelection(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PopUpViewController") as! PopUpViewController
        vc.isComingFrom = "1"
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func btnOnPresentOptions(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PopUpViewController") as! PopUpViewController
        vc.isComingFrom = "2"
        switch sender.tag {
        case 0:
            print("Nation is ")
        case 1:
            print("Community is ")
        case 2:
            print("Province is ")
        case 3:
            print("Muncipal City is ")
        case 4:
            print("Service sector is ")
        default:
            break
        }
        self.navigationController?.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
       
    }
    
    @IBAction func btnOnLogin(_ sender: Any) {
        onBackPressed()
    }
    
}
