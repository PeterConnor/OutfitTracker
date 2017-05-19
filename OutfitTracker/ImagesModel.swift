//
//  ImagesModel.swift
//  OutfitTracker
//
//  Created by Pete Connor on 5/7/17.
//  Copyright © 2017 c0nman. All rights reserved.
//

import Foundation
import UIKit

class ImagesModel: NSObject {
    static let shared: ImagesModel = ImagesModel()
    //var images: [UIImage]
    //var notes: [String]
    //var dates: [String]
    
    var imageItems: [ImageItem]
    
    private override init() {
        //images = []
        //notes = []
        //dates = []
        imageItems = CoreDataManager.fetchObjects()
        super.init()
    }
}
