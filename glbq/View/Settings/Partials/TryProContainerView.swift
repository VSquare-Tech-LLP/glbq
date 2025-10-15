//
//  TryProContainerView.swift
//  EveCraft
//
//  Created by Purvi Sancheti on 28/08/25.
//


import Foundation
import SwiftUI

struct TryProContainerView: View {
    
    @State var isShowPayWall: Bool = false
    let notificationfeedback = UINotificationFeedbackGenerator()
    let impactfeedback = UIImpactFeedbackGenerator(style: .heavy)
    let selectionfeedback = UISelectionFeedbackGenerator()
//    @EnvironmentObject var purchaseManager: PurchaseManager
    @State private var isProContainerButtonPressed = false
    
    var body: some View {
        VStack(spacing: 0) {
            Button {
                impactfeedback.impactOccurred()
//                if !purchaseManager.hasPro {
//                    isShowPayWall = true
//                }
            } label: {
                HStack {
                    VStack(alignment: .leading,spacing:ScaleUtility.scaledSpacing(4)) {
                    
                        Text("Access all features")
                            .font(FontManager.generalSansMediumFont(size: .scaledFontSize(16)))
                            .foregroundColor(Color.primaryApp)
                        
                        Text("Upgrade to pro")
                            .font(FontManager.generalSansRegularFont(size: .scaledFontSize(14)))
                            .foregroundColor(Color.primaryApp.opacity(0.6))
                        
                    }
                    .padding(.leading,ScaleUtility.scaledSpacing(20))
                    
                    Spacer()
                    
                    Image(.tryProIcon )
                        .resizable()
                        .frame(width: ScaleUtility.scaledValue(114),
                               height:  ScaleUtility.scaledValue(39))
                        .padding(.trailing,ScaleUtility.scaledSpacing(20))
                    
                }
                .frame(maxWidth: .infinity)
                .background {
                    Color.accent
                        .frame(maxWidth: .infinity)
                        .frame(height: ScaleUtility.scaledValue(75))
                        .cornerRadius(15)
                }
                .padding(.horizontal,ScaleUtility.scaledSpacing(20))
           
            }
            .buttonStyle(PlainButtonStyle())
            .scaleEffect(isProContainerButtonPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.5), value: isProContainerButtonPressed)
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        withAnimation {
                            isProContainerButtonPressed = true
                        }
                    }
                    .onEnded { _ in
                        withAnimation {
                            isProContainerButtonPressed = false
                        }
                    }
            )
//            .fullScreenCover(isPresented: $isShowPayWall) {
//                
//                PaywallView(isInternalOpen: true) {
//                    isShowPayWall = false
//                } purchaseCompletSuccessfullyAction: {
//                    isShowPayWall = false
//                }
//            }
        }
        .padding(.top,ScaleUtility.scaledSpacing(17))
    }
}

