//
//  LoginViewController.swift
//  NotesApp
//
//  Created by Carmen Popa on 24/03/2018.
//  Copyright © 2018 Carmen Popa. All rights reserved.
//

import UIKit
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadScreen()
    }
    
    internal func loadScreen() {
        switch state {
            case .LoggedIn:
                loginButton.setTitle(ButtonLogOutMessage, for: UIControlState.normal)
                loginButton.titleLabel?.textAlignment = NSTextAlignment.center
                lowerMessageLabel.text = IsLoggedInMessage
                profilePictureImageView.layer.cornerRadius = profilePictureImageView.frame.size.width / 2;
                profilePictureImageView.clipsToBounds = true;
            case .LoggedOut:
                loginButton.setTitle(ButtonLogInMessage, for: UIControlState.normal)
                loginButton.titleLabel?.textAlignment = NSTextAlignment.center
                profilePictureImageView.image = #imageLiteral(resourceName: "ic_nav_profile")
                upperMessageLabel.text = NotLoggedIn
                lowerMessageLabel.text = IsLoggedOutMessage
        }
    }
    
    @IBAction func doLoginWithFacebook(_ sender: Any) {
        switch state {
            case .LoggedIn:
                state = .LoggedOut
            case .LoggedOut:
                requestLogin()
                state = .LoggedIn
        }
        loadScreen()
    }
    
    func requestLogin() {
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: Permissions, from: nil) { (result, error) in
            if error == nil {
                let fbLoginResult = result
                if fbLoginResult?.grantedPermissions?.contains("email") != nil {
                    self.getUserInfo()
                }
            }
        }
    }
    
    func getUserInfo() {
        if(FBSDKAccessToken.current() != nil) {
            let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "id, name, email"])
            let connection = FBSDKGraphRequestConnection()
            connection.add(graphRequest, completionHandler: { (connection, result, error) -> Void in
                
                let data = result as! [String : AnyObject]
                self.upperMessageLabel.text = data["name"] as? String
                let FBid = data["id"] as? String
                let url = NSURL(string: "https://graph.facebook.com/\(FBid!)/picture?type=large&return_ssl_resources=1")
                self.profilePictureImageView.image = UIImage(data: NSData(contentsOf: url! as URL)! as Data)
                Account.singleton.setAccount(name: (data["name"] as? String)!, id: FBid!, token:  FBSDKAccessToken.current().appID, email: (data["email"] as? String)!, profilePicture: url!)
            })
            connection.start()
        }
    }
    
    
}
