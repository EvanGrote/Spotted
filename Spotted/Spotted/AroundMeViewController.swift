//
//  ViewController.swift
//  Spotted
//
//  Created by Evan Grote on 10/25/16.
//  Copyright © 2016 Evan Grote. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase
import FirebaseStorage

class AroundMeViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    var locValue:CLLocation = CLLocation.init(latitude: 0, longitude: 0)
    let regionRadius: CLLocationDistance = 1000
    var userPosts: [UserPost] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // permission for foreground location tracking
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            //initial location
            locationManager.requestLocation()
        }
        
        

        //download and format database entries
        let ref = FIRDatabase.database().reference(withPath: "posts")
        
        ref.observe(.value, with: { snapshot in
            self.userPosts = []
            
            var databasePosts: [UserPost] = []
            
            for post in snapshot.children {
                let description = (post as! FIRDataSnapshot).childSnapshot(forPath: "description").value!
                let tag = (post as! FIRDataSnapshot).childSnapshot(forPath: "tag").value!
                let user = (post as! FIRDataSnapshot).childSnapshot(forPath: "user").value!
                let userPhoto = (post as! FIRDataSnapshot).childSnapshot(forPath: "userPhoto").value!
                let userLatitude = (post as! FIRDataSnapshot).childSnapshot(forPath: "latitude").value!
                let userLongitude = (post as! FIRDataSnapshot).childSnapshot(forPath: "longitude").value!
                
                let individualPost = UserPost.init(postDescription: description as! String, postTags: tag as! String, posterId: user as! String, postPhoto: userPhoto as! String, postLatitude: userLatitude as! Double, postLongitude: userLongitude as! Double)
                
                individualPost.printPost()
                let meters:CLLocationDistance = self.locValue.distance(from: CLLocation.init(latitude: individualPost.latitude, longitude: individualPost.longitude))
                if(meters.isLess(than: 1609)) {
                    databasePosts.append(individualPost)
                }
            }
            
            self.userPosts = databasePosts
            
            //populate the map with markers for database entries
            if !(self.userPosts.isEmpty) {
                for i in 0...(self.userPosts.count-1) {
                    let annotation = PostMapAnnotation(userPost: self.userPosts[i])
                    self.mapView.addAnnotation(annotation)
                }
            }
        })
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //called when location manager asks for location
        locValue = manager.location!
        print("locations = \(locValue.coordinate)")
        centerMapOnLocation(location: locValue)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while updating location " + error.localizedDescription)
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        //if let annotation = annotation as? PostMapAnnotation {
            let identifier = String(NSDate().timeIntervalSince1970)
        print("IDENTIFIERRRRRR  "+identifier)
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
                as? MKPinAnnotationView { // 2
                dequeuedView.annotation = annotation
                view = dequeuedView
                view.canShowCallout = true
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
            }
            //let btn = UIButton(type: .detailDisclosure)
            
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIButton
            return view
        //}
        //return nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

