//
//  ViewController.swift
//  OutfitTracker
//
//  Created by Pete Connor on 5/7/17.
//  Copyright © 2017 c0nman. All rights reserved.
//

import Foundation
import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var model = ImagesModel.shared
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    private let reuseIdentifier = "imageCell"
    
    override func viewDidLoad() {
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! CustomCollectionViewCell
        cell.customImageView.image = model.images[indexPath.row]
        cell.dateLabel.text = model.dates[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        model.images.remove(at: indexPath.item)
        collectionView.deleteItems(at: [indexPath])
    }
    
    @IBAction func saveButton(segue: UIStoryboardSegue) {
        let photoPickerController = segue.source as! PhotoPickerController
        let photoImage = photoPickerController.photoImage.image
        model.images.append(photoImage!)
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, M.d.yy"
        let dateLabel = dateFormatter.string(from: date)
        model.dates.append(dateLabel)
        imageCollectionView.reloadData()
    }
    
    @IBAction func cancelButton(segue: UIStoryboardSegue) {
        
    }
}

