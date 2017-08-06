//
//  ViewController.swift
//  OutfitTracker
//
//  Created by Pete Connor on 4/25/17.
//  Copyright © 2017 c0nman. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import MobileCoreServices


class PhotoPickerController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, GroupDelegate {

    @IBOutlet weak var photoImage: UIImageView!
    var imagePicker: UIImagePickerController!
    @IBOutlet var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var xButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var groupButton: UIButton!
    @IBOutlet weak var takePhotoButton: UIButton!
    @IBOutlet weak var photoLibraryButton: UIButton!
    @IBOutlet weak var dateTextField: UITextField!
    
    let datePicker = UIDatePicker()
    
    var note = ""
    var groupGlobal = ""
    
    var editedItem: ImageItem?
    
    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
    }

    override func viewWillAppear(_ animated: Bool) {
        if photoImage.image == nil {
            saveButton.isEnabled = false
            xButton.isHidden = true
        } else {
            saveButton.isEnabled = true
            xButton.isHidden = false
        }
        if !(UIImagePickerController.isSourceTypeAvailable(.camera)) {
            takePhotoButton.isHidden = true
        }
        if !(UIImagePickerController.isSourceTypeAvailable(.photoLibrary)) {
            photoLibraryButton.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        
        createDatePicker()
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E  MM/d/yy"
        dateTextField.text = dateFormatter.string(from: date)
        
        if editedItem != nil {
            photoImage.image = editedItem?.image
            textField.text = editedItem?.note
            dateTextField.text = editedItem?.date
            groupButton.setTitle(editedItem?.group, for: .normal)
            groupGlobal = editedItem!.group
            
            
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func photoLibraryAction(_ sender: Any) {
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        if (UIImagePickerController.isSourceTypeAvailable(.photoLibrary)) {
                
                let status = PHPhotoLibrary.authorizationStatus()
                
                if (status == .authorized) {
                    self.displayPicker(type: .photoLibrary)
                }
                
                if (status == .restricted) {
                    
                    self.handleRestricted()
                }
                
                if (status == .denied) {
                    
                    self.handleDenied()
                }
                
                if (status == .notDetermined) {
                    
                    PHPhotoLibrary.requestAuthorization({ (status) in
                        if (status == PHAuthorizationStatus.authorized) {
                            self.displayPicker(type: .photoLibrary)
                        }
                    })
                    
                }
                
                
            }
    }
    
    
    @IBAction func choosePhoto(_ sender: UIButton) {
        print("yo")
        
        //let alertController = UIAlertController(title: "Title", message: "Message", preferredStyle: .actionSheet)
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
            //let cameraAction = UIAlertAction(title: "Use Camera", style: .default) { (action) in
                
                let status = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
                
                if (status == .authorized) {
                    self.displayPicker(type: .camera)
                }
                
                if (status == .restricted) {
                
                    self.handleRestricted()
                }
                
                if (status == .denied) {
                    
                    self.handleDenied()
                }
                
                if (status == .notDetermined) {
                
                    AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { (granted) in
                        if (granted) {
                            self.displayPicker(type: .camera)
                        }
                        
                    })
                }
                
            }
    }
    
        //alertController.addAction(cameraAction)
        //}
        
        /*if (UIImagePickerController.isSourceTypeAvailable(.photoLibrary)) {
            let photoLibraryAction = UIAlertAction(title: "Use Photo Library", style: .default) { (action) in
                
                let status = PHPhotoLibrary.authorizationStatus()
                
                if (status == .authorized) {
                    self.displayPicker(type: .photoLibrary)
                }
                
                if (status == .restricted) {
                    
                    self.handleRestricted()
                }
                
                if (status == .denied) {
                    
                    self.handleDenied()
                }
                
                if (status == .notDetermined) {
                    
                    PHPhotoLibrary.requestAuthorization({ (status) in
                        if (status == PHAuthorizationStatus.authorized) {
                            self.displayPicker(type: .photoLibrary)
                            }
                        })

                    }

                
                }
            
            //alertController.addAction(photoLibraryAction)
        }
        
        //let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    
      //  alertController.addAction(cancelAction)
        
      //  present(alertController, animated: true, completion: nil)
    } */
    
    func handleDenied() {
        
        let alertController = UIAlertController(title: "Camera Access Denied", message: "This app does not have acces to your device's camera. Please update your settings.", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Go To Settings", style: .default) { (action) in
            DispatchQueue.main.async {
                UIApplication.shared.open(NSURL(string: UIApplicationOpenSettingsURLString)! as URL)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.popoverPresentationController?.sourceView = self.photoImage
        alertController.popoverPresentationController?.sourceRect = self.photoImage.bounds
        
        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func handleRestricted() {
        
        let alertController = UIAlertController(title: "Camera Access Denied", message: "This device is restricted from accessing the camera at this time", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertController.popoverPresentationController?.sourceView = self.photoImage
        alertController.popoverPresentationController?.sourceRect = self.photoImage.bounds
        
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
        
    }
    
    func displayPicker(type: UIImagePickerControllerSourceType) {
        self.imagePicker.mediaTypes = [kUTTypeImage as String]
        self.imagePicker.sourceType = type
        self.imagePicker.allowsEditing = true
        
        DispatchQueue.main.async {
            self.present(self.imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerEditedImage] as! UIImage
        photoImage.contentMode = .scaleAspectFill
        photoImage.image = chosenImage
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteImage(_ sender: Any) {
        photoImage.image = nil
        xButton.isHidden = true
        saveButton.isEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text {
            note = text
            print(note)
            textField.resignFirstResponder()
            }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        moveDistance(textField: textField, moveDistance: -250, up: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        moveDistance(textField: textField, moveDistance: -250, up: false)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.length + range.location > (textField.text?.characters.count)! {
            return false
        }
        
        let newLength = (textField.text?.characters.count)! + string.characters.count - range.length
        
            return newLength <= 10
    }
    
    func moveDistance(textField: UITextField, moveDistance: Int, up: Bool) {
        let moveDuration = 0.3
        let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
        
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
    func userDidPickGroup(group: String) {
        groupButton.setTitle(group, for: .normal)
        groupGlobal = group
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showGroupVC" {
            let  groupViewController = segue.destination as! GroupViewController
            groupViewController.delegate = self
        }
    }
    
    func createDatePicker() {
        
        datePicker.datePickerMode = .date
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneButton], animated: true)
        
        dateTextField.inputAccessoryView = toolbar
        
        dateTextField.inputView = datePicker
        
    }
    
    func donePressed() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E  MM/d/yy"
        
        dateTextField.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }

}

