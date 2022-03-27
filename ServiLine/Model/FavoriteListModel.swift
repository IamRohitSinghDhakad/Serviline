//
//  FavoriteListModel.swift
//  ServiLine
//
//  Created by Rohit Singh Dhakad on 27/03/22.
//

import UIKit

class FavoriteListModel: NSObject {
    
    
    var strName :String = ""
    var strUserImage :String = ""
    var strAge :String = ""
    var strOpponentUserID :String = ""
    var strBio :String = ""
    var strDOB : String = ""
    
    
    init(dict : [String : Any]) {
        
        
        if let sender_name = dict["name"] as? String{
            self.strName = sender_name
        }
        
        if let user_image = dict["user_image"] as? String{
            self.strUserImage = user_image
        }
        
        if let bio = dict["bio"] as? String{
            self.strBio = bio
        }
        
        if let age = dict["age"] as? String{
            self.strAge = age
        }else if let age = dict["age"] as? Int{
            self.strAge = "\(age)"
        }
        
        if let dob = dict["dob"] as? String{
            self.strDOB = dob
        }
        
        if let user_id = dict["user_id"] as? String{
            self.strOpponentUserID = user_id
        }else  if let user_id = dict["user_id"] as? Int{
            self.strOpponentUserID = "\(user_id)"
        }
    }

}
