//
//  AppConstant.swift
//  LoyalInfo Loyalhospitality
//
//  Created by DREAMWORLD on 11/08/21.
//  Copyright © 2021 iMac. All rights reserved.
//

import Foundation
import UIKit

let kAppDelegate = UIApplication.shared.delegate as! AppDelegate

// MARK: - Constant
class AppConstant {
    
    struct Key {
        
        static let appKey          =   12345
     
    }
    
    struct API {
       
        static let BASE_URL                         = "https://devrenewsms.proteam.co.in/api/v1/" // Dev
//        static let BASE_URL                         = "https://renewsms.proteam.co.in/api/v1/"  //Live
        

        //Auth Module
        static let kValidateProject                 = BASE_URL + "Auth/validate_project"
        static let kLogin                           = BASE_URL + "Auth/login"
        static let kRegister                        = BASE_URL + "Auth/register"
        static let kVerifyUser                      = BASE_URL + "Auth/verify_user"
        static let kResetPassword                   = BASE_URL + "Auth/reset_password"
        
        static let kGetStates                       = BASE_URL + "Common/get_states"
        static let kGetDistricts                    = BASE_URL + "Common/get_districts"
        static let kGetTehsils                      = BASE_URL + "Common/get_tehsils"
        static let kGetPanchayats                   = BASE_URL + "Common/get_panchayats"
        static let kGetVillages                     = BASE_URL + "Common/get_villages"
        
        static let kSyncDataFromServer              = BASE_URL + "Synchronization/sync_data_from_server"
        static let kSyncMedia                       = BASE_URL + "ProjectMaster/sync_media"
        static let kSyncSurvey                      = BASE_URL + "ProjectMaster/sync_survey"
    }
    
    
    struct Link {
       
        static let Terms                         = "https://devrenewsms.proteam.co.in/TermsConditions" // Dev
//        static let Terms                         = "https://renewsms.proteam.co.in/TermsConditions" // Live

    }
    
    struct ValidationMessages {
        
        static let kComingSoon = "Coming Soon"
        
        static let kNameEmpty                = "Please enter your name"
        static let kEmailEmpty               = "Please enter your email"
        static let kMobileEmpty              = "Please enter your mobile number"
        static let kInValidEmail             = "Please enter valid email"
        static let kPasswordEmpty            = "Please enter your password"
        static let kOTPEmpty                 = "Please enter OTP"
        static let kInValidOTP               = "Please enter valid OTP"
        
        static let kEmptyBrand               = "Please select brand"
        static let kEmptyDish                = "Please select item"
        
        static let kEmptyHeadline            = "Please enter headline"
        static let kEmptySubHeadline         = "Please enter sub header"
        static let kEmptyDescription         = "Please enter description"
        
        static let kEmptyName                = "Please enter name"
        static let kEmptyPhone               = "Please enter phone number"
        static let kEmptyEmail               = "Please enter email"
        static let kInvalidEmail             = "Please valid email"
        static let kEmptyDOB                 = "Please select date of birth"
        static let kEmptyState               = "Please select state"
        static let kEmptyCity                = "Please select city"
        static let kEmptyAddress             = "Please enter address"
        static let kEmptyPincode             = "Please enter pincode"
        static let kEmptyAdhaar              = "Please enter adhhar number"
        static let kEmptyPancard             = "Please enter pancard number"
        static let kEmptyBankName            = "Please enter bank name"
        static let kEmptyBankAcNo            = "Please enter bank account number"
        static let kEmptyBankAcName          = "Please enter bank account name"
        static let kEmptyBankIFSC            = "Please enter bank IFSC"
    }
    
    
    struct FailureMessage {
        static let kNoInternetConnection    = "Please check your internet connection."
        static let kInvalidCredential       = "Invalid login credential."
        
        static let kMusicNotFound   = "Music Not Found."
    }
    
    struct SuccessMessage {
        static let kPostUplaodSuccess      = "Your post has been pushed and is awaiting approval"
        static let kRollUplaodSuccess      = "Your roll has been pushed and is awaiting approval"
    }
}

struct ObserverName {
    static let kcontentSize           = "contentSize"
}

typealias FailureBlock = (_ statuscode: String,_ error: String, _ customError: ErrorType) -> Void

enum ErrorType: String {
    case server = "Error"
    case connection = "No connection"
    case response = ""
}

// MARK: - User Defaults Key Constant
struct UserDefaultsKey {
    static let kIsLoggedIn           = "isLoggedIn"
    static let kFcmToken             = "fcmToken"
    static let kLoginUser            = "loginUser"
    static let kLastAsyncDate        = "lastAsyncDate"
    static let kpassedTestFromIds    = "passedTestFromIds"
    static let kTrainingTutorials    = "trainingTutorials"
}

// MARK: - Notification
struct Notiifcations {
    static let kUserStatusChange     = NSNotification.Name.init(rawValue: "userStatusChange")
    static let kUpdateBrandList      = NSNotification.Name.init(rawValue: "updateBrandList")
    static let kUpdateOutletList     = NSNotification.Name.init(rawValue: "updateOutletList")
}

let appGroupName    :   String  =   "group.com.app.locatoca.native.actionExtension"
