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
    
    @IBOutlet weak var tagTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        var ref: FIRDatabaseReference!
        var timeStamp = String(round(NSDate().timeIntervalSince1970))
        let timeStampFormatted = String(timeStamp.characters.dropLast(2))
        let tag = tagTextField.text
        let description = descriptionTextField.text
        
        ref = FIRDatabase.database().reference()
        ref.child("posts").child(timeStampFormatted).setValue(["tag":tag,"user":"1234","description":description])
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

