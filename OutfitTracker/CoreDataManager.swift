//
//  CoreDataManager.swift
//  OutfitTracker
//
//  Created by Pete Connor on 5/18/17.
//  Copyright © 2017 c0nman. All rights reserved.
// 

import Foundation
import UIKit
import CoreData

class CoreDataManager: NSObject {
     class func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }

class func storeObject(item: ImageItem) {
    let context = getContext()
    
    if let entity = NSEntityDescription.entity(forEntityName: "ImageEntity", in: context) {
        let managedObject = NSManagedObject(entity: entity, insertInto: context)
        
        //save date
        managedObject.setValue(item.date, forKey: "date")
        managedObject.setValue(item.actualDate, forKey: "actualDate")
        managedObject.setValue(item.note, forKey: "note")
        managedObject.setValue(item.group, forKey: "group")
        let imageData = UIImageJPEGRepresentation(item.image, 1)
        managedObject.setValue(imageData, forKey: "imageVal")
        
        do {
            try context.save()
            print("Successfully saved data!")
        } catch {
            print("Error saving data!")
            print(error.localizedDescription)
        }
        
    } else {
        print("Entity is null")
    }
    
}
    
    class func deleteObject(item: ImageItem) {
        let fetchRequest: NSFetchRequest<ImageEntity> = ImageEntity.fetchRequest()
        
        fetchRequest.predicate = NSCompoundPredicate(type:.and, subpredicates:[
            NSPredicate(format: "note == %@", item.note),
            NSPredicate(format: "date == %@", item.date),
            NSPredicate(format: "group == %@", item.group),
            NSPredicate(format: "actualDate == %@", item.actualDate as CVarArg)])
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        
        
        // execute request
        do {
            print("Deleting object from Core Data!")
            try getContext().execute(deleteRequest)
        } catch {
            print("Error deleting object from Core Data")
            print(error.localizedDescription)
        }
    }
    
    
    class func fetchObjects() -> [ImageItem] {
        var objects = [ImageItem]()
        
        let fetchRequest: NSFetchRequest<ImageEntity> = ImageEntity.fetchRequest()
        do {
            let fetchResult = try getContext().fetch(fetchRequest)
            print("ResultRN: \(fetchResult)")
            for item in fetchResult {
                let imageFromData = UIImage(data: item.imageVal! as Data)
                let itemImage = ImageItem(img: imageFromData!, date: item.date!, note: item.note!, group: item.group!, actualDate: item.actualDate! as Date)
                objects.append(itemImage)
            }
        } catch {
            print("Error fetching data!")
            print(error.localizedDescription)
        }
        return objects
    }
    
    // delete everything from core data
    class func cleanCoreData() {
        let fetchRequest: NSFetchRequest<ImageEntity> = ImageEntity.fetchRequest()
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        
        do {
            print("Deleting contents of Core Data!")
            try getContext().execute(deleteRequest)
        } catch {
            print("Error cleaning contents of Core Data")
            print(error.localizedDescription)
        }
    }
}
    
    struct ImageItem {
        var image: UIImage
        var date: String
        var note: String
        var group: String
        var actualDate: Date
        
        init(img: UIImage, date: String, note: String, group: String, actualDate: Date) {
            self.image = img
            self.date = date
            self.note = note
            self.group = group
            self.actualDate = actualDate
    }

}
