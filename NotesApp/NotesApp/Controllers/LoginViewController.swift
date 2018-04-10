//
//  LoginViewController.swift
//  NotesApp
//
//  Created by Carmen Popa on 24/03/2018.
//  Copyright © 2018 Carmen Popa. All rights reserved.
//

import UIKit
import FacebookLogin
import FBSDKLoginKit

private let Permissions = ["public_profile", "email", "user_friends"]
private let ButtonLogOutMessage = "LOG OUT"
private let ButtonLogInMessage = "CONNECT WITH FACEBOOK"
private let NotLoggedIn = "You're not logged in"
private let IsLoggedInMessage = "You're awesome!"
private let IsLoggedOutMessage = "You're missing all the fun!"

enum State {
    case LoggedIn
    case LoggedOut
}

class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var upperMessageLabel: UILabel!
    @IBOutlet weak var lowerMessageLabel: UILabel!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    
    var state: State = .LoggedOut
    
    override func viewWillAppear(_ animated: Bool) {
        loadScreen()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    internal func loadScreen() {
        switch state {
            case .LoggedIn:
                loginButton.titleLabel?.text = ButtonLogOutMessage
                profilePictureImageView.image = nil //poza de pe FB
                upperMessageLabel.text = "name"
                lowerMessageLabel.text = IsLoggedInMessage
            case .LoggedOut:
                loginButton.titleLabel?.text = ButtonLogInMessage
                profilePictureImageView.image = #imageLiteral(resourceName: "ic_nav_profile")
                upperMessageLabel.text = NotLoggedIn
                lowerMessageLabel.text = IsLoggedOutMessage
        }
    }
}
