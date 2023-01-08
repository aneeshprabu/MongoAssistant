//
//  Course.swift
//  AnimatedApp
//
//  Created by Meng To on 2022-04-14.
//

import SwiftUI

struct Feature: Identifiable {
    var id = UUID()
    var tag : Int
    var title: String
    var subtitle: String
    var caption: String
    var color: Color
    var image: Image
}

var features = [
    Feature(tag: 1, title: "Ask Mongo Querys", subtitle: "Ask ChatGPT to query your database", caption: "Execution - True", color: Color(hex: "3FA037"), image: Image("Topic 2")),
    Feature(tag: 2, title: "More about Mongo", subtitle: "Ask about schemas, security and much more...", caption: "Execution - False", color: Color(hex: "6792FF"), image: Image("Topic 2")),
    Feature(tag: 3, title: "Convert MQL to JSON", subtitle: "Convert your NLP to MQL and directly to JSON", caption: "Execution - false", color: Color(hex: "005FE7"), image: Image("Topic 1"))
]
