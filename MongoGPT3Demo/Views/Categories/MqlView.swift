//
//  MqlView.swift
//  MongoGPT3Demo
//
//  Created by Aneesh Prabu on 1/2/23.
//

import SwiftUI
import Alamofire
import SwiftyJSON
import CodeEditor

struct MqlView: View {
    
    @Binding var showMqlView: Bool
    @State var showResponse = false
    @State private var isLoading: Bool = false
    @State var chatResponses = ["Hope this helps!", "Here's my take on it!", "Does this work for you?", "Here you go!"].randomElement()!
    @State var mongoAssistants = ["Jake", "Amy", "Wednesday", "Paul"].randomElement()!
    
    @State var response: String = "db.find(number: \"1\")"
    @State var schema: String = "{\"result\": {\"type\": \"string\" }, \"sector\": { \"type\": \"string\" },}"
    
    @State var MongoURI = UserDefaults.standard.string(forKey: "MongoURI")
    
    //MARK: - Form fields
    @Binding var collections : [Collection]
    @Binding var dbs : [DB]
    
    @Binding var selectedCollection: Collection
    @Binding var selectedDb : DB
    
    @State var selectedType: Type = typeItems[0]
    @State var types : [Type] = typeItems
    
    
    @State var atlasConnected = false
    @State var query = ""
    @State var showAlert = false
    
    
    var body: some View {
        ZStack {
            Color(.secondarySystemBackground).ignoresSafeArea()
            VStack {
                NavigationView {
                    Form {
                        Section {
                            TextEditor(text: $query)
//                                .disableAutocorrection(true)
                            Button(action: {
                                UIApplication.shared.keyWindow?.endEditing(true)
                            }) {
                                Text("Close Keyboard")
                                    .customFont(.subheadline)
                                    .opacity(0.7)
                                    .frame(maxWidth: .infinity, alignment: .center)
                            }
                            
                        } header: {
                            Text("Query").customFont(.title)
                        } footer: {
                            Text("Please enter your query above").customFont(.subheadline)
                        }
                        
                        Section {
                            CodeEditor(source: $schema, language: .json, theme: .ocean, flags: [ .selectable, .smartIndent ])
                                .frame(minHeight: 150)
                                .padding(.top, 10)
                                .padding(.bottom, 10)
                                .mask(RoundedRectangle(cornerRadius: 20, style: .continuous))
//                                .disableAutocorrection(true)
                            
                        } header: {
                            Text("Schema").customFont(.subheadline)
                        } footer: {
                            Text("Schema for the selected collection").customFont(.subheadline)
                        }
                        
                        Section {
                            Picker(selection: $selectedType, label: Text("Query Type ").customFont(.subheadline).opacity(0.7)) {
                                ForEach(types, id: \.self) { item in
                                    Text(item.type).tag(item.tag)
                                    }
                                }
                        } footer: {
                            Text("Choose between CRUD MQL and Aggregation pipeline")
                        }
                        
                    
                        Section {
                            Picker(selection: $selectedDb, label: Text("Database").customFont(.subheadline).opacity(0.7)) {
                                ForEach(dbs, id: \.self) { item in
                                    Text(item.database).tag(item.tag)
                                    }
                                }
                        } footer: {
                            Text("Choose a database to execute this query on.")
                        }.onChange(of: selectedDb) { tag in
                            isLoading = true
                            if let mongoURI = UserDefaults.standard.string(forKey: "MongoURI") {
                                // Get Databases
                                getCollections()
                                getSchema()
                            }
                            else {
                                print("No URI")
                            }
                        }
                        
                        Section {
                            Picker(selection: $selectedCollection, label: Text("Collection").customFont(.subheadline).opacity(0.7)) {
                                ForEach(collections, id: \.self) { item in
                                    Text(item.collection).tag(item.tag)
                                    }
                                }
                        } footer: {
                            Text("Choose a collection above. This feature is only available if you have logged in using your Atlas. If not then you'll need to manually input what collection you want your MQL for. \n\n For example: \n \"Write a mongo find query to get all number of oranges from collection fruit\"")
                        }
                        .onChange(of: selectedCollection) { tag in
                            isLoading = true
                            getSchema()
                        }
                        
                        Button(action: {
                            if query != "" {
                                withAnimation(.spring()) {
                                    sendMessage()
                                }
                            }
                        }, label: {
                            HStack {
                                Text("Send")
                                Image(systemName: "paperplane")
                            }
                        })
                            .frame(maxWidth: .infinity, alignment: .center)
                            .customFont(.headline)
                            .padding(10)
                    }
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button {
                                withAnimation {
                                    showMqlView.toggle()
                                }
                            } label: {
                                Image(systemName: "xmark")
                                    .frame(width: 36, height: 36)
                                    .background(Color(.systemBackground))
                                    .foregroundColor(Color(.label))
                                    .mask(Circle())
                                    .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 10)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                            .offset(y: showResponse ? -400 : 0)
                        }
                        
                        ToolbarItem(placement: .cancellationAction) {
                            Button {
                                withAnimation {
                                    if UserDefaults.standard.string(forKey: "MongoURI") != nil {
                                        UserDefaults.standard.set(nil, forKey: "MongoURI")
                                        showAlert.toggle()
                                    }
                                }
                            } label: {
                                Image(systemName: "trash").foregroundColor(.red)
                                Text("URI").foregroundColor(.red)
                            }
                            .alert("Warning!", isPresented: $showAlert) {
                            
                            } message: {
                                Text("You have successfully deleted the URI.")
                            }
                        }
                    }
                }
                .navigationBarHidden(true)
                .blur(radius: showResponse || isLoading ? 100 : 0)
                .allowsHitTesting(!isLoading || !showResponse)
            }

