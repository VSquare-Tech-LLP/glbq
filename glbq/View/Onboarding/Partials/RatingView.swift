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
            
            ZStack(alignment: .top) {
                

                VStack(spacing: ScaleUtility.scaledSpacing(184)) {
                    
                    VStack(spacing: ScaleUtility.scaledSpacing(10)) {
                        
                        Text("Thanks for\nRating")
                            .font(FontManager.generalSansSemiboldFont(size: .scaledFontSize(42)))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color.appBlack)
                        
                        
                        
                        Text("Your rating helps design smarter gardens,\n one Rating at a time")
                            .font(FontManager.generalSansRegularFont(size: .scaledFontSize(16)))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color.appBlack)
                    }
                    
                    Image(.heartIcon)
                        .resizable()
                        .frame(width: isIPad ? ScaleUtility.scaledValue(297) :  ScaleUtility.scaledValue(198),
                               height:isIPad ? ScaleUtility.scaledValue(297) :  ScaleUtility.scaledValue(198))
                    
            
                    
                }
                .padding(.top, ScaleUtility.scaledSpacing(19))
                
                HStack(spacing: 0) {
                    
                    Image(.leftGrassIcon)
                        .resizable()
                        .frame(width: isIPad ?  ScaleUtility.scaledValue(75) : ScaleUtility.scaledValue(51),
                               height:  isIPad ?  ScaleUtility.scaledValue(321) : ScaleUtility.scaledValue(214))
                    
                    Spacer()
                    
                    Image(.rightGrassIcon)
                        .resizable()
                        .frame(width: isIPad ?  ScaleUtility.scaledValue(75) : ScaleUtility.scaledValue(51),
                               height:  isIPad ?  ScaleUtility.scaledValue(321) : ScaleUtility.scaledValue(214))
                    
                }
                .offset(y: ScaleUtility.scaledSpacing(-20))
                
            }
            
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
