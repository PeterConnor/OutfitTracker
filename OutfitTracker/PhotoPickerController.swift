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
import GoogleMobileAds


class PhotoPickerController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, GroupDelegate, GADBannerViewDelegate {

    @IBOutlet weak var photoImage: UIImageView!
    var imagePicker: UIImagePickerController!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var xButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var groupButton: UIButton!
    @IBOutlet weak var takePhotoButton: UIButton!

    @IBOutlet weak var viewAroundPhotoImage: UIView!
    
    @IBOutlet weak var takePhotoTextButton: UIButton!
    
    @IBOutlet weak var takePhotoButtonWithImage: UIButton!
    @IBOutlet weak var photoLibraryButtonWithImage: UIButton!
    @IBOutlet weak var photoLibraryButton: UIButton!
    
    @IBOutlet weak var chooseFromGalleryButton: UIButton!
    
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var orLabel: UILabel!
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    let datePicker = UIDatePicker()
    let magnesium = UIColor(red: CGFloat(199.0/255.0), green: CGFloat(199.0/255.0), blue: CGFloat(205.0/255.0), alpha: CGFloat(0.9))

    
    var note = ""
    var groupGlobal = ""
    var actualDate = Date()
    
    var editedItem: ImageItem?
    var indexPathNumber: [IndexPath]?
    var number: Int?
    
    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
    }

    override func viewWillAppear(_ animated: Bool) {
        
        isThereAPhoto()
        
        if !(UIImagePickerController.isSourceTypeAvailable(.camera)) {
            takePhotoButton.isEnabled = false
            takePhotoButtonWithImage.isEnabled = false
            takePhotoTextButton.isEnabled = false
            takePhotoTextButton.setTitle("Camera Unavailable", for: .normal)
            takePhotoTextButton.setTitleColor(UIColor.gray, for: .disabled)
        }
        if !(UIImagePickerController.isSourceTypeAvailable(.photoLibrary)) {
            photoLibraryButton.isEnabled = false
            photoLibraryButtonWithImage.isEnabled = false
            chooseFromGalleryButton.isEnabled = false
            chooseFromGalleryButton.setTitle("Photo Library Unavailable", for: .normal)
            chooseFromGalleryButton.setTitleColor(UIColor.gray, for: .disabled)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: "HelveticaNeue-BoldItalic", size: 20)!, NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        let whiteSaveButton = UIImage(named: "SavePhotoImage")?.withRenderingMode(.alwaysTemplate)
        saveButton.setImage(whiteSaveButton, for: .normal)
        saveButton.tintColor = UIColor.white
        
        
        
        takePhotoButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        photoLibraryButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        
        textField.delegate = self
        
        createDatePicker()
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E  MM/d/yy"
        dateTextField.text = dateFormatter.string(from: date)
        
        if editedItem != nil {
            photoImage.contentMode = .scaleAspectFit
            viewAroundPhotoImage.backgroundColor = .clear
            photoImage.image = editedItem?.image
            textField.text = editedItem?.note
            dateTextField.text = editedItem?.date
            datePicker.date = (editedItem?.actualDate)!
            datePicker.setDate((editedItem?.actualDate)!, animated: true)
            actualDate = (editedItem?.actualDate)!
            
            if editedItem?.group != "" {
                groupButton.setTitle(editedItem?.group, for: .normal)
                groupButton.setTitleColor(.black, for: .normal)
                groupGlobal = editedItem!.group
            } else {
                groupButton.setTitleColor(magnesium, for: .normal)
                groupButton.setTitle("Add Group, Category, or Event", for: .normal)
            }
        }
        if number != nil {
            
        }
        
        let request = GADRequest()
        bannerView.delegate = self
        bannerView.adUnitID = "ca-app-pub-9017513021309308/6032231248"
        bannerView.rootViewController = self
        bannerView.load(request)
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
    
    func isThereAPhoto() {
        if photoImage.image == nil {
            saveButton.isEnabled = false
            xButton.isHidden = true
            viewAroundPhotoImage.backgroundColor = .white
            photoLibraryButton.isHidden = false
            photoLibraryButtonWithImage.isHidden = false
            chooseFromGalleryButton.isHidden = false
            takePhotoButton.isHidden = false
            takePhotoButtonWithImage.isHidden = false
            takePhotoTextButton.isHidden = false
            orLabel.isHidden = false
        } else {
            saveButton.isEnabled = true
            xButton.isHidden = false
            viewAroundPhotoImage.backgroundColor = .clear
            photoLibraryButton.isHidden = true
            photoLibraryButtonWithImage.isHidden = true
            chooseFromGalleryButton.isHidden = true
            takePhotoButton.isHidden = true
            takePhotoButtonWithImage.isHidden = true
            takePhotoTextButton.isHidden = true
            orLabel.isHidden = true
            print("picked")
        }
    }
    
    
    @IBAction func choosePhoto(_ sender: UIButton) {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
                let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
                
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
                
                    AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted) in
                        if (granted) {
                            self.displayPicker(type: .camera)
                        }
                        
                    })
                }
                
            }
    }
    
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
        DispatchQueue.main.async {
            self.imagePicker.mediaTypes = [kUTTypeImage as String]
            self.imagePicker.sourceType = type
            self.imagePicker.allowsEditing = true
            self.present(self.imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerEditedImage] as! UIImage
        photoImage.contentMode = .scaleAspectFit
        photoImage.image = chosenImage
        isThereAPhoto()
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteImage(_ sender: Any) {
        photoImage.image = nil
        xButton.isHidden = true
        saveButton.isEnabled = false
        viewAroundPhotoImage.backgroundColor = .white
        photoLibraryButton.isHidden = false
        photoLibraryButtonWithImage.isHidden = false
        takePhotoButton.isHidden = false
        takePhotoButtonWithImage.isHidden = false
        takePhotoTextButton.isHidden = false
        chooseFromGalleryButton.isHidden = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text {
            note = text
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
        if range.length + range.location > (textField.text?.count)! {
            return false
        }
        
        let newLength = (textField.text?.count)! + string.count - range.length
        
            return newLength <= 13
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
        groupButton.setTitleColor(.black, for: .normal)
        groupGlobal = group
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showGroupVC" {
            let  groupViewController = segue.destination as! GroupViewController
            groupViewController.delegate = self
            textField.resignFirstResponder()
        }
    }
    
    func createDatePicker() {
        
        datePicker.datePickerMode = .date
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        doneButton.tintColor = .black
        toolbar.setItems([doneButton], animated: true)
        
        dateTextField.inputAccessoryView = toolbar
        
        dateTextField.inputView = datePicker
        
    }
    
    @objc func donePressed() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E  MM/d/yy"
        
        dateTextField.text = dateFormatter.string(from: datePicker.date)
        actualDate = datePicker.date
        self.view.endEditing(true)
    }
}

