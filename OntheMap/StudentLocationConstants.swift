//
//  StudentLocationConstants.swift
//  OntheMap
//
//  Created by Venkat Kurapati on 17/12/2016.
//  Copyright © 2016 Kurapati. All rights reserved.
//

import Foundation

extension StudentLocationClient{
    // MARK: Constants
    struct Constants {
        
        // MARK: API Key
        static let ParseApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let RestApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        
        // MARK: URLs
        static let ApiScheme = "https"
        static let ApiHost = "parse.udacity.com/parse/classes"
        static let ApiPath = "/StudentLocation"
    }
    
    // MARK: Methods
    struct Methods {
        //MARL:- HTTP Method
        static let POST = "POST"
        static let GET = "GET"
        static let PUT = "PUT"
        // MARK: Student Location
        static let MultipleLocarions = "/limit"
        static let SingleLocation = "/uniqueKey"
        static let UpdateLocation = "/<objectId>"
        
    }
    
    // MARK: URL Keys
    struct URLKeys {
        static let UserID = "id"
    }
    
    // MARK: Parameter Keys
    struct ParameterKeys {
        static let ParseApplicationId = "X-Parse-Application-Id"
        static let ParseRESTAPIKey = "X-Parse-REST-API-Key"
        static let Limit = "limit"
    }
    
    // MARK: JSON Body Keys
    struct JSONBodyKeys {
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        
        // MARK: General
        static let StatusMessage = "status_message"
        static let StatusCode = "status_code"
    }
}
