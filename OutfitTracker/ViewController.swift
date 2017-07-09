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

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    var model = ImagesModel.shared
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    private let reuseIdentifier = "imageCell"
    
    var notes = [String]()
    
    var noteSearches = [String]()

    var tap = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        searchBar.delegate = self
        tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        searchBar.placeholder = "Search"
        }
    
    override func viewWillAppear(_ animated: Bool) {
        resetFilteredSearches()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return noteSearches.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! CustomCollectionViewCell
        
        
        let currentItem = model.imageItems[indexPath.row]
        print(currentItem.date)
        print(currentItem.note)
        print(currentItem.image)
        print("LOOK HERE!!! \(currentItem.group)")
        cell.customImageView.image = currentItem.image
        cell.dateLabel.text = currentItem.date
        cell.noteLabel.text = noteSearches[indexPath.row]
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    @IBAction func saveButton(segue: UIStoryboardSegue) {
        let photoPickerController = segue.source as! PhotoPickerController
        let photoImage = photoPickerController.photoImage.image
        
        let item = ImageItem(img: photoImage!, date: generateDate(), note: photoPickerController.textField.text!, group: photoPickerController.groupGlobal)
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
        notes.remove(at: largeImageViewController.number)
        noteSearches.remove(at: largeImageViewController.number)
        imageCollectionView.deleteItems(at: largeImageViewController.indexPathNumber)
        dismiss(animated: true, completion: nil)
        print("is this it???")
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
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        noteSearches = searchText.isEmpty ? notes : notes.filter {(item: String) -> Bool in
            return item.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
      imageCollectionView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
        view.addGestureRecognizer(tap)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        resetFilteredSearches()
        view.removeGestureRecognizer(tap)
        searchBar.resignFirstResponder()
        imageCollectionView.reloadData()
        
    }
    
    func resetFilteredSearches() {
        noteSearches = [String]()
        notes = [String]()
        for i in model.imageItems {
            let note = i.note
            print("THE NOTE:\(note)")
            noteSearches.append(note)
            notes.append(note)
            print("notes!!!!!!: \(noteSearches)")
            print(noteSearches.count)
        }
    }
    
    func dismissKeyboard() {
        view.removeGestureRecognizer(tap)
        searchBar.resignFirstResponder()
    }
    
    @IBAction func segmentedControl(_ sender: Any) {
        if segmentedControl.selectedSegmentIndex == 0 {
            searchBar.placeholder = "Search by Note"
        } else if segmentedControl.selectedSegmentIndex == 1 {
            searchBar.placeholder = "Search by Group, Category or Event"
        } else if segmentedControl.selectedSegmentIndex == 2 {
            searchBar.placeholder = "Search by Date"
        } else {
            searchBar.placeholder = "Search"
        }
    }
    
    
}

