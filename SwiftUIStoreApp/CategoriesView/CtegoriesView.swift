//
//  CtegoriesView.swift
//  SwiftUIStoreApp
//
//  Created by Keto Nioradze on 20.12.23.
//

import SwiftUI

struct CategoriesView: View {
    var products: [Product] = []
    @State var path = NavigationPath()
    var uniqueCategories: [String] {
        let uniqueCategories = Set(products.map { $0.category })
        return Array(uniqueCategories)
    }

    var body: some View {
        navigationStack
        
    }
    private var navigationStack: some View {
        NavigationStack(path: $path) {
            categoryList
                .navigationTitle("Categories")
        }
        
    }
    private var categoryList: some View {
       
        return List {
            ForEach(uniqueCategories, id: \.self) { category in
                productCategoryLink(category: category)
                    .frame(height: 45)
            }
        }
    }
    
    
    private func productCategoryLink(category: String) -> some View {
        NavigationLink(value: category, label: {
            Text(category)
                .font(.system(size: 18))
        })
    }
}



#Preview {
    CategoriesView()
}
