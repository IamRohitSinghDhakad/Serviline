//
//  SignUpModel.swift
//
//  Created by Rohit Singh Dhakad on 25/03/21.
//

import UIKit

class SignUpModel: NSObject {

    var strName           : String = ""
    var strEmail          : String = ""
    var strPassword       : String = ""
    var strConfirmPassword : String = ""
    var strPhoneNo        : String = ""
    var strDialCode        : String = ""
    var strCountryCode    : String = ""
    var strDeviceToken    : String = ""
}

class userDetailModel: NSObject {
    var straAuthToken          : String = ""
  
   
    var strDeviceId            : String = ""
    var strDeviceTimeZone        : String = ""
    var strDeviceType          : String = ""
    var strDeviceToken           : String = ""
    
    var strEmail                : String = ""
    var strName                  : String = ""
    var strPassword             : String = ""
    var strPhoneNumber          : String = ""
    var strProfilePicture     : String = ""
    var strSocialId           : String = ""
    var strSocialType          : String = ""
    var strStatus            : String = ""
    var strUserId               : String = ""
    var strUserName             : String = ""
    
    var strlatitude :String = ""
    var strlongitude :String = ""
    var strAddress :String = ""
    var strDob    :String = ""
    var strGender    :String = ""
    var strCity      :String = ""
    var strState      :String = ""
    var strCountry      :String = ""
    var strLookingFor      :String = ""
    var strAge      :String = ""
    
    var strAboutMe :String = ""
    var strSpecialInstruction :String = ""
    var strHairColor :String = ""
    var strAllowSex :String = ""
    var strAllowCountry :String = ""
    var strAllowCity :String = ""
    var strAllowState :String = ""
    var strCinema :String = ""
    var strEye :String = ""
    var strHeight :String = ""
    var strMusic :String = ""
    var strSkinTone :String = ""
    var strSport :String = ""
    var strRelStatus: String = ""
    var valLikedStatus: Int = 0
    var valBlockedStatus: Int = 0
    var strBlockedBy: String = ""
    var strVisibilityStatus: String = ""
    var strMembershipStats:String = ""
    
    init(dict : [String:Any]) {
        
        if let userID = dict["user_id"] as? String{
            self.strUserId = userID
        }else if let userID = dict["user_id"] as? Int{
            self.strUserId = "\(userID)"
        }
        
        if let age = dict["age"] as? String{
            self.strAge = age
        }else if let age = dict["age"] as? Int{
            self.strAge = "\(age)"
        }
        
        if let username = dict["name"] as? String{
            self.strUserName = username.decodeEmoji
        }
        
        if let strMembership = dict["has_membership"] as? String{
            self.strMembershipStats = strMembership
        }else if let strMembership = dict["has_membership"] as? Int{
            self.strMembershipStats = "\(strMembership)"
        }
        
        
        
        if let password = dict["password"] as? String{
            self.strPassword = password
        }
        
        if let short_bio = dict["short_bio"] as? String{
            self.strAboutMe = short_bio.decodeEmoji
        }
      
        
        if let hairColor = dict["hair"] as? String{
            self.strHairColor = hairColor.decodeEmoji
        }
        
        if let skin = dict["skin"] as? String{
            self.strSkinTone = skin.decodeEmoji
        }
        
        if let sport = dict["sport"] as? String{
            self.strSport = sport.decodeEmoji
        }
        
        if let music = dict["music"] as? String{
            self.strMusic = music.decodeEmoji
        }
        
        if let name = dict["name"] as? String{
            self.strName = name.decodeEmoji
        }
        
        if let email = dict["email"] as? String{
            self.strEmail = email
        }
        
        if let address = dict["address"] as? String{
            self.strAddress = address.decodeEmoji
        }
        
        if let allow_sex = dict["allow_sex"] as? String{
            self.strAllowSex = allow_sex
        }else if let allow_sex = dict["allow_sex"] as? Int{
            self.strAllowSex = "\(allow_sex)"
        }
        
        if let allow_country = dict["allow_country"] as? String{
            self.strAllowCountry = allow_country
        }else if let allow_country = dict["allow_country"] as? Int{
            self.strAllowCountry = "\(allow_country)"
        }
        
        if let allow_city = dict["allow_city"] as? String{
            self.strAllowCity = allow_city
        }else if let allow_city = dict["allow_city"] as? Int{
            self.strAllowCity = "\(allow_city)"
        }
        
        if let allow_state = dict["allow_state"] as? String{
            self.strAllowState = allow_state
        }else if let allow_state = dict["allow_state"] as? Int{
            self.strAllowState = "\(allow_state)"
        }
        
        
        if let height = dict["height"] as? String{
            self.strHeight = height
        }
        
        
        if let looking_for = dict["looking_for"] as? String{
            self.strLookingFor = looking_for
        }
        
        if let cinema = dict["cinema"] as? String{
            self.strCinema = cinema
        }
        
        if let eye = dict["eye"] as? String{
            self.strEye = eye
        }
        
        if let highlight_info = dict["highlight_info"] as? String{
            self.strSpecialInstruction = highlight_info
        }
        
        
        
        
        if let country = dict["country"] as? String{
            self.strCountry = country
        }
        
        if let state = dict["state"] as? String{
            self.strState = state
        }
        
        if let city = dict["city"] as? String{
            self.strCity = city
        }
 
        if let lat = dict["lat"] as? String{
            self.strlatitude = lat
        }else if let lat = dict["lat"] as? Int{
            self.strlatitude = "\(lat)"
        }
        
        if let long = dict["lon"] as? String{
            self.strlongitude = long
        }else if let long = dict["lon"] as? Int{
            self.strlongitude = "\(long)"
        }
        
        if let phone_number = dict["mobile"] as? String{
            self.strPhoneNumber = phone_number
        }else if let phone_number = dict["mobile"] as? Int{
            self.strPhoneNumber = "\(phone_number)"
        }
        
        if let dob = dict["dob"] as? String{
            self.strDob = dob
        }
        
        if let sex = dict["sex"] as? String{
            self.strGender = sex
        }
        
        if let profile_picture = dict["user_image"] as? String{
            self.strProfilePicture = profile_picture
        }
        
        if let device_id = dict["device_id"] as? String{
            self.strDeviceId = device_id
        }
        
        if let device_token = dict["device_token"] as? String{
            self.strDeviceToken = device_token
        }
        
        if let device_type = dict["device_type"] as? String{
            self.strDeviceType = device_type
        }
        
        if let auth_token = dict["auth_token"] as? String{
            self.straAuthToken = auth_token
            UserDefaults.standard.setValue(auth_token, forKey: objAppShareData.UserDetail.straAuthToken)
        }
        
        if let rel_status = dict["rel_status"] as? String {
            self.strRelStatus = rel_status
        }
        
        if let liked_status = dict["liked"] as? Int {
            self.valLikedStatus = liked_status
        }
        
        if let blocked = dict["blocked"] as? Int {
            self.valBlockedStatus = blocked
        }else if let blocked = dict["blocked"] as? String {
            self.valBlockedStatus = Int(blocked) ?? 0
        }
        
        if let blockedBy = dict["blockedBy"] as? String {
            self.strBlockedBy = blockedBy
        }
        
        if let visible = dict["visible"] as? String {
            self.strVisibilityStatus = visible
        }
        
        
        
    }
}

