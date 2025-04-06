import SwiftUI

struct NetworkImage: View {
    let url: String
    let aspectRatio: ContentMode
    
    enum ImagePriority {
        case high, normal, low
    }
    
    // Increase priority for images in visible UI
    let priority: ImagePriority
    
    init(url: String, aspectRatio: ContentMode = .fit, priority: ImagePriority = .normal) {
        self.url = url
        self.aspectRatio = aspectRatio
        self.priority = priority
    }
    
    var body: some View {
        // Start with placeholder to ensure immediate display
        AsyncImage(url: URL(string: url), transaction: Transaction(animation: .easeInOut(duration: 0.2))) { phase in
            switch phase {
            case .empty:
                // Show placeholder immediately
                placeholderView
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: aspectRatio)
                    .scaledToFit()
                    .transition(.opacity)
            case .failure:
                // Show error placeholder
                errorPlaceholderView
            @unknown default:
                placeholderView
            }
        }
        .clipped() // Explicitly clip any overflowing content
    }
    
    // Lightweight placeholder that displays immediately
    private var placeholderView: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.1))
            .overlay {
                Image(systemName: "photo")
                    .font(.system(size: 20))
                    .foregroundColor(.gray.opacity(0.5))
            }
    }
    
    // Error placeholder
    private var errorPlaceholderView: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.1))
            .overlay {
                Image(systemName: "exclamationmark.triangle")
                    .font(.system(size: 20))
                    .foregroundColor(.gray.opacity(0.5))
            }
    }
}

// Custom environment key for image loading priority
private struct ImageLoadingPriorityKey: EnvironmentKey {
    static let defaultValue: ImageLoadingPriority = .normal
}

enum ImageLoadingPriority {
    case high, normal, low
}

extension EnvironmentValues {
    var imageLoadingPriority: ImageLoadingPriority {
        get { self[ImageLoadingPriorityKey.self] }
        set { self[ImageLoadingPriorityKey.self] = newValue }
    }
} 
