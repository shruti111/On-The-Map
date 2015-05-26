//
//  Client.swift
//  On The Map
//
//  Created by Shruti Pawar on 15/05/15.
//  Copyright (c) 2015 ShapeMyApp Software Solutions Pvt. Ltd. All rights reserved.
//

import Foundation

class Client : NSObject {
    
    /* Shared session */
    var session: NSURLSession
    
    /* Authentication state */
    var sessionID : String? = nil
    var userID : String? = nil
    
    /* Logged in user inforamtion */
    var userInformation: UdacityUser?
    var studentLocations: [StudentInformation]?
    
    var clientType: ClientType = ClientType.UdacityClient
    
    override init() {
        session = NSURLSession.sharedSession()
        studentLocations = [StudentInformation]()
        super.init()
    }
    
    // MARK: - GET
    
    func taskForGETMethod(method: String, parameters: [String : AnyObject]? = nil, headerParameters: [String:String]? = nil, completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        //Build the URL and configure the request 
        
        var baseMethod = ""
        
        switch clientType {
        case .UdacityClient :
             baseMethod = Constants.BaseURL
        case .ParseClient:
             baseMethod = Constants.ParseURL
        }
        
        var urlString = baseMethod + method
        
        // Add parameters
        
        urlString = parameters != nil ? urlString + Client.escapedParameters(parameters!) : urlString

        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        
        if let headerInfo = headerParameters {
            Client.createRequestHeaders(request, headerInfo: headerInfo)
        }
        
        // Make the request
        
        let task = session.dataTaskWithRequest(request) {data, response, downloadError in
            
            // Set up the error (if any)
            
            if let error = downloadError {
                let newError = Client.errorForNetworkConnection(error)
                completionHandler(result: nil, error: newError)
                
            } else {
                // Parse data
                Client.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
            }
        }
        
        // Start request
        task.resume()
        
        return task
    }
    
    // MARK: - POST
    
    func taskForPOSTMethod(method: String, parameters: [String : AnyObject]? = nil, jsonBody: [String:AnyObject],headerParameters: [String:String] , completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        //Build the URL and configure the request
        
        var baseMethod = ""
        
        switch clientType {
        case .UdacityClient :
            baseMethod = Constants.BaseURL
        case .ParseClient:
            baseMethod = Constants.ParseURL
        }
        
        var urlString = baseMethod + method
        
        
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        var jsonifyError: NSError? = nil
        request.HTTPMethod = "POST"
        
        // Add headres
        Client.createRequestHeaders(request, headerInfo: headerParameters)
        
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(jsonBody, options: nil, error: &jsonifyError)
        
        // Make the request
        let task = session.dataTaskWithRequest(request) {data, response, downloadError in
            
            //Set up the error
            
            if let error = downloadError {
                let newError = Client.errorForNetworkConnection(error)
                completionHandler(result: nil, error: newError)
            } else {
                
                // Parse data
                Client.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
            }
        }
        
        // Start the request
        task.resume()
        
        return task
    }
    
    // MARK: - PUT
    
    func taskForPUTMethod(method: String, parameters: [String : AnyObject]? = nil, jsonBody: [String:AnyObject],headerParameters: [String:String] , completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        //Build the URL and configure the request
        
        var baseMethod = ""
        
        switch clientType {
        case .UdacityClient :
            baseMethod = Constants.BaseURL
        case .ParseClient:
            baseMethod = Constants.ParseURL
        }
        
        var urlString = baseMethod + method
        
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        var jsonifyError: NSError? = nil
        request.HTTPMethod = "PUT"
        
        // Add headers
        
        Client.createRequestHeaders(request, headerInfo: headerParameters)

        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(jsonBody, options: nil, error: &jsonifyError)
        
        // Make the request
        let task = session.dataTaskWithRequest(request) {data, response, downloadError in
            
           // Set up the error
            
            if let error = downloadError {
                let newError = Client.errorForNetworkConnection(error)
                completionHandler(result: nil, error: newError)
            } else {
                
                // Parse the data
                Client.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
            }
        }
        
        // Start the request
        task.resume()
        
        return task
    }
 
    /* Helper: method to return Network error */
    
    class func errorForNetworkConnection(error:NSError) -> NSError {
        
         let userInfo = [NSLocalizedDescriptionKey : error.localizedDescription]
        // Set the domain and code for the errro
        return  NSError(domain: "OnTheMap NetworkError", code: 10, userInfo: userInfo)
    }
    
    /* Helper: Given raw JSON, return a usable Foundation object */
    
    class func parseJSONWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        
        var newData: NSData = data
        
        // For Udacity, trim the first 5 characters
        
        if Client.sharedInstance().clientType == ClientType.UdacityClient {
             newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
        }
        
        var parsingError: NSError? = nil
        
        let parsedResult: AnyObject? = NSJSONSerialization.JSONObjectWithData(newData, options: NSJSONReadingOptions.AllowFragments, error: &parsingError)
        
        if let error = parsingError {
            
            // Set up the domain and code for the error
            let userInfo = [NSLocalizedDescriptionKey : "Internal Error getting data. Please try again later."]
            let newError = NSError(domain: "OnTheMap ParsingError", code: 30, userInfo: userInfo)
        
            completionHandler(result: nil, error: error)
            } else {
            completionHandler(result: parsedResult, error: nil)
        }
    }
    
    //MARK:- Helper Methods
    
    /* Helper: Substitute the key for the value that is contained within the method name */
    
    class func subtituteKeyInMethod(method: String, key: String, value: String) -> String? {
        if method.rangeOfString("{\(key)}") != nil {
            return method.stringByReplacingOccurrencesOfString("{\(key)}", withString: value)
        } else {
            return nil
        }
    }
    
    /* Helper: Set the request headers for request */
    
    class func createRequestHeaders(request: NSMutableURLRequest, headerInfo:[String:String]) {
        for (key,value) in headerInfo {
            
            request.addValue(value, forHTTPHeaderField: key)
        }
    }
    
    /* Helper function: Given a dictionary of parameters, convert to a string for a url */
    class func escapedParameters(parameters: [String : AnyObject]) -> String {
        
        var urlVars = [String]()
        
        for (key, value) in parameters {
            
            /* Make sure that it is a string value */
            let stringValue = "\(value)"
            
            /* Escape it */
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            
            /* Append it */
            urlVars += [key + "=" + "\(escapedValue!)"]
            
        }
        
        return (!urlVars.isEmpty ? "?" : "") + join("&", urlVars)
    }
    
    // MARK: - Shared Instance
    
    class func sharedInstance() -> Client {
        
        struct Singleton {
            static var sharedInstance = Client()
        }
        
        return Singleton.sharedInstance
    }

}