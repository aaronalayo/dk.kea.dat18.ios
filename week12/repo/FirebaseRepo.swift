//
//  FirebaseRepo.swift
//  MapDemo2020
//
//  Created by Aaron ALAYO on 20/03/2020.
//  Copyright © 2020 Aaron ALAYO. All rights reserved.
//

import Foundation
import FirebaseFirestore


class FirebaseRepo {
    
    private static let db = Firestore.firestore() // gets the Firebase instance
    private static let path = "locations"
    
    static func startListener(vc: ViewController){
        db.collection(path).addSnapshotListener { (snap, error) in
            if error != nil {  // check if there is an error. If so, then return
                return
            }
            
            if let snap = snap { // we check, if the snap has a value.
                // if snap does have a value, it is reassigned to another variable, also called snap
                // This is a way of unwrapping the snap Optional
                vc.updateMarkers(snap: snap)
            }
        }
    }
    
    static func addMarker(title:String, lat:Double, lon:Double){
        let ref = db.collection(path).document()
        var map = [String:Any]()
        map["text"] = title
        map["coordinates"] = GeoPoint(latitude: lat, longitude: lon)
        ref.setData(map)
    }
    
    static func deleteMarker(with coordinates: GeoPoint) {
        db.collection(path).whereField("coordinates", isEqualTo: coordinates)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                        deleteMarker(id: document.documentID)
                    }
                }
        }
        
    }
    
    static func deleteMarker(id:String) {
        
        let ref = db.collection(path).document(id)
        ref.delete()
        print("marker deleted")
    }
    
    static func getMarkerId(with coordinates: GeoPoint, completion: @escaping (String)-> Void) {
        db.collection(path).whereField("coordinates", isEqualTo: coordinates)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                        completion(document.documentID)
                    }
                }
        }
        
    }
    
    static func updateMarker(id: String, title: String) {
        let ref = db.collection(path).document(id)
        ref.updateData(["text": title]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    
}
