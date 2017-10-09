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
    
    @IBOutlet weak var directionsLabel: UILabel!
    
    
    private let reuseIdentifier = "imageCell"
    
    var notes = [String]()
    var groups = [String]()
    var dates = [String]()
    
    var itemList = [ImageItem]()
    
    var searches = [String]()

    var tap = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: "HelveticaNeue-BoldItalic", size: 20)!, NSAttributedStringKey.foregroundColor: UIColor.white]
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        searchBar.delegate = self
        tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        searchBar.placeholder = "Search"
        itemList = model.imageItems
        itemList.sort(by: { $0.actualDate > $1.actualDate})

        
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        model.imageItems.sort(by: { $0.actualDate > $1.actualDate})
        resetSearches()
        itemList = model.imageItems
        itemList.sort(by: { $0.actualDate > $1.actualDate})

        imageCollectionView.reloadData()
        
        if itemList.count > 0 {
            directionsLabel.isHidden = true
        } else {
            directionsLabel.isHidden = false
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searches.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! CustomCollectionViewCell
        
        if segmentedControl.selectedSegmentIndex == 0 {
            cell.customImageView.image = itemList[indexPath.row].image
            cell.dateLabel.text = itemList[indexPath.row].date
            cell.noteLabel.text = searches[indexPath.row]
            if cell.noteLabel.text == "" {
                cell.noteLabel.text = "-"
            }
            cell.groupLabel.text = itemList[indexPath.row].group
            if cell.groupLabel.text == "" {
                cell.groupLabel.text = "-"
            }
        } else if segmentedControl.selectedSegmentIndex == 1 {
            cell.customImageView.image = itemList[indexPath.row].image
            cell.dateLabel.text = itemList[indexPath.row].date
            cell.noteLabel.text = itemList[indexPath.row].note
            cell.groupLabel.text = searches[indexPath.row]
            if cell.noteLabel.text == "" {
                cell.noteLabel.text = "-"
            }
            cell.groupLabel.text = itemList[indexPath.row].group
            if cell.groupLabel.text == "" {
                cell.groupLabel.text = "-"
            }
        } else if segmentedControl.selectedSegmentIndex == 2 {
            cell.customImageView.image = itemList[indexPath.row].image
            cell.dateLabel.text = searches[indexPath.row]
            cell.noteLabel.text = itemList[indexPath.row].note
            cell.groupLabel.text = itemList[indexPath.row].group
            if cell.noteLabel.text == "" {
                cell.noteLabel.text = "-"
            }
            cell.groupLabel.text = itemList[indexPath.row].group
            if cell.groupLabel.text == "" {
                cell.groupLabel.text = "-"
            }
        }
        //print(model.imageItems)
        //print(itemList)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }

    @IBAction func saveButton(segue: UIStoryboardSegue) {
        let photoPickerController = segue.source as! PhotoPickerController
        
        if photoPickerController.number != nil && photoPickerController.indexPathNumber != nil {
            CoreDataManager.deleteObject(item: model.imageItems[photoPickerController.number!])
            model.imageItems.remove(at: photoPickerController.number!)
            itemList = model.imageItems
            //resetSearches()
            //imageCollectionView.deleteItems(at: photoPickerController.indexPathNumber!)
            imageCollectionView.reloadData()
            
        }
        let photoImage = photoPickerController.photoImage.image
        
        let item = ImageItem(img: photoImage!, date: photoPickerController.dateTextField.text!, note: photoPickerController.textField.text!, group: photoPickerController.groupGlobal, actualDate: photoPickerController.actualDate)
        model.imageItems.append(item)
        itemList.append(item)
        model.imageItems.sort(by: { $0.actualDate > $1.actualDate})
        itemList = model.imageItems
        
        CoreDataManager.storeObject(item: item)

        imageCollectionView.reloadData()
        
    }
    
    func generateDate() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E  MM/d/yy"
        let dateLabel = dateFormatter.string(from: date)
        return dateLabel
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = imageCollectionView.frame.width / 3 - 1
        let height = imageCollectionView.frame.height / 3 - 1
        return CGSize(width: width, height: height)
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
        itemList = model.imageItems
        resetSearches()
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
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if segmentedControl.selectedSegmentIndex == 0 {
            searches = searchText.isEmpty ? notes : notes.filter {(item: String) -> Bool in
                return item.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
            }
            //print("searches in searchBar!!!!!\(searches)")
            itemList = []
            for i in model.imageItems {
                if searches.contains(i.note) {
                    itemList.append(i)
                }
            }
        } else if segmentedControl.selectedSegmentIndex == 1 {
            searches = searchText.isEmpty ? groups : groups.filter {(item: String) -> Bool in
                return item.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
            }
            //print("searches in searchBar!!!!!\(searches)")
            itemList = []
            for i in model.imageItems {
                if searches.contains(i.group) {
                    itemList.append(i)
                }
            }
        } else if segmentedControl.selectedSegmentIndex == 2 {
            searches = searchText.isEmpty ? dates : dates.filter {(item: String) -> Bool in
                return item.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
            }
            //print("searches in searchBar!!!!!\(searches)")
            itemList = []
            for i in model.imageItems {
                if searches.contains(i.date) {
                    itemList.append(i)
                }
            }
        }

        
        //print("itemListNOTE: \(itemList) AND \(itemList.count)")
      imageCollectionView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
        view.addGestureRecognizer(tap)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        resetSearches()
        itemList = model.imageItems
        view.removeGestureRecognizer(tap)
        searchBar.resignFirstResponder()
        imageCollectionView.reloadData()
        
    }
    
    func resetSearches() {
        searches = [String]()
        notes = [String]()
        groups = [String]()
        dates = [String]()
        
        for i in model.imageItems {
            if segmentedControl.selectedSegmentIndex == 0 {
                let note = i.note
                searches.append(note)
                notes.append(note)
            } else if segmentedControl.selectedSegmentIndex == 1 {
                let group = i.group
                searches.append(group)
                groups.append(group)
            } else if segmentedControl.selectedSegmentIndex == 2 {
                let date = i.date
                searches.append(date)
                dates.append(date)
            }
        }
    }
    
    @objc func dismissKeyboard() {
        view.removeGestureRecognizer(tap)
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    @IBAction func segmentedControl(_ sender: Any) {
        searchBar.text = ""
        resetSearches()
        itemList = model.imageItems
        imageCollectionView.reloadData()
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

