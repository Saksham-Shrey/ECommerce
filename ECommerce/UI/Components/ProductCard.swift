import SwiftUI

struct ProductCard: View {
    let product: Product
    let onFavoriteToggle: () -> Void
    let isFavorite: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .topTrailing) {
                // Image container with fixed dimensions and proper constraints
                VStack {
                    AsyncImage(url: URL(string: product.image)) { phase in
                        switch phase {
                        case .empty:
                            Rectangle()
                                .fill(Color.gray.opacity(0.1))
                                .overlay {
                                    Image(systemName: "photo")
                                        .font(.system(size: 20))
                                        .foregroundColor(.gray.opacity(0.5))
                                }
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                        case .failure:
                            Rectangle()
                                .fill(Color.gray.opacity(0.1))
                                .overlay {
                                    Image(systemName: "exclamationmark.triangle")
                                        .font(.system(size: 20))
                                        .foregroundColor(.gray.opacity(0.5))
                                }
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 150)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                
                Button(action: onFavoriteToggle) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(isFavorite ? .red : .gray)
                        .font(.system(size: 18, weight: .semibold))
                        .padding(8)
                        .background(Circle().fill(.white.opacity(0.8)))
                }
                .padding(8)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(product.title)
                    .font(.system(size: 14, weight: .semibold))
                    .lineLimit(2)
                    .foregroundColor(.primary)
                    .frame(height: 40, alignment: .topLeading)
                
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(Color.green)
                        .font(.system(size: 12))
                    
                    Text(String(format: "%.1f", product.rating.rate))
                        .font(.system(size: 12, weight: .medium))
                    
                    Text("(\(product.rating.count))")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.secondary)
                }
                
                Text(String(format: "£%.2f", product.price))
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.primary)
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        )
    }
} 