//
//  MessageSettingViewController.swift
//  ServiLine
//
//  Created by Rohit Singh Dhakad on 11/03/22.
//

import UIKit

class MessageSettingViewController: UIViewController {

    @IBOutlet var imgVwFirst: UIImageView!
    @IBOutlet var imgVwSecond: UIImageView!
    @IBOutlet var imgVwThird: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnOnOpenSideMenu(_ sender: Any) {
        self.sideMenuController?.revealMenu()
    }

    @IBAction func btnOnAction(_ sender: UIButton) {
        
        switch sender.tag {
        case 0:
            self.imgVwFirst.image = UIImage.init(named: "checkBox")
        case 1:
            self.imgVwSecond.image = UIImage.init(named: "checkBox")
        default:
            self.imgVwThird.image = UIImage.init(named: "checkBox")
        }
    }
    

}
