//
//  PreguntasModel.swift
//  ServiLine
//
//  Created by Rohit Singh Dhakad on 14/12/22.
//

import UIKit

class PreguntasModel: NSObject {

    var strReason :String = ""
    var strStatus :String = ""
    var strOpponentUserID :String = ""
    var strTicketId :String = ""
    var strTimeago : String = ""
    
    
    init(dict : [String : Any]) {
        
        if let reason = dict["reason"] as? String{
            self.strReason = reason
        }
        
        if let status = dict["status"] as? String{
            self.strStatus = status
        }else if let status = dict["status"] as? Int{
            self.strStatus = "\(status)"
        }
        
        if let time_ago = dict["time_ago"] as? String{
            self.strTimeago = time_ago
        }
        
        if let ticket_id = dict["ticket_id"] as? String{
            self.strTicketId = ticket_id
        }else if let ticket_id = dict["ticket_id"] as? Int{
            self.strTicketId = "\(ticket_id)"
        }
        
    }
    
}

class PreguntasModelChatList: NSObject {
    
    var strFromAdmin :String = ""
    var strMessage :String = ""
    var strOpponentUserID :String = ""
    var strTicketId :String = ""
    var strTimeago : String = ""
    var strChatId : String = ""
    
    
    init(dict : [String : Any]) {
        
        if let message = dict["message"] as? String{
            self.strMessage = message
        }
        
        if let fromAdmin = dict["fromAdmin"] as? String{
            self.strFromAdmin = fromAdmin
        }else if let fromAdmin = dict["fromAdmin"] as? Int{
            self.strFromAdmin = "\(fromAdmin)"
        }
        
        if let time_ago = dict["time_ago"] as? String{
            self.strTimeago = time_ago
        }
        
        if let ticket_id = dict["ticket_id"] as? String{
            self.strTicketId = ticket_id
        }else if let ticket_id = dict["ticket_id"] as? Int{
            self.strTicketId = "\(ticket_id)"
        }
        
        if let id = dict["id"] as? String{
            self.strChatId = id
        }else if let id = dict["id"] as? Int{
            self.strChatId = "\(id)"
        }
        
    }
    
}
