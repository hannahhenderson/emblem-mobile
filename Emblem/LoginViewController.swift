//
//  LoginViewController.swift
//  Emblem
//
//  Created by Dane Jordan on 8/3/16.
//  Copyright © 2016 Hadashco. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var FBLoginButton: FBSDKLoginButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureFacebook()
        if FBSDKAccessToken.currentAccessToken() != nil {
            print("loggedInAlready")
            //User is logged in
        } else {
            //log user in
        }
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!){
        

        FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields":"first_name, email, last_name, picture.type(large)"]).startWithCompletionHandler { (connection, result, error) -> Void in
            
            
            //Result Object Here
            print("in result", result)
            
//            let strFirstName: String = (result.objectForKey("first_name") as? String)!
//            let strLastName: String = (result.objectForKey("last_name") as? String)!
//            let strPictureURL: String = (result.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as? String)!
            }
        
    }

    func configureFacebook(){
        FBLoginButton.readPermissions = ["public_profile", "email", "user_friends"]
        FBLoginButton.delegate = self
    }
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!){
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
