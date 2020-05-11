//
//  SecondViewController.swift
//  MapDemo2020
//
//  Created by Aaron ALAYO on 20/03/2020.
//  Copyright © 2020 Aaron ALAYO. All rights reserved.

import UIKit
import MapKit
import CoreLocation

class customPin: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(pinTitle:String, pinSubTitle:String, location:CLLocationCoordinate2D) {
        self.title = pinTitle
        self.subtitle = pinSubTitle
        self.coordinate = location
    }
}

class SecondViewController: UIViewController, MKMapViewDelegate {
    
    
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "virus-background")!)
        
        
        let marker1 = MKPointAnnotation()
        let marker2 = MKPointAnnotation()
        let marker3 = MKPointAnnotation()
        let marker4 = MKPointAnnotation()
        let marker5 = MKPointAnnotation()
        let marker6 = MKPointAnnotation()
        let marker7 = MKPointAnnotation()
        let marker8 = MKPointAnnotation()
        let marker9 = MKPointAnnotation()
        let marker10 = MKPointAnnotation()
        let marker11 = MKPointAnnotation()
        let marker12 = MKPointAnnotation()
        let marker13 = MKPointAnnotation()
        let marker14 = MKPointAnnotation()
        let marker15 = MKPointAnnotation()
        
        
        let WHO = CLLocationCoordinate2D(latitude: 55.704935, longitude: 12.598395)
        let DHM = CLLocationCoordinate2D(latitude: 55.662067, longitude: 12.571113)
        let WHOCollabCenter = CLLocationCoordinate2D(latitude: 55.685164, longitude: 12.524933)
        let Herlev = CLLocationCoordinate2D(latitude: 55.731316, longitude: 12.442820)
        let Rigshospitalet = CLLocationCoordinate2D(latitude: 55.695853, longitude: 12.566911)
        let Amager = CLLocationCoordinate2D(latitude: 55.654883, longitude: 12.620386)
        let HejmdalPrivateHospital = CLLocationCoordinate2D(latitude: 55.680116, longitude: 12.556387)
        let Hvidovre = CLLocationCoordinate2D(latitude: 55.648560, longitude: 12.470220)
        let Bispebjerg = CLLocationCoordinate2D(latitude: 55.713968, longitude: 12.539950)
        let Gentofte = CLLocationCoordinate2D(latitude: 55.738861, longitude: 12.546746)
        let Glostrup = CLLocationCoordinate2D(latitude: 55.670377, longitude: 12.389268)
        let Roskilde = CLLocationCoordinate2D(latitude: 55.634777, longitude: 12.090976)
        let Odense = CLLocationCoordinate2D(latitude: 55.384848, longitude: 10.367978)
        let Aarhus = CLLocationCoordinate2D(latitude: 56.140500, longitude: 10.188054)
        let Aarhus_2 = CLLocationCoordinate2D(latitude: 56.191562, longitude: 10.168498)
        
        
        
        marker1.coordinate = WHO
        marker1.title = "World Health Organization Branch Building"
        marker2.coordinate = DHM
        marker2.title = "Danish Health Ministry Building"
        marker3.coordinate = WHOCollabCenter
        marker3.title = "Frederiksberg Hospital and WHO Collaboration Center"
        marker4.coordinate = Herlev
        marker4.title = "Herlev Hospital"
        marker5.coordinate = Rigshospitalet
        marker5.title = "Rigshospitalet"
        marker6.coordinate = Amager
        marker6.title = "Amager Hospital"
        marker7.coordinate = HejmdalPrivateHospital
        marker7.title = "Hejmdal Private Hospital"
        marker8.coordinate = Hvidovre
        marker8.title = "Hvidovre Hospital"
        marker9.coordinate = Bispebjerg
        marker9.title = "Bispebjerg Hospital"
        marker10.coordinate = Gentofte
        marker10.title = "Gentofte Hospital"
        marker11.coordinate = Glostrup
        marker11.title = "Glostrup Hospital"
        marker12.coordinate = Roskilde
        marker12.title = "Roskilde Hospital"
        marker13.coordinate = Odense
        marker13.title = "Odense Hospital"
        marker14.coordinate = Aarhus
        marker14.title = "Aarhus Hospital"
        marker15.coordinate = Aarhus_2
        marker15.title = "Aarhus Univerisity Hospital"
        
        
        mapView.addAnnotation(marker1)
        mapView.addAnnotation(marker2)
        mapView.addAnnotation(marker3)
        mapView.addAnnotation(marker4)
        mapView.addAnnotation(marker5)
        mapView.addAnnotation(marker6)
        mapView.addAnnotation(marker7)
        mapView.addAnnotation(marker8)
        mapView.addAnnotation(marker9)
        mapView.addAnnotation(marker10)
        mapView.addAnnotation(marker11)
        mapView.addAnnotation(marker12)
        mapView.addAnnotation(marker13)
        mapView.addAnnotation(marker14)
        mapView.addAnnotation(marker15)
        
        
        mapView.showsUserLocation = true
        
        
        
        //        let WHO = CLLocationCoordinate2D(latitude: 55.704935, longitude: 12.598395)  ^This is repeated above^
        let firstUserLoc = CLLocationCoordinate2D(latitude: 55.684234619140625, longitude: 12.488873032864637)
        //        let firstUserLoc:CLLocationCoordinate2D = locationManager.location!.coordinate
        //        print("your location is: \(firstUserLoc)")
        let sourcePin = customPin(pinTitle: "user", pinSubTitle: "", location: firstUserLoc )
        let destinationPin = customPin(pinTitle: "WORLD HEALTH ORGANISATION", pinSubTitle: "", location: WHO)
        self.mapView.addAnnotation(sourcePin)
        self.mapView.addAnnotation(destinationPin)
        
        
        
        self.mapView.delegate = self
        
        
    }
    
    //MARK:- MapKit delegates
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        self.mapView.removeOverlays(mapView.overlays)
        let request = MKDirections.Request()
        request.source = MKMapItem.forCurrentLocation()
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: (view.annotation?.coordinate)!))
        request.requestsAlternateRoutes = true
        request.requestsAlternateRoutes = true
        request.transportType = .walking
        let directions = MKDirections(request: request)

        directions.calculate { [unowned self] response, error in
            guard let unwrappedResponse = response else { return }
            
            for route in unwrappedResponse.routes {
                self.mapView.addOverlay(route.polyline);                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                self.mapView.userTrackingMode = MKUserTrackingMode(rawValue: 2)!
                self.mapView.mapType = MKMapType(rawValue: 0)!
                self.locationManager.startUpdatingLocation()
                self.locationManager.startUpdatingHeading()
                
                return
            }
        }
        
    }
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polyLine = overlay
        let polyLineRenderer = MKPolylineRenderer(overlay: polyLine)
        polyLineRenderer.strokeColor = UIColor.blue
        polyLineRenderer.lineWidth = 5.0
        return polyLineRenderer
    }
    
    
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coord = locations.last?.coordinate {
            let region = MKCoordinateRegion(center: coord, latitudinalMeters: 300, longitudinalMeters: 300)
            mapView.setRegion(region, animated: true) // will move the "camera"
            self.mapView.showsUserLocation = true
            
        }
    }
    
    
    
}

