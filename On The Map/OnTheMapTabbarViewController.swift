//
//  OnTheMapTabbarViewController.swift
//  On The Map
//
//  Created by Shruti Pawar on 16/04/15.
//  Copyright (c) 2015 ShapeMyApp Software Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

class OnTheMapTabbarViewController: UITabBarController {

    /* Outlets and Properties */

    @IBOutlet var pinBarbautton: UIBarButtonItem!
    @IBOutlet weak var refreshBarbutton: UIBarButtonItem!
    
    //MARK:- Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Show two buttons in right in navigation bar
        self.navigationItem.rightBarButtonItems  = [refreshBarbutton,pinBarbautton]
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        getStudentLocations()
    }
    
    //MARK:- Get Students data
    
    @IBAction func refreshLocationsData(sender: UIBarButtonItem) {
        // Get data when refresh button is clicked
        getStudentLocations()
    }
    
    // Get students locations from parse API
    
    func getStudentLocations() -> Void {
        
        // Show activity indicator
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        Client.sharedInstance().clientType = Client.ClientType.ParseClient
        
        // Query to Parse to retrieve data
        
        Client.sharedInstance().getLocations() {
            students, error in
            
            dispatch_async(dispatch_get_main_queue()) {
            
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                
                if let error = error {
                    
                    // Show network error
                    
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    
                    if error.domain == "OnTheMap NetworkError" {
                        self.showNetworkError()
                        
                    } else {
                        
                        // Show data fetching and loading erro
                        
                        let hudMessageView = HUDMessageView.hudMessageInView(self.view, animated: true)
                        hudMessageView.titleText = "Oops..."
                        hudMessageView.messageText = error.localizedDescription
                    }
                    
                } else {
                    
                    // Show data on Maps and table view controller
                    
                    if let studentsData = students {
                        
                        Client.sharedInstance().studentLocations = studentsData
                        
                        let mapsViewController = self.viewControllers![0] as! MapsLocationsViewController
                        mapsViewController.didRefreshMapData = true
                        
                        let locationsTableViewController = self.viewControllers![1] as! LocationsTableViewController
                        locationsTableViewController.didRefreshData = true
                        
                        
                    }
                    
                }
                
            }
        }
    }
    
    //Log out from Facebook

    @IBAction func logOut(sender: UIBarButtonItem) {
        
        if FBSDKAccessToken.currentAccessToken() != nil {
            FBSDKAccessToken.setCurrentAccessToken(nil)
        }
        
                 Client.sharedInstance().sessionID  = nil
                Client.sharedInstance().userID  = nil
                Client.sharedInstance().userInformation = nil
                Client.sharedInstance().studentLocations = nil

        dismissViewControllerAnimated(true, completion: nil)
        
        
    }
    
    //Helper method to show Network error
    
    func showNetworkError() {
        
        var errorView = HUDErrorView(frame: CGRectZero)
        errorView.title = "Could not connect"
        errorView.message = "Please check your internet connection and try again."
        errorView.showInView(self.view)
        
    }

}
