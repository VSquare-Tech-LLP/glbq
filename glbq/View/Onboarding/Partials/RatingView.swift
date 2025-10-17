//
//  RatingView.swift
//  EveCraft
//
//  Created by Purvi Sancheti on 02/09/25.
//


import Foundation
import SwiftUI
import StoreKit

struct RatingView: View {
    var body: some View
    {
        VStack {
            
            VStack(spacing: ScaleUtility.scaledSpacing(184)) {
                
                VStack(spacing: ScaleUtility.scaledSpacing(10)) {
                    
                    VStack(spacing: 0) {
                        Text("Thanks for ")
                            .font(FontManager.generalSansSemiboldFont(size: .scaledFontSize(42)))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color.appBlack)
                        
                        Text("Rating")
                            .font(FontManager.generalSansSemiboldFont(size: .scaledFontSize(60)))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color.appBlack)
                    }
                    
                    Text("You are helping the world craft\n events smartly with AI.")
                        .font(FontManager.generalSansRegularFont(size: .scaledFontSize(16)))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.appBlack)
                }
                
                Image(.heartIcon)
                    .resizable()
                    .frame(width: isIPad ? ScaleUtility.scaledValue(223) :  ScaleUtility.scaledValue(198),
                           height:isIPad ? ScaleUtility.scaledValue(281) :  ScaleUtility.scaledValue(198))
        
                  
                  
            }
            .padding(.top, ScaleUtility.scaledSpacing(42.86))
            
            Spacer()
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1)
            {
                showRatingPopup()
            }
        }
 
    }
    
    func showRatingPopup() {
        let userSettings = UserSettings() // Get user settings instance
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
            if userSettings.ratingPopupCount < 1  {
                if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                    SKStoreReviewController.requestReview(in: scene)
                    
                    // Increment the rating count
                    userSettings.ratingPopupCount += 1
                    

                }
            }
        }
    }
}
