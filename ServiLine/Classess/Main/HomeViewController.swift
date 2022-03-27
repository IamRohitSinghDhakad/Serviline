//
//  HomeViewController.swift
//  ServiLine
//
//  Created by Rohit Singh Dhakad on 11/03/22.
//

import UIKit

class HomeViewController: UIViewController, GetLocationProtocol {
 
    @IBOutlet var vwHeaderBottomCorners: UIView!
    @IBOutlet var vwMsg: UIView!
    @IBOutlet var lblSelectedSector: UILabel!
    @IBOutlet var lblLocation: UILabel!
    @IBOutlet var txtVw: RDTextView!
    @IBOutlet var imgVwShowHidePopUp: UIImageView!
    
    var strSectorID = ""
    
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
        let sb = UIStoryboard.init(name: "Auth", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "PopUpViewController")as! PopUpViewController
        vc.isComingFrom = "6"
        vc.closerForSelectionTable = { dict
            in
            print(dict)
            if dict.count != 0{
                
                self.lblSelectedSector.text = dict["Sector"]as? String
                self.strSectorID = dict["Sector_id"]as? String ?? ""
            }
        }
        
        if #available(iOS 13.0, *) {
            self.isModalInPresentation = true // available in IOS13
        }
        self.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true,completion: nil)
    }
    
    @IBAction func btnOnSelectLocation(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectLocationViewController")as! SelectLocationViewController
        vc.getLocationDelegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func getLocationDetails(strLocation: String) {
        self.lblLocation.text = strLocation
    }
}
