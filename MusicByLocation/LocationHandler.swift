//
//  LocationHandler.swift
//  MusicByLocation
//
//  Created by Perkins, Alexander (ABH) on 02/03/2023.
//

import Foundation
import CoreLocation

class LocationHandler: NSObject, CLLocationManagerDelegate, ObservableObject {
    let manager = CLLocationManager()
    let geocoder = CLGeocoder()
    var lastKnownCoordinates: String = ""
    @Published var lastKnownCity: String = "huh"
    @Published var lastKnownCountry: String = "uh"
    @Published var lastKnownInterest: [String] = ["damn"]
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    func requestAuthorisation() {
        manager.requestWhenInUseAuthorization()
    }
    
    func requestLocation() {
        manager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let firstLocation = locations.first {
            geocoder.reverseGeocodeLocation(firstLocation, completionHandler: { (placemarks, error) in
                if error != nil {
                    self.lastKnownCity = "Could not perform look up of location from coordinate information"
                } else {
                    if let firstPlacemark = placemarks?[0] {
                        self.lastKnownCity = firstPlacemark.locality ?? "Couldn't find locality"
                        self.lastKnownCountry = firstPlacemark.country ?? "Couldn't find region"
                        self.lastKnownInterest = firstPlacemark.areasOfInterest ?? ["Couldn't find anywhere interesting"]
                    } else {
                        self.lastKnownCity = "No placemarks"
                    }
                }
            })
        } else {
            self.lastKnownCity = "No location"
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        lastKnownCoordinates = "Error finding location"
    }
    
    func displayLastKnowLocation() -> String {
        return """
        Country: \(lastKnownCountry)
        City: \(lastKnownCity)
        Areas of Interest: \(lastKnownInterest[0])
        """
    }
}
