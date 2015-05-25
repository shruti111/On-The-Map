//
//  MapsLocationsViewController.swift
//  On The Map
//
//  Created by Shruti Pawar on 15/04/15.
//  Copyright (c) 2015 ShapeMyApp Software Solutions Pvt. Ltd. All rights reserved.
//

import UIKit
import MapKit

class MapsLocationsViewController: UIViewController, MKMapViewDelegate {

     /* Outlets and Properties */
    
    @IBOutlet weak var mapView: MKMapView!
    
    var didRefreshMapData : Bool = false {
        didSet {
            if mapView != nil {
                showLocations()
            }
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
  //MARK:- Show Pins on Map 
    
    /* Show Annotations on Map from student information data */
    
    func showLocations() -> Void {
        
        if let allAnnotaions = mapView.annotations {
        mapView.removeAnnotations(mapView.annotations)
        }
        
        // Create array of annotaions
        
        var annotations = [MKPointAnnotation]()
        if let locations = Client.sharedInstance().studentLocations {
            
            for location in locations {
                
                // Create annotation object
                
                var annotation = MKPointAnnotation()
                if location.coordinate != nil {
                annotation.coordinate = location.coordinate!
                annotation.title = "\(location.firstName!) \(location.lastName!)"
                annotation.subtitle = location.mediaURL!
                annotations.append(annotation)
                }
            }
        }
        mapView.addAnnotations(annotations)
    }
    
    //MARK:- MKMapviewDelegate
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        // Customize Annotaion View 
        
        let reusableMapId = "studentLocationPinId"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reusableMapId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reusableMapId)
            pinView!.canShowCallout = true
            pinView!.pinColor = MKPinAnnotationColor.Green
            pinView!.rightCalloutAccessoryView = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as! UIButton
        } else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        
        //Navigate to User's link / URL when call out is Tapped
        
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            app.openURL(NSURL(string: view.annotation.subtitle!)!)
        }
        
    }
    

}
