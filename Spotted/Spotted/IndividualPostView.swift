//
//  IndividualPostView.swift
//  Spotted
//
//  Created by Evan Grote on 12/11/16.
//  Copyright © 2016 Evan Grote. All rights reserved.
//

import UIKit

class CustomIndividualPostTableViewCell: UITableViewCell {
    //customIndividualPostCell
    @IBOutlet weak var cellTagLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

class IndividualPostView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var individualPost: UserPost? = nil
    var individualPostImage: UIImage? = nil
    
    @IBOutlet weak var individualPostImageView: UIImageView!
    @IBOutlet weak var individualPostDescription: UILabel!
    @IBOutlet weak var individualPostTableView: UITableView!
    
    override func viewDidAppear(_ animated: Bool) {
        self.individualPostImageView.image = self.individualPostImage
        self.individualPostImageView.contentMode = .scaleAspectFit
        self.individualPostDescription.text = self.individualPost?.description
        
        self.individualPostDescription.sizeToFit()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.individualPost?.tags.count)!
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customIndividualPostCell", for: indexPath) as! CustomIndividualPostTableViewCell
        
        cell.cellTagLabel.text = self.individualPost?.tags[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Tag Selected: \(self.individualPost!.tags[indexPath.row])")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 30.0;//Choose your custom row height
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
