//
//  HomeView.swift
//  MongoGPT3Demo
//
//  Created by Aneesh Prabu on 1/1/23.
//

import SwiftUI
import RiveRuntime
import Alamofire
import SwiftyJSON

struct HomeView: View {
    
    //MARK: - All States and Variables
    @Namespace var namespace
    
    @State var isLoading = false
    @State var collectionsLoaded = false
    let check = RiveViewModel(fileName: "check")
    
    let databaseApiUrl = "https://mongo-assistant-app.azurewebsites.net/api/v1/uri/databases"
    let collectionsApiUrl = "https://mongo-assistant-app.azurewebsites.net/api/v1/uri/collections"

    
    @State var dbs : [DB] = dbItems
    @State var selectedDb : DB = dbItems[0]
    
    @State var collections : [Collection] = collectionItems
    @State var selectedCollection: Collection = collectionItems[0]
    
    @Binding var showMqlView : Bool
    @Binding var showChatGPTView : Bool
    @Binding var showAggregationView : Bool
    
    
    // MARK: - Main Body View
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            ScrollView {
                content
            }
            if showMqlView {
                MqlView(showMqlView: $showMqlView, collections: $collections, dbs: $dbs, selectedCollection: $selectedCollection, selectedDb: $selectedDb)
                    .transition(.move(edge: .bottom))
                    .zIndex(2)
            }
            if showChatGPTView {
                ChatGPTView(showChatGPTView: $showChatGPTView)
                    .transition(.move(edge: .bottom))
                    .zIndex(1)
            }
            if showAggregationView {
                AggregationView(showAggregationView: $showAggregationView)
                    .transition(.move(edge: .bottom))
                    .zIndex(1)
            }
        }
        .allowsHitTesting(!isLoading)
        .blur(radius: isLoading ? 30 : 0)
        .overlay {
            ZStack {
                if isLoading {
                    check.view()
                        .frame(width: 100, height: 100)
                        .allowsHitTesting(false)
                }
            }
        }
    }
    
    // MARK: - Function to get DBs and Collections from server.
    
    func getDbAndCollection() {
        isLoading = true
        if let mongoURI = UserDefaults.standard.string(forKey: "MongoURI") {
            
            // Get Databases
            getDatabases(mongoURI: mongoURI)
            
        }
    }
    
    func getCollections(mongoURI: String, dbName: String) {
        //MARK: - Parameters
        let parameters: Parameters = [
            "uri" : mongoURI,
            "db_name": dbName
        ]
        
        print("Parameters : \(parameters)")
        
        //MARK: - Request to get Databases
        AF.request(collectionsApiUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).validate(statusCode: 200 ..< 600).responseData { response in
            switch response.result {
            case .success(let data):
                
                var statusCode = response.response?.statusCode
                if statusCode == 200 {
                    print(data)
                    
                    do {
                        let decoder = JSONDecoder()
                        let jsonData = try JSON(data: data)["collections_info"]
                        print(jsonData)
                        if let data = getDataFrom(JSON: jsonData) {
                            let response = try decoder.decode([Collection].self, from: data)
                            print("Response: \(response)")
                            collections = response
                            collectionsLoaded = true
                            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                                check.triggerInput("Check")
                                isLoading = false
                            })
                            withAnimation(.spring()) {
                                showMqlView.toggle()
                            }
                        }
                        else {
                            collectionsLoaded = false
                        }
                    }
                    catch {
                        collectionsLoaded = false
                    }
                }
                else {
                    collectionsLoaded = false
                }
                
            case .failure(let error):
                print(error)
                collectionsLoaded = false
            }
        }
    }
    
    func getDatabases(mongoURI: String) {
        
        //MARK: - Parameters
        let parameters: Parameters = [
            "uri" : mongoURI
        ]
        
        print("Parameters : \(parameters)")
        
        //MARK: - Request to get Databases
        AF.request(databaseApiUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).validate(statusCode: 200 ..< 600).responseData { response in
            switch response.result {
            case .success(let data):
                
                var statusCode = response.response?.statusCode
                if statusCode == 200 {
                    print("Reached 1")
                    print(data)
                    
                    do {
                        print("Reached 2")
                        let decoder = JSONDecoder()
                        let jsonData = try JSON(data: data)["database_info"]
                        print(jsonData)
                        if let data = getDataFrom(JSON: jsonData) {
                            let response = try decoder.decode([DB].self, from: data)
                            print("Response: \(response)")
                            dbs = response
                            selectedDb = dbs[0]
                            
                            getCollections(mongoURI: mongoURI, dbName: selectedDb.database)
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
                    catch {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                            check.triggerInput("Error")
                        })
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                            isLoading = false
                            check.stop()
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
                
            case .failure(let error):
                print(error)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    check.triggerInput("Error")
                })
                DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                    isLoading = false
                    check.stop()
                })
            }
        }
    }
    
    var content: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Hello Aneesh,")
                .customFont(.largeTitle)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
            Text("I am your Personal MongoDB Assistant. How can be of service to you? Please select any one of the categories below.")
                .customFont(.subheadline)
                .opacity(0.7)
                .padding(20)
            Text("Categories")
                .customFont(.title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(features) { feature in
                        VCard(feature: feature).onTapGesture {
                            print(feature.tag)
                            if feature.tag == 1 {
                                getDbAndCollection()
                            }
                            else if feature.tag == 2 {
                                withAnimation(.spring()) {
                                    showChatGPTView.toggle()
                                }
                            }
                            else if feature.tag == 3 {
                                withAnimation(.spring()) {
                                    showAggregationView.toggle()
                                }
                            }
                        }
                    }
                }
                .padding(20)
                .padding(.bottom, 10)
            }
        }.offset(y: showMqlView || showChatGPTView || showAggregationView ? -400 : 0)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(showMqlView: .constant(false), showChatGPTView: .constant(false), showAggregationView: .constant(false))
    }
}
