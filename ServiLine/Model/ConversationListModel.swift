//
//  ConversationListModel.swift
//  ServiLine
//
//  Created by Rohit Singh Dhakad on 27/03/22.
//

import UIKit

class ConversationListModel: NSObject {
    
    var strUserImage :String = ""
    var strChatStatus :String = ""
    var strName: String = ""
    var strLastMsg: String = ""
    var strTimeAgo : String = ""
    var strSenderID :String = ""
    var strSenderIDForChat :String = ""
    var strIsBlocked : String = ""
    var strNotificationId : String = ""
    var strMessageCount : Int = 0
    var strNotificationTitle  : String = ""
    var strNotificationUserName  : String = ""
    var strNotificationImage  : String = ""
    var isSelected : Bool = false
    
    init(dict : [String:Any]) {
        
        
        if let chat_status = dict["chat_status"] as? String{
            self.strChatStatus = chat_status
        }
        
        if let sender_id = dict["send_by"] as? String{
            self.strSenderID = sender_id
        }else if let sender_id = dict["send_by"] as? Int{
            self.strSenderID = "\(sender_id)"
        }
        
        if let no_of_message = dict["no_of_message"] as? String{
            self.strMessageCount = Int(no_of_message) ?? 0
        }else if let no_of_message = dict["no_of_message"] as? Int{
            self.strMessageCount = no_of_message
        }
        
        if let sender_id = dict["sender_id"] as? String{
            self.strSenderIDForChat = sender_id
        }else if let sender_id = dict["sender_id"] as? Int{
            self.strSenderIDForChat = "\(sender_id)"
        }
        
        if let notification_id = dict["notification_id"] as? String{
            self.strNotificationId = notification_id
        }else if let notification_id = dict["notification_id"] as? Int{
            self.strNotificationId = "\(notification_id)"
        }

        if let user_image = dict["sender_image"] as? String{
            self.strUserImage = user_image
        }
        
        if let name = dict["sender_name"] as? String{
            self.strName = name
        }
        
        if let send_by_name = dict["send_by_name"] as? String{
            self.strNotificationUserName = send_by_name
        }
        
        if let image = dict["image"] as? String{
            self.strNotificationImage = image
        }
        
        if let last_message = dict["last_message"] as? String{
            self.strLastMsg = last_message
        }
        
        if let time_ago = dict["time_ago"] as? String{
            self.strTimeAgo = time_ago
        }
        
        if let time_ago = dict["notification_title"] as? String{
            self.strNotificationTitle = time_ago
        }
        
        if let blocked = dict["blocked"] as? String{
            self.strIsBlocked = blocked
        }else  if let blocked = dict["blocked"] as? Int{
            self.strIsBlocked = "\(blocked)"
        }
        
    }
}
