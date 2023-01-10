//
//  SignInView.swift
//  MongoGPT3Demo
//
//  Created by Aneesh Prabu on 12/25/22.
//

import SwiftUI
import RiveRuntime
import Alamofire
import SwiftyJSON

struct SignInView: View {
    
    @State var uri = ""
    let mongoApiUrl = "https://{AzureURI}/api/v1/uri"
    
    // For SignIn process
    @State var isLoading = false
    let check = RiveViewModel(fileName: "check")
    let confetti = RiveViewModel(fileName: "confetti")
    
    @Binding var showModal: Bool
    
    fileprivate func showError() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            check.triggerInput("Error")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            isLoading = false
            check.stop()
        })
    }
    
    func logIn() {
        isLoading = true
        
        if uri != "" {
            
            let parameters: Parameters = [
                "uri" : uri
            ]
            
            // Checking
            print("Parameters : \(parameters)")
            
            //Mark: - Post request to check MongoURI is working
            AF.request(mongoApiUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).validate(statusCode: 200 ..< 600).responseData { response in
                    switch response.result {
                        case .success(let data):
                        do {
                            let json = try JSON(data: data)
                            print(json, data)
                            
                            if json["Data"] == "Connection is successful" {
                                
                                // Persist the URI
                                UserDefaults.standard.set(uri, forKey: "MongoURI")
                                
                                print(json["Data"])
                                @AppStorage("MongoURI") var mongoURI: String = uri
                                
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
                            else {
                                showError()
                            }
                        }
                        catch {
                            showError()
                        }

                        case .failure(let error):
                            print(error)
                        showError()
                    }
                }
        }
        else {
            showError()
        }
        
        
    }
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Connect to Atlas")
                .customFont(.largeTitle)
            
            Text("Connecting to Atlas lets you execute queries generated")
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
                Label("Connect", systemImage: "app.connected.to.app.below.fill")
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
                Text("How to connect").customFont(.subheadline2).foregroundColor(.black.opacity(0.3))
                Rectangle().frame(height: 1).opacity(0.1)
            }
            
            Text("Connect > Connect your application > Copy URI from step 2.")
                .customFont(.subheadline)
                .foregroundColor(.secondary)
            
            Link(destination: URL(string: "https://www.mongodb.com/docs/atlas/driver-connection/#connect-your-application")!) {
                Text("Documentation").customFont(.subheadline)
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
