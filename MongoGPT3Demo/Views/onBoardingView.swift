//
//  onBoardingView.swift
//  MongoGPT3Demo
//
//  Created by Aneesh Prabu on 12/25/22.
//

import SwiftUI
import RiveRuntime
import CodeEditor

struct OnBoardingView: View {
    
    let button = RiveViewModel(fileName: "button")
    @State var showModal = false
    @Binding var show: Bool
    
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
            
            Button {
                withAnimation {
                    show = false
                }
            } label: {
                Image(systemName: "xmark")
                    .frame(width: 36, height: 36)
                    .background(.black)
                    .foregroundColor(.white)
                    .mask(Circle())
                .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 10)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            .padding(20)
            .offset(y: showModal ? -200 : 30)
            
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
            
            Text("Connect to MongoDB Atlas").layoutPriority(1)
                .font(.custom("Poppins Bold", size: 45, relativeTo: .largeTitle))
                .frame(width: 300, alignment: .leading)
//                .foregroundColor(.black)
                .multilineTextAlignment(.leading)
            
            // MongoURI
            if let mongoURI = UserDefaults.standard.string(forKey: "MongoURI") {
                Text("You are currently logged in with the following URI")
                    .customFont(.body)
                    .opacity(0.7)
                    .frame(maxWidth: .infinity, alignment: .leading)
                CodeEditor(source: "\n\(mongoURI)", language: .swift, theme: .ocean)
                    .mask(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .frame(maxHeight: 150)
                
                Spacer()
                
                button.view()
                    .frame(width: 237, height: 64)
                    .overlay(
                        Label("New Connection", systemImage: "tray.and.arrow.down.fill")
                            .foregroundColor(Color("MongoGreen"))
                            .offset(x: 4, y: 4)
                            .font(.subheadline)
                    )
                    .background(
                        Color.black
                            .cornerRadius(30)
                            .blur(radius: 10)
                            .opacity(0.3)
                            .offset(y:10)
                    )
                    .foregroundColor(.black)
                    .onTapGesture {
                        button.play(animationName: "active")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                            withAnimation(.spring()) {
                                showModal = true
                            }
                        }
                }
                
                Text("You can connect to a new Atlas instance or use a different URI by clicking the button above.")
                    .customFont(.footnote)
                    .opacity(0.7)
            }
            else {
                Text("Hi, It's me! Your MongoDB Personal Assistant. This app lets you ask me any questions regarding MongoDB as well as lets you execute MQL. If you would like to connect your MongoDB Atlas please click the button below.")
                    .customFont(.body)
                    .opacity(0.7)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                button.view()
                    .frame(width: 237, height: 64)
                    .overlay(
                        Label("Connect to Atlas", systemImage: "tray.and.arrow.down.fill")
                            .foregroundColor(Color("MongoGreen"))
                            .offset(x: 4, y: 4)
                            .font(.subheadline)
                    )
                    .background(
                        Color.black
                            .cornerRadius(30)
                            .blur(radius: 10)
                            .opacity(0.3)
                            .offset(y:10)
                    )
                    .foregroundColor(.black)
                    .onTapGesture {
                        button.play(animationName: "active")
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
            
            
        }
        .padding(40)
        .padding(.top, 40)
    }
}

struct onBoardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingView(show: .constant(true))
    }
}
