//
//  SideMenu.swift
//  MongoGPT3Demo
//
//  Created by Aneesh Prabu on 1/2/23.
//

import SwiftUI

struct SideMenu: View {
    
    @State var selectedMenu: SelectedMenu = .home
    @State var isDarkMode = false
    
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "person")
                    .padding(12)
                    .background(.white.opacity(0.2))
                    .mask(Circle())
                VStack(alignment: .leading, spacing: 2) {
                    Text("Aneesh Prabu")
                        .customFont(.body)
                    Text("Mongo Developer")
                        .customFont(.subheadline)
                        .opacity(0.7)
                }
                Spacer()
            }
            .padding()
            
            Text("BROWSE")
                .customFont(.subheadline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
                .padding(.top, 40)
                .opacity(0.7)
            
            VStack(alignment: .leading, spacing: 0) {
                
                ForEach(menuItems) { item in
                    Rectangle()
                        .frame(height: 1)
                        .opacity(0.1)
                        .padding(.horizontal)
                    
                    MenuRow(item: item, selectedMenu: $selectedMenu)
                }
            }
            .padding(8)
    
            Spacer()
            
            HStack(spacing: 14) {
                menuItems2[0].image
                    .frame(width: 32, height: 32)
                    .opacity(0.6)
                    .onChange(of: isDarkMode) { newValue in
                        if newValue == true {
                            menuItems2[0].image = Image(systemName: "lightbulb.fill")
                        }
                        else {
                            menuItems2[0].image = Image(systemName: "lightbulb")
                        }
                    }
                Text(menuItems2[0].text)
                    .customFont(.headline)
                Toggle("", isOn: $isDarkMode)
            }
            .padding(20)
            
            
        }
        .foregroundColor(.white)
        .frame(maxWidth: 288, maxHeight: .infinity)
        .background(Color("TextColor"))
        .mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct SideMenu_Previews: PreviewProvider {
    static var previews: some View {
        SideMenu()
    }
}

struct MenuItem: Identifiable {
    var id = UUID()
    var text: String
    var image: Image
    var menu: SelectedMenu
}

var menuItems = [
    MenuItem(text: "Home", image: Image(systemName: "house.fill"), menu: .home),
    MenuItem(text: "Mongo URI", image: Image(systemName: "link"), menu: .mongouri),
    MenuItem(text: "Settings", image: Image(systemName: "gearshape"), menu: .settings)
]

var menuItems2 = [
    MenuItem(text: "Dark Mode", image: Image(systemName: "lightbulb.fill"), menu: .darkmode),
]


enum SelectedMenu: String {
    case home
    case mongouri
    case settings
    case darkmode
}
