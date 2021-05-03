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
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBOutlet weak var levelLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCoreLocation()
        activityView.style = .large
    }
    
    func setupCoreLocation() {
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func getAirQualityData(lat: String, lon: String){
        self.activityView.startAnimating()
        NetworkManager.shared.getAirQualityData(lat: lat, lon: lon) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let airData):
                print(airData)
                self.cityLabel.text = airData.data.city.name
                self.setupAQINumber(aqi: airData.data.aqi)
                self.activityView.isHidden = true
            case .failure(let error):
                self.activityView.isHidden = true
                self.presentGFAlertOnMainThread(title: "Bad things happen", message: error.rawValue, buttonTitle: "OK")
            }
        }
    }
    
    func setupAQINumber(aqi: Int) {
        self.aqiLabel.text = "AQI: \(aqi)"
        switch aqi {
        case 0..<50:
            self.aqiLabel.backgroundColor = .green
            self.levelLabel.text = "Good"
        case 51..<100:
            self.aqiLabel.backgroundColor = .yellow
            self.levelLabel.text = "Moderate"
        case 101..<150:
            self.aqiLabel.backgroundColor = .orange
            self.levelLabel.text = "Unhealthy for Sensitive Groups"
        case 151..<200:
            self.aqiLabel.backgroundColor = .red
            self.levelLabel.text = "Unhealthy"
        case 201..<300:
            self.aqiLabel.backgroundColor = .purple
            self.levelLabel.text = "Very Unhealthy"
        case 301..<500:
            self.aqiLabel.backgroundColor = .magenta
            self.levelLabel.text = "Hazardous"
        default:
            self.aqiLabel.backgroundColor = .black
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("Coordinates: \(locValue.latitude) \(locValue.longitude)")
        location.latitude = locValue.latitude
        location.longitude = locValue.longitude
        coordinatesLabel.text = "Coordinates: \(locValue.latitude) \(locValue.longitude)"
        getAirQualityData(lat: String(format: "%f",self.location.latitude), lon: String(format: "%f",self.location.longitude))
        
    }
    @IBAction func reloadButtonPressed(_ sender: Any) {
        getAirQualityData(lat: String(format: "%f",self.location.latitude), lon: String(format: "%f",self.location.longitude))
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
