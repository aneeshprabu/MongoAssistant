//
//  AggregationView.swift
//  MongoGPT3Demo
//
//  Created by Aneesh Prabu on 1/2/23.
//

import SwiftUI

struct AggregationView: View {
    
    @Binding var showAggregationView: Bool
    
    var body: some View {
        ZStack {
            Color(.white).ignoresSafeArea()
            Text("Aggregation View")
            Button {
                withAnimation {
                    showAggregationView = false
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
            .offset(y: -100)
        }
    }
}

struct AggregationView_Previews: PreviewProvider {
    static var previews: some View {
        AggregationView(showAggregationView: .constant(true))
    }
}
