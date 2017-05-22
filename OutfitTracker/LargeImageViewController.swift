//
//  LargeImageViewController.swift
//  OutfitTracker
//
//  Created by Pete Connor on 5/21/17.
//  Copyright © 2017 c0nman. All rights reserved.
//

import Foundation
import UIKit

class LargeImageViewController: UIViewController {
    
    @IBOutlet weak var largePhotoImage: UIImageView!
    var newImageItem: ImageItem!
    var indexPathNumber: [IndexPath]!
    var number: Int!
    
    override func viewWillAppear(_ animated: Bool) {
        largePhotoImage.image = newImageItem.image
    }
}
