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
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var coordinatesLabel: UILabel!
    @IBOutlet weak var aqiLabel: UILabel!

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
        NetworkManager.shared.getAirQuality(lat: String(format: "%f",location.latitude), lon: String(format: "%f",location.latitude)) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let airData):
                 print(airData)
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Bad things happen", message: error.rawValue, buttonTitle: "OK")
            }
        }
    }

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("Coordinates: \(locValue.latitude) \(locValue.longitude)")
        location.latitude = locValue.latitude
        location.longitude = locValue.longitude
        coordinatesLabel.text = "Coordinates: \(locValue.latitude) \(locValue.longitude)"
        getData()
//        NetworkManager.shared.work(lat: String(format: "%f",locValue.latitude), lon: String(format: "%f",locValue.longitude))
        
    }
}

extension UIViewController {
    
    func presentGFAlertOnMainThread(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alertVC = AQIAlertVC(title: title, messages: message, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            self.present(alertVC, animated: true)
            
        }
    }
}
