//
//  LocationManager.swift
//

import UIKit
import CoreLocation

class LocationHandler: NSObject, CLLocationManagerDelegate {
    
    static let shared = LocationHandler()
    let locationManager = CLLocationManager()
    var provideLocationBlock: ((_ locationManager: CLLocationManager,_ location: CLLocation)->(Bool))?
    var location: CLLocation?
    
    private override init() {
        super.init()
        
    }
    
    func getLocationUpdates(completionHandler: @escaping ((_ locationManager: CLLocationManager,_ location: CLLocation)->(Bool))) {
        location = nil
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.activityType = .automotiveNavigation
//        locationManager.distanceFilter = 10
        locationManager.allowsBackgroundLocationUpdates = true

        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        provideLocationBlock = completionHandler
        
    }
    
    func getPlacemark(fromLocation location: CLLocation, completionBlock: @escaping ((CLPlacemark)->())) {
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
            
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            if placemarks!.count > 0 {
                if let placemark = placemarks!.first {
                    completionBlock(placemark)
                }
            }
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("locationManager update")

        if locations.count == 0 {
            return
        }
        
        if let block = provideLocationBlock {
            location = locations.last ?? CLLocation(latitude: 0, longitude: 0)
            if block(locationManager,location!) {
                
            }
        }
    }
    
    func locationAvailable(completionBlock: @escaping ((Bool)->())) {
        switch(CLLocationManager.authorizationStatus()) {
        case .notDetermined:
            print("No determinded")
            self.gotoSettingForLocation()
            completionBlock(false)
        case  .restricted, .denied:
            print("No access")
            self.gotoSettingForLocation()
            completionBlock(false)
            
        case .authorizedAlways, .authorizedWhenInUse:
            print("Granted")
            completionBlock(true)
        @unknown default:
            self.gotoSettingForLocation()
            completionBlock(false)
        }
    }
    
    func gotoSettingForLocation() {
        let alertController = UIAlertController (title: "Please enable location for checkin", message: nil, preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        }
        alertController.addAction(settingsAction)
        
        UIApplication.topViewController()?.present(alertController, animated: true, completion: nil)
    }
    
    func getDistance(fromLocation: CLLocationCoordinate2D,toLocation: CLLocationCoordinate2D) -> CLLocationDistance {
        let coordinate₀ = CLLocation(latitude: fromLocation.latitude, longitude: fromLocation.longitude)
        let coordinate₁ = CLLocation(latitude: toLocation.latitude, longitude: toLocation.longitude)

        return coordinate₀.distance(from: coordinate₁) / 1000
    }
        
}
