//
//  StudentLocationConvenience.swift
//  OntheMap
//
//  Created by Venkat Kurapati on 17/12/2016.
//  Copyright © 2016 Kurapati. All rights reserved.
//

import Foundation
import UIKit

// MARK: - StudentLocationClient (Convenient Resource Methods)
extension StudentLocationClient{
    
    // MARK: GET Convenience Methods
    
    func getStudentLocations(_ completionHandlerForStudentLocations: @escaping (_ result: [StudentLocation]?, _ error: NSError?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = [String:AnyObject]()
        let mutableMethod: String = Methods.StudentLocation
        
        /* 2. Make the request */
        let _ = taskForGETMethod(mutableMethod, parameters: parameters as [String:AnyObject]) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForStudentLocations(nil, error)
            } else {
                
                if let results = results?[StudentLocationClient.JSONResponseKeys.StudentLocationsResults] as? [[String:AnyObject]] {
                    
                    let studentLocations = StudentLocation.moviesFromResults(results)
                    completionHandlerForStudentLocations(studentLocations, nil)
                } else {
                    completionHandlerForStudentLocations(nil, NSError(domain: "getStudentLocations parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getStudentLocations"]))
                }
            }
        }
    }
    
    // MARK: POST Convenience Methods
    
    func postToStudentLocation(_ movie: StudentLocation, favorite: Bool, completionHandlerForFavorite: @escaping (_ result: Int?, _ error: NSError?) -> Void) {
        
    }
}
