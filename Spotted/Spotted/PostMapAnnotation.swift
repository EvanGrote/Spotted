//
//  PostMapAnnotation.swift
//  Spotted
//
//  Created by Christopher Boswell on 11/27/16.
//  Copyright © 2016 Christopher Boswell, Evan Grote. All rights reserved.
//

import Foundation
import MapKit

class PostMapAnnotation: NSObject, MKAnnotation {
    let title: String?
    let postDescription: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.postDescription = locationName
        self.coordinate = coordinate
        
        super.init()
    }
    init(userPost: UserPost) {
        self.title = userPost.tags
        self.postDescription = userPost.description
        self.coordinate = CLLocationCoordinate2D(latitude: userPost.latitude, longitude: userPost.longitude)
    }
    
    var subtitle: String? {
        return postDescription
    }
}
