//
//  OtherUserProfileViewController.swift
//  ServiLine
//
//  Created by Rohit Singh Dhakad on 12/03/22.
//

import UIKit

class OtherUserProfileViewController: UIViewController {

    @IBOutlet var vwPopUp: UIView!
    @IBOutlet var lblPopUpHeading: UILabel!
    @IBOutlet var lblMessage: UILabel!
    
    @IBOutlet var cvHgtConstant: NSLayoutConstraint!
    @IBOutlet var cvImages: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.vwPopUp.isHidden = true
        // Do any additional setup after loading the view.
    }
    @IBAction func btnOnBackHeader(_ sender: Any) {
        onBackPressed()
    }
    
    @IBAction func btnAction(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            pushVc(viewConterlerId: "RatingViewController")
        case 1:
            self.vwPopUp.isHidden = false
        case 2:
            self.vwPopUp.isHidden = false
        default:
            self.pushVc(viewConterlerId: "ReportUserViewController")
        }
    }
    
    
    @IBAction func btnOnMessage(_ sender: Any) {
        self.pushVc(viewConterlerId: "ChatDetailViewController")
    }
    
    
    @IBAction func btnOnCancelPopUp(_ sender: Any) {
        self.vwPopUp.isHidden = true
    }
    
   
    @IBAction func btnYesPopUp(_ sender: Any) {
        self.vwPopUp.isHidden = true
    }
    
}
