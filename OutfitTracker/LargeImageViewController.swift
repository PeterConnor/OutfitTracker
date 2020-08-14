//
//  LargeImageViewController.swift
//  OutfitTracker
//
//  Created by Pete Connor on 5/21/17.
//  Copyright © 2017 c0nman. All rights reserved.

import Foundation
import UIKit
import GoogleMobileAds

class LargeImageViewController: UIViewController, GADBannerViewDelegate {
    
    @IBOutlet weak var largePhotoImage: UIImageView!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var noteLabel: UILabel!
    
    @IBOutlet weak var groupLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    var newImageItem: ImageItem!
    var indexPathNumber: [IndexPath]!
    var number: Int!
    
    override func viewWillAppear(_ animated: Bool) {
        largePhotoImage.image = newImageItem.image
        
        if newImageItem.note == "" {
            noteLabel.text = "-"
        } else {
            noteLabel.text = newImageItem.note
        }
        if newImageItem.group == "" {
            groupLabel.text = "-"
        } else {
            groupLabel.text = newImageItem.group
        }
        
        dateLabel.text = newImageItem.date
    }
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-BoldItalic", size: 20)!, NSAttributedString.Key.foregroundColor: UIColor.white]
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
        
        let request = GADRequest()
        bannerView.delegate = self
        bannerView.adUnitID = "ca-app-pub-9017513021309308/6032231248"
        bannerView.rootViewController = self
        bannerView.load(request)
    }
    
    @IBAction func saveToPhone(_ sender: Any) {
        let imageData = largePhotoImage.image!.pngData()
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
