//
//  NoteClass.swift
//  NotesApp
//
//  Created by Carmen Popa on 24/03/2018.
//  Copyright © 2018 Carmen Popa. All rights reserved.
//

import CoreData

class Note: NSManagedObject {
    
    @NSManaged private(set) var title: String?
    @NSManaged private(set) var detail: String?
    @NSManaged private(set) var images: NSSet?
    @NSManaged private(set) var id: String!
    @NSManaged private(set) var lastUpdate: Int64
    
    internal func set(title: String, detail: String, images: NSSet, id: String, lastUpdate: Int64) {
        self.title = title
        self.detail = detail
        self.images = images
        self.id = id
        self.lastUpdate = lastUpdate
    }

}
