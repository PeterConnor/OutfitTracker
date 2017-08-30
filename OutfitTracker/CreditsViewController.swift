//
//  CreditsViewController.swift
//  OutfitTracker
//
//  Created by Pete Connor on 8/24/17.
//  Copyright © 2017 c0nman. All rights reserved.
//

import UIKit

class CreditsViewController: UIViewController {
    
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var tshirtButton: UIButton!
    
    @IBOutlet weak var photoLibraryButton: UIButton!
    
    @IBOutlet weak var cameraButton: UIButton!
    
    @IBOutlet weak var settingsButton: UIButton!
    
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var savePhotoButton: UIButton!
    
    
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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
