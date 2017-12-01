//
//  MyObject.swift
//  ARKitClient
//
//  Created by NelliStudio on 26/10/2017.
//  Copyright © 2017 Apple. All rights reserved.
//

import Foundation

struct MyObject : Codable {
    
    let id: Int?
    let image: String?
    let indexeObject: Int?
    let positionX: Float?
    let positionY: Float?
    let positionZ: Float?
    let x1: Float?
    let y1: Float?
    let z1: Float?
    let w1: Float?
    let x2: Float?
    let y2: Float?
    let z2: Float?
    let w2: Float?
    let x3: Float?
    let y3: Float?
    let z3: Float?
    let w3: Float?
    let x4: Float?
    let y4: Float?
    let z4: Float?
    let w4: Float?
    
    private enum CodingKeys : String, CodingKey {
        case id, image, indexeObject, positionX, positionY, positionZ, x1, y1, z1, w1, x2, y2, z2, w2, x3, y3, z3, w3, x4, y4, z4, w4
    }
}
