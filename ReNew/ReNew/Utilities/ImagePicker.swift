//
//  ImagePicker.swift
//  Shift
//
//  Created by mac on 04/05/19.
//  Copyright © 2019 Differenz System. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices
import UniformTypeIdentifiers


class ImagePicker: NSObject, UINavigationControllerDelegate,UIImagePickerControllerDelegate, UIDocumentPickerDelegate {
    
    var imgName: String?
    var sourceData = Data()
    var handler:((UIImage)->())?
    var pickerHandler:((Data,URL,UIImage,Int)->Void)?
    var videoPickerHandler:((Data,URL)->Void)?
    var picker = UIImagePickerController()
    var viewController: UIViewController?
    var isVideo = false
    var isImageUpload = false
    var tag = Int()
    
    var isAllowsEditing: Bool = true {
        didSet {
            self.setAllowsEditing()
        }
    }
    
    override init() {
        super.init()
        
        picker = UIImagePickerController.init()
        picker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
    }
    
    func setAllowsEditing() {
        picker.allowsEditing = isAllowsEditing
    }
    
    func pickImage(_ sender:Any,_ pickertitle : String,pickerHandler:@escaping(UIImage)->()) {
        
        handler = pickerHandler
        
        AVCaptureDevice.requestAccess(for:  .video) { (granted) in
            DispatchQueue.main.async {
                guard granted == true else {
                    
                    let alertController = UIAlertController (title: "Grant Permisson", message: "Please provide camera access", preferredStyle: .alert)
                    
                    let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                            return
                        }
                        
                        if UIApplication.shared.canOpenURL(settingsUrl) {
                            
                            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                                print("Settings opened: \(success)") // Prints true
                                exit(0)
                            })
                        }
                    }
                    alertController.addAction(settingsAction)
                    let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                    alertController.addAction(cancelAction)
                    
                    self.viewController?.present(alertController, animated: true, completion: nil)
                    
