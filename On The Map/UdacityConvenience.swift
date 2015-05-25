//
//  Convenience.swift
//  On The Map
//
//  Created by Shruti Pawar on 15/05/15.
//  Copyright (c) 2015 ShapeMyApp Software Solutions Pvt. Ltd. All rights reserved.
//

import Foundation

extension Client {

    // Login with Udacity  or Facebook Username and password (POST request)
    
    func loginWithUdacityAccount(userName:String, password:String,token: String?, completionHandler: (success: Bool, error: NSError?) -> Void) {
        
        /* Specify parameters, method, header parameters and json body for POST request */
        
        var method : String = Methods.CreateSession
        var jsonBody =  [String:AnyObject]()
        
        if token != nil {
            
            jsonBody = [JSONBodyKeys.Facebook : [ JSONBodyKeys.FacebookAccessToken : token!] ]
            
        } else {
         jsonBody  = [JSONBodyKeys.UdacityLogin :
                    [JSONBodyKeys.UserName : userName, JSONBodyKeys.Password : password] ]
        }
        
        let headerParameters = ["Accept" : "application/json", "Content-Type" : "application/json"]
        
        /* Make the request */
        
        let task = taskForPOSTMethod(method, jsonBody: jsonBody, headerParameters:headerParameters) { JSONResult, error in
            
            /*  Send the desired value(s) to completion handler */
            
            if let error = error {
               
                completionHandler(success: false, error: error)
                
            } else {

                if let loginerror =  JSONResult["error"] as? String {
                    
                    let error = NSError(domain: "OnTheMap DataError", code: 20, userInfo: [NSLocalizedDescriptionKey : "Invalid login credentials. The email and password you entered don't match."])
                     completionHandler(success: false, error: error)
                    
                } else {
                    
                    // Get session Id and User Id
                    
                    let sessionData: NSDictionary = JSONResult[JSONResponseKeys.Session] as! NSDictionary
                    
                    let sessionId = sessionData[JSONResponseKeys.SessionId] as! String
                    self.sessionID = sessionId
                    
                    let userData: NSDictionary = JSONResult[JSONResponseKeys.UserAccount] as! NSDictionary
                    
                    let userId = userData[JSONResponseKeys.UserId] as! String
                    self.userID = userId
                    
                    println("User id is \(userId)")
                    
                    if self.userID != nil {
                        
                        // if UserId is available, get Logged In user's information
                        
                        self.getStudentInformation(completionHandler)
                        
                    } else {
                        
                        let error = NSError(domain: "OnTheMap DataError", code: 20, userInfo: [NSLocalizedDescriptionKey : "Internal Error getting UserId. Please try again later."])
                        completionHandler(success: false, error: error)
                    }
                }
            }
        }
        
    }
    
    // Get Logged in User's data (GET request)
    
    func getStudentInformation(completionHandler: (success: Bool, error: NSError?) -> Void) {
        
        /* Specify parameters, method, header parameters and json body for POST request */
        
        var mutableMethod : String = Methods.GetUserInformation
        mutableMethod = Client.subtituteKeyInMethod(mutableMethod, key: Client.URLKeys.UserID, value: String(self.userID!))!
       
        /* Make the request */
        
        let task = taskForGETMethod(mutableMethod) { jsonResult, error in
            
            /*  Send the desired value(s) to completion handler */
            
            if let error = error {
                completionHandler(success: false, error: error)
            } else {
               
                // Get user data
                
                if let userData : NSDictionary = jsonResult[JSONResponseKeys.UserData] as? NSDictionary {
                    
                     var userInfoDict: Dictionary = userData as Dictionary
                     userInfoDict[UdacityUser.Keys.UniqueKey] = self.userID!
                    
                    var studentInfo = UdacityUser(dictionary: userInfoDict as! [String : AnyObject])
                    Client.sharedInstance().userInformation = studentInfo
                    
                     completionHandler(success: true, error: nil)
                    
                } else {
                    let error = NSError(domain: "OnTheMap DataError", code: 20, userInfo: [NSLocalizedDescriptionKey : "Internal Error getting user data. Please try again later."])
                     completionHandler(success: false, error: nil)
                }
               
            }
        }
    }
    
}