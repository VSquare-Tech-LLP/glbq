//
//  PaywallPartials.swift
//  EveCraft
//
//  Created by Purvi Sancheti on 02/09/25.
//

import Foundation
import SwiftUI
import StoreKit

struct PaywallHeaderView: View {
    
    @Binding var isShowCloseButton: Bool
    @Binding var isDisable: Bool
    let restoreAction: () -> Void
    let closeAction: () -> Void
    var isInternalOpen: Bool = false
    
    var delayCloseButton: Bool = false
    var delaySeconds: Double
    
    let impactfeedback = UIImpactFeedbackGenerator(style: .medium)
    
    @State private var isRestorePressed = false
    @State private var isCrossPressed = false
    
    @State private var isCountdownFinished = false   // NEW
    @State private var hasStartedCountdown = false   // NEW
    
    @State private var closeProgress: CGFloat = 0
    
    var body: some View {
        ZStack(alignment: .top) {
      
            Image(.paywall)
                  .resizable()
                  .aspectRatio(contentMode: .fill)
                  .frame(height: isIPad ? ScaleUtility.scaledValue(306) :   ScaleUtility.scaledValue(204))
                  .frame(maxWidth: .infinity)
                  .padding(.top,ScaleUtility.scaledSpacing(54))
            
            Image(.grassIcon2)
                .resizable()
                .frame(height: ScaleUtility.scaledValue(214))
                .frame(maxWidth: .infinity)
                .padding(.top,ScaleUtility.scaledSpacing(24))
     
            
            HStack(spacing: 0) {
                Button {
                    impactfeedback.impactOccurred()
                    restoreAction()
                } label: {
                    
                    Text("Restore")
                      .font(FontManager.generalSansMediumFont(size: .scaledFontSize(12)))
                      .multilineTextAlignment(.trailing)
                      .foregroundColor(.white)
                      .opacity(0.8)
                      .padding(10)
                      .background{
                          Capsule()
                              .fill(.appBlack.opacity(0.5))
                      }
                      .overlay(
                        Capsule()
                            .stroke(.primaryApp.opacity(0.1), lineWidth: 1)
                      )
                      .background(.ultraThinMaterial)
                      .clipShape(Capsule())
                    
                    
                    
//                    Image(.restoreIcon)
//                        .resizable()
//                        .frame(width: ScaleUtility.scaledValue(66),height: ScaleUtility.scaledValue(34))
                      
                    
                }
                .buttonStyle(PlainButtonStyle())
                .scaleEffect(isRestorePressed ? 0.95 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.5), value: isRestorePressed)
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in
                            withAnimation {
                                isRestorePressed = true
                            }
                        }
                        .onEnded { _ in
                            withAnimation {
                                isRestorePressed = false
                            }
                        }
                )
                .offset(x: ScaleUtility.scaledValue(-5),y: ScaleUtility.scaledValue(-3))
          
                
                Spacer()
                
                Button {
                    impactfeedback.impactOccurred()
                    closeAction()
                } label: {
                    Image(.crossIcon)
                        .resizable()
                        .frame(width: ScaleUtility.scaledValue(12.44445), height: ScaleUtility.scaledValue(12.44445))
                        .padding(.all,ScaleUtility.scaledSpacing(7.78))
                        .background{
                            Circle()
                                .fill(Color(red: 0.71, green: 0.71, blue: 0.71))
                        }
                        .overlay(
                            ZStack {
                                // Base ring
                                Circle()
                                    .stroke(
                                        delayCloseButton ? Color.appStroke : .appStokeFill,
                                        lineWidth: 2
                                    )
                                
                                // Animated white progress ring (only when delaying)
                                if delayCloseButton {
                                    Circle()
                                        .trim(from: 0, to: closeProgress)
                                        .stroke(Color.appStokeFill, style: StrokeStyle(lineWidth: 2, lineCap: .round))
                                        .rotationEffect(.degrees(-90)) // start at top
                                }
                            }
                        )
                }
                .disabled(isDisable || (delayCloseButton && closeProgress < 1))
                .buttonStyle(PlainButtonStyle())
                .opacity(isShowCloseButton ? 1 : 0)
                .scaleEffect(isCrossPressed ? 0.95 : 1.0)
                .padding(.trailing, ScaleUtility.scaledSpacing(5))
                .disabled(isDisable || (delayCloseButton && !isCountdownFinished)) // CHANGED
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in
                            withAnimation {
                                isCrossPressed = true
                            }
                        }
                        .onEnded { _ in
                            withAnimation {
                                isCrossPressed = false
                            }
                        }
                    
                )
                .onAppear {
                    guard !hasStartedCountdown else { return }  // prevent multiple starts
                    hasStartedCountdown = true

                    if delayCloseButton {
                        isCountdownFinished = false
                        closeProgress = 0

                        // Animate the ring visually
                        withAnimation(.linear(duration: delaySeconds)) {
                            closeProgress = 1
                        }

                        // Flip the gate AFTER the duration
                        DispatchQueue.main.asyncAfter(deadline: .now() + delaySeconds) {
                            withAnimation { isCountdownFinished = true }
                        }
                    } else {
                        closeProgress = 1
                        isCountdownFinished = true
                    }
                }
                .offset(x: ScaleUtility.scaledValue(5),y: ScaleUtility.scaledValue(-3))
            }
            .frame(height: 24 * heightRatio)
            .disabled(isDisable || (delayCloseButton && closeProgress < 1))
            .padding(.horizontal, ScaleUtility.scaledSpacing(15))
            .padding(.top,ScaleUtility.scaledSpacing(49))
        }
 

    }
}


