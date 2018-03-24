//
//  ImageClass.swift
//  NotesApp
//
//  Created by Carmen Popa on 24/03/2018.
//  Copyright © 2018 Carmen Popa. All rights reserved.
//

import UIKit

class ImageClass: NSObject {
    private(set) var fileName: String?
    
    func set(fileName: String) {
        self.fileName = fileName
    }
    
}
