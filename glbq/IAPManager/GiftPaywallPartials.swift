//
//  GiftPaywallPartials.swift
//  EveCraft
//
//  Created by Purvi Sancheti on 02/09/25.
//

import Foundation
import SwiftUI

struct GiftPaywallBottomView: View {
    

    @EnvironmentObject var purchaseManager: PurchaseManager
    @EnvironmentObject var timerManager: TimerManager
    let closeGiftSheet: () -> Void
    let purchaseConfirm: () -> Void
    
    let notificationfeedback = UINotificationFeedbackGenerator()
    let impactfeedback = UIImpactFeedbackGenerator(style: .medium)
    let selectionfeedback = UISelectionFeedbackGenerator()
    

    
    var body: some View {
        
        if let product = purchaseManager.products.first(where: { $0.id == SubscriptionPlan.yearlygift.productId }),
           let lifetimePlan = purchaseManager.products.first(where: { $0.id == SubscriptionPlan.yearly.productId }) {
            
            let discountPrice = product.displayPrice
            let originalPrice = lifetimePlan.displayPrice
            
            //Extract numerical value from the prices
            let discountedPriceValue = Double(discountPrice.replacingOccurrences(of: "[^0-9.]", with: "", options: .regularExpression)) ?? 0
            let originalPriceValue = Double(originalPrice.replacingOccurrences(of: "[^0-9.]", with: "", options: .regularExpression)) ?? 0
            
            //calculate the discount percentage
            let discountPercentage = originalPriceValue > 0 ? round((originalPriceValue - discountedPriceValue) / originalPriceValue * 100) : 0
            ZStack(alignment: .topTrailing) {
                
                Color.primaryApp.ignoresSafeArea(.all)
                
                VStack(spacing: 0) {
                    
                    VStack(spacing: ScaleUtility.scaledSpacing(25)) {
                        
                        VStack(spacing: ScaleUtility.scaledSpacing(20)) {
                            
                            VStack(spacing: ScaleUtility.scaledSpacing(0)) {
                                if discountPercentage == 100 {
                                    Text("Free")
                                        .font(FontManager.generalSansSemiboldFont(size: .scaledFontSize(52)))
                                        .foregroundColor(Color.accent)
                                } else {
                                    Text("\(Int(discountPercentage))% off")
                                        .font(FontManager.generalSansSemiboldFont(size: .scaledFontSize(52)))
                                        .foregroundColor(Color.accent)
                                    
                                    
                                }
                                
                                Text("on Yearly Plan")
                                    .font(FontManager.generalSansMediumFont(size: .scaledFontSize(24)))
                                    .foregroundStyle(Color.appBlack)
                            }
                            
                            Text("Once you close this offer, it’s gone")
                                .font(FontManager.generalSansMediumFont(size: .scaledFontSize(18)))
                                .foregroundColor(Color.appBlack.opacity(0.6))
                            
                            
                        }
                        .padding(.top,ScaleUtility.scaledSpacing(25))
                        
                        
                        HStack(spacing: ScaleUtility.scaledValue(6)) {
                            if timerManager.isExpired {
                                Text("Offer expired")
                                    .font(FontManager.generalSansRegularFont(size: .scaledFontSize(24)))
                                    .foregroundColor(Color.appBlack)
                                  
                            }
                          
                                Text("Expires in")
                                    .font(FontManager.generalSansRegularFont(size: .scaledFontSize(24)))
                                    .foregroundColor(Color.appBlack)
                                   
                                
                                Text("\(timerManager.hours) : \(String(format: "%02d", timerManager.minutes)) : \(String(format: "%02d", timerManager.seconds))")
                                  .font(FontManager.generalSansRegularFont(size: .scaledFontSize(24)))
                                  .foregroundColor(Color.appRed2)
                              
                            
                        }
                        
                        ZStack(alignment: .topTrailing) {
                            VStack(spacing: 0) {
                                
                                VStack(alignment: .leading,spacing: ScaleUtility.scaledSpacing(25)) {
                                    Text("Limited time offer")
                                        .font(FontManager.generalSansMediumFont(size: .scaledFontSize(18)))
                                        .foregroundColor(Color.appBlack)
                                    
                                    VStack(spacing: ScaleUtility.scaledSpacing(5)) {
                                        
                                        Text("Just \(discountPrice)")
                                            .font(FontManager.generalSansSemiboldFont(size: .scaledFontSize(40)))
                                            .foregroundColor(Color.appBlack)
                                            .frame(maxWidth: .infinity, alignment: .topLeading)
                                        
                                        Text("Cheaper than the fee of an event planner")
                                            .font(FontManager.generalSansMediumFont(size: .scaledFontSize(14)))
                                            .foregroundColor(Color.appBlack.opacity(0.5))
                                            .frame(maxWidth: .infinity, alignment: .topLeading)
                                        
                                    }
                                    
                                }
                                
                            }
                            
                            Image(.tagIcon)
                                .resizable()
                                .frame(width: ScaleUtility.scaledValue(80), height: ScaleUtility.scaledValue(80))
                                .opacity(0.5)
                                .offset(x: ScaleUtility.scaledSpacing(-5),y: ScaleUtility.scaledSpacing(-5))
                            
                        }
                        .padding(.all, ScaleUtility.scaledSpacing(15))
                        .frame(height: ScaleUtility.scaledValue(157))
                        .background(Color.accent.opacity(0.2))
                        .cornerRadius(15)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.accent, lineWidth: 1)
                        )
                        .padding(.horizontal, ScaleUtility.scaledSpacing(25))
                    }
                    
                    Spacer()
                    
                    Button {
                        impactfeedback.impactOccurred()
                        Task {
                            
                            do {
                                try await purchaseManager.purchase(product)
                                if purchaseManager.hasPro {
                                    purchaseConfirm()
                                    notificationfeedback.notificationOccurred(.success)
//                                    AnalyticsManager.shared.log(.giftScreenPlanPurchase)
                                }
                            } catch {
                                notificationfeedback.notificationOccurred(.error)
                                print("Purchase failed: \(error)")
                                purchaseManager.isInProgress = false
                                purchaseManager.alertMessage = "Purchase Failed! Please try again or check your payment method."
                                purchaseManager.showAlert = true
                            }
                        }
                    } label: {
                        if purchaseManager.isInProgress {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                                    .tint(.white)
                           
                        }
                        else {
                            Text("Claim Now")
                                .font(FontManager.generalSansMediumFont(size: .scaledFontSize(18)))
                                .kerning(0.16)
                                .foregroundColor(Color.primaryApp)
                                .frame(maxWidth: .infinity)
                        }
               
                           
                    }
                    .frame(height: ScaleUtility.scaledValue(60))
                    .frame(maxWidth: .infinity)
                    .background(Color.accent)
                    .cornerRadius(15)
                    .opacity(purchaseManager.isInProgress ? 0.5 : 1)
                    .disabled(purchaseManager.isInProgress || timerManager.isExpired)
                    .padding(.horizontal, ScaleUtility.scaledSpacing(15))
                    .padding(.bottom, ScaleUtility.scaledSpacing(25))
                    
        
                    
                }
                .alert(isPresented: $purchaseManager.showAlert) {
                    Alert(
                        title: Text("Error"),
                        message: Text(purchaseManager.alertMessage),
                        dismissButton: .default(Text("OK"))
                    )
                }
                
                Button {
                    impactfeedback.impactOccurred()
                    closeGiftSheet()
                } label: {
                    Image(.crossIcon)
                        .resizable()
                        .frame(width: ScaleUtility.scaledValue(12.44444), height: ScaleUtility.scaledValue(12.44444))
                        .padding(.all, ScaleUtility.scaledSpacing(7.78))
                        .background{
                            Circle()
                                .fill(Color(red: 0.71, green: 0.71, blue: 0.71))
                        }
                        .padding(.trailing,ScaleUtility.scaledSpacing(15))
                        .padding(.top,ScaleUtility.scaledSpacing(15))
                }

            }
        }
    }
}
