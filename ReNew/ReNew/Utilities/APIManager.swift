//
//  APIManager.swift
//  RecordingStudio
//
//  Created by mac on 16/01/2020.
//  Copyright © 2019 Differenzsystem Pvt. LTD. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SystemConfiguration
import AVFoundation
import MobileCoreServices
import CommonCrypto


class APIManager: NSObject {
    
    static let sharedInstance = APIManager()
    //private var alamofireManager = AF.SessionManager.default
    var sessionManager: Alamofire.Session.RequestModifier!

    override init() {
        
    }
    
    // MARK: - Check for internet connection
    
    /**
     This method is used to check internet connectivity.
     - Returns: Return boolean value to indicate device is connected with internet or not
     */
    
    
    
    func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
    
    /**
     This method is used to make Alamofire request with or without parameters.
     - Parameters:
     - url: URL of request
     - method: HTTPMethod of request
     - parameter: Parameter of request
     - success: Success closure of method
     - response: Response object of request
     - failure: Failure closure of method
     - error: Failure error
     - connectionFailed: Network connection faild closure of method
     - error: Network error
     */
    
    func makeRequest(with url: String, method: HTTPMethod, parameter: [String:Any]?, isShowLoader: Bool = true, responseData:@escaping  (_ error: NSError?,_ responseDict: NSDictionary?) -> Void) {
        
        if(isConnectedToNetwork()) {
            if let param = parameter, let data = try? JSONSerialization.data(withJSONObject: param, options: .prettyPrinted) {
                print("Parameter of \(url):\n \(String(data: data, encoding: .utf8) ?? "Nil Param")")
                
            }
            if isShowLoader {
                SVProgressHUD.show()
            }
            var headers: HTTPHeaders = [:]
            var encondingType = JSONEncoding.default
            if ModelUser.getCurrentUserFromDefault()?.accessToken != "" {
                headers["Authorization"] = ModelUser.getCurrentUserFromDefault()?.accessToken ?? ""
            }
            
            if url == AppConstant.API.kResetPassword {
                headers["Authorization"] = parameter?["access_token"] as? String ?? ""
            }
            
            if method == .get {
                AF.request(url, method: .get, headers: headers, requestModifier: { urlMOdifire in
                    urlMOdifire.timeoutInterval = 1000000000
                }).responseString(completionHandler: { responseStraing in
                    if isShowLoader {
                        SVProgressHUD.dismiss()
                    }
                    switch responseStraing.result{
                    case .success(let strResult):
                        responseData(nil, dictionaryOfFilteredBy(dict: strResult.toJson() as NSDictionary))
                        break
                    case .failure(let error):
                        responseData(error as NSError?, nil)
                        break
                    }
                })
            }
            else{
                AF.request(url, method: method, parameters: parameter, headers: headers, requestModifier: { urlMOdifire in
                    urlMOdifire.timeoutInterval = 1000000000
                }).responseString(completionHandler: { responseStraing in
                    if isShowLoader {
                        SVProgressHUD.dismiss()
                    }
                    switch responseStraing.result{
                    case .success(let strResult):
                        responseData(nil, dictionaryOfFilteredBy(dict: strResult.toJson() as NSDictionary))
                        break
                    case .failure(let error):
                        responseData(error as NSError?, nil)
                        break
                    }
                })            }
            
        }
        else {
//            connectionFailed("AppConstant.FailureMessage.kNoInternetConnection")
        }
    }
    
