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
    var newImageItem: ImageItem!
    var indexPathNumber: [IndexPath]!
    var number: Int!
    
    override func viewWillAppear(_ animated: Bool) {
        largePhotoImage.image = newImageItem.image
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
}
