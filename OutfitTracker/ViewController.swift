//
//  ViewController.swift
//  OutfitTracker
//
//  Created by Pete Connor on 5/7/17.
//  Copyright © 2017 c0nman. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
        return model.imageItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! CustomCollectionViewCell
        //cell.customImageView.image = model.images[indexPath.row]
        //cell.dateLabel.text = model.dates[indexPath.row]
        //cell.noteLabel.text = model.notes[indexPath.row]
        
        let currentItem = model.imageItems[indexPath.row]
        print(currentItem.date)
        print(currentItem.note)
        print(currentItem.image)
        cell.customImageView.image = currentItem.image
        cell.dateLabel.text = currentItem.date
        cell.noteLabel.text = currentItem.note
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        /// need to delete
        /*model.imageItems.remove(at: indexPath.item)
        let itemList = CoreDataManager.fetchObjects()
        let item = itemList[indexPath.row]
        //collectionView.deleteItems(at: [indexPath])
        print("model items")
        print(model.imageItems[indexPath.row])
        print("coredata items")*/
        
    }
    
    @IBAction func saveButton(segue: UIStoryboardSegue) {
        let photoPickerController = segue.source as! PhotoPickerController
        let photoImage = photoPickerController.photoImage.image
        //model.images.append(photoImage!)
        //model.notes.append(photoPickerController.note)
        //model.dates.append(dateLabel)
        
        let item = ImageItem(img: photoImage!, date: generateDate(), note: photoPickerController.textField.text!)
        print(item)
        model.imageItems.append(item)
        
        CoreDataManager.storeObject(item: item)
        
        imageCollectionView.reloadData()
    }
    
    func generateDate() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, M.d.yy"
        let dateLabel = dateFormatter.string(from: date)
        return dateLabel
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = imageCollectionView.frame.width / 3 - 1
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    @IBAction func cancelButton(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func deleteButton(segue: UIStoryboardSegue) {
        let largeImageViewController = segue.source as! LargeImageViewController
        CoreDataManager.deleteObject(item: model.imageItems[largeImageViewController.number])
        model.imageItems.remove(at: largeImageViewController.number)
        imageCollectionView.deleteItems(at: largeImageViewController.indexPathNumber)
        dismiss(animated: true, completion: nil)
        imageCollectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowLargeImage" {
            let newViewController = segue.destination as! LargeImageViewController
            let indexPath = self.imageCollectionView.indexPath(for: sender as! UICollectionViewCell)!
            newViewController.newImageItem = model.imageItems[indexPath.row]
            newViewController.indexPathNumber = [indexPath]
            newViewController.number = Int(indexPath.row)
            
        }
    }
    
}

