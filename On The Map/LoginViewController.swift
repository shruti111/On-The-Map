//
//  LoginViewController.swift
//  On The Map
//
//  Created by Shruti Pawar on 11/04/15.
//  Copyright (c) 2015 ShapeMyApp Software Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate, UITextFieldDelegate {

    /* Outlets and Properties */
    
    @IBOutlet weak var loginNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var fbLoginView: FBSDKLoginButton!
    var tapPerformed: Bool = false
    
    // To check which text field is active (User name or password)
    var activeTextField : UITextField!
    //Dismiss keybaord when user taps on view
    var tapGestureRecognizer: UITapGestureRecognizer?

    //MARK:- View LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fbLoginView.delegate = self;
        FBSDKProfile.enableUpdatesOnAccessTokenChange(true)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("dismissKeyboard:"))
        tapGestureRecognizer?.numberOfTapsRequired = 1
}
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.view.addGestureRecognizer(tapGestureRecognizer!)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        self.view.removeGestureRecognizer(tapGestureRecognizer!)
    }
    
    func configureUI() {
       
        /* Configure background gradient */
        self.view.backgroundColor = UIColor.clearColor()
        let colorTop = UIColor(red: 232/255, green: 151/255, blue: 38/255, alpha: 1.0).CGColor
        let colorBottom = UIColor(red: 226/255, green: 111/255, blue: 26/255, alpha: 1.0).CGColor
        var backgroundGradient = CAGradientLayer()
        backgroundGradient.colors = [colorTop, colorBottom]
        backgroundGradient.locations = [0.0, 1.0]
        backgroundGradient.frame = view.frame
        self.view.layer.insertSublayer(backgroundGradient, atIndex: 0)
        
        /* Configure text fields*/
        loginNameTextField.attributedPlaceholder = NSAttributedString(string: loginNameTextField.placeholder!, attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
        
         passwordTextField.attributedPlaceholder = NSAttributedString(string: passwordTextField.placeholder!, attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
       
        /* Configure login button */
        loginButton.layer.cornerRadius = 5.0

    }
    
    func dismissKeyboard(gestureRecognizer: UITapGestureRecognizer) {
        tapPerformed = true
        self.view.endEditing(true)
    }
    
    //MARK:- Authentication
    
    /* Make User name and password mandatory */
    
    func validateTextFields() -> Bool {
        
        var textMessage = ""
        
        if loginNameTextField.text.isEmpty {
            textMessage = "Please enter your user name. Example: johndemo@gmail.com."
           
        } else if passwordTextField.text.isEmpty {
            textMessage = "Password can not be empty. Please enter your password for Login Id."
        }
        
        if !textMessage.isEmpty {
        
            let hudMessageView = HUDMessageView.hudMessageInView(self.view, animated: true)
            hudMessageView.titleText = "Form error"
            hudMessageView.messageText = textMessage
            return false
            
        }
        
        return true
    }
    
    /* Login with Udacity Id and Password */
    
    @IBAction func loginWithUdacityAccount(sender: UIButton) {
        
        if validateTextFields() {
            
            //  Show activity indicator 
            
            let hudView = HUDActivityIndicatorView.hudActivityIndicatorInView(view, animated: true)
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            
            // Make request and receive data
            
            Client.sharedInstance().loginWithUdacityAccount(loginNameTextField.text, password: passwordTextField.text,token:nil, completionHandler: {
                succeess, loginerror in
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.view.endEditing(true)
                    hudView.hideHudActivityIndicatorView(self.view)
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    
                    if let error = loginerror {
                        
                        // Show network error
                        if error.domain == "OnTheMap NetworkError" {
                            self.showNetworkError()
                        } else {
                            
                            // Show other erros
                            let hudMessageView = HUDMessageView.hudMessageInView(self.view, animated: true)
                            hudMessageView.titleText = "Oops..."
                            hudMessageView.messageText = error.localizedDescription
                        }
                    } else  {
                        
                        // If there is no error, show maps view for locations
                        self.showMaps()
                        
                    }
                }
           })
        }
        
    }
    
    /*Helper method to show Network Error */
    
    func showNetworkError() {
        var errorView = HUDErrorView(frame: CGRectZero)
        errorView.title = "Could not connect"
        errorView.message = "Please check your internet connection and try again."
        errorView.showInView(self.view)
        
    }

    /* Navigate to Sign up On Udacity page */
    
    @IBAction func displaySignupUdacityPage(sender: UIButton) {
        
        let app = UIApplication.sharedApplication()
        app.openURL(NSURL(string: Client.Constants.SignUpURL)!)
        
    }
    
    /* Facebook Authentication for Udacity Login */
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!){
        
        if result.token != nil {
            
            
        //Sign In With Facebook
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true

            Client.sharedInstance().loginWithUdacityAccount(loginNameTextField.text, password: passwordTextField.text,token:FBSDKAccessToken.currentAccessToken().tokenString, completionHandler: {  success, loginerror in
                
                dispatch_async(dispatch_get_main_queue()) {
                    
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    
                    if let error = loginerror {
                        
                        if error.domain == "OnTheMap NetworkError" {
                            self.showNetworkError()
                        } else {
                            let hudMessageView = HUDMessageView.hudMessageInView(self.view, animated: true)
                            hudMessageView.titleText = "Oops..."
                            hudMessageView.messageText = error.localizedDescription
                        }
                    } else  {
                        self.showMaps()
                    }
                }
                
            })
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
        // Mandatory delegate method
        println("Facebook Logout")
        
    }
    /* Navigation to MapsLocationsViewController */
    
    func showMaps() {
        
        // Nvigate to common Tabbar controller
       let navigationController = storyboard?.instantiateViewControllerWithIdentifier("mapsnavigationController") as!UINavigationController
        presentViewController(navigationController, animated: true, completion: {
            self.passwordTextField.text = ""
        })
        
    }
    
    //MARK:- UITextFieldDelegate Methods
    
    func textFieldDidBeginEditing(textField: UITextField) {
       // Set the active text field
        activeTextField = textField
    }
    func textFieldDidEndEditing(textField: UITextField) {
        
        // When user returns from User name text field. password field will become responder
        if activeTextField === loginNameTextField && !tapPerformed {
           loginNameTextField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
            
        } else {
            tapPerformed = false
        }
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        activeTextField = nil
        return true
    }

}

