//
//  HomeScreenView.swift
//  MongoGPT3Demo
//
//  Created by Aneesh Prabu on 12/17/22.
//

import SwiftUI

struct HomeScreenView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        OptionsView()
            .navigationTitle("Welcome Aneesh")
            .toolbar {
                Button("Logout") {
                    dismiss()
                }
            }
    }
}

struct OptionsView: View {
    var body: some View {
        Text("Hello World")
    }
}

struct HomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreenView()
    }
}
