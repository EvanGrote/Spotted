//
//  UserPost.swift
//  Spotted
//
//  Created by Evan Grote on 11/15/16.
//  Copyright © 2016 Evan Grote. All rights reserved.
//

import Foundation
import Firebase

class UserPost {
    var description: String
    var tags: [String] = []
    var user: String
    var photo: String
    var latitude: Double
    var longitude: Double
    
    init(postDescription: String, postTags: [String], posterId: String, postPhoto: String, postLatitude: Double, postLongitude: Double) {
        self.description = postDescription
        self.tags.append(contentsOf: postTags)
        //self.tags = postTags
        self.user = posterId
        self.photo = postPhoto
        self.latitude = postLatitude
        self.longitude = postLongitude
    }
    
    init(snapshot: FIRDataSnapshot) {
        self.description = snapshot.value(forKey: "description") as! String
        self.tags = [snapshot.value(forKey: "tag") as! String]
        self.user = snapshot.value(forKey: "user") as! String
        self.photo = snapshot.value(forKey: "userPhoto") as! String
        self.latitude = snapshot.value(forKey: "latitude") as! Double
        self.longitude = snapshot.value(forKey: "longitude") as! Double
    }
    
    func printDescription() -> Void {
        print(self.description)
    }
    
    func printTags() -> Void {
        print(self.tags)
    }
    
    func printUser() -> Void {
        print(self.user)
    }
    
    func printPhoto() -> Void {
        print(self.photo)
    }
    
    func printPost() -> Void {
        print("Description: \(self.description)")
        print("Tags:        \(self.tags)")
        print("User:        \(self.user)")
        print("Photo:       \(self.photo)")
        print("Latitude:    \(self.latitude)")
        print("Longitude:   \(self.longitude)")
        print("")
    }
}
