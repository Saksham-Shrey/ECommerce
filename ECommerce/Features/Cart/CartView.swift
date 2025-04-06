import SwiftUI
import UIKit

struct CartView: View {
    @ObservedObject var viewModel: ProductViewModel
    @State private var showThankYou = false
    
    var body: some View {
        
        VStack(spacing: 0) {
            VStack {
                VStack {
                    // Address bar
                    HStack {
                        Text("92 High Street, London")
                            .font(.subheadline)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.05))
                    .cornerRadius(8)
                    .padding(.horizontal)
                }
                .padding(.bottom, 10)
                .background(Color.white)
                .clipShape(
                    RoundedCorner(radius: 20, corners: [.bottomLeft, .bottomRight])
                )
                
                VStack {
                    // Cart items list
                    ScrollView {
                        if viewModel.cartItems.isEmpty {
                            VStack(spacing: 20) {
                                Image(systemName: "cart")
                                    .font(.system(size: 60))
                                    .foregroundColor(.gray)
                                    .padding(.top, 80)
                                
                                Text("Your cart is empty")
                                    .font(.headline)
                                
                                Text("Add items to get started")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, 50)
                        } else {
                            // Select all checkbox
                            HStack {
                                Button {
                                    viewModel.selectAllItems(isSelected: !viewModel.isAllSelected)
                                } label: {
                                    ZStack {
                                        Circle()
                                            .strokeBorder(Color.gray.opacity(0.3), lineWidth: 1)
                                            .frame(width: 22, height: 22)
                                        
                                        if viewModel.isAllSelected {
                                            Circle()
                                                .fill(Color(hex: "AACC00"))
                                                .frame(width: 22, height: 22)
                                            
                                            Image(systemName: "checkmark")
                                                .font(.system(size: 12, weight: .bold))
                                                .foregroundColor(.black)
                                        }
                                    }
                                }
                                
                                Text("Select all")
                                    .font(.system(size: 14, weight: .medium))
                                
                                Spacer()
                                
                                HStack(spacing: 4) {
                                    Button {
                                        // Share action would go here
                                    } label: {
                                        Image(systemName: "square.and.arrow.up")
                                            .foregroundColor(.primary)
                                    }
                                    
                                    Button {
                                        // Edit action would go here
                                    } label: {
                                        Image(systemName: "pencil")
                                            .foregroundColor(.primary)
                                    }
                                }
                                .font(.system(size: 16))
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 12)
                            
                            Divider()
                            
                            // Cart items
                            VStack(spacing: 0) {
                                ForEach(viewModel.cartItems) { item in
                                    CartItemRow(
                                        cartItem: item,
                                        onToggleSelection: {
                                            viewModel.toggleItemSelection(for: item)
                                        },
                                        onIncrease: {
                                            viewModel.increaseQuantity(for: item)
                                        },
                                        onDecrease: {
                                            viewModel.decreaseQuantity(for: item)
                                        }
                                    )
                                    .padding(.horizontal)
                                    
                                    if item.id != viewModel.cartItems.last?.id {
                                        Divider()
                                            .padding(.leading, 104)
                                    }
                                }
                            }
                        }
                    }
                    
                    if !viewModel.cartItems.isEmpty {
                        Spacer()
                        
                        // Checkout button
                        Button {
                            viewModel.checkout()
                        } label: {
                            Text("Checkout")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                                .frame(height: 50)
                                .frame(maxWidth: .infinity)
                                .background(Color(hex: "AACC00"))
                                .cornerRadius(25)
                                .padding(.horizontal)
                        }
                        .padding(.bottom)
                    }
                }
                .padding(.top, 10)
                .background(Color.white)
                .clipShape(
                    RoundedCorner(radius: 20, corners: [.topLeft, .topRight])
                )
            }
        }
        .background(Color.white)
        .toolbarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Text("Cart")
                    .font(.largeTitle)
                    .foregroundColor(.black)
                    .bold()
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    // Clear cart action would go here
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundStyle(Color.black)
                        .background {
                            Circle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 40, height: 40)
                        }
                }
            }
        }
        .alert("Thank You!", isPresented: $viewModel.showThankYouMessage) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Your order has been placed successfully.")
        }
    }
}
