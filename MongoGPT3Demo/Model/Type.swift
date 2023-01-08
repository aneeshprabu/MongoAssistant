//
//  Type.swift
//  MongoGPT3Demo
//
//  Created by Aneesh Prabu on 1/5/23.
//

import SwiftUI

struct Type: Hashable {
    var type: String
    var tag: Int
}

var typeItems = [
    Type(type: "CRUD", tag: 1),
    Type(type: "Aggregation", tag: 2)
]
