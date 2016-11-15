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
            
            for post in snapshot.children {
                let description = (post as! FIRDataSnapshot).childSnapshot(forPath: "description").value!
                let tag = (post as! FIRDataSnapshot).childSnapshot(forPath: "tag").value!
                let user = (post as! FIRDataSnapshot).childSnapshot(forPath: "user").value!
                let userPhoto = (post as! FIRDataSnapshot).childSnapshot(forPath: "userPhoto").value!
                
                let individualPost = UserPost.init(postDescription: description as! String, postTags: tag as! String, posterId: user as! String, postPhoto: userPhoto as! String)
                
                individualPost.printPost()
                databasePosts.append(individualPost)
            }
            
            self.userPosts = databasePosts
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
