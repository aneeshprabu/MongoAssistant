//
//  ContentView.swift
//  MongoGPT3Demo
//
//  Created by Aneesh Prabu on 12/7/22.
//

import SwiftUI

struct ContentView: View {
    
    @State private var mongoURI: String = String()
    
    var body: some View {
        VStack {
            
            Image("gpt3").resizable().aspectRatio(contentMode: .fit).padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/).frame(width: /*@START_MENU_TOKEN@*/250.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/250.0/*@END_MENU_TOKEN@*/)
            Spacer()
            VStack(spacing:-10) {
                Text("URI").bold().multilineTextAlignment(.leading).padding(.trailing, 270.0)
                TextField("mongodb://localhost:27017", text: $mongoURI)
                                        .padding()
                                        .overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder(Color("TextColor"), style: StrokeStyle(lineWidth: 1.0)))
                                        .padding()
            }
            
            Spacer()
            Button(action: {
                print("sign up bin tapped")
            }) {
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
            .background(Color.white)
            .cornerRadius(9)
            Spacer()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
