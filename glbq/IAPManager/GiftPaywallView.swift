//
//  GiftPaywallView.swift
//  EveCraft
//
//  Created by Purvi Sancheti on 02/09/25.
//

import Foundation
import SwiftUI

struct GiftPaywallView: View {
  
    @EnvironmentObject var timerManager: TimerManager
    @EnvironmentObject var purchaseManager: PurchaseManager
    @Binding var isCollectGift: Bool
    @State var plan = SubscriptionPlan.yearlygift
    let closeGift: () -> Void
    let giftPurchaseComplete: () -> Void
    let notificationFeedback = UINotificationFeedbackGenerator()
    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
    let selectionFeedback = UISelectionFeedbackGenerator()
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: isIPad ? ScaleUtility.scaledSpacing(219) : ScaleUtility.scaledSpacing(146)) {
                VStack(spacing: ScaleUtility.scaledSpacing(17)) {
                    
                    VStack(spacing: ScaleUtility.scaledSpacing(2)) {
                        
                        HStack {
                            
                            Spacer()
                            
                            Button {
                                impactFeedback.impactOccurred()
                                closeGift()
                            } label: {
                                Image(.crossIcon)
                                    .resizable()
                                    .frame(width: ScaleUtility.scaledValue(12.44444), height: ScaleUtility.scaledValue(12.44444))
                                    .padding(.all, ScaleUtility.scaledSpacing(7.78))
                                    .background{
                                        Circle()
                                            .fill(Color(red: 0.71, green: 0.71, blue: 0.71))
                                    }
                            }

                       
                        }
                        .padding(.trailing, ScaleUtility.scaledSpacing(17))
                        
                        Text("Collect Gift")
                            .font(FontManager.generalSansMediumFont(size: .scaledFontSize(24)))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color.appBlack.opacity(0.6))
                            .frame(maxWidth: .infinity, alignment: .top)
                    }
                    
                    if let product = purchaseManager.products.first(where: { $0.id == SubscriptionPlan.yearlygift.productId }),
                       let lifetimePlan = purchaseManager.products.first(where: { $0.id == SubscriptionPlan.yearly.productId }) {
                        
                        let discountPrice = product.displayPrice
                        let originalPrice = lifetimePlan.displayPrice
                        
                        //Extract numerical value from the prices
                        let discountedPriceValue = Double(discountPrice.replacingOccurrences(of: "[^0-9.]", with: "", options: .regularExpression)) ?? 0
                        let originalPriceValue = Double(originalPrice.replacingOccurrences(of: "[^0-9.]", with: "", options: .regularExpression)) ?? 0
                        
                        //calculate the discount percentage
                        let discountPercentage = originalPriceValue > 0 ? round((originalPriceValue - discountedPriceValue) / originalPriceValue * 100) : 0
                            
                        VStack(spacing: 0) {
                            Text("\(Int(discountPercentage))% off")
                                .font(FontManager.generalSansSemiboldFont(size: .scaledFontSize(62)))
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color.accent)
                            
                            Text("on Yearly Plan")
                                .font(FontManager.generalSansRegularFont(size: .scaledFontSize(28)))
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color.appBlack)
                        }
                    }
                }
               
               Image(.giftIcon)
                   .resizable()
                   .frame(width: isIPad ? ScaleUtility.scaledValue(270) : ScaleUtility.scaledValue(180),
                          height: isIPad ? ScaleUtility.scaledValue(270) : ScaleUtility.scaledValue(180))
              
            }
            .padding(.top, ScaleUtility.scaledSpacing(59))
            
            Spacer()
            
            Button {
                impactFeedback.impactOccurred()
                self.isCollectGift = true
            } label: {
                Text("Collect Gift")
                    .font(FontManager.generalSansMediumFont(size: .scaledFontSize(18)))
                    .foregroundColor(Color.primaryApp)
                    .frame(height: ScaleUtility.scaledValue(60))
                    .frame(maxWidth: .infinity)
               
            }
            .background(Color.accent)
            .cornerRadius(15)
            .padding(.horizontal,ScaleUtility.scaledSpacing(15))
            .padding(.bottom,ScaleUtility.scaledSpacing(25))

     
        }
        .background {
            Image(.appBg)
                .resizable()
                .frame(maxWidth: .infinity,maxHeight: .infinity)
        }
        .ignoresSafeArea(.all)
        .sheet(isPresented: $isCollectGift) {
            GiftPaywallBottomView(
                    closeGiftSheet: {
                        self.isCollectGift = false
//                        AnalyticsManager.shared.log(.giftBottomSheetXClicked)
                    }, purchaseConfirm: giftPurchaseComplete)
                .frame(height: isIPad ? ScaleUtility.scaledValue(655) : ScaleUtility.scaledValue(523) )
                .background(Color.primaryApp)
                .presentationDetents([.height( isIPad ? ScaleUtility.scaledValue(750) : ScaleUtility.scaledValue(523))])
                .presentationCornerRadius(20)

            
        }
    }
}
