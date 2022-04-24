//
//  ShowImageFullViewController.swift
//  ServiLine
//
//  Created by Rohit Singh Dhakad on 09/04/22.
//

import UIKit
import SDWebImage

class ShowImageFullViewController: UIViewController {
    

    @IBOutlet var imgVwFull: UIImageView!
    
    var strImageUrl : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let profilePic = strImageUrl
        if profilePic != "" {
            let url = URL(string: profilePic)
            self.imgVwFull.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo"))
        }

    }
    
    
    @IBAction func btnBackOnHeader(_ sender: Any) {
        self.onBackPressed()
    }
    
    
}
