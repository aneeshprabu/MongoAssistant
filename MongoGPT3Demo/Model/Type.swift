//
//  Type.swift
//  MongoGPT3Demo
//
//  Created by Aneesh Prabu on 1/5/23.
//

import SwiftUI

enum QueryType {
    case crud, aggregation
}

struct Type: Hashable {
    var type: String
    var tag: Int
    var queryType: QueryType
}

var typeItems = [
    Type(type: "CRUD", tag: 1, queryType: .crud),
    Type(type: "Aggregation", tag: 2, queryType: .aggregation)
]
