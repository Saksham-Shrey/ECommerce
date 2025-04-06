import SwiftUI
import UIKit

struct CategoryItem: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    
    static let categories: [CategoryItem] = [
        CategoryItem(name: "Phones", icon: "iphone"),
        CategoryItem(name: "Consoles", icon: "gamecontroller"),
        CategoryItem(name: "Laptops", icon: "laptopcomputer"),
        CategoryItem(name: "Cameras", icon: "camera"),
        CategoryItem(name: "Audio", icon: "headphones"),
        CategoryItem(name: "Tablets", icon: "ipad"),
        CategoryItem(name: "Wearables", icon: "applewatch"),
        CategoryItem(name: "Accessories", icon: "cable.connector")
    ]
}

struct HomeView: View {
    @ObservedObject var viewModel: ProductViewModel
    @State private var searchText = ""
    @State private var showProductDetail: Product?
    @State private var isFirstAppear = true
    
    private let columns = [
        GridItem(.adaptive(minimum: 160), spacing: 16)
    ]
    
    private var filteredProducts: [Product] {
        if searchText.isEmpty {
            return viewModel.products
        } else {
            return viewModel.products.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.category.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    VStack {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                            
                            TextField("Search the entire shop", text: $searchText)
                                .font(.system(size: 14))
                        }
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(15)
                        .padding(.horizontal)
                        
                        // Delivery info banner
                        HStack {
                            Image(systemName: "feather")
                                .foregroundColor(Color.teal)
                            
                            Text("Delivery is")
                                .foregroundColor(.black)
                            
                            Text("50%")
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                            
                            Text("cheaper")
                                .foregroundColor(.black)
                            
                            Spacer()
                        }
                        .padding()
                        .background(
                            LinearGradient(
                                colors: [Color.cyan.opacity(0.2), Color.teal.opacity(0.1)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(25)
                        .padding(.horizontal)
                    }
                    .padding(.bottom, 10)
                    .background(Color.white)
                    .clipShape(
                        RoundedCorner(
                            radius: 20,
                            corners: [.bottomRight, .bottomLeft]
                        )
                    )
                    
                    // Categories
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Categories")
                                .font(.headline)
                                .fontWeight(.bold)
                            
                            Spacer()
                            
                            NavigationLink(destination: Text("All Categories")) {
                                HStack {
                                    Text("See all")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                ForEach(CategoryItem.categories) { category in
                                    VStack {
                                        Circle()
                                            .fill(Color.gray.opacity(0.1))
                                            .frame(width: 60, height: 60)
                                            .overlay(
                                                Image(systemName: category.icon)
                                                    .font(.system(size: 24))
                                                    .foregroundColor(.gray)
                                            )
                                        
                                        Text(category.name)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    
                    // Flash sale
                        HStack {
                            Text("Flash Sale")
                                .font(.headline)
                                .fontWeight(.bold)
                            
                            // Timer tag
                            HStack {
                                Text("02:59:23")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                                    .padding(.vertical, 4)
                                    .padding(.horizontal, 8)
                                    .background(
                                        Capsule()
                                            .fill(Color(hex: "AACC00"))
                                    )
                            }
                            
                            Spacer()
                            
                            NavigationLink(destination: Text("All Flash Sales")) {
                                HStack {
                                    Text("See all")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        // Product grid - now displays immediately with content
                        ZStack {
                            // Always show products if we have them
                            if !filteredProducts.isEmpty {
                                LazyVGrid(columns: columns, spacing: 16) {
                                    ForEach(filteredProducts) { product in
                                        ProductCard(
                                            product: product,
                                            onFavoriteToggle: {
                                                viewModel.toggleFavorite(for: product)
                                            },
                                            isFavorite: viewModel.isProductFavorite(product)
                                        )
                                        .onTapGesture {
                                            showProductDetail = product
                                        }
                                    }
                                }
                                .padding(.horizontal)
                                .padding(.bottom, 16)
                                .refreshable {
                                    await viewModel.refreshProducts()
                                }
                            }
                            
                            // Loading overlay - only show if NO products are available
                            if viewModel.products.isEmpty && viewModel.isLoading {
                                VStack {
                                    ProgressView()
                                        .padding()
                                    Text("Loading products...")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                            }
                            
                            // Error view - only show if NO products are available
                            if viewModel.products.isEmpty && viewModel.showError {
                                VStack {
                                    Image(systemName: "wifi.slash")
                                        .font(.largeTitle)
                                        .foregroundColor(.red)
                                        .padding()
                                    
                                    Text(viewModel.errorMessage ?? "Failed to load products")
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.secondary)
                                    
                                    Button {
                                        Task {
                                            await viewModel.loadProducts()
                                        }
                                    } label: {
                                        Text("Try Again")
                                            .padding(.horizontal)
                                            .padding(.vertical, 8)
                                            .background(Color(hex: "AACC00"))
                                            .foregroundColor(.black)
                                            .cornerRadius(20)
                                    }
                                    .padding(.top)
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                            }
                            
                            // Loading images indicator - subtle overlay when products are visible
                            if viewModel.areImagesLoading && !viewModel.products.isEmpty {
                                VStack {
                                    Spacer()
                                    Text("Loading images...")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                        .padding(6)
                                        .background(
                                            Capsule()
                                                .fill(Color.white.opacity(0.8))
                                                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                                        )
                                }
                                .padding(.bottom)
                            }
                        }
                    }
                    .padding(.top, 10)
                    .background(Color.white)
                    .clipShape(RoundedCorner(radius: 20, corners: [.topLeft, .topRight]))

                }
                .background(Color.gray.opacity(0.2))
                
            }
            .navigationDestination(item: $showProductDetail) { product in
                ProductDetailView(product: product, viewModel: viewModel)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        // User profile action would go here
                    } label: {
                        Circle()
                            .fill(Color(hex: "AACC00"))
                            .frame(width: 36, height: 36)
                            .overlay(
                                Image(systemName: "gearshape")
                                    .foregroundColor(.black)
                            )
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    // Delivery address bar
                    VStack(alignment: .center) {
                        Text("Delivery address")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text("92 High Street, London")
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                    
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // User profile action would go here
                    } label: {
                        Circle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 36, height: 36)
                            .overlay(
                                Image(systemName: "bell")
                                    .foregroundColor(.black)
                            )
                    }
                }
            }
        }
        .onAppear {
            if isFirstAppear {
                // Force loading on first appearance
                Task {
                    await viewModel.loadProducts()
                }
                isFirstAppear = false
            }
        }
    }
}
