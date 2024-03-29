//
//  SupportViewController.swift
//  OutfitTracker
//
//  Created by Pete Connor on 7/9/17.
//  Copyright © 2017 c0nman. All rights reserved.

import UIKit
import MessageUI
import GoogleMobileAds

class SupportViewController: UIViewController, MFMailComposeViewControllerDelegate, GADBannerViewDelegate {

    @IBOutlet weak var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-BoldItalic", size: 20)!, NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        let request = GADRequest()
        bannerView.delegate = self
        bannerView.adUnitID = "ca-app-pub-9017513021309308/6032231248"
        bannerView.rootViewController = self
        bannerView.load(request)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendEmail(_ sender: Any) {
        let mailComposeViewController = configureMailController()
        UINavigationBar.appearance().barTintColor = UIColor.black
        UIBarButtonItem.appearance().tintColor = UIColor.white
        if MFMailComposeViewController.canSendMail() {

        self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            showMailError()
        }
    }
    func configureMailController() -> MFMailComposeViewController {
        UINavigationBar.appearance().barTintColor = UIColor.blue
        UIBarButtonItem.appearance().tintColor = UIColor.lightGray
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        mailComposerVC.setToRecipients(["c0nmanApps@gmail.com"])
        mailComposerVC.setSubject("Outfit Tracker")
        
        return mailComposerVC
    }
    
    func showMailError() {
        let sendMailErrorAlert = UIAlertController(title: "Error Sending Email", message: "Email Failed", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "OK", style: .default, handler: nil)
        sendMailErrorAlert.addAction(dismiss)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteAll(_ sender: Any) {
        
        let alert = UIAlertController(title: "WARNING!", message: "Are you sure you want to delete all entries?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes, I'm sure", style: .default, handler: deleteConfirmation)
        let dismiss = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(yesAction)
        alert.addAction(dismiss)
        
        present(alert, animated: true, completion: nil)
    }
    
    func deleteConfirmation(action: UIAlertAction) {
        CoreDataManager.cleanCoreData()
        ImagesModel.shared.imageItems = []
    }

}
