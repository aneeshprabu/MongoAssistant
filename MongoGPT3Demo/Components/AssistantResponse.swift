//
//  AssistantResponse.swift
//  MongoGPT3Demo
//
//  Created by Aneesh Prabu on 1/4/23.
//

import SwiftUI
import CodeEditor
import Alamofire
import SwiftyJSON

enum ActiveAlert {
    case copied, error
}

struct AssistantResponse: View {
    
    @Binding var showResponse: Bool
    @State var showDocuments : Bool = false
    
    @Binding var collections : [Collection]
    @Binding var selectedCollection: Collection
    
    @Binding var dbs: [DB]
    @Binding var selectedDb : DB

    @State private var isLoading: Bool = false
    
    
    
    @Binding var response : String
    @State var disabledTextEditor = true
    
    
    @Binding var chatResponses : String
    @Binding var mongoAssistants : String
    
    @State var documentsResult = [JSON]()

    @State private var showAlert: Bool = false
    @State private var alertType: ActiveAlert = .copied
    
    @State private var alertMessage = ""
    @Binding var atlasConnected : Bool
    
    
    var body: some View {
        ZStack {
            ScrollView(.vertical) {
                VStack {
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "person")
                                .padding(12)
                                .background(.white.opacity(0.3))
                                .mask(Circle())
                            VStack(alignment: .leading, spacing: 2) {
                                Text(mongoAssistants)
                                    .customFont(.body)
                                Text("Mongo Assistant")
                                    .customFont(.subheadline)
                                    .opacity(0.7)
                            }
                        }
                        
                        Text(chatResponses)
                            .padding(5)
                            .customFont(.subheadline)
                            .opacity(0.7)
                        
                        HStack {

                            Button {
                                UIApplication.shared.keyWindow?.endEditing(true)

                            } label: {
                                Text("Close Keyboard")
                                    .customFont(.subheadline)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .customFont(.subheadline)
                            .padding(10)
                            .offset(y:10)

                            Button {
                                UIPasteboard.general.string = response
                                showAlert = true
                                alertType = .copied
                            } label: {
                                Image(systemName: "doc.on.clipboard")
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                            .offset(y:10)
                            .padding(10)

                        }
                        
                        CodeEditor(source: $response, language: .javascript, theme: .ocean, flags: [ .selectable, .smartIndent, .editable ], indentStyle: .softTab(width: 2), autoPairs: [ "{": "}", "<": ">", "'": "'" ], autoscroll: true)
                            .mask(RoundedRectangle(cornerRadius: 8, style: .continuous))
                            .padding(.bottom, 20)
                            .frame(minHeight: 200)
                        Button {
                            
                            executeQuery()
                            
                        } label: {
                            Label("Execute", systemImage: "network")
                                .customFont(.headline)
                                .padding(15)
                                .frame(maxWidth: .infinity)
                                .background(atlasConnected ? Color("MongoGreen") : Color(.gray))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                                .shadow(color: atlasConnected ? Color("MongoGreen").opacity(0.5) : Color(.gray).opacity(0.5), radius: 20, x: 0, y: 10)
                        }
                    }
                }
                .padding(20)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            Button {
                withAnimation {
                    showResponse.toggle()
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
        }
        .blur(radius: isLoading || showAlert ? 30 : 0)
        .allowsHitTesting(!isLoading)
        .alert(isPresented: $showAlert) {
            switch alertType {
            case .copied:
                return Alert(title: Text("Copied"), message: Text("Text copied to clipboard"), dismissButton: .default(Text("Ok"), action: { showAlert = false }))
            case .error:
                return Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("Ok"), action: { showAlert = false }))
            }
        }
        
        if isLoading {
            // Add a loading animation while waiting for a response
            ActivityIndicator(isAnimating: isLoading)
        }
        
        if showDocuments {
            ShowDocumentsView(documentsResult: $documentsResult, showDocuments: $showDocuments).transition(.move(edge: .bottom))
        }
    }
    
    
    func executeQuery() {
        isLoading = true
        if let mongoURI = UserDefaults.standard.string(forKey: "MongoURI") {
            let queryApiUrl = "https://{AzureURI}/api/v1/uri/query"
            /*
             {
               "uri": "string",
               "query": "string",
               "db_name": "string"
             }
             */
            
            let query = response
            let parameters: Parameters = [
                "uri": mongoURI,
                "query": query,
                "db_name": selectedDb.database
            ]
            
            AF.request(queryApiUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
                    if let data = response.data {
                        let jsonString = String(data: data, encoding: .utf8)
                          print(jsonString)
                    } else {
                      print("Response does not contain any data")
                    }
                    if let data = response.data {
                      let json = JSON(data)
                      print("JSON: " , json)
                      if json["success"].boolValue {
                          print("Inside loop 1")
                        // request was successful, process the results
                        let results = json["result"]
                        // check if results is an array or an object
                        if results.array != nil {
                          // results is an array, process each element
                          for result in results.arrayValue {
                            // add the json object to the documentsResult array
                            documentsResult.append(result)
                          }
                          
                          isLoading = false
                          withAnimation(.spring()) {
                            showDocuments.toggle()
                          }
                          
                        } else if results.dictionary != nil {
                          // add the json object to the documentsResult array
                          documentsResult.append(results)
                          isLoading = false
                          withAnimation(.spring()) {
                            showDocuments.toggle()
                          }
                        }
                      }

                    else {
                        isLoading = false
                        showAlert = true
                        alertType = .error
                        alertMessage = "Query may be wrong or JSON Decoding error"
                        print("Alamofire Failure")
                    }
                }
                else {
                    isLoading = false
                    showAlert = true
                    alertType = .error
                    alertMessage = "No response data"
                    print("No response data")
                }
            }
        }
        else {
            isLoading = false
            showAlert = true
            alertType = .error
            alertMessage = "No MongoURI or connection"
            print("No MongoURI")
        }
    }
}

struct AssistantResponse_Previews: PreviewProvider {
    static var previews: some View {
        AssistantResponse(showResponse: .constant(true), collections: .constant(collectionItems), selectedCollection: .constant(collectionItems[0]), dbs: .constant(dbItems), selectedDb: .constant(dbItems[0]), response: .constant("db.find(number: \"1\")"), chatResponses: .constant("Hope this helps!"), mongoAssistants: .constant("Jake Paul"), atlasConnected: .constant(true))
    }
}
