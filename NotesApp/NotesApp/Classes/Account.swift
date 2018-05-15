//
//  Account.swift
//  NotesApp
//
//  Created by Carmen Popa on 15/05/2018.
//  Copyright © 2018 Carmen Popa. All rights reserved.
//

import UIKit

class Account: NSObject {
    override private init() {}
    static let singleton = Account()
    
    var name: String?
    var id: String?
    var token: String?
    var email: String?
    var profilePicture: NSURL?
    
    func setAccount(name: String, id: String, token: String, email: String, profilePicture: NSURL) {
        self.name = name
        self.id = id
        self.token = token
        self.email = email
        self.profilePicture = profilePicture
    }
}
