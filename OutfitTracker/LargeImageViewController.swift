//
//  LargeImageViewController.swift
//  OutfitTracker
//
//  Created by Pete Connor on 5/21/17.
//  Copyright © 2017 c0nman. All rights reserved.
//

import Foundation
import UIKit

class LargeImageViewController: UIViewController {
    
    @IBOutlet weak var largePhotoImage: UIImageView!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var shareButton: UIButton!
    
    
    var newImageItem: ImageItem!
    var indexPathNumber: [IndexPath]!
    var number: Int!
    
    override func viewWillAppear(_ animated: Bool) {
        largePhotoImage.image = newImageItem.image
    }
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        let whiteDeleteButton = UIImage(named: "DeleteImage")?.withRenderingMode(.alwaysTemplate)
        deleteButton.setImage(whiteDeleteButton, for: .normal)
        deleteButton.tintColor = UIColor.white
        
        let whiteSaveButton = UIImage(named: "SaveImage")?.withRenderingMode(.alwaysTemplate)
        saveButton.setImage(whiteSaveButton, for: .normal)
        saveButton.tintColor = UIColor.white
       
        let whiteEditButton = UIImage(named: "EditImage")?.withRenderingMode(.alwaysTemplate)
        editButton.setImage(whiteEditButton, for: .normal)
        editButton.tintColor = UIColor.white
        
        let whiteShareButton = UIImage(named: "ShareImage")?.withRenderingMode(.alwaysTemplate)
        shareButton.setImage(whiteShareButton, for: .normal)
        shareButton.tintColor = UIColor.white
    }
    
    @IBAction func saveToPhone(_ sender: Any) {
        let imageData = UIImagePNGRepresentation(largePhotoImage.image!)
        let compressedImage = UIImage(data: imageData!)
        UIImageWriteToSavedPhotosAlbum(compressedImage!, nil, nil, nil)
        
        let alert = UIAlertController(title: "Saved", message: "Your photo has been saved", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func shareButtonAction(_ sender: Any) {
        let activityVC = UIActivityViewController(activityItems: [largePhotoImage.image!], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        
        self.present(activityVC, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPhotoPickerVC" {
            let destinationVC = segue.destination as! PhotoPickerController
            destinationVC.editedItem = newImageItem
            destinationVC.indexPathNumber = indexPathNumber
            destinationVC.number = number
        }
    }
}
