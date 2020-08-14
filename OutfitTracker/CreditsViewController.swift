//
//  CreditsViewController.swift
//  OutfitTracker
//
//  Created by Pete Connor on 8/24/17.
//  Copyright © 2017 c0nman. All rights reserved.

import UIKit
import GoogleMobileAds

class CreditsViewController: UIViewController, GADBannerViewDelegate {
    
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var tshirtButton: UIButton!
    
    @IBOutlet weak var photoLibraryButton: UIButton!
    
    @IBOutlet weak var cameraButton: UIButton!
    
    @IBOutlet weak var settingsButton: UIButton!
    
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var savePhotoButton: UIButton!
    
    @IBOutlet weak var cloudButton: UIButton!
    
    @IBOutlet weak var questionmanButton: UIButton!
    
    @IBOutlet weak var lightbulbButton: UIButton!
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        let whiteSettingsButton = UIImage(named: "SettingsImage")?.withRenderingMode(.alwaysTemplate)
        settingsButton.setImage(whiteSettingsButton, for: .normal)
        settingsButton.tintColor = UIColor.white
        
        let whiteTshirtButton = UIImage(named: "TshirtImage")?.withRenderingMode(.alwaysTemplate)
        tshirtButton.setImage(whiteTshirtButton, for: .normal)
        tshirtButton.tintColor = UIColor.white
        
        let whiteCameraButton = UIImage(named: "CameraImage")?.withRenderingMode(.alwaysTemplate)
        cameraButton.setImage(whiteCameraButton, for: .normal)
        cameraButton.tintColor = UIColor.white
        
        let whitePhotoLibraryButton = UIImage(named: "PhotoLibraryImage")?.withRenderingMode(.alwaysTemplate)
        photoLibraryButton.setImage(whitePhotoLibraryButton, for: .normal)
        photoLibraryButton.tintColor = UIColor.white
        
        let whiteSavePhotoButton = UIImage(named: "SavePhotoImage")?.withRenderingMode(.alwaysTemplate)
        savePhotoButton.setImage(whiteSavePhotoButton, for: .normal)
        savePhotoButton.tintColor = UIColor.white
        
        let whiteCloudButton = UIImage(named: "cloud1")?.withRenderingMode(.alwaysTemplate)
        cloudButton.setImage(whiteCloudButton, for: .normal)
        cloudButton.tintColor = UIColor.white
        
        let whiteQuestionmanButton = UIImage(named: "questionman")?.withRenderingMode(.alwaysTemplate)
        questionmanButton.setImage(whiteQuestionmanButton, for: .normal)
        questionmanButton.tintColor = UIColor.white
        
        let whiteLightbulbButton = UIImage(named: "lightbulb")?.withRenderingMode(.alwaysTemplate)
        lightbulbButton.setImage(whiteLightbulbButton, for: .normal)
        lightbulbButton.tintColor = UIColor.white

        // Do any additional setup after loading the view.
        
        let request = GADRequest()
        bannerView.delegate = self
        bannerView.adUnitID = "ca-app-pub-9017513021309308/6032231248"
        bannerView.rootViewController = self
        bannerView.load(request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
