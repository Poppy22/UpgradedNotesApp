//
//  NoteClass.swift
//  NotesApp
//
//  Created by Carmen Popa on 24/03/2018.
//  Copyright © 2018 Carmen Popa. All rights reserved.
//

import UIKit

class Note: NSObject {
    
    private(set) var title: String?
    private(set) var detail: String?
    private(set) var images: NSSet = []
    private(set) var id: String!
    private(set) var lastUpdate: Int64 = 0
    
    internal func set(title: String, detail: String, images: NSSet, id: String, lastUpdate: Int64) {
        self.title = title
        self.detail = detail
        self.images = images
        self.id = id
        self.lastUpdate = lastUpdate
    }

}
