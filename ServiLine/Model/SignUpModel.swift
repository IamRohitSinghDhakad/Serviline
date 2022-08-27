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
    var strWebsite      :String = ""
    var strUserType         :String = ""
    var strUserRating      :Double = 0.0
    
    var strSectorID   :String = ""
    var strAboutMe :String = ""
    var strSpecialInstruction :String = ""
    var strMunicipality :String = ""
    var strNationID :String = ""
    var strCommunityID :String = ""
    var strMunicipalityId :String = ""
    var strProvienceID :String = ""
    var strCinema :String = ""
    var strEye :String = ""
    var strHeight :String = ""
    var strCommunity :String = ""
    var strProvince :String = ""
    var strNation :String = ""
    var strRelStatus: String = ""
    var valLikedStatus: Int = 0
    var valBlockedStatus: Int = 0
    var strBlockedBy: String = ""
    var strVisibilityStatus: String = ""
    var strMembershipStats:String = ""
    var isFavorite:String = ""
    var isReport:String = ""
    var isRating:String = ""
    var isBlock:String = ""
    var strNotificationStatus:String = ""
    var strAllowFree:String = ""
    var strIsPlanActive:String = ""
    var strSectorName:String = ""
    
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
        
        if let rating = dict["rating"]as? String{
            self.strUserRating = Double(rating) ?? 0.0
        }else  if let rating = dict["rating"]as? Double{
            self.strUserRating = rating
        }
        
        if let username = dict["name"] as? String{
            self.strUserName = username.decodeEmoji
        }
        
        if let strMembership = dict["has_membership"] as? String{
            self.strMembershipStats = strMembership
        }else if let strMembership = dict["has_membership"] as? Int{
            self.strMembershipStats = "\(strMembership)"
        }
        
        if let favorite_status = dict["favorite_status"] as? String{
            self.isFavorite = favorite_status
        }else if let favorite_status = dict["favorite_status"] as? Int{
            self.isFavorite = "\(favorite_status)"
        }
        
        if let report_status = dict["report_status"] as? String{
            self.isReport = report_status
        }else if let report_status = dict["report_status"] as? Int{
            self.isReport = "\(report_status)"
        }
        
        
        if let rating_status = dict["rating_status"] as? String{
            self.isRating = rating_status
        }else if let rating_status = dict["rating_status"] as? Int{
            self.isRating = "\(rating_status)"
        }
        
        if let block_status = dict["block_status"] as? String{
            self.isBlock = block_status
        }else if let block_status = dict["block_status"] as? Int{
            self.isBlock = "\(block_status)"
        }
        
        
        if let notification_status = dict["notification_status"] as? String{
            self.strNotificationStatus = notification_status
        }else if let notification_status = dict["notification_status"] as? Int{
            self.strNotificationStatus = "\(notification_status)"
        }
        
        
        
        
        if let password = dict["password"] as? String{
            self.strPassword = password
        }
        
        if let bio = dict["bio"] as? String{
            self.strAboutMe = bio.decodeEmoji
        }
      
        
        if let municipality_name = dict["municipality_name"] as? String{
            self.strMunicipality = municipality_name
        }
        
        if let province_name = dict["province_name"] as? String{
            self.strProvince = province_name
        }
        
        if let nation_name = dict["nation_name"] as? String{
            self.strNation = nation_name
        }
        
        if let community_name = dict["community_name"] as? String{
            self.strCommunity = community_name
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
        
        if let nation_id = dict["nation_id"] as? String{
            self.strNationID = nation_id
        }else if let nation_id = dict["nation_id"] as? Int{
            self.strNationID = "\(nation_id)"
        }
        
        if let community_id = dict["community_id"] as? String{
            self.strCommunityID = community_id
        }else if let community_id = dict["community_id"] as? Int{
            self.strCommunityID = "\(community_id)"
        }
        
        if let municipality_id = dict["municipality_id"] as? String{
            self.strMunicipalityId = municipality_id
        }else if let municipality_id = dict["municipality_id"] as? Int{
            self.strMunicipalityId = "\(municipality_id)"
        }
        
        if let province_id = dict["province_id"] as? String{
            self.strProvienceID = province_id
        }else if let province_id = dict["province_id"] as? Int{
            self.strProvienceID = "\(province_id)"
        }
        
        if let sector_id = dict["sector_id"] as? String{
            self.strSectorID = sector_id
        }else if let sector_id = dict["sector_id"] as? Int{
            self.strSectorID = "\(sector_id)"
        }
        
        if let sector_name = dict["sector_name"] as? String{
            self.strSectorName = sector_name
        }
        
        
        
        if let website = dict["website"] as? String{
            self.strWebsite = website
        }
        
        
        if let looking_for = dict["looking_for"] as? String{
            self.strLookingFor = looking_for
        }
        
        if let cinema = dict["cinema"] as? String{
            self.strCinema = cinema
        }
        
        if let type = dict["type"] as? String{
            self.strUserType = type
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
        
        if let allow_free = dict["allow_free"] as? String{
            self.strAllowFree = allow_free
        }else if let allow_free = dict["allow_free"] as? Int{
            self.strAllowFree = "\(allow_free)"
        }
        
        if let isPlanActive = dict["isPlanActive"] as? String{
            self.strIsPlanActive = isPlanActive
        }else if let isPlanActive = dict["isPlanActive"] as? Int{
            self.strIsPlanActive = "\(isPlanActive)"
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
 address = "";
 "allow_free" = 0;
 bio = "Hope you will choose me. anda ki roti ki sabji recipe in hindi with lyrics of a girl name in hindi full episode in english with song";
 "block_status" = 0;
 code = "";
 "community_id" = 1;
 "community_name" = "<null>";
 deletedRemark = "";
 deletedTime = "";
 email = "elvish2412@gmail.com";
 "email_verified" = 1;
 entrydt = "2022-04-01 07:21:29";
 expiry = "0000-00-00 00:00:00";
 "favorite_status" = 0;
 lat = "";
 lng = "";
 "membership_id" = 1;
 mobile = "";
 "municipality_id" = 1;
 "municipality_name" = "municipality 1";
 name = "Akankhsa Sharma";
 "nation_id" = 1;
 "nation_name" = "Espa\U00f1a";
 "notification_status" = 1;
 "other_block_status" = 0;
 password = 12345;
 "plan_id" = 0;
 "province_id" = 1;
 "province_name" = "Province 1";
 rating = "4.3";
 "rating_status" = 0;
 "register_id" = "eMDYvgwuRqKXVOSHTzwc9b:APA91bEx6PttnmIkJRC8Vldo0G8FzqjAQhfj1gN478SSzon4RFa2bct7zbBidEqX9b6PLGqUJz9tfbdbldDY2EXyga8wEuyrQKgRPXouqweCx-cL2qYPyt3OFx8Q2uQ4YRFcocT-yqQP";
 "report_status" = 0;
 "sector_id" = 0;
 "sector_name" = "<null>";
 selectedPlan =     {
 };
 "social_id" = "";
 "social_type" = "";
 status = 1;
 type = user;
 "user_id" = 4;
 "user_image" = "https://ambitious.in.net/Arun/serviline/uploads/user/3548IMG_1645701651993.png";
 website = "www.ambitious.in.net";
 */
