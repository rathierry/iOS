//
//  ClassUser.swift
//  ARKitClient
//
//  Created by NelliStudio on 25/10/2017.
//  Copyright © 2017 Apple. All rights reserved.
//

import Foundation

class UserCL {
    var id : Int
    var firstName : String
    var name : String
    var phone : String
    var address : String
    var userName : String
    var email : String
    var password : String
    
    init(id : Int, firstName : String, name : String, phone : String, address : String, userName : String, email : String, password : String) {
        self.id = id
        self.firstName = firstName
        self.name = name
        self.phone = phone
        self.address = address
        self.userName = userName
        self.email = email
        self.password = password
    }
}
