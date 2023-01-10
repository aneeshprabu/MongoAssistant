//
//  chatGPTResponse.swift
//  MongoGPT3Demo
//
//  Created by Aneesh Prabu on 1/5/23.
//
import Alamofire
import SwiftUI

struct Message {

    let text: String
    let isResponse: Bool
    let id = UUID()
}

func chatGPTResponse(for message: String, completion: @escaping (String) -> Void) {
    
    let chatGPTApiUri = "https://{AzureURI}/api/v1/openai"
    
    let query = message
    let parameters: Parameters = [
        "query" : query
    ]
    
    AF.request(chatGPTApiUri, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).validate(statusCode: 200 ..< 600).responseString { response in
        switch response.result {
        case .success(let data):
            print(data)
            let statusCode = response.response?.statusCode
            if statusCode == 200 {
                print(data)
                completion(data)
            }
        case .failure(let error):
            print(error)
            completion("Error getting response")
        }
    }
}
