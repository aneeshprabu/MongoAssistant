//
//  Collection.swift
//  MongoGPT3Demo
//
//  Created by Aneesh Prabu on 1/3/23.
//

import SwiftUI

struct Collection: Codable, Hashable {
    var collection: String
    var tag: Int
}

var collectionItems = [
    Collection(collection: "Marketting", tag: 1),
    Collection(collection: "Test", tag: 2),
    Collection(collection: "Sales", tag: 3)
]
    
