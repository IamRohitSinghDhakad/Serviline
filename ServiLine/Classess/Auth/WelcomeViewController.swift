//
//  WelcomeViewController.swift
//  ServiLine
//
//  Created by Rohit Singh Dhakad on 14/03/22.
//

import UIKit

class WelcomeViewController: UIViewController {

    
    @IBOutlet var vwLogo: UIView!
    @IBOutlet var imgVwAnimate: UIImageView!
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.vwLogo.frame = CGRect(x: self.vwLogo.frame.origin.x, y: UIScreen.main.bounds.size.height/2, width: self.vwLogo.frame.size.width, height: self.vwLogo.frame.size.height)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Up()
    }
    
    //MARK: - Animation Methods
    
    func Up()  {
        UIView.animate(withDuration: 2.0, delay: 0, options: [.curveLinear], animations: {
            self.vwLogo.frame = CGRect(x: self.vwLogo.frame.origin.x, y: 0, width: self.vwLogo.frame.size.width, height: self.vwLogo.frame.size.height)
          //  self.imgVwAnimation.frame = CGRect(x: 0, y: 0, width: 100.0, height: 100.0)
        }) { (finished) in
            if finished {
              //  self.vwLogo.tilt()
                
                //==============XXXX===============//
                
                UIView.animate(withDuration: 1.0, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                        
                       // HERE
                    self.imgVwAnimate.transform = CGAffineTransform.identity.scaledBy(x: 1.5, y: 1.5) // Scale your image

                 }) { (finished) in
                     UIView.animate(withDuration: 2, animations: {
                       
                      self.imgVwAnimate.transform = CGAffineTransform.identity // undo in 1 seconds

                   })
                }
                
                //=============XXXX===============//
                
                
                // Repeat animation to bottom to top
                DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                    self.goToNextController()
                }
            }
        }

    }
    
    //MARK: - Redirection Methods
    func goToNextController() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if AppSharedData.sharedObject().isLoggedIn {
            let vc = (self.mainStoryboard.instantiateViewController(withIdentifier: "SideMenuController") as? SideMenuController)!
            let navController = UINavigationController(rootViewController: vc)
            navController.isNavigationBarHidden = true
            appDelegate.window?.rootViewController = navController
        }
        else {
            let vc = (self.authStoryboard.instantiateViewController(withIdentifier: "ViewController") as? ViewController)!
            let navController = UINavigationController(rootViewController: vc)
            navController.isNavigationBarHidden = true
            appDelegate.window?.rootViewController = navController
        }
    }
}

extension UIView {
    func tilt() {
        /// Plus Animation Duration
        let plusAnimationDuration : TimeInterval = 0.05
        /// Minus Animation Duration
        let minusAnimationDuration : TimeInterval = 0.05
        /// Zero Animation Duration
        let zeroAnimationDuration : TimeInterval = 0.05
        
        /// Plus Degree
        let degrees : CGFloat = 10.0
        /// Minus Degree
        let minusDegree : CGFloat = -10.0
        /// Zero Degree
        let zeroDegree : CGFloat = 0
        
        let plusRadian : CGFloat = degrees * CGFloat((Double.pi/180))
        let minusRadian : CGFloat = minusDegree * CGFloat((Double.pi/180))
        let zeroRadian : CGFloat = zeroDegree * CGFloat((Double.pi/180))
        
        /// First Animation To make View Goes clockwise
        UIView.animate(withDuration: plusAnimationDuration, animations: {
            self.transform = CGAffineTransform(rotationAngle: plusRadian)
        }) { (success) in
            /// Second Animation to make view go antiClockWise
            UIView.animate(withDuration: minusAnimationDuration, animations: {
                self.transform = CGAffineTransform(rotationAngle: minusRadian)
            }) { (success) in
                /// Second Animation to make view go antiClockWise
                UIView.animate(withDuration: zeroAnimationDuration, animations: {
                    self.transform = CGAffineTransform(rotationAngle: zeroRadian)
                })
            }
        }
    }
}
