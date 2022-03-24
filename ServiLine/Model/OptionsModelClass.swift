//
//  OptionsModelClass.swift
//  ServiLine
//
//  Created by Rohit Singh Dhakad on 23/03/22.
//

import UIKit

class OptionsModelClass: NSObject {
    
    var strName:String = ""
    var strID:String = ""
    
    init(dict : [String:Any]) {
        
        if let name = dict["name"] as? String{
            self.strName = name
        }
        
        if let id = dict["id"] as? String{
            self.strID = id
        }else  if let id = dict["id"] as? Int{
            self.strID = "\(id)"
        }
    }

}
