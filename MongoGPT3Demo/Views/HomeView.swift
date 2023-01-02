//
//  HomeView.swift
//  MongoGPT3Demo
//
//  Created by Aneesh Prabu on 1/1/23.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack(spacing: 0) {
            Text("Features")
                .customFont(.largeTitle)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(features) { feature in
                        VCard(feature: feature)
                    }
                }
                .padding(20)
                .padding(.bottom, 10)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
