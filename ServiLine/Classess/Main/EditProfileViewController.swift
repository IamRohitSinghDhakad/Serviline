//
//  EditProfileViewController.swift
//  ServiLine
//
//  Created by Rohit Singh Dhakad on 13/03/22.
//

import UIKit

class EditProfileViewController: UIViewController {
    
    @IBOutlet var tfName: UITextField!
    @IBOutlet var tfEmail: UITextField!
    @IBOutlet var tfPwd: UITextField!
    @IBOutlet var tfWebsite: UITextField!
    @IBOutlet var txtVw: RDTextView!
    @IBOutlet var lblNation: UILabel!
    @IBOutlet var lblCommunity: UILabel!
    @IBOutlet var lblProvision: UILabel!
    @IBOutlet var lblMuncipal: UILabel!
    
    @IBOutlet var imgVwUser: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnOnUpdate(_ sender: Any) {
    }
    
    @IBAction func btnOnBackHeader(_ sender: Any) {
        onBackPressed()
    }
    
    @IBAction func btnOnOpenCamera(_ sender: Any) {
        
    }
    
    @IBAction func btnOnShowPwd(_ sender: Any) {
        
    }
    @IBAction func btnOnAction(_ sender: UIButton) {
        
        switch sender.tag {
        case 0:
            print("nation")
        case 1:
            print("nation")
        case 2:
            print("nation")
        case 3:
            print("nation")
        default:
            break
        }
    }
}
