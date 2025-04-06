import Foundation
import SwiftUI

@MainActor
class ProductViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var cartItems: [CartItem] = []
    @Published var favoriteProducts: Set<Int> = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showError = false
    @Published var isRefreshing = false
    @Published var showThankYouMessage = false
    @Published var areImagesLoading = false
    
    private let networkService = NetworkService.shared
    
    // MARK: - Product Loading
    
    init() {
        // Start loading products immediately on init
        Task {
            await loadProducts()
        }
    }
    
    func loadProducts() async {
        if products.isEmpty && !isLoading {
            isLoading = true
        }
        
        do {
            // Fetch products from network or cache with high priority
            let simplifiedProducts = try await networkService.fetchProducts()
            
            // Convert simplified products to our Product model
            let convertedProducts = simplifiedProducts.map { simplified -> Product in
                Product(
                    id: simplified.id,
                    title: simplified.title,
                    price: simplified.price,
                    description: simplified.description,
                    category: simplified.category,
                    image: simplified.image,
                    rating: Product.Rating(
                        rate: simplified.rating.rate,
                        count: simplified.rating.count
                    )
                )
            }
            
            // Update UI with products immediately
            self.products = convertedProducts
            
            // Clear any previous errors
            self.errorMessage = nil
            self.showError = false
            
            // Start prefetching images in the background AFTER updating the UI
            prefetchProductImages(for: simplifiedProducts)
        } catch {
            if products.isEmpty {
                errorMessage = error.localizedDescription
                showError = true
            } else {
                // If we already have products, don't show the error and keep existing data
                print("Failed to refresh products: \(error.localizedDescription)")
            }
        }
        
        isLoading = false
        isRefreshing = false
    }
    
    private func prefetchProductImages(for products: [SimplifiedProduct]) {
        // Set flag to indicate image loading is in progress
        areImagesLoading = true
        
        // Use background task to prefetch images
        Task.detached(priority: .background) {
            await self.networkService.prefetchImagesFor(products: products)
            
            // Update UI on main thread when complete
            await MainActor.run {
                self.areImagesLoading = false
            }
        }
    }
    
    func refreshProducts() async {
        isRefreshing = true
        await loadProducts()
    }
    
    // MARK: - Cart Management
    
    var cartItemCount: Int {
        cartItems.reduce(0) { $0 + $1.quantity }
    }
    
    var totalCartPrice: Double {
        cartItems.reduce(0) { $0 + ($1.product.price * Double($1.quantity)) }
    }
    
    var formattedTotalPrice: String {
        String(format: "£%.2f", totalCartPrice)
    }
    
    func toggleFavorite(for product: Product) {
        if favoriteProducts.contains(product.id) {
            favoriteProducts.remove(product.id)
        } else {
            favoriteProducts.insert(product.id)
        }
    }
    
    func isProductFavorite(_ product: Product) -> Bool {
        favoriteProducts.contains(product.id)
    }
    
    func addToCart(product: Product) {
        if let index = cartItems.firstIndex(where: { $0.product.id == product.id }) {
            cartItems[index].quantity += 1
        } else {
            cartItems.append(CartItem(product: product))
        }
    }
    
    func removeFromCart(product: Product) {
        cartItems.removeAll { $0.product.id == product.id }
    }
    
    func increaseQuantity(for cartItem: CartItem) {
        if let index = cartItems.firstIndex(where: { $0.id == cartItem.id }) {
            cartItems[index].quantity += 1
        }
    }
    
    func decreaseQuantity(for cartItem: CartItem) {
        if let index = cartItems.firstIndex(where: { $0.id == cartItem.id }) {
            if cartItems[index].quantity > 1 {
                cartItems[index].quantity -= 1
            } else {
                cartItems.remove(at: index)
            }
        }
    }
    
    func toggleItemSelection(for cartItem: CartItem) {
        if let index = cartItems.firstIndex(where: { $0.id == cartItem.id }) {
            cartItems[index].isSelected.toggle()
        }
    }
    
    func selectAllItems(isSelected: Bool) {
        for index in cartItems.indices {
            cartItems[index].isSelected = isSelected
        }
    }
    
    var isAllSelected: Bool {
        !cartItems.isEmpty && cartItems.allSatisfy { $0.isSelected }
    }
    
    func checkout() {
        showThankYouMessage = true
        
        // Auto-dismiss after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.showThankYouMessage = false
            self.cartItems.removeAll()
        }
    }
} 