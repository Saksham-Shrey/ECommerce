import SwiftUI
import UIKit

struct CartItemRow: View {
    let cartItem: CartItem
    let onToggleSelection: () -> Void
    let onIncrease: () -> Void
    let onDecrease: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            // Selection checkbox
            Button(action: onToggleSelection) {
                ZStack {
                    Circle()
                        .strokeBorder(Color.gray.opacity(0.3), lineWidth: 1)
                        .frame(width: 22, height: 22)
                    
                    if cartItem.isSelected {
                        Circle()
                            .fill(Color(hex: "AACC00"))
                            .frame(width: 22, height: 22)
                        
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.black)
                    }
                }
            }
            
            // Product image
            NetworkImage(url: cartItem.product.image, aspectRatio: .fit)
                .frame(width: 70, height: 70)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            // Product details
            VStack(alignment: .leading, spacing: 4) {
                Text(cartItem.product.title)
                    .font(.system(size: 14, weight: .medium))
                    .lineLimit(2)
                
                Text(String(format: "£%.2f", cartItem.product.price))
                    .font(.system(size: 15, weight: .bold))
            }
            
            Spacer()
            
            // Quantity controls
            HStack(spacing: 8) {
                Button(action: onDecrease) {
                    Image(systemName: "minus")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.black)
                        .frame(width: 24, height: 24)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                }
                
                Text("\(cartItem.quantity)")
                    .font(.system(size: 15, weight: .medium))
                    .frame(minWidth: 24)
                
                Button(action: onIncrease) {
                    Image(systemName: "plus")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.black)
                        .frame(width: 24, height: 24)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                }
            }
        }
        .padding(.vertical, 8)
    }
}

// For convenience, we'll add a color extension for hex codes
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
} 
