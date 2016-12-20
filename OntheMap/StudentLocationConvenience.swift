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
                    
                    let studentLocations = StudentLocation.studentLocationsFromResults(results)
                    completionHandlerForStudentLocations(studentLocations, nil)
                } else {
                    completionHandlerForStudentLocations(nil, NSError(domain: "getStudentLocations parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getStudentLocations"]))
                }
            }
        }
    }
    
    // MARK: POST Convenience Methods
    
    func postToStudentLocation(_ studentLocation: StudentLocation, completionHandlerForStudentLocation: @escaping (_ result: Int?, _ error: NSError?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = [String:AnyObject]()
        let mutableMethod: String = Methods.StudentLocation
        let appDelegate: AppDelegate! = UIApplication.shared.delegate as! AppDelegate!
        
        let jsonBody = "{\"\(StudentLocationClient.JSONBodyKeys.UniqueKey)\": \"\(appDelegate.udacityUserId!)\", \"firstName\": \"\(studentLocation.firstName!)\", \"lastName\": \"\(studentLocation.lastName!)\",\"mapString\": \"\(studentLocation.mapString!)\", \"mediaURL\": \"\(studentLocation.mediaURL!)\",\"latitude\": \(studentLocation.latitude!), \"longitude\": \(studentLocation.longitude!)}"
        /* 2. Make the request */
        let _ = taskForPOSTMethod(mutableMethod, parameters: parameters as [String:AnyObject], jsonBody: jsonBody) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForStudentLocation(nil, error)
            } else {
                if let results = results?[StudentLocationClient.JSONResponseKeys.ObjectId] as? Int {
                    completionHandlerForStudentLocation(results, nil)
                } else {
                    completionHandlerForStudentLocation(nil, NSError(domain: "postToStudentLocation parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse postToStudentLocation"]))
                }
            }
        }
    }
}
