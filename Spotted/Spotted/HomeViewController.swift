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
    
    let userDefault = UserDefaults.standard

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StaticVariables.numberOfFollowingTags
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        
        // Set cell label
        cell.homeTableCellLabel.text = StaticVariables.followingTags[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Tag Selected: \(StaticVariables.followingTags[indexPath.row])")
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
        
        StaticVariables.numberOfFollowingTags = userDefault.integer(forKey: "numberOfFollowingTags")
        if StaticVariables.numberOfFollowingTags == 0 {
            //no saved following tags
            print("made a new following list")
        } else {
            //there is a saved following list, load it
            print("loaded follow list from defaults")
            StaticVariables.followingTags = userDefault.array(forKey: "followingTags") as! [String]
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
