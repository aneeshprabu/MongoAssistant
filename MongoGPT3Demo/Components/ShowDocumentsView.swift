//
//  ShowDocumentsView.swift
//  MongoGPT3Demo
//
//  Created by Aneesh Prabu on 1/6/23.
//
import Alamofire
import SwiftyJSON
import SwiftUI
import CodeEditor

struct DocumentCardView: View {
    let result: JSON

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            CodeEditor(source: result.description, language: .json, theme: .ocean, flags: [ .selectable, .smartIndent ], indentStyle: .softTab(width: 10))
                .frame(maxWidth: .infinity, minHeight: 200, maxHeight: .infinity)
            .mask(RoundedRectangle(cornerRadius: 8, style: .continuous))
            .padding(10)
        }
    }
}

struct SearchBar: View {
    @Binding var searchText: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)

            TextField("Search", text: $searchText)
                .foregroundColor(.primary)
                .padding(10)
                .background(Color(.secondarySystemFill))
                .cornerRadius(8)
        }
        .padding(10)
    }
}


struct ShowDocumentsView: View {
    @Binding var documentsResult: [JSON]
    @Binding var showDocuments: Bool
    var index = 1
    
    @State private var searchText: String = ""
    @State private var displayedRange: Range<Int> = 0..<5
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(searchText: $searchText)
                ZStack {
                    Color(.secondarySystemBackground).ignoresSafeArea()
                    ScrollView(.vertical) {
                        VStack {
            //                Text(documentsResult.first!.stringValue)
                            ForEach(documentsResult.filter { self.searchText.isEmpty ? true : $0.description.range(of: self.searchText, options: [.caseInsensitive, .regularExpression]) != nil }, id: \.self) { result in
                                DocumentCardView(result: result)
                            }
                            if displayedRange.upperBound < documentsResult.count {
                                Button("Load More") {
                                    self.displayedRange = self.displayedRange.lowerBound + 10..<min(self.displayedRange.upperBound + 10, self.documentsResult.count)
                                }
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .navigationBarTitle("Documents", displayMode: .large)
            }
            .navigationBarItems(trailing:
                Button {
                    withAnimation {
                        showDocuments.toggle()
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
}



struct ShowDocumentsView_Previews: PreviewProvider {
    static var previews: some View {
        ShowDocumentsView(documentsResult: .constant(documents), showDocuments: .constant(true))
    }
}

