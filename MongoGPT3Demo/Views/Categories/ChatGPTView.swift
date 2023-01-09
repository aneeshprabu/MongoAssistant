//
//  SchemaView.swift
//  MongoGPT3Demo
//
//  Created by Aneesh Prabu on 1/2/23.
//

import SwiftUI
import CodeEditor

struct ChatGPTView: View {
    @State private var inputText: String = ""
    @State private var conversation: [Message] = [
//        Message(text: "Hello", isResponse: false),
//        Message(text: "Hello", isResponse: true)
    ]
    @Binding var showChatGPTView: Bool
    @State private var isLoading: Bool = false
    


    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                ForEach(conversation, id: \.id) { message in
                    HStack {
                        Spacer()
                        VStack {
                            if message.isResponse {
                                HStack {
                                    Image(systemName: "cpu")
                                        .padding(12)
                                        .background(Color("MongoGreen").opacity(0.2))
                                        .mask(Circle())
                                        .frame(maxWidth: .infinity, alignment: .leading)

                                    Text("Assistant")
                                        .customFont(.body).opacity(0.7)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .offset(x:-120)
                                    
                                }
                                
                                CodeEditor(source: "\n" + message.text + "\n", language: .javascript, theme: .ocean, flags: [.selectable, .smartIndent])
                                    .frame(maxWidth: .infinity, minHeight: 200, alignment: .leading)
                                    .mask(RoundedRectangle(cornerRadius: 10, style: .continuous))
                            }
                            else {
                                HStack {
                                    Text(message.text)
                                        .padding(10)
                                        .foregroundColor(Color.white)
                                        .background(Color.blue)
                                        .cornerRadius(10)
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                    Image(systemName: "person")
                                        .padding(12)
                                        .background(.blue.opacity(0.2))
                                        .mask(Circle())
                                }
                            }
                            
                        }
                        Spacer()
                    }
                }
                Spacer()
                HStack {
                    TextField("Enter your message...", text: $inputText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Button(action: sendMessage) {
                        Text("Send")
                    }
                }
                .mask(Rectangle())
                .padding()
                .frame(maxHeight: .infinity, alignment: .bottom)
                
                if isLoading {
                    // Add a loading animation while waiting for a response
                    ActivityIndicator(isAnimating: isLoading)
                }
            }
            .keyboardResponsive()
            .navigationBarTitle("Let's Chat", displayMode: .large)
            .edgesIgnoringSafeArea(.bottom)  // Ignore the safe area at the bottom
            .background(
                Image("Spline")
                .ignoresSafeArea()
                .blur(radius: 80)
                .offset(x: 150, y: 100))
            .navigationBarItems(trailing:
                Button {
                    withAnimation {
                        showChatGPTView.toggle()
                    }
                } label: {
                    Image(systemName: "xmark")
                        .frame(width: 36, height: 36)
                        .background(.black)
                        .foregroundColor(.white)
                        .mask(Circle())
                        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 10)
                }
            )
        }
    }

    func sendMessage() {
        conversation.append(Message(text: inputText, isResponse: false))
        let context = "All questions asked will be related to MongoDB. I expect every answer you provide to be related to MongoDB. "
        let queryText = context + inputText
        inputText = ""
        isLoading = true
        chatGPTResponse(for: queryText) { response in
            // Append the message and response to the conversation
            let inputString = response
            var outputString = inputString.replacingOccurrences(of: "^\"|\"$", with: "", options: .regularExpression)
                .replacingOccurrences(of: "{", with: "\n{")
                .replacingOccurrences(of: "}", with: "\n}\n")
                .replacingOccurrences(of: ",", with: ",\n")
                .replacingOccurrences(of: "\t", with: "\u{0009}")
            if let range = outputString.range(of: ":") {
                outputString = outputString.replacingOccurrences(of: ":", with: ":\n\n", options: .regularExpression, range: range)
            }
            conversation.append(Message(text: outputString, isResponse: true))
            isLoading = false
        }
    }
}


struct SchemaView_Previews: PreviewProvider {
    static var previews: some View {
        ChatGPTView(showChatGPTView: .constant(true))
    }
}
