//
//  ContentView.swift
//  SwiftUIStoreApp
//
//  Created by Keto Nioradze on 19.12.23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var dataFetcher = DataFetcher()
    
    var body: some View {
        NavigationView {
            TabView {
                MainView(products: dataFetcher.products)
                    .tabItem {
                        Label("Main", systemImage: "house")
                    }
                
                CategoriesView(products: dataFetcher.products)
                    .tabItem {
                        Label("Categories", systemImage: "list.bullet")
                    }
            }
           
        }
    }
}


struct MainView: View {
    var products: [Product]
    @State private var balance: Double = 7500.0
    @State private var cartItems: [Product] = []
    @State private var showSuccessAlert = false
    @State private var showFailureAlert = false
    
    
    var totalCartAmount: Double {
        Double(cartItems.reduce(0) { $0 + $1.price })
    }
    
    var body: some View {
        VStack {
            
            Text("Balance: $\(balance, specifier: "%.2f")")
            Text("Cart Items: \(cartItems.count)")
            Text("Total Amount: $\(totalCartAmount, specifier: "%.2f")")
                
            
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                    ForEach(products) { product in
                        ProductItemView(product: product, addToCart: addToCart)
                    }
                }
                .padding()
            }
            
            Button(action:  {
                simulateCheckout()
            }, label: {
                Text("Checkout")
            })
            .padding()
            .alert("❌Failed", isPresented: $showFailureAlert){
                Button("OK", role: .cancel) { }
            }
            .alert("✅Succeeded", isPresented: $showSuccessAlert){
                Button("OK", role: .cancel) { }
            }
        }
    }
    
    func addToCart(product: Product) {
        cartItems.append(product)
    }
    
    func simulateCheckout() {
        let cartTotal = totalCartAmount
        if balance >= cartTotal {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                balance -= cartTotal
                cartItems.removeAll()
                showSuccessAlert = true
            }
        } else {
            showFailureAlert = true
        }
    }
}

struct ProductItemView: View {
    var product: Product
    var addToCart: (Product) -> Void
    
    var body: some View {
        VStack {
            Image(product.thumbnail)
                .resizable()
                .scaledToFit()
            
            Text(product.title)
                .font(.headline)
            
            Text("$\(product.price)")
                .foregroundColor(.gray)
            Button("Add to Cart") {
                addToCart(product)
            }
            .padding(5)
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(8)
        }
        .padding()
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(12)
    }
}



#Preview {
    ContentView()
}
