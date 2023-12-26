//
//  Search.swift
//  ExpenseTracer
//
//  Created by Omid Shojaeian Zanjani on 18/12/23.
//

import SwiftUI
import Combine

struct Search: View {
    // View Properties
    @State private var searchText:String = ""
    @State private var filterText:String = ""
    let searchPublishe = PassthroughSubject<String, Never>()
    var body: some View {
        NavigationStack{
            ScrollView(.vertical){
                LazyVStack(spacing:12){
                    
                }
            }
            .overlay(content: {
                ContentUnavailableView("Seach Transactions", systemImage: "magnifyingglass")
                    .opacity(filterText.isEmpty ? 1:0)
            })
            .onChange(of: searchText, {oldVaue, newValue in
                if newValue.isEmpty {
                    filterText = ""
                }
                searchPublishe.send(newValue)
            })
            .onReceive(searchPublishe.debounce(for: .seconds(0.3) , scheduler: DispatchQueue.main), perform: { text in
                filterText = text
                print(text)
            })
            .searchable(text: $searchText)
            .navigationTitle("Search")
            .background(.gray.opacity(0.15))
        }
    }
}

#Preview {
    Search()
}
