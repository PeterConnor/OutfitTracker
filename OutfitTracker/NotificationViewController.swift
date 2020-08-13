//
//  NotificationViewController.swift
//  OutfitTracker
//
//  Created by Pete Connor on 10/14/17.
//  Copyright © 2017 c0nman. All rights reserved.
// 

import UIKit

class NotificationViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var repeatSwitch: UISwitch!
    
    @IBOutlet weak var remainingTime: UILabel!
    
    @IBOutlet weak var scheduleBtn: UIButton!
    
    @IBOutlet weak var cancelBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.scheduleBtn.layer.cornerRadius = 20
        self.cancelBtn.layer.cornerRadius = 20
        
        self.datePicker.minimumDate = Date()
        self.datePicker.date = Date().addingTimeInterval(60)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func schedule(_ sender: Any) {
        if NotificationManager.shared.isAuthorized == false {
            let alert = UIAlertController(title: "Notifications", message: "To enable notifications, please go to Settings -> OutfitTracker -> Notifications -> Allow Notifications. Then, restart the app.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        } else {
            let nextDate = NotificationManager.shared.schedule(date: self.datePicker.date, repeats: self.repeatSwitch.isOn)
            if nextDate != nil {
                self.remainingTime.text = nextDate!.timeIntervalSinceNow.formattedTime
            }
        }
    }
    
    @IBAction func cancelAllNotifications(_ sender: Any) {
        self.remainingTime.text = "0h 0m 0s"
        
        NotificationManager.shared.cancelAllNotofications()
    }
    
    
}

extension TimeInterval {
    var formattedTime: String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .brief
        formatter.includesApproximationPhrase = false
        formatter.includesTimeRemainingPhrase = false
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.calendar = Calendar.current
        
        return formatter.string(from: self) ?? ""
    }
}
