//
//  onBoardingView.swift
//  MongoGPT3Demo
//
//  Created by Aneesh Prabu on 12/25/22.
//

import SwiftUI
import RiveRuntime

struct onBoardingView: View {
    
    let button = RiveViewModel(fileName: "button")
    
    var body: some View {
        ZStack {
            background
            
            VStack(alignment: .leading, spacing: 16) {
                
                Text("Your MongoDB Assistant")
                    .font(.custom("Poppins Bold", size: 60, relativeTo: .largeTitle))
                    .frame(width: 300, alignment: .leading)
                
                Text("Hi, I'll be your MongoDB Personal Assistant. Please ask any questions you have regarding queries, aggregations or schemas and I'll try my best to help you out!")
                    .customFont(.body)
                    .opacity(0.7)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                button.view()
                    .frame(width: 236, height: 64)
                    .overlay(
                        Label("Talk to ChatGPT", systemImage: "arrow.forward")
                            .offset(x: 4, y: 4)
                            .font(.headline)
                    )
                    .background(
                        Color.black
                            .cornerRadius(30)
                            .blur(radius: 10)
                            .opacity(0.3)
                            .offset(y:10)
                    )
                    .onTapGesture {
                        try? button.play(animationName: "active")
                }
                Text("ChatGPT uses OpenAI API and their API services. Please be mindful of the cost as this is a Proof of concept.")
                    .customFont(.footnote)
                    .opacity(0.7)
            }
        }
        .padding(40)
        .padding(.top, 40)
    }
    
    var background: some View {
        RiveViewModel(fileName: "shapes").view()
            .ignoresSafeArea()
            .blur(radius: 30)
            .background(
                Image("Spline")
                    .blur(radius: 80)
                    .offset(x: 150, y: 100)
        )
    }
}

struct onBoardingView_Previews: PreviewProvider {
    static var previews: some View {
        onBoardingView()
    }
}