struct PaywallProFeatureView: View {
    var body: some View {
        VStack(spacing: ScaleUtility.scaledSpacing(14)) {
            
            Text("Go GLBQ Pro")
                .font(FontManager.generalSansSemiboldFont(size: .scaledFontSize(28)))
                .multilineTextAlignment(.center)
                .foregroundColor(Color.appBlack)
            
            
            VStack(alignment: .leading,spacing: ScaleUtility.scaledSpacing(10)) {
                ForEach(PremiumFeature.allCases, id: \.title) { feature in
                    HStack(spacing: ScaleUtility.scaledSpacing(7)) {
                        Image(feature.image)
                            .resizeImage()
                            .frame(width: 28 * widthRatio, height: 28 * heightRatio)
                        
                        VStack(alignment: .leading, spacing: 0) {
                            Text(feature.title)
                                .font(FontManager.generalSansMediumFont(size: .scaledFontSize(15)))
                                .foregroundStyle(Color.appBlack)
                            
                        }
                    }
                }
            }
        }
    }
}


struct PaywallPlanView: View {
    
    @EnvironmentObject var remoteConfigManager: RemoteConfigManager
    @EnvironmentObject var purchaseManager: PurchaseManager
    @Binding var selectedPlan: SubscriptionPlan
    let plan: SubscriptionPlan


    let selectionFeedback = UISelectionFeedbackGenerator()
    
    var body: some View {
        if let product = purchaseManager.products.first(where: { $0.id == plan.productId }) {
            VStack(spacing: ScaleUtility.scaledSpacing(15)) {
                Button {
                    withAnimation {
                        selectionFeedback.selectionChanged()
                        selectedPlan = plan
                    }
                } label: {
                    HStack {
                        VStack(alignment: .leading,spacing: ScaleUtility.scaledSpacing(0)) {
                            
                            Text(plan.planName.uppercased())
                                .font(FontManager.generalSansRegularFont(size: .scaledFontSize(15)))
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color.appBlack.opacity(0.5))
                            
                            
                            Text(displayPriceText(for: plan, product: product))
                                .font(FontManager.generalSansMediumFont(size: .scaledFontSize(18)))
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color.appBlack)
                        }
                        
                        Spacer()
                        
                       
                        if plan.planName == "Yearly" && remoteConfigManager.isApproved {
                            
                            HStack(spacing: ScaleUtility.scaledSpacing(20)) {
                              
                                Rectangle()
                                    .foregroundColor(Color.accent)
                                    .frame(maxWidth: .infinity)
                                    .frame(width: ScaleUtility.scaledValue(1.5), height: ScaleUtility.scaledValue(40))
                                
                                VStack {
                                    
                                    Text("Save")
                                        .font(FontManager.generalSansRegularFont(size: .scaledFontSize(15)))
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Color.appBlack)
                  
                                    
                                    Text("90%")
                                        .font(FontManager.generalSansMediumFont(size: .scaledFontSize(20)))
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Color.appBlack)
                                      
                                }
                                
                            }
                        }
                    }
                    .padding(.horizontal,ScaleUtility.scaledSpacing(20))
                    .frame(height: ScaleUtility.scaledValue(60))
                    .frame(maxWidth: .infinity)
                    .background {
                        if selectedPlan == plan {
                            LinearGradient(
                                stops: [
                                    Gradient.Stop(color: Color(red: 0.49, green: 0.91, blue: 0.25), location: 0.00),
                                    Gradient.Stop(color: Color(red: 0.49, green: 0.91, blue: 0.25).opacity(0.1), location: 1.00),
                                ],
                                startPoint: UnitPoint(x: 0, y: 0.5),
                                endPoint: UnitPoint(x: 1, y: 0.5)
                            )
                        }
                        else {
                            Color.primaryApp
                        }
                           
                    }
                    .cornerRadius(15)
                    .overlay {
                        if selectedPlan == plan  {
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.accent,lineWidth: 1)
                        }
                    }
                    .padding(.horizontal,ScaleUtility.scaledSpacing(15))
                   
                }
            }
        }
    }
    func displayPriceText(for plan: SubscriptionPlan, product: Product) -> String {
        switch plan {
          case .weekly:
            return  product.displayPrice + " / week"
          case .yearly:
            let price = product.price
              if remoteConfigManager.isApproved {
              let weekPrice = price / 52
              return weekPrice.formatted(product.priceFormatStyle) + " / week"
            } else {
              return product.displayPrice + " / year"
            }
         case .yearlygift:
            return product.displayPrice + " / year"
        case .limitExtension:
            return product.displayPrice
        }
    }
}



