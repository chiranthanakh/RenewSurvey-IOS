//
//	ModelUser.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class ModelUser : NSObject, NSCoding{

    var accessToken : String!
    var status : Bool!
    var tblUsersId : String!
    var userType : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        accessToken = dictionary["access_token"] as? String
        status = dictionary["status"] as? Bool
        tblUsersId = dictionary["tbl_users_id"] as? String
        userType = dictionary["user_type"] as? String
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if accessToken != nil{
            dictionary["access_token"] = accessToken
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
        return dictionary
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
         accessToken = aDecoder.decodeObject(forKey: "access_token") as? String
         status = aDecoder.decodeObject(forKey: "status") as? Bool
         tblUsersId = aDecoder.decodeObject(forKey: "tbl_users_id") as? String
         userType = aDecoder.decodeObject(forKey: "user_type") as? String

    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
    {
        if accessToken != nil{
            aCoder.encode(accessToken, forKey: "access_token")
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
    }
    
}