            if showResponse {
                AssistantResponse(showResponse: $showResponse, collections: $collections, selectedCollection: $selectedCollection, dbs: $dbs, selectedDb: $selectedDb, response: $response, chatResponses: $chatResponses, mongoAssistants: $mongoAssistants, atlasConnected: $atlasConnected).transition(.move(edge: .bottom)).zIndex(2)
            }
            if isLoading {
                // Add a loading animation while waiting for a response
                ActivityIndicator(isAnimating: isLoading)
            }
        }.onAppear(perform: getInitialCollectionAndSchema)
    }
    
    func getInitialCollectionAndSchema() {
        getCollections()
        getSchema()
    }
    
    func getCollections() {
        
        let collectionsApiUrl = "https://mongo-assistant-app.azurewebsites.net/api/v1/uri/collections"
        
        //MARK: - Parameters
        let parameters: Parameters = [
            "uri" : MongoURI,
            "db_name": selectedDb.database
        ]
        
        print("Parameters : \(parameters)")
        
        //MARK: - Request to get Collections
        AF.request(collectionsApiUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).validate(statusCode: 200 ..< 600).responseData { response in
            switch response.result {
            case .success(let data):
                
                var statusCode = response.response?.statusCode
                if statusCode == 200 {
                    
                    do {
                        let decoder = JSONDecoder()
                        let jsonData = try JSON(data: data)["collections_info"]
                        if let data = getDataFrom(JSON: jsonData) {
                            let response = try decoder.decode([Collection].self, from: data)
                            print("Response: \(response)")
                            collections = response
                            selectedCollection = collections[0]
//                            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
//                                isLoading = false
//                            })
                        }
                        else {
                            isLoading = false                            }
                    }
                    catch {
                        isLoading = false
                    }
                }
                else {
                    isLoading = false
                }
                
            case .failure(let error):
                print(error)
                isLoading = false
            }
        }
    }
    
    func getSchema() {
        
        if let mongoURI = UserDefaults.standard.string(forKey: "MongoURI") {
            isLoading = true
            
            let schemaApiUrl = "https://mongo-assistant-app.azurewebsites.net/api/v1/uri/schema"
            
            //MARK: - Parameters
            let parameters: Parameters = [
                "uri" : mongoURI,
                "db_name": selectedDb.database,
                "collection": selectedCollection.collection
            ]
            /*
             {
               "uri": "mongodb+srv://m220student:m220password@mflix.adxrpti.mongodb.net/?retryWrites=true&w=majority",
               "db_name": "sample_restaurants",
               "collection": "restaurants"
             }
             */
            
            print("Schema Parameters : \(parameters)")
            
            //MARK: - Request to get Schema
            AF.request(schemaApiUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
                
                if let data = response.data {
                    let inputString = String(decoding: data, as: UTF8.self)
                    let outputString = inputString.replacingOccurrences(of: "^\"|\"$", with: "", options: .regularExpression)
                        .replacingOccurrences(of: "{", with: "\n{\n")
                        .replacingOccurrences(of: "}", with: "\n}\n")
                        .replacingOccurrences(of: ",", with: ",\n")
                        .replacingOccurrences(of: "\t", with: "\u{0009}")
                    schema = outputString
                    print("\n--------Schema-------- \n\(schema)")
                    DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                        isLoading = false
                    })
                }
                else {
                    isLoading = false
                    print("No schema")
                }
            }
        }
    }
    
    func sendMessage() {
        isLoading = true
        
        var context = ""
        var schemaContext = ""
        var finalContext = ""
        let wraps = "Wrap properties, operators and fields in double quotes. Return the mongodb query with the operators such as $gt, $lt in single quotes. Example: {'$gt': 3}"
        
        if selectedType.queryType == .crud {
            context = "Write a MongoDB MQL Query. "
        } else {
            context = "Write a MongoDB Aggregation pipeline. "
        }
        
        if selectedDb.database != "None" || selectedCollection.collection != "None" {
            schemaContext = "Use the following as mongoDB collection schema to write the query: \n\(schema). "
            let collectionMessage = "Using the collection \"\(selectedCollection.collection)\". "
            finalContext = context + schemaContext + query + ". " + collectionMessage + wraps
            atlasConnected = true
        }
        else {
            finalContext = context + query + ". " + wraps
            atlasConnected = false
        }
        
        
        print("Query: \n\(finalContext)")
        
        
        chatGPTResponse(for: finalContext) { result in
            // Append the message and response to the conversation
            let inputString = result
            var outputString = inputString.replacingOccurrences(of: "^\"|\"$", with: "", options: .regularExpression)
//                .replacingOccurrences(of: "{", with: "\n{\n")
//                .replacingOccurrences(of: "}", with: "\n}\n")
//                .replacingOccurrences(of: ",", with: ",\n")
                .replacingOccurrences(of: "\t", with: "\u{0009}")
//            if let range = outputString.range(of: ":") {
//                outputString = outputString.replacingOccurrences(of: ":", with: ":\n\n", options: .regularExpression, range: range)
//            }
            print("RESPONSE: - \(outputString)")
            response = outputString
            isLoading = false
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation(.spring()) {
                    showResponse.toggle()
                }
            }
        }
    }
}

struct MqlView_Previews: PreviewProvider {
    static var previews: some View {
        MqlView(showMqlView: .constant(true), collections: .constant(collectionItems), dbs: .constant(dbItems), selectedCollection: .constant(collectionItems[0]), selectedDb: .constant(dbItems[0]))
    }
}
