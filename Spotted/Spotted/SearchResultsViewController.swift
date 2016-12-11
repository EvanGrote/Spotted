//
//  FollowingTableViewController.swift
//  Spotted
//
//  Created by Evan Grote on 11/15/16.
//  Copyright © 2016 Christopher Boswell, Evan Grote. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage


class SearchResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var searchString:String = ""
    
    @IBOutlet weak var followingButton: UIButton!
    @IBOutlet weak var theTableView: UITableView!
    var userPosts: [UserPost] = []
    
    var postImageDictionary: [String:UIImage] = [:]
    
    var rowSelected: Int = 0
    var indexPathSelected: IndexPath? = nil
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(StaticVariables.followingTags)
        if StaticVariables.followingTags.contains(searchString) {
            followingButton.setTitle("Unfollow", for: .normal)
        } else {
            followingButton.setTitle("Follow", for: .normal)
        }

        
        let ref = FIRDatabase.database().reference(withPath: "posts")
        
        ref.observe(.value, with: { snapshot in
            self.userPosts = []
            self.theTableView.reloadData()
            
            var databasePosts: [UserPost] = []
            
            for post in snapshot.children {
                let description = (post as! FIRDataSnapshot).childSnapshot(forPath: "description").value!
                let tag = (post as! FIRDataSnapshot).childSnapshot(forPath: "tag").value!
                
                var delimitingCharacterSet = CharacterSet()
                delimitingCharacterSet.insert(charactersIn: " \",./<>?'`~!@#$%^&*()-_+=;:[]{}|")
                
                let tagArray = (tag as! String).components(separatedBy: delimitingCharacterSet)
                
                let user = (post as! FIRDataSnapshot).childSnapshot(forPath: "user").value!
                let userPhoto = (post as! FIRDataSnapshot).childSnapshot(forPath: "userPhoto").value!
                let userLatitude = (post as! FIRDataSnapshot).childSnapshot(forPath: "latitude").value!
                let userLongitude = (post as! FIRDataSnapshot).childSnapshot(forPath: "longitude").value!
                
                let individualPost = UserPost.init(postDescription: description as! String, postTags: tagArray, posterId: user as! String, postPhoto: userPhoto as! String, postLatitude: userLatitude as! Double, postLongitude: userLongitude as! Double)
                print("starting to filter tags")
                //databasePosts.append(individualPost)
                for tag in individualPost.tags {
                    individualPost.printPost()
                    if (self.searchStringForPartialMatch(stringToBeSearched: tag, searchString: self.searchString)) {
                        databasePosts.append(individualPost)
                    }
                }
            }
            
            self.userPosts = databasePosts
            if !(self.userPosts.isEmpty) {
            for i in self.userPosts.indices {
                let photoFilePath = self.userPosts[i].photo
                let storageRef = FIRStorage.storage().reference().child(photoFilePath)
                storageRef.data(withMaxSize: 3 * 1024 * 1024) { (data, error) -> Void in
                    if (error != nil) {
                        // Error occurred
                    } else {
                        // Data for "images/island.jpg" is returned
                        // ... let islandImage: UIImage! = UIImage(data: data!)
                        self.postImageDictionary["\(self.userPosts[i].photo)"] = UIImage(data: data!)
                        print("\(self.userPosts[i].photo) appended")
                        
                        DispatchQueue.main.async {
                            self.theTableView.reloadData()
                        }
                    }
                }
            }
            
                self.theTableView.beginUpdates()
                for i in 0...(self.userPosts.count-1) {
                    self.theTableView.insertRows(at: [
                        NSIndexPath(row: i, section: 0) as IndexPath
                        ], with: .automatic)
                }
                self.theTableView.endUpdates()
            }
        })
    }
    
    @IBAction func followButtonPressed(_ sender: UIButton) {
        if StaticVariables.followingTags.contains(searchString) {
            print("unfollowed")
            followingButton.setTitle("Follow", for: .normal)
            let i = StaticVariables.followingTags.index(of: searchString)
            StaticVariables.followingTagsCount -= 1
            StaticVariables.followingTags.remove(at: i!)
            print(StaticVariables.followingTags)
        } else {
            print("now following")
            followingButton.setTitle("Unfollow", for: .normal)
            StaticVariables.followingTags.append(searchString)
            StaticVariables.followingTagsCount += 1
            print(StaticVariables.followingTags)
        }
    }
    
    
    func searchStringForPartialMatch(stringToBeSearched:String, searchString:String) -> Bool {
        if stringToBeSearched.lowercased().range(of: searchString) != nil {
            print("string matches")
            return true
        }
        print("String does not match")
        return false
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userPosts.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customSearchCell", for: indexPath) as! CustomTableViewCell
        
        if (self.postImageDictionary.count > 0) {
            cell.cellImageView.image = self.postImageDictionary[self.userPosts[indexPath.row].photo]
        }
        
        for i in 1...self.userPosts[indexPath.row].tags.count {
            if (i == 1) {
                cell.cellTagLabel.text = self.userPosts[indexPath.row].tags[i-1]
            } else {
                cell.cellTagLabel.text?.append(", \(self.userPosts[indexPath.row].tags[i-1])")
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Tag Selected: \(self.userPosts[indexPath.row].tags)")
        
        //performSegue(withIdentifier: "IndividualPostSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToIndividualPostSegue" {
            let selectedIndex = self.theTableView.indexPathForSelectedRow?.row
            
            (segue.destination as! IndividualPostView).individualPost = self.userPosts[selectedIndex!]
            if (self.postImageDictionary.count > 0) {
                (segue.destination as! IndividualPostView).individualPostImage = self.postImageDictionary[self.userPosts[selectedIndex!].photo]
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        theTableView.dataSource = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
