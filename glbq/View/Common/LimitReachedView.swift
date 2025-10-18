//
//  LimitReachedView.swift
//  EveCraft
//
//  Created by Purvi Sancheti on 23/09/25.
//

import Foundation
import SwiftUI
import StoreKit

struct LimitReachedView: View {
    @EnvironmentObject private var purchaseManager: PurchaseManager
    @EnvironmentObject private var userSettings: UserSettings
    @EnvironmentObject private var remoteConfigManager: RemoteConfigManager
    @Binding var isVisible: Bool
    
    @State private var processing: Bool = false
    @State private var isShowPayWall: Bool = false
    
    let impactfeedback = UIImpactFeedbackGenerator(style: .light)
    
    var dailyCap: Int
    var additionalQuota: Int
    var extensionProduct: Product?
    var triggeredByLimit: Bool = true
    
    
    var body: some View {
        let extensionPrice = extensionProduct?.displayPrice ?? "$0.00"
        ZStack {
            if isVisible {
                Color.appBlack.opacity(0.8)
                    .ignoresSafeArea(.all)
                    .onTapGesture {
                        if !processing {
                            impactfeedback.impactOccurred()
                            isVisible = false
                        }
                    }
                
                
                ZStack(alignment: .topTrailing) {
                    
                    
                    VStack(spacing: 0) {
                        
                        VStack(spacing: ScaleUtility.scaledSpacing(27)) {
                            
                            VStack(spacing: ScaleUtility.scaledSpacing(23)) {
                                
                                Image(.extendIcon)
                                    .resizable()
                                    .frame(width: ScaleUtility.scaledValue(50), height: ScaleUtility.scaledValue(72))
                                
                                VStack(spacing: ScaleUtility.scaledSpacing(10)) {
                                    
                                    Text("Daily Limit Reached")
                                        .font(FontManager.generalSansSemiboldFont(size: .scaledFontSize(20)))
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Color.appBlack)
                                     
                                    VStack(spacing: 0) {
                                        Text("You’ve reached your usage")
                                            .font(FontManager.generalSansMediumFont(size: .scaledFontSize(16)))
                                            .multilineTextAlignment(.center)
                                            .foregroundColor(Color.appBlack.opacity(0.5))
                                        
                                        
                                        Text("limit for today")
                                            .font(FontManager.generalSansMediumFont(size: .scaledFontSize(16)))
                                            .multilineTextAlignment(.center)
                                            .foregroundColor(Color.appBlack.opacity(0.5))
                                    }
                                    
                        
                                      
                                }
                            }
                            
                            
                            
                            Rectangle()
                                .foregroundColor(Color.appBlack.opacity(0.5))
                                .frame(width: ScaleUtility.scaledValue(140),height: ScaleUtility.scaledValue(1))
                            
                            
                            VStack(spacing: ScaleUtility.scaledSpacing(20)) {
                                
                                Text("Want more?")
                                  .font(FontManager.generalSansMediumFont(size: .scaledFontSize(26)))
                                  .multilineTextAlignment(.center)
                                  .foregroundColor(Color.appBlack)
                                  .frame(maxWidth: .infinity, alignment: .center)
                                
                                VStack(spacing: ScaleUtility.scaledSpacing(10)) {
                                    
                                    HStack(spacing: ScaleUtility.scaledSpacing(5)) {
                                        
                                        Text("For just")
                                            .font(FontManager.generalSansSemiboldFont(size: .scaledFontSize(20)))
                                            .multilineTextAlignment(.center)
                                            .foregroundColor(Color.appBlack)
                                        
                                        HStack(spacing: ScaleUtility.scaledSpacing(0)) {
                                            if let product = purchaseManager.products.first(where: { $0.id == SubscriptionPlan.limitExtension.productId }) {
                                                
                                                
                                                let limitExtensionPrice = product.displayPrice
                                                
                                                Text("\(limitExtensionPrice)")
                                                    .font(FontManager.generalSansSemiboldFont(size: .scaledFontSize(20)))
                                                    .multilineTextAlignment(.center)
                                                    .foregroundColor(Color.accent)
                                            }
                                            
                                            Text(",")
                                                .font(FontManager.generalSansSemiboldFont(size: .scaledFontSize(20)))
                                                .multilineTextAlignment(.center)
                                                .foregroundColor(Color.appBlack)
                                        }
                                        
                                    }
                                    
                                    VStack(spacing: 0) {
                                        
                                        Text("you can extend your limit and enjoy")
                                            .font(FontManager.generalSansMediumFont(size: .scaledFontSize(16)))
                                            .multilineTextAlignment(.center)
                                            .foregroundColor(Color.appBlack.opacity(0.5))
                                        
                                        Text("more images for the day!")
                                            .font(FontManager.generalSansMediumFont(size: .scaledFontSize(16)))
                                            .multilineTextAlignment(.center)
                                            .foregroundColor(Color.appBlack.opacity(0.5))
                                        
                                    }
                                       
                                }
                                
                            }
                            
                        }
                        .padding(.top,ScaleUtility.scaledSpacing(25))
                        
                        Spacer()
                        
                        Button {
                            impactfeedback.impactOccurred()
                            if purchaseManager.hasPro {
                                Task {
                                    if let product = purchaseManager.products.first(where: { $0.id == SubscriptionPlan.limitExtension.productId }) {
                                        processing = true
                                        do {
                                            let completed = try await purchaseManager.purchase(product)
                                            if completed {
                                                userSettings.extensionPurchasesToday += 1
                                                
                                                isVisible = false
                                            }
                                        } catch {
                                            // Could show separate alert if you want
                                        }
                                        processing = false
                                    }
                                }
                            } else {
                                isShowPayWall = true
                            }
                        } label: {
                            if processing {
                                ProgressView()
                                    .frame(maxWidth: .infinity)
                                    .tint(Color.primaryApp)
                            }
                            else
                            {
                                Text("Extend Limit")
                                  .font(FontManager.generalSansMediumFont(size: .scaledFontSize(18)))
                                  .multilineTextAlignment(.center)
                                  .foregroundColor(.primaryApp)
                           
                            }
                        }
                        .frame(height: ScaleUtility.scaledValue(58))
                        .frame(maxWidth: .infinity)
                        .background(Color.accent)
                        .cornerRadius(15)
                        .offset(y: ScaleUtility.scaledSpacing(15))
                    }
                    
                    Button {
                        if !processing {
                            impactfeedback.impactOccurred()
                            isVisible = false
                        }
                    } label: {
                        Image(.crossIcon)
                            .resizable()
                            .frame(width: ScaleUtility.scaledValue(12.44444), height: ScaleUtility.scaledValue(12.44444))
                            .padding(.all, ScaleUtility.scaledSpacing(7.78))
                            .background {
                                Circle()
                                    .fill(Color(red: 0.71, green: 0.71, blue: 0.71))
                            }
                    }
                    
                    
                }
                .padding(.all,ScaleUtility.scaledSpacing(15))
                .padding(.bottom,ScaleUtility.scaledSpacing(20))
                .background(Color.primaryApp)
                .cornerRadius(20)
                .frame(width: ScaleUtility.scaledValue(342), height:  ScaleUtility.scaledValue(481))
            }
        }
        .fullScreenCover(isPresented: $isShowPayWall) {
            
            PaywallView(isInternalOpen: true) {
             
                isShowPayWall = false
            } purchaseCompletSuccessfullyAction: {
        
                isShowPayWall = false
            }
        }
    }
}


#Preview {
    LimitReachedView(
        isVisible: .constant(true),
        dailyCap: 10,
        additionalQuota: 5,
        extensionProduct: nil,
        triggeredByLimit: true
    )
    .environmentObject(PurchaseManager())
    .environmentObject(UserSettings())
    .environmentObject(RemoteConfigManager())
}