struct PaywallBottmView: View{
    let isProcess: Bool
    @EnvironmentObject var remoteConfigManager: RemoteConfigManager
    @EnvironmentObject var purchaseManager: PurchaseManager
    @Binding var selectedPlan: SubscriptionPlan
    let tryForFreeAction: () -> Void
    @Environment(\.openURL) var openURL
    
    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
    
    var body: some View {
        VStack(spacing: ScaleUtility.scaledSpacing(10)) {
            
            Button {
                impactFeedback.impactOccurred()
                tryForFreeAction()
            } label: {
                if isProcess {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .tint(Color.primaryApp)
                }
                else {
                    Text("Continue")
                      .font(FontManager.generalSansMediumFont(size: .scaledFontSize(18)))
                      .multilineTextAlignment(.center)
                      .foregroundColor(Color.primaryApp)
                      .frame(maxWidth: .infinity)
                }
            }
            .frame(height: ScaleUtility.scaledValue(60))
            .frame(maxWidth: .infinity)
            .background(Color.accent)
            .cornerRadius(15)
            .padding(.horizontal,ScaleUtility.scaledSpacing(15))

            if let product = purchaseManager.products.first(where: { $0.id == selectedPlan.productId }) {
                Text(displayPriceText(for: selectedPlan, product: product))
                    .font(FontManager.generalSansMediumFont(size: .scaledFontSize(20)))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.appBlack)
                    .frame(maxWidth: .infinity, alignment: .top)
            }
            
            Text("Auto-Renews. Cancel Anytime.")
              .font(FontManager.generalSansMediumFont(size: .scaledFontSize(14)))
              .multilineTextAlignment(.center)
              .foregroundColor(Color.appBlack.opacity(0.5))
  
            HStack(spacing: ScaleUtility.scaledSpacing(6)) {
                
                Button {
                    impactFeedback.impactOccurred()
                    openURL(URL(string: AppConstant.privacyURL)!)
                } label: {
                    Text("Privacy Policy")
                        .font(FontManager.generalSansMediumFont(size: .scaledFontSize(14)))
                        .foregroundColor(Color.appBlack.opacity(0.8))
                }
                .buttonStyle(PlainButtonStyle())
 
                Text(" | ")
                    .font(FontManager.generalSansMediumFont(size: .scaledFontSize(14)))
                    .foregroundColor(Color.appBlack.opacity(0.8))
                
                Button {
                    impactFeedback.impactOccurred()
                    openURL(URL(string: AppConstant.termsAndConditionURL)!)
                } label: {
                    Text("Terms of use")
                        .font(FontManager.generalSansMediumFont(size: .scaledFontSize(14)))
                        .foregroundColor(Color.appBlack.opacity(0.8))
                }
                .buttonStyle(PlainButtonStyle())
     
            }
            .frame(maxWidth: .infinity)
            
         
        }
    }
    
    func displayPriceText(for plan: SubscriptionPlan, product: Product) -> String {
        switch plan {
          case .weekly:
            return  product.displayPrice + " / Week"
          case .yearly:
            return  product.displayPrice + " / Year"
         case .yearlygift:
            return product.displayPrice + " / Year"
        case .limitExtension:
            return product.displayPrice
        }
    }
}
