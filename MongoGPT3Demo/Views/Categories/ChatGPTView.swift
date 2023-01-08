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
    @State private var conversation: [Message] = []
    @Binding var showChatGPTView: Bool
    @State private var isLoading: Bool = false


    var body: some View {
        ZStack {
            // Add a white rectangle as the background
            Rectangle()
                .foregroundColor(Color(.secondarySystemBackground))
                .edgesIgnoringSafeArea(.all)
            VStack {
                ScrollView(.vertical) {
                    VStack(alignment: .leading) {
                        ForEach(conversation, id: \.id) { message in
                            HStack {
                                Spacer()
                                VStack {
//                                    CodeEditor(source: message.text, language: .javascript, theme: .ocean)
                                    Text(message.text)
                                        .padding(10)
                                        .foregroundColor(Color.white)
                                        .background(message.isResponse ? Color.blue : Color.gray)
                                        .cornerRadius(10)
                                        .frame(alignment: message.isResponse ? .leading : .trailing)
                                }
                                Spacer()
                            }
                        }

                        HStack {
                            TextField("Enter your message...", text: $inputText)
                            Button(action: sendMessage) {
                                Text("Send")
                            }
                        }
                        .padding()
                    }
                    if isLoading {
                        // Add a loading animation while waiting for a response
                        ActivityIndicator(isAnimating: isLoading)
                    }
                }
            }
        }
    }

    func sendMessage() {
        isLoading = true
        chatGPTResponse(for: inputText) { response in
            // Append the message and response to the conversation
            conversation.append(Message(text: inputText, isResponse: false))
            conversation.append(Message(text: response, isResponse: true))
            inputText = ""
            isLoading = false
        }
    }
}


struct SchemaView_Previews: PreviewProvider {
    static var previews: some View {
        ChatGPTView(showChatGPTView: .constant(true))
    }
}
