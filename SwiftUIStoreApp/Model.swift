//
//  Mode.swift
//  SwiftUIStoreApp
//
//  Created by Keto Nioradze on 19.12.23.
//

import Foundation
import NetworkManagerPackage

// MARK: - Welcome
struct Model: Decodable {
    let products: [Product]
    let total, skip, limit: Int
}

// MARK: - Product
struct Product: Decodable, Identifiable {
    let id: Int
    let title, description: String
    let price: Int
    let discountPercentage, rating: Double
    let stock: Int
    let brand, category: String
    let thumbnail: String
    let images: [String]
}


class DataFetcher: ObservableObject {
    @Published var products: [Product] = []
    @Published var categories: [Category] = []

    init() {
        fetchProducts()
      
    }

    func fetchProducts() {
        guard let url = URL(string: "https://dummyjson.com/products") else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {return}
                do {
                    let decodedData = try JSONDecoder().decode(Model.self, from: data)
                    DispatchQueue.main.async {
                        self.products = decodedData.products
                    }
                } catch {
                    print("Error decoding products: \(error)")
                }
            
        }.resume()
    }
}
