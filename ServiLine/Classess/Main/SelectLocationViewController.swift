//
//  SelectLocationViewController.swift
//  ServiLine
//
//  Created by Rohit Singh Dhakad on 13/03/22.
//

import UIKit

class SelectLocationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func btnBackOnHeader(_ sender: Any) {
        onBackPressed()
    }
    
    @IBAction func btnOnAction(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            print("Nation")
        case 1:
            print("Nation")
        case 2:
            print("Nation")
        case 3:
            print("Nation")
        default:
            break
        }
    }
    
    @IBAction func btnOnDone(_ sender: Any) {
        onBackPressed()
    }
}