/*
{
    "account_holder_name" = "";
    "account_no" = "";
    address = "";
    age = 28;
    "allow_city" = 0;
    "allow_country" = 1;
    "allow_sex" = Female;
    "allow_state" = 0;
    "bank_name" = "";
    blocked = 0;
    blockedBy = "";
    "branch_name" = "";
    "category_id" = "";
    "chat_status" = "";
    "chat_time" = "0000-00-00 00:00:00";
    cinema = Tt;
    city = Adsubia;
    code = "";
    "commission_base" = 0;
    country = "Espa\U00f1a";
    dob = "1992-12-24";
    document = "";
    email = "goswamipuriarun@yahoo.com";
    "email_verified" = 0;
    entrydt = "2021-05-31 08:02:57";
    "expiry_date" = "2130-12-06 13:32:57";
    eye = Yy;
    "fssai_image" = "";
    "fssai_no" = "";
    "gst_image" = "";
    "gst_no" = "";
    "gumasta_image" = "";
    "gumasta_no" = "";
    hair = Fg;
    "has_membership" = 1;
    height = "";
    "highlight_info" = fgty;
    "ifsc_code" = "";
    lat = "";
    liked = 0;
    lon = "";
    "looking_for" = "Chat,Relaci\U00f3n,Amistad,Relaci\U00f3n \U00edntima";
    "membership_id" = 2;
    mobile = "";
    "mobile_verified" = 0;
    music = Gg;
    name = "Arun Goswami";
    otp = "";
    "over_commission" = 0;
    password = "";
    "payment_email" = "";
    plan =     {
        "discount_price" = 0;
        entrydt = "2020-07-15 09:58:06";
        "expiry_date" = "2130-12-06 13:32:57";
        name = "Arun Goswami";
        "plan_id" = 2;
        "plan_title" = "Female Ultimate";
        "real_price" = 0;
        status = 0;
        validity = 40000;
    };
    "register_id" = "eAu4p6muQO-YQLuW-dvvRo:APA91bHwnw5OHBBg9xyejLivqLgZUn_MSU3KrevrmwRUCktORvC-ynlBRLGO8a7Sel92cuMoC9J_V56YRredd6ADrDK0l1Wh11WNxNGeznt0JsVvieYPA0zHATe_LbjxN0u1qwdY5bNK";
    "rel_status" = "";
    sex = Female;
    "shipping_time" = 0;
    "short_bio" = tyyt;
    skin = Yytt;
    "social_id" = 4005869259503653;
    "social_type" = fb;
    sport = Gg;
    state = "Alicante/Alacant";
    status = 1;
    "sub_category_id" = "";
    "swift_code" = "";
    type = user;
    "under_commission" = 0;
    "user_id" = 26;
    "user_image" = "http://ambitious.in.net/Shubham/paing/uploads/user/9074IMG_1622448105262.png";
    visible = 0;
    work = "";
}

*/
