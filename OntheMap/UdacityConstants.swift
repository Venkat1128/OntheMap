//
//  UdacityConstants.swift
//  OntheMap
//
//  Created by Venkat Kurapati on 14/12/2016.
//  Copyright © 2016 Kurapati. All rights reserved.
//

import Foundation
import UIKit

extension UdacityClient{
    //MARK:- Constans
    struct UdacityConstans {
        //MARK:- Udacity
        struct Udacity {
            static let ApiScheme = "https"
            static let ApiHost = "www.udacity.com"
            static let ApiPath = "/api/"
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
    // MARK: UI
    struct UI {
        static let LoginColorTop = UIColor(red: 0.345, green: 0.839, blue: 0.988, alpha: 1.0)
        static let LoginColorBottom = UIColor(red: 0.023, green: 0.569, blue: 0.910, alpha: 1.0)
        static let GreyColor = UIColor(red: 0.702, green: 0.863, blue: 0.929, alpha:1.0)
        static let BlueColor = UIColor(red: 0.0, green:0.502, blue:0.839, alpha: 1.0)
    }
}
