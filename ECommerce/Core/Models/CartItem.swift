import Foundation

struct CartItem: Identifiable, Equatable {
    let id: UUID
    let product: Product
    var quantity: Int
    var isSelected: Bool = true
    
    init(product: Product, quantity: Int = 1, isSelected: Bool = true) {
        self.id = UUID()
        self.product = product
        self.quantity = quantity
        self.isSelected = isSelected
    }
} 