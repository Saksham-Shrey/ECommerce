import SwiftUI
import UIKit

struct ProductDetailView: View {
    let product: Product
    @ObservedObject var viewModel: ProductViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Product Image
                NetworkImage(url: product.image, aspectRatio: .fit)
                    .frame(height: 300)
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(8)
                    .padding(.horizontal)
                
                // Product Info Section
                VStack(alignment: .leading, spacing: 16) {
                    // Title
                    Text(product.title)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    // Ratings
                    HStack(spacing: 12) {
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .foregroundColor(Color.green)
                            
                            Text(String(format: "%.1f", product.rating.rate))
                                .fontWeight(.medium)
                            
                            Text("\(product.rating.count)")
                                .foregroundColor(.secondary)
                            
                            Text("reviews")
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                                .minimumScaleFactor(0.6)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(Color.gray.opacity(0.1))
                        )
                        
                        HStack {
                            Text("\(Int(product.rating.rate * 20))%")
                                .fontWeight(.medium)
                            
                            Text("satisfaction")
                                .foregroundColor(.secondary)
                                .minimumScaleFactor(0.6)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(Color(hex: "AACC00").opacity(0.3))
                        )
                        
                        HStack {
                            Image(systemName: "bubble.left")
                            Text("8")
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(Color.gray.opacity(0.1))
                        )
                    }
                    .font(.subheadline)
                    
                    // Price
                    HStack {
                        Text(String(format: "£%.2f", product.price))
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("from £\(Int(product.price / 3)) per month")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    // Description
                    Text("Description")
                        .font(.headline)
                        .padding(.top, 8)
                    
                    Text(product.description)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .lineSpacing(4)
                    
                    Spacer()
                }
                .padding()
            }
            
            Button {
                viewModel.addToCart(product: product)
                dismiss()
            } label: {
                Text("Add to cart")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .background(Color(hex: "AACC00"))
                    .cornerRadius(25)
                    .padding(.horizontal)
            }
            
            // Delivery info
            HStack {
                Text("Delivery on 26 October")
                    .font(.caption)
                    .foregroundColor(.primary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 5)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbarBackgroundVisibility(.hidden, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.toggleFavorite(for: product)
                } label: {
                    Image(systemName: viewModel.isProductFavorite(product) ? "heart.fill" : "heart")
                        .foregroundColor(viewModel.isProductFavorite(product) ? .red : .gray)
                        .background {
                            Circle()
                                .fill(Color.gray.opacity(0.4))
                                .frame(width: 40, height: 40)
                        }
                    
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    // Share functionality would go here
                } label: {
                    Image(systemName: "square.and.arrow.up")
                        .background {
                            Circle()
                                .fill(Color.gray.opacity(0.4))
                                .frame(width: 40, height: 40)
                        }
                    
                }
            }
            
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .background {
                            Circle()
                                .fill(Color.gray.opacity(0.4))
                                .frame(width: 40, height: 40)
                        }
                }
            }
        }
    }
}
