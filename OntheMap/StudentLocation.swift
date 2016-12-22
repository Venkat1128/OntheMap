//
//  StudentLocation.swift
//  OntheMap
//
//  Created by Venkat Kurapati on 17/12/2016.
//  Copyright © 2016 Kurapati. All rights reserved.
//

import Foundation
//MARK:- StudentLocation
struct StudentLocation {
    
    var objectId: String?
    var uniqueKey: String?
    var firstName: String?
    var lastName: String?
    var mapString: String?
    var mediaURL: String?
    var latitude: Double?
    var longitude: Double?
    var createdAt: String?
    var updatedAt: String?
    
    // MARK: Initializers
    
    // construct a StudentLocation from a dictionary
    init(dictionary: [String:AnyObject]) {
        objectId = dictionary[StudentLocationClient.JSONResponseKeys.ObjectId] as? String
        uniqueKey = dictionary[StudentLocationClient.JSONBodyKeys.UniqueKey] as? String
        firstName = dictionary[StudentLocationClient.JSONBodyKeys.FirstName] as? String
        lastName = dictionary[StudentLocationClient.JSONBodyKeys.LastName] as? String
        mapString = dictionary[StudentLocationClient.JSONBodyKeys.MapString] as? String
        mediaURL = dictionary[StudentLocationClient.JSONBodyKeys.MediaURL] as? String
        latitude = dictionary[StudentLocationClient.JSONBodyKeys.Latitude] as? Double
        longitude = dictionary[StudentLocationClient.JSONBodyKeys.Longitude] as? Double
        createdAt = dictionary[StudentLocationClient.JSONResponseKeys.CreatedAt] as? String
        updatedAt = dictionary[StudentLocationClient.JSONResponseKeys.UpdatedAt] as? String
    }
    
    static func studentLocationsFromResults(_ results: [[String:AnyObject]]) -> [StudentLocation] {
        
        var studentLocations = [StudentLocation]()
        
        // iterate through array of dictionaries, each student location is a dictionary
        for result in results {
            let studentLocation = StudentLocation(dictionary: result)
            if studentLocation.firstName != nil &&  studentLocation.lastName != nil && studentLocation.mediaURL != nil && studentLocation.latitude != 0 && studentLocation.longitude != 0{
                studentLocations.append(studentLocation)
            }
            
        }
        
        return studentLocations
    }

}
// MARK: - StudentLocation: Equatable

extension StudentLocation: Equatable {}

func ==(lhs: StudentLocation, rhs: StudentLocation) -> Bool {
    return lhs.uniqueKey == rhs.uniqueKey
}
class StudentLocations : NSObject {
    
     var studentLocations: [StudentLocation] = [StudentLocation]()
    // MARK: Initializers
    
    override init() {
        super.init()
    }
    // MARK: Shared Instance
    
    class func sharedInstance() -> StudentLocations {
        struct Singleton {
            static var sharedInstance = StudentLocations()
        }
        return Singleton.sharedInstance
    }
}
