//
//  PostInformationViewController.swift
//  On The Map
//
//  Created by Shruti Pawar on 16/04/15.
//  Copyright (c) 2015 ShapeMyApp Software Solutions Pvt. Ltd. All rights reserved.
//
import Foundation
import UIKit
import CoreLocation
import MapKit

class PostInformationViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate, LinkViewControllerDelegate {

    /* Outlets and Properties */
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var studentLocationMapView: MKMapView!
    @IBOutlet weak var mediaURLTextField: UITextField!
    @IBOutlet weak var postLinkView: UIView!
    @IBOutlet weak var studentLocationView: UIView!
    @IBOutlet weak var findOnMapButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    
    // Geocoder for reverse geocoding
    let geocoder = CLGeocoder()
    
    // Students data to Post or update
    var loggedinUdacityStudentInformation: StudentInformation?
    var loggedinudacityUser: UdacityUser?
    
    var errorView : HUDErrorView?
    
    // Tap gesture to dismiss keyboard
    var tapGestureRecognizer: UITapGestureRecognizer?
    
    //MARK:- Life cycle methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        configureUI()
        
        // Logged in Udacity User
        loggedinudacityUser = Client.sharedInstance().userInformation!
        
        // Logged in Student information to post to Parse
        loggedinUdacityStudentInformation = StudentInformation(uniqueKey: loggedinudacityUser!.uniqueKey, firstName: loggedinudacityUser!.firstName, lastName: loggedinudacityUser!.lastName, mapString: nil, mediaURL: nil, coordinate: nil)
        
        // Find if student has already posted, then set the controls with existing data
        if findIfStudentHasAlreadyPosted() {
        
            locationTextField.text = loggedinUdacityStudentInformation?.mapString
            mediaURLTextField.text = loggedinUdacityStudentInformation?.mediaURL
        
         // Show user information that data is already there, posting again will update the data
        errorView = HUDErrorView(frame: CGRectZero)
        errorView!.title = "Your information exists."
        errorView!.message = "You have already posted data.This will update your location and URL."
        errorView!.showInView(self.view)
            
        }
        
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
    
