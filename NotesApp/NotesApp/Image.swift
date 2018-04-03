//
//  ImageClass.swift
//  NotesApp
//
//  Created by Carmen Popa on 24/03/2018.
//  Copyright © 2018 Carmen Popa. All rights reserved.
//

import UIKit

class Image: NSObject {
    private(set) var imageName: String!
    
    internal func set(imageName: String) {
        self.imageName = imageName
    }
    
}
