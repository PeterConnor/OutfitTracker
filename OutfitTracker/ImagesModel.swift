//
//  ImagesModel.swift
//  OutfitTracker
//
//  Created by Pete Connor on 5/7/17.
//  Copyright © 2017 c0nman. All rights reserved.

import Foundation
import UIKit

class ImagesModel: NSObject {
    static let shared: ImagesModel = ImagesModel()
    
    var imageItems: [ImageItem]
    
    private override init() {
        imageItems = CoreDataManager.fetchObjects()
        super.init()
    }
}
