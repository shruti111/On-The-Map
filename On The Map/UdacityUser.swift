//
//  UdacityUser.swift
//  On The Map
//
//  Created by Shruti Pawar on 16/05/15.
//  Copyright (c) 2015 ShapeMyApp Software Solutions Pvt. Ltd. All rights reserved.
//

import Foundation

struct UdacityUser {
    
   // UdacityUser Class Properties
    
    var uniqueKey: String?
    var firstName: String?
    var lastName: String?
   
    
    // Keys to convert dictionary into object
    struct Keys {
        static let UniqueKey = "UserId"
    }
    
    
    /* Construct a StudentInformation from a dictionary */
    init(dictionary: [String : AnyObject]) {

        firstName =  dictionary[Client.JSONResponseKeys.UserFirstName] as? String
        lastName =  dictionary[Client.JSONResponseKeys.UserLastName] as? String
        uniqueKey = dictionary[Keys.UniqueKey] as? String
    
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