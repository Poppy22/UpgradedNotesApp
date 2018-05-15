//
//  NoteDA.swift
//  NotesApp
//
//  Created by Carmen Popa on 15/05/2018.
//  Copyright © 2018 Carmen Popa. All rights reserved.
//

import Foundation
class NoteDA: BaseDA {
    
    override init() {
        super.init()
        entityName = "NoteEntity"
    }
    
    func createNote() -> Note {
        let note = super.create() as? Note
        note?.set(title: "", detail: "", images: [], id: "", lastUpdate: 0)
        return note!
    }
    
    func getAllNotes() -> [Note] {
        return super.fetchObjects(nil, sortDescriptors: nil) as! [Note]
    }
    
    func deleteNote(_ note: Note) {
        super.deleteObject(note)
        super.save()
    }
    
}
