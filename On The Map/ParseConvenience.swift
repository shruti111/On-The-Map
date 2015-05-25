//
//  ParseConvenience.swift
//  On The Map
//
//  Created by Shruti Pawar on 16/05/15.
//  Copyright (c) 2015 ShapeMyApp Software Solutions Pvt. Ltd. All rights reserved.
//

import Foundation

extension Client {

  // Get latest 100 user locations (by specifying Limit parameter (GET request)
    
   func getLocations(completionHandler: (result: [StudentInformation]?, error: NSError?) -> Void) -> NSURLSessionDataTask? {
    
    /* Specify parameters */
    
     let parameters = [Client.ParameterKeys.LimitNumberofLocations : Client.Constants.limitLocations]
    
     let headerParameters = ["X-Parse-Application-Id" : Client.Constants.ParseAppId , "X-Parse-REST-API-Key" : Client.Constants.ParseAPIKey]
    
    /* Make the request */

     let task = taskForGETMethod(Client.Methods.getLocations, parameters: parameters,headerParameters:headerParameters) { JSONResult, error in
        
         /* Send the desired value(s) to completion handler */
        
        if let error = error {
            
            completionHandler(result: nil, error: error)
            
        } else {
            
            if let results = JSONResult.valueForKey(Client.JSONResponseKeys.Results) as? [[String : AnyObject]] {
                
                var studentsResults = StudentInformation.studnetsFromResults(results)
                
                completionHandler(result: studentsResults, error: nil)
                
            } else {
                
                let dataerror = NSError(domain: "OnTheMap DataError", code: 20, userInfo: [NSLocalizedDescriptionKey : "Internal Error getting locations. Please try again later."])
                completionHandler(result: nil, error: dataerror)
            }
        }
    }
    
    return task
    
   }
    
    // Search User data based on first name or last name or location or unique key (GET request)
    
    func searchLocations(search: [String:String],  completionHandler: (result: [StudentInformation]?, error: NSError?) -> Void) -> NSURLSessionDataTask? {
        
        /* Specify parameters */
        
        var jsonifyError:NSError? = nil
        
        let data = NSJSONSerialization.dataWithJSONObject(search, options: nil, error: &jsonifyError)
        
        var parameters:[String:AnyObject] = [ "where" : NSString(data: data!, encoding: NSUTF8StringEncoding)! ]
        
        let headerParameters = ["X-Parse-Application-Id" : Client.Constants.ParseAppId , "X-Parse-REST-API-Key" : Client.Constants.ParseAPIKey]

         /* Make the request */
        
        let task = taskForGETMethod(Client.Methods.getLocations, parameters: parameters,headerParameters:headerParameters) { JSONResult, error in
            
            /* Send the desired value(s) to completion handler */
            
            if let error = error {
                
                completionHandler(result: nil, error: error)
                
            } else {
                
                if let results = JSONResult.valueForKey(Client.JSONResponseKeys.Results) as? [[String : AnyObject]] {
                    
                    var studentsResults = StudentInformation.studnetsFromResults(results)
                    
                    completionHandler(result: studentsResults, error: nil)
                } else {
                    let dataerror = NSError(domain: "OnTheMap DataError", code: 20, userInfo: [NSLocalizedDescriptionKey : "Internal Error searching data. Please try again later."])
                    completionHandler(result: nil, error: dataerror)
                }
            }
        }
        
        return task
        
    }
    
    // Post student information (POST request)
    
    func postStudentInformation(studentInfo: StudentInformation, completionHandler: (success: Bool, error: NSError?) -> Void) ->  Void {
        
        /* Specify parameters , json body for post request*/
        
        let headerParameters = ["X-Parse-Application-Id" : Client.Constants.ParseAppId , "X-Parse-REST-API-Key" : Client.Constants.ParseAPIKey, "Content-Type" : "application/json"]
        

        var jsonBody: [String:AnyObject] = [JSONResponseKeys.UniqueKey : studentInfo.uniqueKey!,
                        JSONResponseKeys.FirstName : studentInfo.firstName!,
                        JSONResponseKeys.LastName : studentInfo.lastName!,
                        JSONResponseKeys.MapString : studentInfo.mapString!,
                        JSONResponseKeys.MediaURL : studentInfo.mediaURL!,
                        JSONResponseKeys.Latitude : studentInfo.coordinate!.latitude as Double,
                        JSONResponseKeys.Longitude : studentInfo.coordinate!.longitude as Double]
        
         /* Make the request */
        
        let task = taskForPOSTMethod(Client.Methods.getLocations, jsonBody: jsonBody, headerParameters:headerParameters) { JSONResult, error in
            
            /* Send the desired value(s) to completion handler */
            
            if let error = error {
                
                completionHandler(success: false, error: error)
                
            } else {
                 let studentobjectId: String? = JSONResult[JSONResponseKeys.ObjectId] as? String
                
                if studentobjectId != nil {
                    completionHandler(success: true, error: nil)
                } else {
                    
                    let dataerror = NSError(domain: "OnTheMap DataError", code: 20, userInfo: [NSLocalizedDescriptionKey : "Internal Error submitting data. Please try again later."])
                    completionHandler(success: false, error: dataerror )
                }
            }
        }
        
    }
    
    // Update existing student information (PUT request)
    
    func updateStudentInformation(studentInfo: StudentInformation, completionHandler: (success: Bool, error: NSError?) -> Void) -> Void {
    
        /* Specify parameters , json body for post request, and method */
        
        var mutableMethod : String = Client.Methods.getLocations + Methods.updateStudentData
        
        mutableMethod = Client.subtituteKeyInMethod(mutableMethod, key: Client.JSONResponseKeys.ObjectId, value: String(studentInfo.objectId!))!
        let headerParameters = ["X-Parse-Application-Id" : Client.Constants.ParseAppId , "X-Parse-REST-API-Key" : Client.Constants.ParseAPIKey, "Content-Type" : "application/json"]
        
        var jsonBody: [String:AnyObject] = [JSONResponseKeys.UniqueKey : studentInfo.uniqueKey!,
            JSONResponseKeys.FirstName : studentInfo.firstName!,
            JSONResponseKeys.LastName : studentInfo.lastName!,
            JSONResponseKeys.MapString : studentInfo.mapString!,
            JSONResponseKeys.MediaURL : studentInfo.mediaURL!,
            JSONResponseKeys.Latitude : studentInfo.coordinate!.latitude as Double,
            JSONResponseKeys.Longitude : studentInfo.coordinate!.longitude as Double]
        
         /* Make the request */
        
        let task = taskForPUTMethod(mutableMethod, jsonBody: jsonBody, headerParameters:headerParameters) { JSONResult, error in
           
             /* Send the desired value(s) to completion handler */
            
            if let error = error {
                completionHandler(success: false, error: error)
                
            } else {
                
                let dateUpdated: String? = JSONResult[JSONResponseKeys.UpdatedDate] as? String
                
                if dateUpdated != nil {
                    completionHandler(success: true, error: nil)
                } else {
                    let dataerror = NSError(domain: "OnTheMap DataError", code: 20, userInfo: [NSLocalizedDescriptionKey : "Internal Error updating data. Please try again later."])
                    completionHandler(success: false, error: dataerror )
                }
            }
        }

    }
    
}