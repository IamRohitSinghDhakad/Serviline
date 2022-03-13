//
//  PopUpViewController.swift
//  ServiLine
//
//  Created by Rohit Singh Dhakad on 11/03/22.
//

import UIKit

class PopUpViewController: UIViewController {

    @IBOutlet var vwContainTable: UIView!
    @IBOutlet var vwContainPopUp: UIView!
    @IBOutlet var tfSearch: UITextField!
    @IBOutlet var tblVw: UITableView!
    
    var isComingFrom = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.vwContainPopUp.isHidden = true
        self.vwContainTable.isHidden = true
        
        switch isComingFrom {
        case "1":
            self.vwContainPopUp.isHidden = false
        default:
            self.vwContainTable.isHidden = false
        }
    }
    @IBAction func btnOnDoneTable(_ sender: Any) {
       // self.navigationController?.dismiss(animated: true, completion: nil)
        onBackPressed()
    }
    
    @IBAction func btnOnOKPopUp(_ sender: Any) {
        onBackPressed()
       // self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnSelectionPopUp(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            print("user")
        default:
            print("profession")
        }
    }
    

}
