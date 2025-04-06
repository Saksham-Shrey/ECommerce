import Foundation

struct Product: Identifiable, Codable, Equatable, Hashable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: String
    let image: String
    let rating: Rating
    
    struct Rating: Codable, Equatable, Hashable {
        let rate: Double
        let count: Int
    }
    
    static func == (lhs: Product, rhs: Product) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// Sample product for previews and testing
extension Product {
    static var sample: Product {
        Product(
            id: 1,
            title: "Nintendo Switch, Gray",
            price: 169.00,
            description: "The Nintendo Switch gaming console is a compact device that can be taken everywhere. This portable super device is also equipped with 2 gamepads.",
            category: "electronics",
            image: "https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg",
            rating: Rating(rate: 4.8, count: 117)
        )
    }
    
    static var samples: [Product] {
        [
            sample,
            Product(
                id: 2,
                title: "Nintendo Switch Lite, Yellow",
                price: 109.00,
                description: "Dedicated to handheld play, Nintendo Switch Lite is perfect for gamers on the move.",
                category: "electronics",
                image: "https://fakestoreapi.com/img/71pWzhdJNwL._AC_UL640_QL65_ML3_.jpg",
                rating: Rating(rate: 4.6, count: 89)
            ),
            Product(
                id: 3,
                title: "The Legend of Zelda: Tears of the Kingdom",
                price: 39.00,
                description: "An epic adventure across the land and skies of Hyrule awaits in this sequel to The Legend of Zelda: Breath of the Wild.",
                category: "games",
                image: "https://fakestoreapi.com/img/71li-ujtlUL._AC_UX679_.jpg",
                rating: Rating(rate: 4.9, count: 212)
            )
        ]
    }
} 