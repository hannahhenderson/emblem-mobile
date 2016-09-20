//
//  SignUpViewController.swift
//  Emblem
//
//  Created by Dane Jordan on 9/19/16.
//  Copyright © 2016 Hadashco. All rights reserved.
//

import UIKit


class SignUpViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var reenterPasswordTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!

    @IBAction func signupButtonPressed(sender: AnyObject) {
        let password1 = passwordTextField.text!
        let password2 = reenterPasswordTextField.text!
        let email = emailTextField.text!
        if !isValidEmail(email) {
            let alert = UIAlertController(title: "Oops", message: "Invalid Email", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        } else if (password1 == "") {
            let alert = UIAlertController(title: "Oops", message: "Passwords field is blank", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        } else if (password1 == password2) {

            self.performSegueWithIdentifier(MapViewController.getEntrySegueIdentifierFromSignup(), sender: true)
            let hashedPassword = password2.sha512()
            let url = NSURL(string: Store.serverLocation + "auth/local/register")!
            HTTPRequest.post(["username": email, "password": hashedPassword], dataType: .JSON, url: url, postCompleted: { (succeeded, msg) in
                if succeeded {
                    Store.accessToken = msg["response"].stringValue
                    self.performSegueWithIdentifier(MapViewController.getEntrySegueIdentifierFromSignup(), sender: nil)
                } else if msg["response"].stringValue == "A user with this username already exists." {
                    let alert = UIAlertController(title: "Oops", message: "A user with this email already exists.", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            })
        } else {
            let alert = UIAlertController(title: "Oops", message: "Passwords don't match", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    
    func isValidEmail(email:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(email)
    }
    
    class func getEntrySegueIdentifierFromLoginVC() -> String {
        return "loginToSignupSegue"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signupButton.layer.cornerRadius = signupButton.bounds.height / 2
        passwordTextField.secureTextEntry = true
        reenterPasswordTextField.secureTextEntry = true
        
        if let backImage:UIImage = UIImage(named: "left-arrow.png") {
            let backButton: UIButton = UIButton(type: UIButtonType.Custom)
            backButton.frame = CGRectMake(0, 0, 20, 20)
            backButton.contentMode = UIViewContentMode.ScaleAspectFit
            backButton.setImage(backImage, forState: UIControlState.Normal)
            backButton.addTarget(self, action: #selector(backPressed), forControlEvents: .TouchUpInside)
            let leftBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: backButton)
            self.navigationItem.setLeftBarButtonItem(leftBarButtonItem, animated: false)
        }
    }
    
    func backPressed() {
        self.navigationController?.popViewControllerAnimated(true)
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == MapViewController.getEntrySegueIdentifierFromSignup() {
            let dest = segue.destinationViewController as! MapViewController
            dest.isFromSignup = true
        }
    }
 

}
