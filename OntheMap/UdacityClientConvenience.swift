//
//  UdacityClientConvenience.swift
//  OntheMap
//
//  Created by Venkat Kurapati on 21/12/2016.
//  Copyright © 2016 Kurapati. All rights reserved.
//

import Foundation
import UIKit

extension UdacityClient{
    
    // MARK: DELETE  Convenience Methods
    
    func deleteUdacitySession(_ completionHandlerForDeleteUdacitySession: @escaping (_ result: String?, _ error: NSError?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = [String:AnyObject]()
        let mutableMethod: String = UdacityConstans.UdacityResponseKeys.Session
        
        /* 2. Make the request */
        let _ = taskForDeleteMethod(mutableMethod, parameters: parameters as [String:AnyObject]) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForDeleteUdacitySession(nil, error)
            } else {
                
                if let results = results?[UdacityConstans.UdacityResponseKeys.Session] as? [String:AnyObject] {
                    let sesssionId = results[UdacityClient.UdacityConstans.UdacityResponseKeys.Id] as? String
                    completionHandlerForDeleteUdacitySession(sesssionId, nil)
                } else {
                    completionHandlerForDeleteUdacitySession(nil, NSError(domain: "getStudentLocations parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getStudentLocations"]))
                }
            }
        }
    }

    // MARK: GET Convenience Methods
    
    func getPublicUserData(_ completionHandlerForPublicUserData: @escaping (_ result: User?, _ error: NSError?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let appDelegate: AppDelegate! = UIApplication.shared.delegate as! AppDelegate!
        let parameters = [String:AnyObject]()
        let mutableMethod: String = UdacityConstans.Methods.Users + "/" + appDelegate.udacityUserId!
        
        /* 2. Make the request */
        let _ = taskForGETMethod(mutableMethod, parameters: parameters as [String:AnyObject]) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForPublicUserData(nil, error)
            } else {
                
                if let results = results?[UdacityConstans.UdacityResponseKeys.User] as? [String:AnyObject] {
                    
                    let user: User = User.init(firstName: results[UdacityConstans.UdacityResponseKeys.FirstName] as! String, lastName: results[UdacityConstans.UdacityResponseKeys.LastName] as! String)
                    completionHandlerForPublicUserData(user, nil)
                } else {
                    completionHandlerForPublicUserData(nil, NSError(domain: "getPublicUserData parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getPublicUserData"]))
                }
            }
        }
    }

    
}
