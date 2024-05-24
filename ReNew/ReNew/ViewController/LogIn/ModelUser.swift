//
//	ModelUser.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class ModelUser : NSObject, NSCoding{
    
    var aadharCard : String!
    var accessToken : String!
    var address : String!
    var altMoile : String!
    var email : String!
    var fullName : String!
    var message : String!
    var mobile : String!
    var note : String!
    var pincode : String!
    var profilePhoto : String!
    var status : Bool!
    var tblUsersId : String!
    var userType : String!
    var username : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        aadharCard = dictionary["aadhar_card"] as? String
        accessToken = dictionary["access_token"] as? String
        address = dictionary["address"] as? String
        altMoile = dictionary["alt_moile"] as? String
        email = dictionary["email"] as? String
        fullName = dictionary["full_name"] as? String
        message = dictionary["message"] as? String
        mobile = dictionary["mobile"] as? String
        note = dictionary["note"] as? String
        pincode = dictionary["pincode"] as? String
        profilePhoto = dictionary["profile_photo"] as? String
        status = dictionary["status"] as? Bool
        tblUsersId = dictionary["tbl_users_id"] as? String
        userType = dictionary["user_type"] as? String
        username = dictionary["username"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if aadharCard != nil{
            dictionary["aadhar_card"] = aadharCard
        }
        if accessToken != nil{
            dictionary["access_token"] = accessToken
        }
        if address != nil{
            dictionary["address"] = address
        }
        if altMoile != nil{
            dictionary["alt_moile"] = altMoile
        }
        if email != nil{
            dictionary["email"] = email
        }
        if fullName != nil{
            dictionary["full_name"] = fullName
        }
        if message != nil{
            dictionary["message"] = message
        }
        if mobile != nil{
            dictionary["mobile"] = mobile
        }
        if note != nil{
            dictionary["note"] = note
        }
        if pincode != nil{
            dictionary["pincode"] = pincode
        }
        if profilePhoto != nil{
            dictionary["profile_photo"] = profilePhoto
        }
        if status != nil{
            dictionary["status"] = status
        }
        if tblUsersId != nil{
            dictionary["tbl_users_id"] = tblUsersId
        }
        if userType != nil{
            dictionary["user_type"] = userType
        }
        if username != nil{
            dictionary["username"] = username
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        aadharCard = aDecoder.decodeObject(forKey: "aadhar_card") as? String
        accessToken = aDecoder.decodeObject(forKey: "access_token") as? String
        address = aDecoder.decodeObject(forKey: "address") as? String
        altMoile = aDecoder.decodeObject(forKey: "alt_moile") as? String
        email = aDecoder.decodeObject(forKey: "email") as? String
        fullName = aDecoder.decodeObject(forKey: "full_name") as? String
        message = aDecoder.decodeObject(forKey: "message") as? String
        mobile = aDecoder.decodeObject(forKey: "mobile") as? String
        note = aDecoder.decodeObject(forKey: "note") as? String
        pincode = aDecoder.decodeObject(forKey: "pincode") as? String
        profilePhoto = aDecoder.decodeObject(forKey: "profile_photo") as? String
        status = aDecoder.decodeObject(forKey: "status") as? Bool
        tblUsersId = aDecoder.decodeObject(forKey: "tbl_users_id") as? String
        userType = aDecoder.decodeObject(forKey: "user_type") as? String
        username = aDecoder.decodeObject(forKey: "username") as? String
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if aadharCard != nil{
            aCoder.encode(aadharCard, forKey: "aadhar_card")
        }
        if accessToken != nil{
            aCoder.encode(accessToken, forKey: "access_token")
        }
        if address != nil{
            aCoder.encode(address, forKey: "address")
        }
        if altMoile != nil{
            aCoder.encode(altMoile, forKey: "alt_moile")
        }
        if email != nil{
            aCoder.encode(email, forKey: "email")
        }
        if fullName != nil{
            aCoder.encode(fullName, forKey: "full_name")
        }
        if message != nil{
            aCoder.encode(message, forKey: "message")
        }
        if mobile != nil{
            aCoder.encode(mobile, forKey: "mobile")
        }
        if note != nil{
            aCoder.encode(note, forKey: "note")
        }
        if pincode != nil{
            aCoder.encode(pincode, forKey: "pincode")
        }
        if profilePhoto != nil{
            aCoder.encode(profilePhoto, forKey: "profile_photo")
        }
        if status != nil{
            aCoder.encode(status, forKey: "status")
        }
        if tblUsersId != nil{
            aCoder.encode(tblUsersId, forKey: "tbl_users_id")
        }
        if userType != nil{
            aCoder.encode(userType, forKey: "user_type")
        }
        if username != nil{
            aCoder.encode(username, forKey: "username")
        }
        
    }
    
    func saveCurrentUserInDefault() {
        do {
            let encodedData = try NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
            UserDefaults.standard.set(encodedData, forKey: UserDefaultsKey.kLoginUser)
            UserDefaults.standard.synchronize()
        } catch {
            print("Not found")
        }
    }
    
    //Get user object from UserDefault
    class func getCurrentUserFromDefault() -> ModelUser? {
        do {
            
            if let decoded  = UserDefaults.standard.data(forKey: UserDefaultsKey.kLoginUser),      let user = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decoded) as? ModelUser {
                return user
            }
        } catch {
            print("Couldn't read file.")
            return nil
        }
        return nil
    }
    
    //Remove user object from UserDefault
    class func removeUserFromDefault() {
        UserDefaults.standard.set(nil, forKey: UserDefaultsKey.kLoginUser)
        DataManager.deleteDatabase()
        UserDefaults.kLastAsyncDate = ""
        UserDefaults.passedTestFromIds.removeAll()
        UserDefaults.trainingTutorials = [String]()
    }
    
}
