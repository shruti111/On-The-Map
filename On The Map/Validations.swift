//
//  Validations.swift
//  On The Map
//
//  Created by Shruti Pawar on 16/05/15.
//  Copyright (c) 2015 ShapeMyApp Software Solutions Pvt. Ltd. All rights reserved.
//

import Foundation

class Validations {
   

    class func validateURL (stringURL : String) -> Bool {
        
        var regex = "https?:\\/\\/(www\\.)?[-a-zA-Z0-9@:%._\\+~#=]{2,256}\\.[a-z]{2,4}\\b([-a-zA-Z0-9@:%_\\+.~#?&//=]*)"
         var error: NSError?
        let expression = NSRegularExpression(pattern: regex, options: NSRegularExpressionOptions.CaseInsensitive, error: &error)!
        
        let result = expression.matchesInString(stringURL , options: nil, range: NSMakeRange(0,count(stringURL)))
        return result.count > 0
    }
}

