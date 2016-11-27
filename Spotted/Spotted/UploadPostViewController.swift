//
//  UploadPostViewController.swift
//  Spotted
//
//  Created by Christopher Boswell on 11/9/16.
//  Copyright © 2016 Christopher Boswell. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

class UploadPostViewController: UIViewController, UIImagePickerControllerDelegate, CLLocationManagerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    let imagePicker = UIImagePickerController()
    var imageSelected:Bool = false
    let locationManager = CLLocationManager()
    var locValue:CLLocationCoordinate2D = CLLocationCoordinate2D.init(latitude: 0, longitude: 0)
    
    @IBOutlet weak var theImageView: UIImageView!
    @IBOutlet weak var tagTextField: UITextField!
    @IBOutlet weak var addTagsTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    @IBAction func uploadImageButtonPressed(_ sender: AnyObject) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func takePictureButtonPressed(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.allowsEditing = false
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.cameraCaptureMode = .photo
            imagePicker.modalPresentationStyle = .fullScreen
            present(imagePicker,animated: true,completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            print("displaying selected image in imageView")
            theImageView.contentMode = .scaleAspectFit
            theImageView.image = pickedImage
            imageSelected = true
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        if imageSelected {
            print("submit button pressed, uploading post")
            var databaseRef: FIRDatabaseReference!
            var timeStamp = String(round(NSDate().timeIntervalSince1970))
            let timeStampFormatted = String(timeStamp.characters.dropLast(2))
            let tag:String = tagTextField.text!
            let description:String = descriptionTextField.text!
            let filePath = "/images/\(timeStampFormatted)"
            
            //database reference
            databaseRef = FIRDatabase.database().reference()
            
            //compresses the image
            var compressedImage = NSData()
            compressedImage = UIImageJPEGRepresentation(theImageView.image!, 0.7)! as NSData
            let metaData = FIRStorageMetadata()
            metaData.contentType = "image/jpg"
            //storage reference
            var storageRef: FIRStorageReference
            storageRef = FIRStorage.storage().reference()
            print("uploading image")
            storageRef.child(filePath).put(compressedImage as Data,metadata:metaData){(metaData,error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                } else {
                    //store path
                    print("Storing image \(timeStampFormatted)")
                    print("image stored at: \(metaData?.path!)")
                    let MetaDataPath:String = (metaData?.path!)!
                    //store path at database
                    databaseRef.child("posts").child(timeStampFormatted).setValue(["tag":tag,"user":"1234","description":description,"latitude":self.locValue.latitude,"longitude":self.locValue.longitude,"userPhoto": MetaDataPath])
                }
            }
        } else {
            print("No image selected")
            let alert = UIAlertController(title: "Error", message: "Please select an image", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        addTagsTextField.resignFirstResponder()
        descriptionTextField.resignFirstResponder()
        return true
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {        
        self.addTagsTextField.text = ""
        self.descriptionTextField.text = ""
        self.theImageView.image = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locValue = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while updating location " + error.localizedDescription)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        imagePicker.delegate = self
        self.addTagsTextField.delegate = self
        self.descriptionTextField.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UploadPostViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            //locationManager.startUpdatingLocation()
            locationManager.requestLocation()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

