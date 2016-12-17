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
    
    let objectId: String?
    let uniqueKey: String?
    let firstName: String?
    let lastName: String?
    let mapString: String?
    let mediaURL: String?
    let latitude: Double?
    let longitude: Double?
    let createdAt: String?
    let updatedAt: String?
    
    // MARK: Initializers
    
    // construct a TMDBMovie from a dictionary
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
    
    static func moviesFromResults(_ results: [[String:AnyObject]]) -> [StudentLocation] {
        
        var movies = [StudentLocation]()
        
        // iterate through array of dictionaries, each Movie is a dictionary
        for result in results {
            movies.append(StudentLocation(dictionary: result))
        }
        
        return movies
    }
}
// MARK: - StudentLocation: Equatable

extension StudentLocation: Equatable {}

func ==(lhs: StudentLocation, rhs: StudentLocation) -> Bool {
    return lhs.uniqueKey == rhs.uniqueKey
}
