//
//  User.swift
//  ARKitClient
//
//  Created by NelliStudio on 18/10/2017.
//  Copyright © 2017 Apple. All rights reserved.
//

import Foundation

struct User : Codable {
    
    let id: Int?
    let firstName: String?
    let name: String?
    let phone: String?
    let address: String?
    let userName: String?
    let email: String?
    let password: String?
    
    private enum CodingKeys : String, CodingKey {
        case id, firstName, name, phone, address, userName, email, password
    }
}
