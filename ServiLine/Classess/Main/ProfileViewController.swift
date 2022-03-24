//
//  ProfileViewController.swift
//  ServiLine
//
//  Created by Rohit Singh Dhakad on 11/03/22.
//

import UIKit

class ProfileViewController: UIViewController {
    
    
    @IBOutlet var vwContainButtons: UIView!
    @IBOutlet var imgVwUser: UIImageView!
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var cvImages: UICollectionView!
    @IBOutlet var lblHyperLink: UILabel!
    @IBOutlet var lblDescription: UILabel!
    @IBOutlet var cvHgtConstant: NSLayoutConstraint!
    
    //Variables
    var arrImages = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.vwContainButtons.isHidden = true
        self.cvImages.delegate = self
        self.cvImages.dataSource = self
        
            // self.arrImages = [UIImage.init(named: "bg"), UIImage.init(named: "bg")]
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let height = cvImages.collectionViewLayout.collectionViewContentSize.height
        self.cvHgtConstant.constant = height
        self.view.layoutIfNeeded()
    }
    
    @IBAction func btnOnOpenSideMenu(_ sender: Any) {
        self.sideMenuController?.revealMenu()
    }
    

    
    @IBAction func btnOnUpdateProfile(_ sender: Any) {
        self.pushVc(viewConterlerId: "EditProfileViewController")
    }
    
    @IBAction func btnOnAddImages(_ sender: Any) {
        
    }
    
}


extension ProfileViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ViewProfileCollectionViewCell", for: indexPath)as! ViewProfileCollectionViewCell
        
        
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let noOfCellsInRow = 3

        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout

        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))

        return CGSize(width: size, height: size)
    }
    
    
    
    
}
