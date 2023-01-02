//
//  HomeScreenView.swift
//  MongoGPT3Demo
//
//  Created by Aneesh Prabu on 12/17/22.
//

import SwiftUI
import RiveRuntime

struct MenuIcon: View {
    
    @State var isOpen = false
    let button = RiveViewModel(fileName: "menu_button", stateMachineName: "State Machine", autoPlay: false)
    
    
    var body: some View {
        button.view()
            .frame(width: 44, height: 44)
            .mask(Circle())
            .shadow(color: Color("Shadow").opacity(0.2), radius: 5, x: 0, y: 5)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding()
            .onTapGesture {
                button.setInput("isOpen", value: isOpen)
                isOpen.toggle()
            }
        
    }
}

struct MenuIcon_Previews: PreviewProvider {
    static var previews: some View {
        MenuIcon()
    }
}
