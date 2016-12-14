//
//  UdacityConstants.swift
//  OntheMap
//
//  Created by Venkat Kurapati on 14/12/2016.
//  Copyright © 2016 Kurapati. All rights reserved.
//

import Foundation
//MARK:- Constans
struct UdacityConstans {
    //MARK:- Udacity
    struct Udacity {
        static let ApiScheme = "https"
        static let ApiHost = "www.udacity.com"
        static let ApiPath = "/api/session"
    }
    //MARK:- Udacity Parameter Keys
    struct UdacityParameterKeys {
        static let Username = "username"
        static let Password = "password"
    }
    //MARK:- Udacity Response Keys
    struct UdacityResponseKeys {
        static let Session = "session"
        static let Id = "id"
    }
}
