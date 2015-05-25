//
//  StudentLocation.swift
//  On The Map
//
//  Created by Shruti Pawar on 15/04/15.
//  Copyright (c) 2015 ShapeMyApp Software Solutions Pvt. Ltd. All rights reserved.
//

import Foundation
import MapKit

struct StudentInformation {
   
    // StudentInformation Struct properties
    
    var objectId: String?
    var uniqueKey: String?
    var firstName: String?
    var lastName: String?
    var mapString: String?
    var mediaURL: String?
    var coordinate: CLLocationCoordinate2D?
    var createdAt:NSDate?
    var updatedAt:NSDate?
    

  /* Construct a StudentInformation from a available fields */
    init(uniqueKey: String?, firstName: String?, lastName: String?, mapString: String?,mediaURL: String?,coordinate:CLLocationCoordinate2D? ) {
        
        self.uniqueKey = uniqueKey
        self.firstName = firstName
        self.lastName = lastName
        self.mapString = mapString
        self.mediaURL = mediaURL
        self.coordinate = coordinate
        
    }
    
    /* Construct a StudentInformation from a dictionary */
    init(dictionary: [String : AnyObject]) {
                
        objectId = dictionary[Client.JSONResponseKeys.ObjectId] as? String
        uniqueKey = dictionary[Client.JSONResponseKeys.UniqueKey] as? String
        firstName =  dictionary[Client.JSONResponseKeys.FirstName] as? String
        lastName =  dictionary[Client.JSONResponseKeys.LastName] as? String
        mapString = dictionary[Client.JSONResponseKeys.MapString] as? String
        mediaURL = dictionary[Client.JSONResponseKeys.MediaURL] as? String
        
        let lattitude = dictionary[Client.JSONResponseKeys.Latitude] as? Double
        let longitude = dictionary[Client.JSONResponseKeys.Longitude] as? Double
        
        if lattitude != nil && longitude != nil {
            coordinate = CLLocationCoordinate2D(latitude: lattitude!, longitude: longitude!)
        }
        createdAt =  dictionary[Client.JSONResponseKeys.CreatedDate] as? NSDate
        updatedAt =  dictionary[Client.JSONResponseKeys.UpdatedDate] as? NSDate       
    }
    
    /* Helper: Given an array of dictionaries, convert them to an array of StudentInformation objects */
    static func studnetsFromResults(results: [[String : AnyObject]]) -> [StudentInformation] {
        var students = [StudentInformation]()
        
        for result in results {
            students.append(StudentInformation(dictionary: result))
        }
        
        return students
    }
}
    
