//
//  FollowingTableViewController.swift
//  Spotted
//
//  Created by Evan Grote on 11/15/16.
//  Copyright © 2016 Evan Grote. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class CustomTableViewCell: UITableViewCell {
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var cellTagLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

class FollowingTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var customTableCell: UITableView!
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
            
            self.theTableView.beginUpdates()
            for i in 0...(self.userPosts.count-1) {
                self.theTableView.insertRows(at: [
                    NSIndexPath(row: i, section: 0) as IndexPath
                    ], with: .automatic)
            }
            self.theTableView.endUpdates()
        })
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userPosts.count
    }
    
    func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomTableViewCell
        //cell.cellImageView = self.userPosts[indexPath.row].photo
        cell.cellTagLabel.text = self.userPosts[indexPath.row].tags
        
        return cell
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
