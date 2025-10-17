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
                .frame(height: ScaleUtility.scaledValue(250))
            
            VStack(spacing: ScaleUtility.scaledSpacing(20)) {
                
                Image(.appLogo)
                    .resizable()
                    .frame(width: ScaleUtility.scaledValue(120), height: ScaleUtility.scaledValue(120))
                
                
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
        .background(Color.primaryApp).ignoresSafeArea(.all)
    }
}
