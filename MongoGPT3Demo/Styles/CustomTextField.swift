//
//  CustomTextField.swift
//  MongoGPT3Demo
//
//  Created by Aneesh Prabu on 12/25/22.
//

import SwiftUI

struct CustomTextField: ViewModifier {
    
    var image: Image
    
    func body(content: Content) -> some View {
        content
            .padding(15)
            .padding(.leading, 36)
            .background(Color(.systemBackground))
            .mask(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                .stroke()
                .fill(.black.opacity(0.1))
            )
            .overlay {
                image
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 8)
                    .foregroundColor(Color("MongoGreen"))
            }
    }
}

extension View {
    func customTextField(image: Image = Image(systemName: "link")) -> some View {
        modifier(CustomTextField(image: image))
    }
}
