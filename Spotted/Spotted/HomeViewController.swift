//
//  HomeViewController.swift
//  Spotted
//
//  Created by Evan Grote on 12/11/16.
//  Copyright © 2016 Evan Grote. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    //HomeTableViewCell
    @IBOutlet weak var homeTableCellLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var homeTableView: UITableView!
    
    let userDefault = UserDefaults.standard
    var followedTags: [String] = []
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.followedTags = []
        self.homeTableView.reloadData()
        
        if (StaticVariables.followingTagsCount() > 0) {
            self.followedTags = StaticVariables.followingTags
            
            self.homeTableView.beginUpdates()
            for i in 0...(followedTags.count-1) {
                self.homeTableView.insertRows(at: [
                    NSIndexPath(row: i, section: 0) as IndexPath
                    ], with: .automatic)
            }
            self.homeTableView.endUpdates()
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followedTags.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        
        cell.homeTableCellLabel.text = followedTags[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Tag Selected: \(followedTags[indexPath.row])")
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "IndividualPostSegue" {
//            let selectedIndex = self.theTableView.indexPathForSelectedRow?.row
//            
//            (segue.destination as! IndividualPostView).individualPost = self.userPosts[selectedIndex!]
//            if (self.postImageDictionary.count > 0) {
//                (segue.destination as! IndividualPostView).individualPostImage = self.postImageDictionary[self.userPosts[selectedIndex!].photo]
//            }
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if userDefault.array(forKey: "followingTags") == nil {
            //no saved following tags
            print("made a new following list")
        } else {
            //there is a saved following list, load it
            print("loaded follow list from defaults")
            StaticVariables.followingTags = userDefault.array(forKey: "followingTags") as! [String]
        }
        
        homeTableView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
