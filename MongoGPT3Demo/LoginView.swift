//
//  ContentView.swift
//  MongoGPT3Demo
//
//  Created by Aneesh Prabu on 12/7/22.
//

import SwiftUI
import OpenAISwift

struct LoginView: View {
    
    var body: some View {
        NavigationView {
            MongoLoginView().navigationTitle("Login")
        }
    }
}

struct MongoLoginView: View {
    
    
    @State private var mongoURI: String = String()
    @State private var login: Bool = false
    let key = "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"
    
    func mongoAPI(key: String, uri: String) {
        let openAPI = OpenAISwift(authToken: key)
        let query = "generate a mongodb query to find all coins greater than 10 in collection test "
        
        openAPI.sendCompletion(with: query, model: .gpt3(.davinci)) { result in
            print("----Running model----")
            switch result {
            case .success(let success):
//                        print(success.choices)
                for choices in success.choices {
                    dump(choices.text)
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    var body: some View {
        VStack {
            
            //MARK: - Image
            Image("gpt3").resizable().aspectRatio(contentMode: .fit).padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/).frame(width: /*@START_MENU_TOKEN@*/250.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/250.0/*@END_MENU_TOKEN@*/)
            Spacer()
            
            //MARK: - URI and Textfield
            VStack(spacing:-10) {
                Text("URI").bold().multilineTextAlignment(.leading).padding(.trailing, 270.0)
                TextField("mongodb://localhost:27017", text: $mongoURI)
                                        .padding()
                                        .overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder(Color("TextColor"), style: StrokeStyle(lineWidth: 1.0)))
                                        .padding()
            }
            
            Spacer()
            
            //MARK: - Button to connect
            Button(action: {
//                mongoAPI(key: key, uri: mongoURI)
                login = false
            }) {
                
                NavigationLink {
//                    ContentView().navigationBarBackButtonHidden(true)
                } label: {
                    Text("Connect")
                        .frame(minWidth: 0, maxWidth: 150)
                        .font(.system(size: 18))
                        .padding()
                        .foregroundColor(Color("TextColor"))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color("MongoGreen"), lineWidth: 3)
                    )
                }
            }
            .background(Color.white)
            .cornerRadius(9)
            
            Spacer()
        }
        .padding()
    }
}


struct MongoLoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
