//
//  UserImageModel.swift
//  ServiLine
//
//  Created by Rohit Singh Dhakad on 26/03/22.
//

import UIKit

class UserImageModel: NSObject {
    
    var strEntrydt :String = ""
    var strFile :String = ""
    var valLiked :Int = 0
    var valStatus :Int = 0
    var strType :String = ""
    var strUserId :String = ""
    var strUserImageId :String = ""
    var isSelected:Bool?
    
    
    init(dict : [String : Any]) {
        
        if let entrydt = dict["entrydt"] as? String{
            self.strEntrydt = entrydt
        }
        
        if let file = dict["file"] as? String{
            self.strFile = file
        }
        
        if let liked = dict["liked"] as? Int{
            self.valLiked = liked
        }
        
        if let status = dict["status"] as? Int{
            self.valStatus = status
        }
        
        if let type = dict["type"] as? String{
            self.strType = type
        }
        
        if let user_id = dict["user_id"] as? String{
            self.strUserId = user_id
        }
        
        if let user_image_id = dict["user_image_id"] as? String{
            self.strUserImageId = user_image_id
        }
        
        
    }
    
}
