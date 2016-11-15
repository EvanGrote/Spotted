//
//  FollowingTableViewController.swift
//  Spotted
//
//  Created by Evan Grote on 11/15/16.
//  Copyright © 2016 Evan Grote. All rights reserved.
//

import UIKit
import Firebase

class FollowingTableViewController: UIViewController {
    
    @IBOutlet weak var theTableView: UITableView!
    var userPosts: [UserPost] = []
    
    override func viewDidAppear(_ animated: Bool) {
        let ref = FIRDatabase.database().reference(withPath: "posts")
        
        ref.observe(.value, with: { snapshot in
            //print(snapshot.value!)
            
            var databasePosts: [UserPost] = []
            
            print("Still alive")
            for post in snapshot.children {
                print((post as! FIRDataSnapshot).childSnapshot(forPath: "tag"))
                
                print("I cannot die")
                //let individualPost = UserPost(snapshot: post as! FIRDataSnapshot)
                print("Creates some shit")
                //databasePosts.append(individualPost)
                print("Everything is fine")
            }
            
            print("Try to kill me")
            self.userPosts = databasePosts
            //self.theTableView.reloadData()
            print("Probably dead now")
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
