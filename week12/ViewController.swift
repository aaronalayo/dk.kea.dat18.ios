//
//  ViewController.swift
//  MapDemo2020
//
//  Created by Aaron ALAYO on 20/03/2020.
//  Copyright © 2020 Aaron ALAYO. All rights reserved.
//

import UIKit
import MapKit
import FirebaseFirestore
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        mapView.delegate = self
        locationManager.requestWhenInUseAuthorization()//ask user for permission to share location
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer//how precise do you want it
        FirebaseRepo.startListener(vc: self)
        mapView.showsUserLocation = true
        let longPressed = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
        mapView.addGestureRecognizer(longPressed)
        
        
    }
    
    func updateMarkers(snap: QuerySnapshot){
        let markers = MapDataAdapter.getMKAnnotationsFromData(snap: snap) //call adapter to convert data
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(markers)
    }

    @IBAction func longPress(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .ended { // limit amounts of calls to just one
 
            let cgPoint = sender.location(in: mapView)
            let coordinate2D = mapView.convert(cgPoint, toCoordinateFrom: mapView)

            let alert = UIAlertController(title: "New Place", message: "Enter a name", preferredStyle: UIAlertController.Style.alert)
            
            alert.addTextField { (textField: UITextField) in
                
                textField.placeholder = "Name"
            }
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (UIAlertAction) in
                
                if let tempPlace = alert.textFields?[0].text {
                    let place = tempPlace
                    let annotation = MKPointAnnotation()
                    annotation.title = place
                    annotation.coordinate = coordinate2D
                    let lat = coordinate2D.latitude
                    let lon = coordinate2D.longitude
                    annotation.subtitle = "Lat " + (String(format: "%.2f", lat) + " Lon " + String(format: "%.2f", lon))
                    
                    self.mapView.addAnnotation(annotation)
                    FirebaseRepo.addMarker(title: annotation.title!, lat:coordinate2D.latitude, lon:coordinate2D.longitude)
                    print("long pressed\(coordinate2D)")
                    
                    
                }
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { (UIAlertAction) in
                
            }
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            
            present(alert, animated: true, completion: nil)
            
        }
        
        
    }
    
    @IBAction func startUpdate(_ sender: UIButton) {
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func stopUpdate(_ sender: UIButton) {
        locationManager.stopUpdatingLocation()
    }
    
}
extension ViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coord = locations.last?.coordinate {
            print("new location")
            let region = MKCoordinateRegion(center: coord, latitudinalMeters: 300, longitudinalMeters: 300)
            mapView.setRegion(region, animated: true) // will move the "camera"
        }
    }
    
    
}
extension ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        print("tapped on pin ")
        view.canShowCallout = true
        view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let marker = self.mapView.selectedAnnotations[0] as! MKPointAnnotation
            let placeName = marker.title
            let ac = UIAlertController(title: placeName, message: "Choose", preferredStyle: .actionSheet)
            weak var weakSelf = self
            ac.addAction(UIAlertAction(title: "DELETE", style: .destructive, handler: { action in
                self.mapView.removeAnnotation(marker)
                let geoPoint = GeoPoint(latitude: marker.coordinate.latitude, longitude: marker.coordinate.longitude)
                FirebaseRepo.deleteMarker(with: geoPoint)
                
            }))
            
            ac.addAction(UIAlertAction(title: "EDIT", style: .default, handler: {
                action in
                let alert = UIAlertController(title: "Edit Place", message: "Modify name", preferredStyle: UIAlertController.Style.alert)
                
                alert.addTextField { (textField: UITextField) in
                    textField.placeholder = "Name"
                }
                
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (alertAction) in
                    if let tempPlace = alert.textFields?[0].text {
                        let place = tempPlace
                        marker.title = place
                        let geoPoint = GeoPoint(latitude: marker.coordinate.latitude, longitude: marker.coordinate.longitude)
                        FirebaseRepo.getMarkerId(with: geoPoint) { (id) in
                            if let title = marker.title {
                                FirebaseRepo.updateMarker(id: id, title: title)
                            }
                        }
                    }
                }
                
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { (alertAction) in }
                
                alert.addAction(okAction)
                alert.addAction(cancelAction)
                
                if let strongSelf = weakSelf {
                    strongSelf.present(alert, animated: true, completion: nil)
                }
            }))
            
            ac.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: nil))
            present(ac, animated: true)
        }
        
    }
    

}
