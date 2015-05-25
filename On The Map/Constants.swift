//
//  Constants.swift
//  On The Map
//
//  Created by Shruti Pawar on 15/05/15.
//  Copyright (c) 2015 ShapeMyApp Software Solutions Pvt. Ltd. All rights reserved.
//

import Foundation

extension Client {
    
    // MARK: - Constants
    struct Constants {
        
        //Udacity
        static let BaseURL: String = "https://www.udacity.com/api/"
        static let SignUpURL: String = "https://www.udacity.com/account/auth#!/signup"
        
        //Parse
        static let ParseURL: String = "https://api.parse.com/1/classes"
        static let limitLocations: String = "100"
        static let ParseAppId: String = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let ParseAPIKey: String = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    }
    
    // MARK: - Methods
    
    struct Methods {
        
        //Udacity
        static let CreateSession = "session"
        static let GetUserInformation = "users/{id}"
        
        //Parse Methods
        static let getLocations = "/StudentLocation"
        static let updateStudentData = "/{objectId}"
    }
    
    // MARK: - URL Keys
    struct URLKeys {
        static let UserID = "id"
    }
    
    // MARK: - Parameter Keys
    struct ParameterKeys {
      
        // Parse
        static let LimitNumberofLocations = "limit"
        
        
    }
    
    // MARK: - JSON Body Keys
    struct JSONBodyKeys {
        static let UdacityLogin = "udacity"
        static let UserName = "username"
        static let Password = "password"
        static let Facebook = "facebook_mobile"
        static let FacebookAccessToken = "access_token"
       
    }
    
    // MARK: - JSON Response Keys
    struct JSONResponseKeys {
        
        //Authentication
        static let Session = "session"
        static let SessionId =  "id"
        static let UserAccount = "account"
        static let UserId = "key"
        
        static let UserData = "user"
        static let UserFirstName = "first_name"
        static let UserLastName = "last_name"
       
        //Parse Response
        static let Results = "results"
        
        static let FirstName = "firstName"
        static let LastName =  "lastName"
        static let Latitude = "latitude"
        static let Longitude = "longitude"        
        static let MediaURL = "mediaURL"
        static let ObjectId = "objectId"
        static let UniqueKey = "uniqueKey"
        static let MapString = "mapString"
        static let CreatedDate = "createdAt"
        static let UpdatedDate = "updatedAt"
        
    }
    
    // API Client type
    enum ClientType {
        case ParseClient
        case UdacityClient
    }
    
    
}