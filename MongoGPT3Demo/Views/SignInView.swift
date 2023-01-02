//
//  SignInView.swift
//  MongoGPT3Demo
//
//  Created by Aneesh Prabu on 12/25/22.
//

import SwiftUI
import RiveRuntime

struct SignInView: View {
    
    @State var uri = ""
    
    // For SignIn process
    @State var isLoading = false
    let check = RiveViewModel(fileName: "check")
    let confetti = RiveViewModel(fileName: "confetti")
    
    @Binding var showModal: Bool
    
    func logIn() {
        isLoading = true
        
        if uri != "" {
            
            // TODO: - Do mongo login using backend.
            var login = true
            @AppStorage("MongoURI") var mongoURI: String = uri
            
            if login {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    check.triggerInput("Check")
                })
                DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                    isLoading = false
                    confetti.triggerInput("Trigger explosion")
                })
                DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: {
                    withAnimation {
                        showModal = false
                    }
                })
            }
        }
        else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                check.triggerInput("Error")
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                isLoading = false
                check.stop()
            })
        }
        
        
    }
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Sign In")
                .customFont(.largeTitle)
            
            Text("Using MongoDB URI your queries generated through ChatGPT can be used to query your database and gather results.")
                .customFont(.headline)
            
            VStack(alignment: .leading) {
                Text("URI")
                    .customFont(.subheadline)
                .foregroundColor(.secondary)
                
                TextField("mongodb://localhost:27017", text: $uri).customTextField()
                    
            }
            
            Button {
                logIn()
                
            } label: {
                Label("Connect", systemImage: "arrow.right")
                    .customFont(.headline)
                    .padding(20)
                    .frame(maxWidth: .infinity)
                    .background(Color("MongoGreen"))
                    .foregroundColor(.white)
                    .cornerRadius(20, corners: [.topRight, .bottomLeft, .bottomRight])
                    .cornerRadius(8, corners: [.topLeft])
                .shadow(color: Color("MongoGreen").opacity(0.5), radius: 20, x: 0, y: 10)
            }
            
            
            HStack {
                Rectangle().frame(height: 1).opacity(0.1)
                Text("OR").customFont(.subheadline2).foregroundColor(.black.opacity(0.3))
                Rectangle().frame(height: 1).opacity(0.1)
            }
            
            Text("Skip this step. Limited features will be available")
                .customFont(.subheadline)
                .foregroundColor(.secondary)
            
            Button {
                
            } label: {
                Text("Skip").customFont(.subheadline)
            }
            
        }
        .padding(30)
        .background(.regularMaterial)
        .mask(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: Color("Shadow").opacity(0.3), radius: 5, x: 0, y: 3)
        .shadow(color: Color("Shadow").opacity(0.3), radius: 30, x: 0, y: 30)
        .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous)
            .stroke(.linearGradient(colors: [.white.opacity(0.8), .white.opacity(0.1)], startPoint: .topLeading, endPoint: .bottomTrailing)))
        .padding(16)
        .overlay {
            ZStack {
                if isLoading {
                    check.view()
                        .frame(width: 100, height: 100)
                        .allowsHitTesting(false)
                }
                confetti.view()
                    .scaleEffect(3)
                    .allowsHitTesting(false)
            }
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(showModal: .constant(true))
    }
}
