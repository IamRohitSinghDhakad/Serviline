//
//  HomeViewController.swift
//  ServiLine
//
//  Created by Rohit Singh Dhakad on 11/03/22.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet var vwHeaderBottomCorners: UIView!
    @IBOutlet var vwMsg: UIView!
    @IBOutlet var txtVw: RDTextView!
    @IBOutlet var imgVwShowHidePopUp: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.vwHeaderBottomCorners.roundedCorners(corners: [.bottomLeft, .bottomRight],  radius: 10)
    }
    

    @IBAction func btnOnOpenSideMenu(_ sender: Any) {
        self.sideMenuController?.revealMenu()
    }
    
    @IBAction func btnOnDoNotShowAgainPopUp(_ sender: Any) {
        self.imgVwShowHidePopUp.image = UIImage.init(named: "checked")
    }
    
    @IBAction func btnOnOKPopUpMsg(_ sender: Any) {
        self.vwMsg.isHidden = true
    }
    @IBAction func btnOnClickHere(_ sender: Any) {
        pushVc(viewConterlerId: "NewSectorViewController")
    }
    
    @IBAction func btnOnSend(_ sender: Any) {
        
    }
    
    @IBAction func btnOnSelectSector(_ sender: Any) {
        
    }
    @IBAction func btnOnSelectLocation(_ sender: Any) {
        self.pushVc(viewConterlerId: "SelectLocationViewController")
    }
    
}
