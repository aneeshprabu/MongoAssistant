//
//  Collection.swift
//  MongoGPT3Demo
//
//  Created by Aneesh Prabu on 1/3/23.
//

import SwiftUI

struct DB: Codable, Hashable {
    var tag: Int
    var database: String
}

var dbItems = [
    DB(tag: 1, database: "Development"),
    DB(tag: 2, database: "Production"),
    DB(tag: 3, database: "Pre-prod")
]
    
