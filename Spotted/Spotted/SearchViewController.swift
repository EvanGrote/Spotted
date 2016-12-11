//
//  SearchViewController.swift
//  Spotted
//
//  Created by Christopher Boswell on 11/27/16.
//  Copyright © 2016 Evan Grote, Christopher Boswell. All rights reserved.
//

import UIKit


class SearchViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var searchTextField: UITextField!
    
//    @IBAction func searchButtonPressed(_ sender: UIButton) {
//        sender.setTitle(String(describing: searchTextField.text), for: UIControlState.normal)
//        performSegue(withIdentifier: "searchResultsSegue", sender: self)
//    }
    @IBAction func searchEditingFinished(_ sender: UITextField) {
        //sender.setTitle(String(describing: searchTextField.text), for: UIControlState.normal)
        performSegue(withIdentifier: "searchResultsSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchResultsSegue" {
            if let destinationVC = segue.destination as? SearchResultsViewController {
                destinationVC.searchString = searchTextField.text!
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.searchTextField.delegate = self
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SearchViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
        searchTextField.returnKeyType = UIReturnKeyType.done

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        return true
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