    func dismissKeyboard(gestureRecognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func findIfStudentHasAlreadyPosted() -> Bool {
        
            if let students = Client.sharedInstance().studentLocations {
            
            let loggedInStudent = students.filter {
                $0.uniqueKey == self.loggedinudacityUser?.uniqueKey
            }
            
            if loggedInStudent.count > 0 {
                
                loggedinUdacityStudentInformation = loggedInStudent.last
                
                return true
            }
        }
        
        return false
    }
    
    func configureUI() {
        findOnMapButton.layer.cornerRadius = 5.0
        submitButton.layer.cornerRadius = 5.0
    }
    
    //MARK:- Enter Student Location

    /* Find user's locaion data from Location text field */
    
    @IBAction func findMyLocation(sender: UIButton) {
        
        if locationTextField.text.isEmpty {
            
            // Validation, if user has not entered data
            
            let hudMessageView = HUDMessageView.hudMessageInView(self.view, animated: true)
            hudMessageView.titleText = "Validation Error"
            hudMessageView.messageText = "Location not entered. Please enter your place of study."
            
        }
        else {
            
            // Find location coordinates
            
            var userEnteredLocation = locationTextField.text
            
            // activity indicators
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            let hudView = HUDActivityIndicatorView.hudActivityIndicatorInView(view, animated: true)
            hudView.text = "Searching..."
          
            // Find coordinates using Geocoding
            
            geocoder.geocodeAddressString(userEnteredLocation, completionHandler: {
                placemarks, error in
                
               UIApplication.sharedApplication().networkActivityIndicatorVisible = false
               hudView.hideHudActivityIndicatorView(self.view)
                
                // Show geocoding error
                
                if let geoCodeError = error {
                    
                    let hudMessageView = HUDMessageView.hudMessageInView(self.view, animated: true)
                    hudMessageView.titleText = "Oops..."
                    hudMessageView.messageText = "Address not found! Please re-enter your location."
                }
                
                else {
                let lastPlacemark = placemarks.last as! CLPlacemark

                    self.view.resignFirstResponder()
                    
                    // Update data with user location and coordiante
                    
                    self.loggedinUdacityStudentInformation?.mapString = userEnteredLocation
                    self.loggedinUdacityStudentInformation?.coordinate = lastPlacemark.location.coordinate
                    
                    // Show Post link view with View Animation
                   self.changeAlphaWithAnimations()
            }
                
            })
        }
    }
    
    /* View animation (show post link view by changing alpha and animating with time frame) */
    
    func changeAlphaWithAnimations() {
        
        if errorView != nil {
            errorView?.hide()
        }
        
        UIView.animateWithDuration(2.0, delay: 0.5, options: UIViewAnimationOptions.AllowAnimatedContent, animations: {
            self.postLinkView.alpha = 1.0
            }, completion: {
                finished in
                if finished {
                    
                    // Update the Map in post link view based on the location name entered by student
                    
                    self.updateMapView()
                }
        })

    }
    
    /* Cancel will dismiss the view and go back to locations view */
    
    @IBAction func cancel(sender: UIButton) {
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    //MARK:- Post Link
    
    /* Show mapview with the location user has entered */
    
    func updateMapView() -> Void {
        
        var annotations = [MKPointAnnotation]()
        
        if let location = loggedinUdacityStudentInformation {
            
            // Set map view region
            let longitude = location.coordinate!.longitude
            let latitude = location.coordinate!.latitude
            let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            let longitudeDelta = 10.0
            let latitudeDelta = 10.0
            let span = MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
            
            let region = MKCoordinateRegion(center: center, span: span)
            studentLocationMapView.setRegion(region, animated: true)
            
            // Show annotaion on map with the user's location
            
            var annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate!
            annotation.title = "\(location.firstName!) \(location.lastName!)"
            annotations.append(annotation)
            
        }
        
        // Add annotation
        studentLocationMapView.addAnnotations(annotations)
    }
    
    /* Cancel button to Post link */
    
    @IBAction func cancelPostLink(sender: UIButton) {
    
        //Animate views 
        
            UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.AllowAnimatedContent, animations: {
                self.postLinkView.alpha = 0.0
                }, completion: nil)
    }
    
    /* Post student data to Parse */
    
     
    
    @IBAction func postStudentInformation(sender: UIButton) {
       
        // Validations for URL Text field
            
        if mediaURLTextField.text.isEmpty {
          
            let hudMessageView = HUDMessageView.hudMessageInView(self.view, animated: true)
            hudMessageView.titleText = "Validation Error"
            hudMessageView.messageText = "URL not entered. Please enter your link for data submission."
            
        } else if (Validations.validateURL(mediaURLTextField.text) == false) {
                        
            let hudMessageView = HUDMessageView.hudMessageInView(self.view, animated: true)
            hudMessageView.titleText = "Validation Error"
            hudMessageView.messageText = "Invalid URL. Please enter valid URL example: http://www.udacity.com"
            
            mediaURLTextField.text = ""
            
        } else {
            
            // Show network activity while data is posted to Parse
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            
            // Update student information
            
            loggedinUdacityStudentInformation?.mediaURL = mediaURLTextField.text!
            
            // Uodate data if already exisits
            
            if loggedinUdacityStudentInformation!.objectId != nil {
                
                self.updateStudentInformationData()
                
            } else {
            
            // User is posting data for first time
                
           self.postStudentInformationData()
      }
        }
        
    }
    
    func updateStudentInformationData() {

        let hudView = HUDActivityIndicatorView.hudActivityIndicatorInView(view, animated: true)
        hudView.text = "Submitting.."
        
        Client.sharedInstance().updateStudentInformation(loggedinUdacityStudentInformation!, completionHandler: {
            success, error in
            
            dispatch_async(dispatch_get_main_queue(), {
                
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                hudView.hideHudActivityIndicatorView(self.view)
                
                if let error = error {
                    
                    // Show netwrok error
                    
                    if error.domain == "OnTheMap NetworkError" {
                        self.showNetworkError()
                    } else {
                        
                        // Show data fetching and parsing error
                        
                        let hudMessageView = HUDMessageView.hudMessageInView(self.view, animated: true)
                        hudMessageView.titleText = "Oops..."
                        hudMessageView.messageText = error.localizedDescription
                    }
                    
                } else {
                    
                    // When data is successfully posted, go back to maps view
                    
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
                
            })
        })
        
    }
    
    func postStudentInformationData() {
        
        let hudView = HUDActivityIndicatorView.hudActivityIndicatorInView(view, animated: true)
        hudView.text = "Submitting.."
        
        Client.sharedInstance().postStudentInformation(loggedinUdacityStudentInformation!, completionHandler: {
            success, error in
            
            dispatch_async(dispatch_get_main_queue(), {
                
                // Show network activity
                
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                hudView.hideHudActivityIndicatorView(self.view)
                
                if let error = error {
                    
                    // Show network error
                    if error.domain == "OnTheMap NetworkError" {
                        self.showNetworkError()
                    } else {
                        
                        // SHow data fetching and parsing error
                        let hudMessageView = HUDMessageView.hudMessageInView(self.view, animated: true)
                        hudMessageView.titleText = "Oops..."
                        hudMessageView.messageText = error.localizedDescription
                    }
                    
                } else {
                    
                    // When data is successfully posted, go back to maps view
                    
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
                
            })
            
        })
        
    }
    
    /* Helper method to show Network error */
    
    func showNetworkError() {
        
        var errorView = HUDErrorView(frame: CGRectZero)
        errorView.title = "Could not connect"
        errorView.message = "Please check your internet connection and try again."
        errorView.showInView(self.view)
        
    }
    
    //MARK:- UITextField Delegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }

    
    //MARK:- MKMapviewDelegate
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
       
        // Annotaion view customization
        
        let reusableMapId = "studentInformationPinId"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reusableMapId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reusableMapId)
            pinView!.canShowCallout = true
            pinView!.pinColor = MKPinAnnotationColor.Purple
        } else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    @IBAction func browseLink(sender: UIButton) {
        
        if mediaURLTextField.text.isEmpty {
            
            let hudMessageView = HUDMessageView.hudMessageInView(self.view, animated: true)
            hudMessageView.titleText = "Validation Error"
            hudMessageView.messageText = "URL not entered. Please enter your link to browse."
            
        } else {
        
          performSegueWithIdentifier("BrowseLink", sender: nil)
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "BrowseLink" {
            let controller = segue.destinationViewController as! UINavigationController
            let linkViewController =  controller.topViewController as! LinkViewController
            linkViewController.delegate = self
            linkViewController.urlString = mediaURLTextField.text
        }
        
    }

    
     //MARK:- LinkViewControllerDelegate
    
    func sendLink(linkViewController: LinkViewController, didSendLink link: String) {
        mediaURLTextField.text = link
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
