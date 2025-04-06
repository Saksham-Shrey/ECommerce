import Foundation

// Define a simple error type
enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case failedRequest(Error)
}

// A simplified product struct for immediate use
struct SimplifiedProduct: Identifiable, Codable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: String
    let image: String
    
    struct Rating: Codable {
        let rate: Double
        let count: Int
    }
    
    let rating: Rating
}

// Simplified actor that avoids using NSCache directly
actor NetworkService {
    static let shared = NetworkService()
    private let baseURL = "https://fakestoreapi.com"
    
    // Use simple dictionaries instead of NSCache to avoid sendability issues
    private var productsCache: Data?
    private var imageCache: [String: Data] = [:]
    private var loadedProducts: [SimplifiedProduct]?
    
    // Use standard URLSession
    private let session: URLSession
    
    private init() {
        // Configure a session with optimized settings
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 3
        config.timeoutIntervalForResource = 5
        config.requestCachePolicy = .returnCacheDataElseLoad
        session = URLSession(configuration: config)
    }
    
    func fetchProducts() async throws -> [SimplifiedProduct] {
        // Return cached products immediately if available
        if let loadedProducts = loadedProducts {
            return loadedProducts
        }
        
        // Check if data is cached
        if let cachedData = productsCache {
            do {
                let products = try JSONDecoder().decode([SimplifiedProduct].self, from: cachedData)
                self.loadedProducts = products
                
                // Refresh data in background even when returning cached data
                Task { try? await refreshProductsInBackground() }
                
                return products
            } catch {
                // If cache decoding fails, proceed with network request
                print("Failed to decode cached data: \(error.localizedDescription)")
            }
        }
        
        // Fetch from network if not cached
        guard let url = URL(string: "\(baseURL)/products") else {
            throw NetworkError.invalidURL
        }
        
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.invalidResponse
            }
            
            let products = try JSONDecoder().decode([SimplifiedProduct].self, from: data)
            
            // Cache the result
            self.productsCache = data
            self.loadedProducts = products
            
            return products
        } catch let error as DecodingError {
            print("Decoding error: \(error)")
            throw NetworkError.invalidData
        } catch {
            throw NetworkError.failedRequest(error)
        }
    }
    
    // Background refresh to keep data updated without blocking UI
    private func refreshProductsInBackground() async throws {
        guard let url = URL(string: "\(baseURL)/products") else { return }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else { return }
        
        let products = try JSONDecoder().decode([SimplifiedProduct].self, from: data)
        
        // Update cache and loaded products
        self.productsCache = data
        self.loadedProducts = products
    }
    
    func fetchImage(from urlString: String) async throws -> Data {
        // Check if image is cached
        if let cachedImage = imageCache[urlString] {
            return cachedImage
        }
        
        // Fetch from network if not cached
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        // Use a background task to load images
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }
        
        // Cache the image
        imageCache[urlString] = data
        
        return data
    }
    
    // Prefetch images for faster display
    func prefetchImagesFor(products: [SimplifiedProduct]) {
        Task.detached(priority: .background) {
            for product in products {
                do {
                    if await self.imageCache[product.image] == nil {
                        let _ = try await self.fetchImage(from: product.image)
                    }
                } catch {
                    // Silently fail on prefetch errors
                    print("Failed to prefetch image: \(error.localizedDescription)")
                }
            }
        }
    }
} 
