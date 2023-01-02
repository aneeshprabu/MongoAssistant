//
//  ChatGPTData.swift
//  MongoGPT3Demo
//
//  Created by Aneesh Prabu on 12/30/22.
//

import SwiftUI

struct ChatGPT: Codable {
    var data: String
}

class Api {
    func getChatGPT() {
        // API get call to ChatGPT
        guard let url = URL(string: "") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            let chatGPT = try! JSONDecoder().decode([ChatGPT].self, from: data!)
            print(chatGPT)
        }
        .resume()
    }
}
