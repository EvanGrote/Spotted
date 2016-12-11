//
//  ViewController.swift
//  Spotted
//
//  Created by Evan Grote on 10/25/16.
//  Copyright © 2016 Christopher Boswell, Evan Grote. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController {
    
    var searchString:String = "default"
    
    @IBOutlet weak var tempLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tempLabel.text = searchString
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

