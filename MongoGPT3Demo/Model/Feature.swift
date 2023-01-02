//
//  Course.swift
//  AnimatedApp
//
//  Created by Meng To on 2022-04-14.
//

import SwiftUI

struct Feature: Identifiable {
    var id = UUID()
    var title: String
    var subtitle: String
    var caption: String
    var color: Color
    var image: Image
}

var features = [
    Feature(title: "Ask Mongo Query", subtitle: "Ask ChatGPT to query your database", caption: "Execution - True", color: Color(hex: "3FA037"), image: Image("Topic 2")),
    Feature(title: "Ask Mongo Schemas", subtitle: "Ask ChatGPT to create and suggest modals for your organization", caption: "Execution - False", color: Color(hex: "6792FF"), image: Image("Topic 2")),
    Feature(title: "Ask Mongo Aggregation - ⍺ (TEST)", subtitle: "Ask ChatGPT to create aggregation pipelines", caption: "Execution - false", color: Color(hex: "005FE7"), image: Image("Topic 1"))
]