    func requestWithPostMultipartParam(endpointurl:String,
                                       parameters:NSDictionary,
                                       image:UIImage = UIImage(),
                                       isShowLoader:Bool,
                                       uploadfileName: String = "file",
                                       responseData:@escaping (_ error: NSError?,_ responseDict: NSDictionary?) -> Void)
    {
        if self.isConnectedToNetwork()
        {
            if isShowLoader {
                SVProgressHUD.show()
            }
            var headers: HTTPHeaders = [:]
            var encondingType = JSONEncoding.default
            if ModelUser.getCurrentUserFromDefault()?.accessToken != "" {
                headers["Authorization"] = ModelUser.getCurrentUserFromDefault()?.accessToken ?? ""
            }
            
            if endpointurl == AppConstant.API.kResetPassword {
                headers["Authorization"] = parameters["access_token"] as? String ?? ""
            }

            Alamofire.Session.default.upload(multipartFormData: { multipartFormData in
                for (key, value) in parameters
                {
                    if value is URL {
                        let videoData :NSData = try! NSData(contentsOf: value as! URL,options: .mappedIfSafe)
                        multipartFormData.append(videoData as Data, withName: key as! String, fileName: "video.mp4", mimeType: "video/mp4")
                    }
                    else if value is UIImage {
                        let imgData = (value as! UIImage).jpegData(compressionQuality: 0.9)
                         
                         multipartFormData.append(imgData! , withName: key as! String, fileName: "image.jpg", mimeType: "image/jpeg")
                    }
                    else if let imgarr = value as? [UIImage] {
                        imgarr.forEach { img in
                            let imgData = img.jpegData(compressionQuality: 0.9)
                            multipartFormData.append(imgData! , withName: key as! String, fileName: "image.jpg", mimeType: "image/jpeg")
                        }
                    }
                    else if value is Data
                    {
                        multipartFormData.append(value as! Data, withName: key as! String, fileName: "file_image.jpg", mimeType: "image/jpeg")
                    }
                    else
                    {
                        multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as! String)
                    }
                }
            }, to: "\(endpointurl)", usingThreshold: UInt64.init(), method: .post, headers: headers).responseString(completionHandler: { responseStraing in
                if isShowLoader {
                    SVProgressHUD.dismiss()
                }
                switch responseStraing.result{
                case .success(let strResult):
                    responseData(nil, dictionaryOfFilteredBy(dict: strResult.toJson() as NSDictionary))
                    break
                case .failure(let error):
                    responseData(error as NSError?, nil)
                    break
                }
            })
        }
    }
    
    func requestUploadMedia(endpointurl:String,
                            parameters:NSDictionary,
                            arrFiles: [Any],
                            isShowLoader:Bool,
                            uploadfileName: String = "files[]",
                            responseData:@escaping (_ error: NSError?,_ responseDict: NSDictionary?) -> Void)
    {
        if self.isConnectedToNetwork()
        {
            if isShowLoader {
                SVProgressHUD.show()
            }
            var headers: HTTPHeaders = [:]
            var encondingType = JSONEncoding.default
            if ModelUser.getCurrentUserFromDefault()?.accessToken != "" {
                headers["Authorization"] = ModelUser.getCurrentUserFromDefault()?.accessToken ?? ""
            }
            
            if endpointurl == AppConstant.API.kResetPassword {
                headers["Authorization"] = parameters["access_token"] as? String ?? ""
            }
            
            var jsonString = ""
            var passingData = Data()

            do {
                
                if parameters["post_data"] != nil{
                    let tempaArr = parameters["post_data"] as? [[String:Any]] ?? [[String:Any]]()
                    let jsonData = try JSONSerialization.data(withJSONObject: tempaArr, options: JSONSerialization.WritingOptions.prettyPrinted)
                    passingData = jsonData
                    jsonString = String(data: jsonData, encoding: String.Encoding.utf8)!
                    print("Parameter of \(endpointurl):\n \(jsonString)")
                }
            }
            catch let error as NSError {
                print(error)
            }
            Alamofire.Session.default.upload(multipartFormData: { multipartFormData in
                arrFiles.forEach { file in
                    if let img = file as? UIImage {
                        let imgData = img.jpegData(compressionQuality: 0.6)
                        multipartFormData.append(imgData! , withName: uploadfileName, fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
                    }
                    else if let urlType = file as? URL {
                        if urlType.pathExtension.caseInsensitiveCompare("pdf") == .orderedSame {
                            let FileData :NSData = try! NSData(contentsOf: file as! URL)//NSData(contentsOfFile: uploadfile)
                            multipartFormData.append(FileData as Data, withName: uploadfileName, fileName: "\(Date().timeIntervalSince1970).pdf", mimeType: "application/pdf")
                        }
                        if urlType.pathExtension.caseInsensitiveCompare("doc") == .orderedSame {
                            let FileData :NSData = try! NSData(contentsOf: file as! URL)//NSData(contentsOfFile: uploadfile)
                            multipartFormData.append(FileData as Data, withName: uploadfileName, fileName: "\(Date().timeIntervalSince1970).doc", mimeType: "application/msword")
                        }
                        if urlType.pathExtension.caseInsensitiveCompare("png") == .orderedSame {
                            let FileData :NSData = try! NSData(contentsOf: file as! URL)//NSData(contentsOfFile: uploadfile)
                            multipartFormData.append(FileData as Data, withName: uploadfileName, fileName: "\(Date().timeIntervalSince1970).png", mimeType: "image/jpeg")
                        }
                        if urlType.pathExtension.caseInsensitiveCompare("jpg") == .orderedSame {
                            let FileData :NSData = try! NSData(contentsOf: file as! URL)//NSData(contentsOfFile: uploadfile)
                            multipartFormData.append(FileData as Data, withName: uploadfileName, fileName: "\(Date().timeIntervalSince1970).jpg", mimeType: "image/jpg")
                        }
                        if urlType.pathExtension.caseInsensitiveCompare("jpeg") == .orderedSame {
                            let FileData :NSData = try! NSData(contentsOf: file as! URL)//NSData(contentsOfFile: uploadfile)
                            multipartFormData.append(FileData as Data, withName: uploadfileName, fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
                        }
                        if urlType.pathExtension.caseInsensitiveCompare("xls") == .orderedSame {
                            let FileData :NSData = try! NSData(contentsOf: file as! URL)//NSData(contentsOfFile: uploadfile)
                            multipartFormData.append(FileData as Data, withName: uploadfileName, fileName: "\(Date().timeIntervalSince1970).xls", mimeType: "application/octet-stream")
                        }
                        if urlType.pathExtension.caseInsensitiveCompare("xlsx") == .orderedSame {
                            let FileData :NSData = try! NSData(contentsOf: file as! URL)//NSData(contentsOfFile: uploadfile)
                            multipartFormData.append(FileData as Data, withName: uploadfileName, fileName: "\(Date().timeIntervalSince1970).xlsx", mimeType: "application/octet-stream")
                        }
                    }
                    else if let data = file as? Data {
                        multipartFormData.append(data, withName: uploadfileName, fileName: "file_image.jpg", mimeType: "image/jpeg")
                    }
                }
                for (key, value) in parameters
                {
                    multipartFormData.append(passingData, withName: key as! String)
                }
            }, to: "\(endpointurl)", usingThreshold: UInt64.init(), method: .post, headers: headers).responseString(completionHandler: { responseStraing in
                if isShowLoader {
                    SVProgressHUD.dismiss()
                }
                switch responseStraing.result{
                case .success(let strResult):
                    responseData(nil, dictionaryOfFilteredBy(dict: strResult.toJson() as NSDictionary))
                    break
                case .failure(let error):
                    responseData(error as NSError?, nil)
                    break
                }
            })
        }
    }
        
    func requestAsyncDataUploadToServer(endpointurl:String,
                                        parameters: [[String:Any]],
                                        isShowLoader:Bool,
                                        responseData:@escaping (_ error: NSError?,_ responseDict: NSDictionary?) -> Void)
    {
        if self.isConnectedToNetwork()
        {
            if isShowLoader {
                SVProgressHUD.show()
            }
            var request = URLRequest(url: URL(string: endpointurl)!)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue(ModelUser.getCurrentUserFromDefault()?.accessToken ?? "", forHTTPHeaderField: "Authorization")
            
            request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            AF.sessionConfiguration.timeoutIntervalForRequest = 36000000
            AF.sessionConfiguration.timeoutIntervalForResource = 36000000
            AF.sessionConfiguration.httpMaximumConnectionsPerHost = 30
            
            print(parameters)
            AF.request(request).responseString(completionHandler: { responseStraing in
                if isShowLoader {
                    SVProgressHUD.dismiss()
                }
                switch responseStraing.result{
                case .success(let strResult):
                    responseData(nil, dictionaryOfFilteredBy(dict: strResult.toJson() as NSDictionary))
                    break
                case .failure(let error):
                    responseData(error as NSError?, nil)
                    break
                }
            })
        }
    }
    
    func downloadFile(fileURL : URL,
                            withSuccess success: @escaping (_ file: String) -> Void,
                            failure: @escaping (_ error: String) -> Void)
    {
        if isConnectedToNetwork()
        {
            let destination: DownloadRequest.Destination = { _, _ in
                let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let fileURL = documentsURL.appendingPathComponent(fileURL.lastPathComponent)

                return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
            }

            AF.download(fileURL, to: destination).response { response in
                debugPrint(response)

                if response.error == nil, let imagePath = response.fileURL?.path {
                    success(imagePath)
                }
            }
        }
    }
}
extension URL {
    public var queryParameters: [String: String]? {
        guard
            let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
            let queryItems = components.queryItems else { return nil }
        return queryItems.reduce(into: [String: String]()) { (result, item) in
            result[item.name] = item.value
        }
    }
    func mimeType() -> String {
        let pathExtension = self.pathExtension
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype as String
            }
        }
        return "application/octet-stream"
    }
    
    var typeIdentifier: String? {
        return (try? resourceValues(forKeys: [.typeIdentifierKey]))?.typeIdentifier
    }
    var localizedName: String? {
        return (try? resourceValues(forKeys: [.localizedNameKey]))?.localizedName
    }
}
extension String {

    func hmac(key: String) -> String {
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA256), key, key.count, self, self.count, &digest)
        let data = Data(bytes: digest)
        return data.map { String(format: "%02hhx", $0) }.joined()
    }

}
