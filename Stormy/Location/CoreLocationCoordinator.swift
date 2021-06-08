//
//  CoreLocationCoordinator.swift
//  Stormy
//
//  Copyright © 2020-2021 Maciej Chudzik. All rights reserved.
//

import Foundation
import CoreLocation


class CoreLocationCoordinator: NSObject, CLLocationManagerDelegate {
    
    
    private var locationManager = CLLocationManager()
    private var awaitingCompletion: ((CLLocation) -> ())?
    
    init(completion: @escaping (CLLocation) -> ()) {
        super.init()
        
        configureLocationManager()
        awaitingCompletion = completion
        checkAndStartUpdating()
        
        
    }
    
    func configureLocationManager(){
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.distanceFilter = 1000
        
    }
    
    func checkAndStartUpdating(){
        
        if locationManager.authorizationStatus == .authorizedWhenInUse{
            
            locationManager.startUpdatingLocation()
            
        }else{
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        
    }
    
    
    func getLocationData(completion: @escaping (CLLocation) -> ()) {
        
        
        awaitingCompletion = completion
        checkAndStartUpdating()
        
    }
    
    func getPlaceMarkAndCountryCode(_ location: CLLocation, completion: @escaping (CLPlacemark?,String?) -> Void){
        
        CLGeocoder().reverseGeocodeLocation(location){(placemarks, error) -> Void in
            
            if error == nil{
                
                if let placemark = placemarks?.last, placemarks!.count > 0 {
                    
                    completion(placemark, placemark.isoCountryCode)
                }
                
            }else{
                
                completion(nil,nil)
            }
            
        }
        
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first{
            
            awaitingCompletion?(location)
        
            self.locationManager.stopUpdatingLocation()
 
        }
    }

    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        
        
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            locationManager.requestWhenInUseAuthorization()
            
        }
    }
}

