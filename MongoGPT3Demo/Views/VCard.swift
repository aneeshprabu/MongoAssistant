//
//  VCard.swift
//  MongoGPT3Demo
//
//  Created by Aneesh Prabu on 1/1/23.
//

import SwiftUI

struct VCard: View {
    
    var feature: Feature
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(feature.title)
                .customFont(.title)
                .frame(maxWidth: 170, alignment: .leading)
                .layoutPriority(1)
            Text(feature.subtitle)
                .customFont(.subheadline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .opacity(0.7)
            Text(feature.caption.uppercased())
                .customFont(.footnote2)
        }
        .foregroundColor(.white)
        .padding(30)
        .frame(width: 260, height: 310)
        .background(.linearGradient(colors: [feature.color, feature.color.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing))
        .mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
        .shadow(color: feature.color.opacity(0.3), radius: 8, x: 0, y: 12)
        .shadow(color: feature.color.opacity(0.3), radius: 2, x: 0, y: 1)
        .overlay {
            feature.image.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding(20)
        }
    }
}

struct VCard_Previews: PreviewProvider {
    static var previews: some View {
        VCard(feature: features[0])
    }
}
