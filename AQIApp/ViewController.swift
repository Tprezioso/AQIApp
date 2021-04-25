//
//  ViewController.swift
//  AQIApp
//
//  Created by Thomas Prezioso Jr on 4/24/21.
//

import UIKit
import CoreLocation


class ViewController: UIViewController, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    var location = CLLocationCoordinate2D()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCoreLocation()
    }

    func setupCoreLocation() {
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }

    }

    func getData(){
        NetworkManager.shared.getAirQuality(lat: String(format: "%f",location.latitude), lon: String(format: "%f",location.latitude)) { result in
            print(result)
        }
    }

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        NetworkManager.shared.work(lat: String(format: "%f",locValue.latitude), lon: String(format: "%f",locValue.longitude))
        location.latitude = locValue.latitude
        location.longitude = locValue.longitude
    }
}

