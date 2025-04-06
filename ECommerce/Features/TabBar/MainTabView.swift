import SwiftUI

struct MainTabView: View {
    @StateObject private var viewModel = ProductViewModel()
    @State private var selectedTab: Tab = .home
    
    enum Tab {
        case home, catalog, cart, favorites, profile
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(viewModel: viewModel)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(Tab.home)
            
            Text("Catalog")
                .tabItem {
                    Label("Catalog", systemImage: "square.grid.2x2")
                }
                .tag(Tab.catalog)
            
            NavigationStack {
                CartView(viewModel: viewModel)
            }
                .tabItem {
                    Label("Cart", systemImage: "cart")
                }
                .tag(Tab.cart)
                .badge(viewModel.cartItemCount > 0 ? "\(viewModel.cartItemCount)" : "")
            
            Text("Favorites")
                .tabItem {
                    Label("Favorites", systemImage: "heart")
                }
                .tag(Tab.favorites)
            
            Text("Profile")
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
                .tag(Tab.profile)
        }
        .tint(Color(hex: "AACC00"))
        .onAppear {
            // Use SwiftUI's appearance modifiers where possible
            // Tab bar styling is mostly controlled by the system
        }
    }
}
