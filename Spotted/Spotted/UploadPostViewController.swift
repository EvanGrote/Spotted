//
//  UploadPostViewController.swift
//  Spotted
//
//  Created by Christopher Boswell on 11/9/16.
//  Copyright © 2016 Christopher Boswell. All rights reserved.
//

import UIKit
import Firebase

class UploadPostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var theImageView: UIImageView!
    @IBOutlet weak var tagTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    @IBAction func uploadImageButtonPressed(_ sender: AnyObject) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func takePictureButtonPressed(_ sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .camera
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            theImageView.contentMode = .scaleAspectFit
            theImageView.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        var ref: FIRDatabaseReference!
        var timeStamp = String(round(NSDate().timeIntervalSince1970))
        let timeStampFormatted = String(timeStamp.characters.dropLast(2))
        let tag = tagTextField.text
        let description = descriptionTextField.text
        
        ref = FIRDatabase.database().reference()
        
        var compressedImage = NSData()
        compressedImage = UIImageJPEGRepresentation(theImageView.image!, 0.8)! as NSData
        let filePath = "/\(timeStampFormatted)"
        let metaData = FIRStorageMetadata()
        metaData.contentType = "image/jpg"
        var storageRef: FIRStorageReference
        storageRef = FIRStorage.storage().reference()
        storageRef.child(filePath).put(compressedImage as Data,metadata:metaData){(metaData,error) in
            if let error = error {
                print(error.localizedDescription)
                return
            } else {
                //store downloadURL
                let downloadURL = metaData!.downloadURL()!.absoluteString
                //store downloadURL at database
                ref.child("posts").child(timeStampFormatted).setValue(["tag":tag,"user":"1234","description":description,"userPhoto": downloadURL])
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        imagePicker.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

