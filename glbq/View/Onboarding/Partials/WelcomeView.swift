//
//  WelcomeView.swift
//  GLBQ
//
//  Created by Purvi Sancheti on 17/10/25.
//

import Foundation
import SwiftUI

struct WelcomeView: View {
    var body: some View {
        VStack(spacing: 0) {
            
            Spacer()
                .frame(height: isIPad ? ScaleUtility.scaledValue(375) : ScaleUtility.scaledValue(250))
            
            VStack(spacing: ScaleUtility.scaledSpacing(20)) {
                
                Image(.appLogo)
                    .resizable()
                    .frame(width: isIPad ? ScaleUtility.scaledValue(180) : ScaleUtility.scaledValue(120),
                           height: isIPad ? ScaleUtility.scaledValue(180) : ScaleUtility.scaledValue(120))
                
                
                VStack(spacing: ScaleUtility.scaledSpacing(5)) {
                    Text("Welcome to GLBQ")
                        .font(FontManager.generalSansMediumFont(size: .scaledFontSize(24)))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.appBlack)
                    
                    Text("Dream, Design and Transform your Garden with AI")
                        .font(FontManager.generalSansRegularFont(size: .scaledFontSize(14)))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.appBlack)
                }
            }
            
       
            Spacer()
            
            
        }
       
    }
}
