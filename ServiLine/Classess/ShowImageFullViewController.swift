//
//  ShowImageFullViewController.swift
//  ServiLine
//
//  Created by Rohit Singh Dhakad on 09/04/22.
//

import UIKit
import SDWebImage

class ShowImageFullViewController: UIViewController, UIScrollViewDelegate {
    

    @IBOutlet var scrollVw: UIScrollView!
    @IBOutlet var imgVwFull: UIImageView!
    
    var strImageUrl : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollVw.delegate = self
        self.scrollVw.minimumZoomScale = 1.0
        self.scrollVw.maximumZoomScale = 10.0
        
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


extension ShowImageFullViewController {
   func viewForZooming(in scrollView: UIScrollView) -> UIView? {
       return imgVwFull
}
}
