//
//  NewSectorViewController.swift
//  ServiLine
//
//  Created by Rohit Singh Dhakad on 13/03/22.
//

import UIKit

class NewSectorViewController: UIViewController {

    @IBOutlet var imgVwUser: UIImageView!
    @IBOutlet var txtVw: RDTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

   
    @IBAction func btnOnBackHeader(_ sender: Any) {
        onBackPressed()
    }
    
    
    @IBAction func btnOnSend(_ sender: Any) {
        
    }
    
}
