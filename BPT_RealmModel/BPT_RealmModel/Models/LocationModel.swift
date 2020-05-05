//
//  LocationModel.swift
//  BPT_RealmModel
//
//  Created by Apple on 27/02/20.
//  Copyright © 2020 Agaze. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationServiceDelegate {
    func tracingLocation(currentLocation: CLLocation)
    func tracingLocationDidFailWithError(error: NSError)
}

class LocationService: NSObject, CLLocationManagerDelegate {
    
    public static var sharedInstance = LocationService ()
    
    var locationManager: CLLocationManager?
    var lastLocation: CLLocation?
    var delegate: LocationServiceDelegate?
    
    override init() {
        super.init()
        
        self.locationManager = CLLocationManager()
        guard let locationManager = self.locationManager else {
            return
        }
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            // you have 2 choice
            // 1. requestAlwaysAuthorization
            // 2. requestWhenInUseAuthorization
            locationManager.requestAlwaysAuthorization()
        }
        else if CLLocationManager.authorizationStatus() == .denied {
            lastLocation = CLLocation(latitude: 39.7392, longitude: 104.9903) // set default location to Denver ...
            getAreaIDfromLocation(latitude: (lastLocation?.coordinate.latitude)!, longitude: (lastLocation?.coordinate.longitude)!)
        }
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // The accuracy of the location data
        locationManager.distanceFilter = 200 // The minimum distance (measured in meters) a device must move horizontally before an update event is generated.
        locationManager.delegate = self
    }
    
    func startUpdatingLocation() {
        print("Starting Location Updates")
        locationManager?.requestLocation()
        self.locationManager?.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        print("Stop Location Updates")
        self.locationManager?.stopUpdatingLocation()
    }
    
    // CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else {
            return
        }
        
        // singleton for get last location
        self.lastLocation = location
        
        // use for real time update location
        updateLocation(currentLocation: location)
        getAreaIDfromLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.latitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        // do on error
        updateLocationDidFailWithError(error: error as NSError)
    }
    
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .restricted,.denied,.notDetermined:
            print(status)
            // report error, set default location
            lastLocation = CLLocation(latitude: 39.7392, longitude: 104.9903) // set default location to Denver ...
            getAreaIDfromLocation(latitude: (lastLocation?.coordinate.latitude)!, longitude: (lastLocation?.coordinate.longitude)!)
        default:
            // location access allowed, start monitoring
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    // location access allowed, start monitoring
                    startUpdatingLocation()
                }
            }
        }
    }
    
    // Private function
    private func updateLocation(currentLocation: CLLocation){
        
        guard let delegate = self.delegate else {
            return
        }
        
        delegate.tracingLocation(currentLocation: currentLocation)
    }
    
    private func updateLocationDidFailWithError(error: NSError) {
        
        guard let delegate = self.delegate else {
            return
        }
        
        delegate.tracingLocationDidFailWithError(error: error)
    }
    
    func getAreaIDfromLocation(latitude: Double, longitude: Double) {
        let theme_id = 0
        let adjLat = 10 as Double
        let adjLong = 10 as Double
        let vent_id_theme_bit_position = 31
        let vent_id_lat_bit_position = 23
        let vent_id_long_bit_position = 12
        let lat = abs(Int(latitude*adjLat))
        let longi = abs(Int(longitude*adjLong))
        let theme_bits = theme_id << vent_id_theme_bit_position
        let lat_bits = lat << vent_id_lat_bit_position
        let long_bits = longi << vent_id_long_bit_position
        
        let areaId = (theme_bits) | (lat_bits) | (long_bits)
        print("areaID",areaId)
        //            mventAreaId = ventID
        //            mrootnode_id = ventID
        //            super.mSelectedNodeId = ventID
        
    }
}
