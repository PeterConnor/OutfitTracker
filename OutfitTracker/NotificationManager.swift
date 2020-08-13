//
//  NotificationManager.swift
//  OutfitTracker
//
//  Created by Pete Connor on 10/16/17.
//  Copyright © 2017 c0nman. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

/* LOOK AT APPDELEGATE FOR THE REQUEST */

class NotificationManager: NSObject {
    
    static let shared: NotificationManager = {
        
        return NotificationManager()
        
    }()
    
    var isAuthorized: Bool? = nil
    
    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.badge, .alert, .sound]
        
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (granted: Bool, error: Error?) in
            
            if granted {
                
                print("Notification Authorized")
                self.isAuthorized = true
                
            } else {
                print("Notification Not Authorized")
                self.isAuthorized = false
                
            }
            
        }
        
        UNUserNotificationCenter.current().delegate = self
    }
    
    func schedule(date: Date, repeats: Bool) -> Date? {
        
        requestAuthorization()
        
        cancelAllNotofications()
        
        let content = UNMutableNotificationContent()
        content.title = "Outfit Tracker"
        content.body = "Time to enter an outfit!"
        content.userInfo = ["test": "test"]
        
        /* guard let filePath = Bundle.main.path(forResource: "AppIcon20x20@1x", ofType: "png") else {
            print("Image not found")
            return nil
        }
        let attachment = try! UNNotificationAttachment(identifier: "attachment", url: URL.init(fileURLWithPath: filePath), options: nil)
        content.attachments = [attachment] */
        
        let components = Calendar.current.dateComponents([.minute, .hour], from: date)
        
        var newComponent = DateComponents()
        newComponent.hour = components.hour
        newComponent.minute = components.minute
        newComponent.second = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: newComponent, repeats: repeats)
        
        let request = UNNotificationRequest(identifier: "TestNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error: Error?) in
            
            if error == nil {
                print("Notification Scheduled", trigger.nextTriggerDate()?.formattedDate ?? "Date Nil")
            } else {
                print("Error scheduling notification", error?.localizedDescription ?? "")
            }
        }
        
        return trigger.nextTriggerDate()
    }
    
    func getAllPendingNotifications(completion: @escaping ([UNNotificationRequest]?) -> Void) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { (requests: [UNNotificationRequest]) in
            return completion(requests)
        }
    }
    
    func cancelAllNotofications() {
        getAllPendingNotifications { (requests: [UNNotificationRequest]?) in
            if let requestsIds = requests {
                UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: requestsIds.map{$0.identifier})
            }
        }
    }
}

extension NotificationManager: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("Local notification received while app is open", notification.request.content)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Did tap on the notification", response.notification.request.content)
        
        completionHandler()
    }
    
}

extension Date {
    var formattedDate: String {
        let format = DateFormatter()
        format.timeZone = TimeZone.current
        format.timeStyle = .medium
        format.dateStyle = .medium
        
        return format.string(from: self)
    }
}
