//
//  MapViewController.swift
//  COVID Data
//
//  Created by David Kababyan on 11/04/2020.
//  Copyright © 2020 David Kababyan. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

class MapViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: - Vars

    let locationManager = CLLocationManager()
    var allCountries: [Country] = []
    var selectedAnnotation: MKPointAnnotation?

    
    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupMapView()
        fetchCountryStatsFromCD()
    }
    

    private func setupMapView() {
        
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }

        mapView.delegate = self
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        
        if locationManager.location != nil {
            let locValue: CLLocationCoordinate2D = locationManager.location!.coordinate

            mapView.mapType = MKMapType.standard
            
            let span = MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
            let region = MKCoordinateRegion(center: locValue, span: span)
            mapView.setRegion(region, animated: true)

            if let coordinate = mapView.userLocation.location?.coordinate{
                mapView.setCenter(coordinate, animated: true)
            }

        }
    }
    

    private func fetchCountryStatsFromCD() {
        
        let context = AppDelegate.context

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Country")
        fetchRequest.sortDescriptors = []
        

        do {
            self.allCountries = try context.fetch(fetchRequest) as! [Country]
            
        } catch {
            print("Failed to fetch country")
        }
        

        if allCountries.count > 0 {
            self.setMapPins()
        } else {
            print("no countries in db")
        }
    }

    

    private func setMapPins() {
        
        for countryData in allCountries {
            
            let coordinate = CLLocationCoordinate2D(latitude: countryData.latitude, longitude: countryData.longitude)

            let title = countryData.country! + "\n Confirmed " + countryData.confirmed.formatNumber() + "\n Death " + countryData.deaths.formatNumber()

            let pin = MapPin(coordinate: coordinate, title: title, subtitle: "")

            mapView.addAnnotation(pin)
        }
    }

    private func countryFromSelectedPin(_ coordinate: CLLocationCoordinate2D?) {
        
        if coordinate != nil {
            for data in allCountries {
                if data.longitude == coordinate!.longitude && data.latitude == coordinate!.latitude {
                    showCountryData(data)
                    return
                }
            }
        }
    }
    
    private func showCountryData(_ countryData: Country) {
        
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "countryDetailView") as! CountryDetailViewController
        
        vc.country = countryData
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
}

extension MapViewController: CLLocationManagerDelegate, MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        countryFromSelectedPin(view.annotation?.coordinate)
        
    }

    
}

