//
//  HomeView.swift
//  MongoGPT3Demo
//
//  Created by Aneesh Prabu on 1/1/23.
//

import SwiftUI
import RiveRuntime

struct HomeView: View {
    
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
//            background
            ScrollView {
                content
            }
        }
    }
    
    var background: some View {
        RiveViewModel(fileName: "shapes").view()
            .ignoresSafeArea()
            .blur(radius: 80)
            .background(
                Image("Spline")
                    .blur(radius: 80)
                    .offset(x: 150, y: 100)
        )
    }
    
    var content: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Hello Aneesh,")
                .customFont(.largeTitle)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
            Text("I am your very MongoDB Assistant. How can be of service to you? Please select any one of the categories below.")
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
