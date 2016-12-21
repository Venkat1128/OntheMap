//
//  UdacityUserProfile.swift
//  OntheMap
//
//  Created by Venkat Kurapati on 21/12/2016.
//  Copyright © 2016 Kurapati. All rights reserved.
//

import Foundation

struct User {
    let  first_name: String?
    let  last_name: String?
    
    init(firstName: String, lastName: String) {
        self.first_name = firstName
        self.last_name = lastName
    }
}

