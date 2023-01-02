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
    @State var showModal = false
    
    var body: some View {
        ZStack {
            background
            
            content
                .offset(y: showModal ? -50 : 0)
            
            Color("Shadow")
                .opacity(showModal ? 0.4 : 0)
                .ignoresSafeArea()
            
            if showModal {
                SignInView(showModal: $showModal)
                    .transition(
                        .move(edge: .top)
                        .combined(with: .opacity)
                    )
                    .overlay(
                        Button {
                            withAnimation(.spring()) {
                                showModal = false
                            }
                        } label: {
                            Image(systemName: "xmark")
                                .frame(width: 36, height: 36)
                                .foregroundColor(.black)
                                .background(.white)
                                .mask(Circle())
                            .shadow(color: Color("MongoGreen").opacity(0.3), radius: 5, x: 0, y: 3)
                        }
                            .frame(maxHeight: .infinity, alignment: .bottom)
                    )
                    .zIndex(1)
            }
        }
        
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
    
    var content: some View {
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
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                        withAnimation(.spring()) {
                            showModal = true
                        }
                    }
            }
            Text("ChatGPT uses OpenAI API and their API services. Please be mindful of the cost as this is a Proof of concept.")
                .customFont(.footnote)
                .opacity(0.7)
        }
        .padding(40)
        .padding(.top, 40)
    }
}

struct onBoardingView_Previews: PreviewProvider {
    static var previews: some View {
        onBoardingView()
    }
}
