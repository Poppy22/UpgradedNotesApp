//
//  NoteClass.swift
//  NotesApp
//
//  Created by Carmen Popa on 24/03/2018.
//  Copyright © 2018 Carmen Popa. All rights reserved.
//

import UIKit

class NoteClass: NSObject {
    
    private(set) var title: String? //optional
    private(set) var detail: String?
    private(set) var images: NSSet = []
    private(set) var id: String! //mandatory
    private(set) var lastUpdate: Int64 = 0
    
    func set(title: String, detail: String, images: NSSet, id: String, lastUpdate: Int64) {
        self.title = title
        self.detail = detail
        self.images = images
        self.id = id
        self.lastUpdate = lastUpdate
    }

}
