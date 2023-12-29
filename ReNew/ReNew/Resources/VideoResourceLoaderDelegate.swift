//
//  VideoResourceLoaderDelegate.swift
//  Pix-cooking
//
//  Created by Nikkil Aarya M on 09/05/23.
//

import Foundation
import AVFoundation
import UIKit

public enum CacheResult<T> {
    case success(T)
    case failure(NSError)
}

class CacheManager {

    static let shared = CacheManager()

    private let fileManager = FileManager.default

    private lazy var mainDirectoryUrl: URL = {

        let documentsUrl = self.fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        return documentsUrl
    }()
    
    var ongoingDownloadTasks: [String: URLSessionDownloadTask] = [:]
    var downloadedIndexes: [String] = []
   // var generatedThumbnails: [Int: UIImage] = [:]
    private var urlSessionDownloadTask: URLSessionDownloadTask?
  //  var loadedAVPlayers: [Int: AVPlayer] = [:]
    private let accessQueue = DispatchQueue(label: "SynchronizedDictionaryAccess", attributes: .concurrent)

    
    func getFileWith(stringUrl: String, index: Int, freshDownload: (() -> ())?, completionHandler: @escaping (CacheResult<URL>) -> Void) {
        guard let file = directoryFor(stringUrl: stringUrl) else {return}

        //return file path if already exists in cache directory
        guard !fileManager.fileExists(atPath: file.path)  else {
            completionHandler(CacheResult.success(file))
            return
        }
        
        freshDownload?()
        
        
        DispatchQueue.global().async {

            if let videoData = NSData(contentsOf: URL(string: stringUrl)!) {
                videoData.write(to: file, atomically: true)

                DispatchQueue.main.async {
                    completionHandler(CacheResult.success(file))
                }
            } else {
                DispatchQueue.main.async {
                    completionHandler(CacheResult.failure(NSError(domain: "Could not download", code: 300)))
                }
            }
        }

    }
    
    func checkIfFileExist(stringUrl: String) ->  URL? {
        
        guard let file = directoryFor(stringUrl: stringUrl) else {return nil}

        if fileManager.fileExists(atPath: file.path) {return file}
        
        return nil
        
    }
    
    func preDownloadTheMedia(stringUrl: String) {
        guard let file = directoryFor(stringUrl: stringUrl) else {return}

//
//        //return file path if already exists in cache directory
        guard !fileManager.fileExists(atPath: file.path)  else {
            // completionHandler(CacheResult.success(file))
            return
        }
        
        self.accessQueue.async(flags: .barrier) { [weak self] in
            
            if let _ = self?.ongoingDownloadTasks[stringUrl] {return}
            
            guard let videoUrl = URL(string: stringUrl) else {return}
            
          //  print("indexToDownload \(index)")
            
            
            DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                // accessQueue.async { [weak self] in
                
                self?.urlSessionDownloadTask = URLSession.shared.downloadTask(with: videoUrl) {
                    urlOrNil, responseOrNil, errorOrNil in
                    
                    guard let fileURL = urlOrNil else {
                        self?.ongoingDownloadTasks[stringUrl] = nil
                        return
                    }
                    
                    do {
                        try FileManager.default.moveItem(at: fileURL, to: file)
                        self?.ongoingDownloadTasks[stringUrl] = nil
                        self?.downloadedIndexes.append(stringUrl)
                        
                        //  self?.loadedAVPlayers[index] = AVPlayer(playerItem: playerItem)
                        //print("downloadedIndexes --> \(self?.downloadedIndexes)")
                        
                    } catch {
                        self?.ongoingDownloadTasks[stringUrl] = nil
                        
                        print ("file error: \(error)")
                    }
                }
                
                self?.urlSessionDownloadTask?.resume()
                
                self?.accessQueue.async(flags: .barrier) {
                    self?.ongoingDownloadTasks[stringUrl] = self?.urlSessionDownloadTask
                    self?.urlSessionDownloadTask = nil
                }
                
            }
        }
          
        
    }

    private func directoryFor(stringUrl: String) -> URL? {

        guard let fileURL = URL(string: stringUrl)?.lastPathComponent else {return nil}

        let file = self.mainDirectoryUrl.appendingPathComponent(fileURL)

        return file
    }
}

extension CacheManager {
    
    func getSavedImage(named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
        return nil
    }
    
    func imageFromVideo(url: URL, at time: TimeInterval) -> Data? {
        let asset = AVURLAsset(url: url)
        let assetIG = AVAssetImageGenerator(asset: asset)
        assetIG.appliesPreferredTrackTransform = true
        assetIG.apertureMode = AVAssetImageGenerator.ApertureMode.encodedPixels

        let cmTime = CMTime(seconds: time, preferredTimescale: 60)
        let thumbnailImageRef: CGImage
        do {
            thumbnailImageRef = try assetIG.copyCGImage(at: cmTime, actualTime: nil)
        } catch let error {
            print("Error: \(error)")
            return nil
        }
        
        if let data = thumbnailImageRef.png {
            return data
        }
        
        return nil
    }
    
    func saveImage(imageName: String, imageData: Data?) -> Bool {
        guard let data = imageData else {
            return false
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return false
        }
        do {
            try data.write(to: directory.appendingPathComponent(imageName)!)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
}


extension CGImage {
    var png: Data? {
        guard let mutableData = CFDataCreateMutable(nil, 0),
            let destination = CGImageDestinationCreateWithData(mutableData, "public.png" as CFString, 1, nil) else { return nil }
        CGImageDestinationAddImage(destination, self, nil)
        guard CGImageDestinationFinalize(destination) else { return nil }
        return mutableData as Data
    }
}
