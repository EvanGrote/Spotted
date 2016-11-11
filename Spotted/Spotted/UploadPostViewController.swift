//
//  UploadPostViewController.swift
//  Spotted
//
//  Created by Christopher Boswell on 11/9/16.
//  Copyright © 2016 Christopher Boswell. All rights reserved.
//

import UIKit
import Firebase

class UploadPostViewController: UIViewController {
    
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        var ref: FIRDatabaseReference!
        
        ref = FIRDatabase.database().reference()
        ref.child("posts").child("post").setValue(["tag":"Beyonce","user":"1234","description":"picture of Beyonc"])
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

