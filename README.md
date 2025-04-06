# ECommerce iOS App

A professional e-commerce application built with SwiftUI, implementing industry best practices in iOS development. This application features a clean architecture, optimized performance, and a refined user interface.

## Features

### User Interface

- **Refined, Modern UI**: Following Apple's Human Interface Guidelines with smooth animations and transitions
- **Responsive Design**: Adapts to all iOS device sizes
- **Dark Mode Support**: Automatically adjusts to system appearance settings

### Shopping Experience

- **Product Catalog**: Displays products with images, titles, prices, and ratings
- **Categories**: Browse products by category with intuitive navigation
- **Product Details**: Comprehensive view with full product information and ratings
- **Search**: Real-time filtering of products
- **Favorites**: Save and manage favorite products for quick access
- **Cart Management**: Add, remove, and adjust quantities of items in cart
- **Flash Sales**: Special promotions with countdown timers

### Technical Features

- **Efficient Data Loading**: Fast startup and smooth browsing experience
- **Pull-to-Refresh**: Update product data with intuitive gesture
- **Optimized Image Loading**: Asynchronous loading with caching for performance
- **Network Resilience**: Graceful error handling
- **Background Prefetching**: Preloads data and images for seamless browsing
- **Responsive UI**: Maintains fluidity during network operations

## Architecture

### MVVM Design Pattern

- **Models**: Core data structures (`Product`, `CartItem`)
- **Views**: SwiftUI views with clear separation of concerns
- **ViewModels**: Business logic controllers managing state and operations

### Project Structure

```
ECommerce/
├── Core/
│   ├── Models/         # Data models
│   ├── Services/       # Network and data services
│   └── ViewModels/     # Business logic and state management
├── Features/
│   ├── Home/           # Main product browsing experience
│   ├── ProductDetail/  # Detailed product information
│   ├── Cart/           # Shopping cart functionality
│   └── TabBar/         # Main navigation structure
├── UI/
│   └── Components/     # Reusable UI elements
└── Assets.xcassets/    # Assets and resources
```

### Key Components

#### Core Services

- **NetworkService**: Actor-based networking with efficient caching
- **ProductViewModel**: Central state manager for product and cart operations

#### UI Components

- **NetworkImage**: Optimized async image loading with caching
- **ProductCard**: Reusable product display card
- **CartItemRow**: Interactive shopping cart item component
- **MainTabView**: Tab-based navigation structure

## Technical Implementation

### Modern Swift Features

- **Swift Concurrency**: Using `async/await` for clean asynchronous code
- **Actors**: Thread-safe data management with Swift actors
- **SwiftUI**: Declarative UI with the latest SwiftUI features

### Performance Optimizations

- **Image Caching**: Efficient memory management for product images
- **Background Processing**: Non-blocking data operations
- **Lazy Loading**: Just-in-time resource loading
- **Prefetching**: Anticipatory data loading for smooth browsing

### Networking

- **URLSession**: Configured for optimal performance and caching
- **REST API Integration**: Clean communication with [FakeStoreAPI](https://fakestoreapi.com)
- **JSON Decoding**: Swift Codable for type-safe data parsing
- **Error Handling**: Comprehensive network error management

## Getting Started

### Requirements

- Xcode 14.0 or later
- iOS 16.0 or later
- Swift 5.7 or later

### Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/yourusername/ECommerce.git
   cd ECommerce
   ```

2. Open the project in Xcode:

   ```bash
   open ECommerce.xcodeproj
   ```

3. Select a simulator or connected device and click Run

### Configuration

The application uses the [Fake Store API](https://fakestoreapi.com) for demonstration purposes. No API key is required.

## Best Practices

### Code Style

- **Clear Naming**: Descriptive, purpose-indicating names
- **Type Safety**: Leveraging Swift's strong type system
- **Value Types**: Preference for structs and enums
- **Immutability**: Using `let` over `var` where possible

### SwiftUI Patterns

- **Property Wrappers**: Appropriate use of `@State`, `@ObservedObject`, etc.
- **View Composition**: Breaking down complex views into reusable components
- **Environment Values**: Using `@Environment` for system-wide settings

## Future Enhancements

- User authentication and profiles
- Order history and tracking
- Payment integration
- Wishlist synchronization
- Enhanced product filtering and sorting
- Reviews and ratings submission
- Localization support
- Accessibility features including VoiceOver compatibility and Dynamic Type
- Offline support
- Unit, UI, and performance tests

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contributors

- Saksham Shrey - Initial development and architecture
