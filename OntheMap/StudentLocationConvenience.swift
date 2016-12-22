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
    
    func postToStudentLocation(_ studentLocation: StudentLocation, completionHandlerForStudentLocation: @escaping (_ result: String?, _ error: NSError?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = [String:AnyObject]()
        let mutableMethod: String = Methods.StudentLocation
       
        let _ = taskForPOSTMethod(mutableMethod, parameters: parameters as [String:AnyObject], jsonBody: getJSONBodyForStudentLocation(studentLocation)) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForStudentLocation(nil, error)
            } else {
                if let results = results?[StudentLocationClient.JSONResponseKeys.ObjectId] as? String {
                    completionHandlerForStudentLocation(results, nil)
                } else {
                    completionHandlerForStudentLocation(nil, NSError(domain: "postToStudentLocation parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse postToStudentLocation"]))
                }
            }
        }
    }
    
    func updateToStudentLocation(_ studentLocation: StudentLocation, completionHandlerForStudentLocation: @escaping (_ result: String?, _ error: NSError?) -> Void) {
        let appDelegate: AppDelegate! = UIApplication.shared.delegate as! AppDelegate!
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = [String:AnyObject]()//[JSONResponseKeys.ObjectId : appDelegate.udacityUserObjectId!]
        let mutableMethod: String = Methods.StudentLocation + "/" + appDelegate.udacityUserObjectId!
        
        /* 2. Make the request */
        let _ = taskForPUTMethod(mutableMethod, parameters: parameters as [String:AnyObject], jsonBody: getJSONBodyForStudentLocation(studentLocation)) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForStudentLocation(nil, error)
            } else {
                if let results = results?[StudentLocationClient.JSONResponseKeys.UpdatedAt] as? String {
                    completionHandlerForStudentLocation(results, nil)
                } else {
                    completionHandlerForStudentLocation(nil, NSError(domain: "updateToStudentLocation parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse updateToStudentLocation"]))
                }
            }
        }
    }
    
    func getJSONBodyForStudentLocation(_ studentLocation: StudentLocation) -> String {
        let appDelegate: AppDelegate! = UIApplication.shared.delegate as! AppDelegate!
          let jsonBody = "{\"\(StudentLocationClient.JSONBodyKeys.UniqueKey)\": \"\(appDelegate.udacityUserId!)\", \"\(StudentLocationClient.JSONBodyKeys.FirstName)\": \"\(studentLocation.firstName!)\", \"\(StudentLocationClient.JSONBodyKeys.LastName)\": \"\(studentLocation.lastName!)\",\"\(StudentLocationClient.JSONBodyKeys.MapString)\": \"\(studentLocation.mapString!)\", \"\(StudentLocationClient.JSONBodyKeys.MediaURL)\": \"\(studentLocation.mediaURL!)\",\"\(StudentLocationClient.JSONBodyKeys.Latitude)\": \(studentLocation.latitude!), \"\(StudentLocationClient.JSONBodyKeys.Longitude)\": \(studentLocation.longitude!)}"
        return jsonBody
    }
    
}