                    return
                }
                
                //self.choosePhoto()
                let actionSheet = UIAlertController.init(title: pickertitle, message: nil, preferredStyle: .actionSheet)
                let camera = UIAlertAction.init(title: "Take Photo", style: .default) { (action) in
                    self.takePhoto()
                }
                let library = UIAlertAction.init(title: "Choose Photo", style: .default) { (action) in
                    self.choosePhoto()
                }
                let cancel = UIAlertAction.init(title: "Cancel", style: .cancel) { (action) in
                    
                }
                
                actionSheet.addAction(camera)
                actionSheet.addAction(library)
                actionSheet.addAction(cancel)
                
                if let popoverController = actionSheet.popoverPresentationController {
                    if let view = sender as? UIView {
                        popoverController.sourceView = view
                        popoverController.sourceRect = view.bounds
                    }
                }
                self.viewController?.present(actionSheet, animated: true, completion: nil)
            }
        }
    }
    
    func pickImageFromCamera(_ sender:Any,pickerHandler:@escaping(UIImage)->()) {
        
        handler = pickerHandler
        
        AVCaptureDevice.requestAccess(for:  .video) { (granted) in
            DispatchQueue.main.async {
                guard granted == true else {
                    
                    let alertController = UIAlertController (title: "Grant Permisson", message: "Please provide camera access", preferredStyle: .alert)
                    
                    let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                            return
                        }
                        
                        if UIApplication.shared.canOpenURL(settingsUrl) {
                            
                            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                                print("Settings opened: \(success)") // Prints true
                                exit(0)
                            })
                        }
                    }
                    alertController.addAction(settingsAction)
                    let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                    alertController.addAction(cancelAction)
                    
                    self.viewController?.present(alertController, animated: true, completion: nil)
                    
                    return
                }
                
                self.takePhoto()
            }
        }
    }
    func pickImageFromGallary(_ sender:Any,pickerHandler:@escaping(UIImage)->()) {
        
        handler = pickerHandler
        
        AVCaptureDevice.requestAccess(for:  .video) { (granted) in
            DispatchQueue.main.async {
                guard granted == true else {
                    
                    let alertController = UIAlertController (title: "Grant Permisson", message: "Please provide camera access", preferredStyle: .alert)
                    
                    let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                            return
                        }
                        
                        if UIApplication.shared.canOpenURL(settingsUrl) {
                            
                            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                                print("Settings opened: \(success)") // Prints true
                                exit(0)
                            })
                        }
                    }
                    alertController.addAction(settingsAction)
                    let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                    alertController.addAction(cancelAction)
                    
                    self.viewController?.present(alertController, animated: true, completion: nil)
                    
                    return
                }
                
                self.choosePhoto()
            }
        }
    }
    
    func takePhoto() {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
            let vc = UIApplication.topViewController(base: self.viewController)
            vc?.present(picker, animated: true, completion: nil)
        }
    }
    func choosePhoto() {
        DispatchQueue.main.async {
            self.picker.sourceType = .photoLibrary
            self.viewController?.present(self.picker, animated: true, completion: nil)
        }
    }
    /*func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       
        let image: UIImage?
        if picker.allowsEditing {
            image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        } else {
            image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        }
        
        if #available(iOS 11.0, *) {
//            if let imgname = info[UIImagePickerController.InfoKey.imageURL] as? URL {
//                imgName = imgname.lastPathComponent
//            } else {
//                /*saveImage(image: image) { (error) in
//                    print(error ?? "Error while saving the image captured from camera.")
//                }*/
//            }
            
            if let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
                print(videoURL)
                if AVURLAsset(url: videoURL).fileSize ?? 0 > 50 {
                    self.viewController?.showMessage("Video size must be less then 50 MB.")
                    picker.dismiss(animated: true, completion: nil)
                    return
                }
                else{
                    do {
                        let videoData = try Data(contentsOf: videoURL)
                        sourceData = videoData
                    } catch let error {
                        print(error)
                    }

                }
            }
        } else {
            // Fallback on earlier versions
        }
        
        picker.dismiss(animated: true) { [self] in
            if self.isVideo {
                if isImageUpload {
                    /*let cropper = CropperViewController(originalImage: image ?? UIImage.init())

                    cropper.delegate = self

                    picker.dismiss(animated: true) {
                        self.viewController?.present(cropper, animated: true, completion: nil)
                    }*/
                    let cropController = CropViewController(croppingStyle: .default, image: image ?? UIImage.init())
                    cropController.delegate = self
                    picker.dismiss(animated: true) {
                        self.viewController?.present(cropController, animated: true, completion: nil)
                    }
                }
                else {
                    if (self.pickerHandler != nil){
                        self.pickerHandler!(sourceData,imgName ?? "",image ?? UIImage.init())
                       
                    }
                    sourceData = Data()
                }
                
            }
            else {
                /*let cropper = CropperViewController(originalImage: image ?? UIImage.init())

                cropper.delegate = self

                picker.dismiss(animated: true) {
                    self.viewController?.present(cropper, animated: true, completion: nil)
                }*/
                let cropController = CropViewController(croppingStyle: .default, image: image ?? UIImage.init())
                cropController.delegate = self
                picker.dismiss(animated: true) {
                    self.viewController?.present(cropController, animated: true, completion: nil)
                }
            }
        }
    }*/
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image: UIImage!
        if picker.allowsEditing {
            image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        } else {
            image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        }
        
        if #available(iOS 11.0, *) {
            if let imgname = info[UIImagePickerController.InfoKey.imageURL] as? URL {
                imgName = imgname.lastPathComponent
            } else {
                /*saveImage(image: image) { (error) in
                    print(error ?? "Error while saving the image captured from camera.")
                }*/
            }
        } else {
            // Fallback on earlier versions
        }
        if let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
            let fileData = try! Data.init(contentsOf: videoURL)
            if (self.videoPickerHandler != nil){
                self.videoPickerHandler!(fileData,videoURL)
            }
            picker.dismiss(animated: true)
        }
        else {
            picker.dismiss(animated: true) {
                if (self.handler != nil){
                    self.handler!(image)
                }
            }
        }
        
    }
    
    func saveImage(image: UIImage, completion: @escaping (Error?) -> ()) {
       UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(path:didFinishSavingWithError:contextInfo:)), nil)
    }

    @objc private func image(path: String, didFinishSavingWithError error: NSError?, contextInfo: UnsafeMutableRawPointer?) {
        debugPrint(path) // That's the path you want
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true) {
            
        }
    }
    
    func chooseVideo() {
        DispatchQueue.main.async {
            self.picker = UIImagePickerController.init()
            self.picker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
            self.picker.sourceType = .savedPhotosAlbum
            self.picker.mediaTypes = ["public.movie"]
            self.viewController?.present(self.picker, animated: true, completion: nil)
        }
    }
    
    func chooseDocument(docType: [String]) {
        DispatchQueue.main.async {
            var arrdocumentTypes = [String]()
            if docType.contains("PNG") {
                arrdocumentTypes.append(kUTTypePNG as String)
            }
            if docType.contains("JPG") {
                arrdocumentTypes.append("JPG")
            }
            if docType.contains("JPEG") {
                arrdocumentTypes.append(kUTTypeJPEG as String)
            }
            if docType.contains("PDF") {
                arrdocumentTypes.append(kUTTypePDF as String)
            }
            if docType.contains("DOC") {
                arrdocumentTypes.append("org.openxmlformats.wordprocessingml.document")
                arrdocumentTypes.append("com.microsoft.word.doc")
            }
            if docType.contains("XLSX") {
                arrdocumentTypes.append("org.openxmlformats.spreadsheetml.sheet")
            }
            if docType.contains("XLS") {
                arrdocumentTypes.append("com.microsoft.excel.xls")
            }
            if docType.contains("GIF") {
                arrdocumentTypes.append("com.compuserve.gif")
            }
            let documentPicker = UIDocumentPickerViewController(documentTypes: arrdocumentTypes, in: .import)
            //["com.apple.iwork.pages.pages", "com.apple.iwork.numbers.numbers", "com.apple.iwork.keynote.key","public.image", "com.apple.application", "public.item","public.data", "public.content", "public.audiovisual-content", "public.zip-archive", "com.pkware.zip-archive", "public.composite-content", "public.text"]
            documentPicker.delegate = self
           if #available(iOS 11.0, *) {
                documentPicker.allowsMultipleSelection = false
            }
            self.viewController?.present(documentPicker, animated: true, completion: nil)
        }
       
    }
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
 
        let fileData = try! Data.init(contentsOf: url)
        imgName = url.absoluteString
        sourceData = fileData
        if (self.pickerHandler != nil){
            self.pickerHandler!(sourceData,url, UIImage.init(), self.tag)
        }
        sourceData = Data()
        imgName = ""
       // documentType == .FILE

       // arrImageData.append(["data":fileData as AnyObject,"mimeType":url.mimeType() as AnyObject,"name":url.lastPathComponent as AnyObject])
      //  self.manageSelectedDocCount()
     }
}
