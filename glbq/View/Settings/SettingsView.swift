//
//  SettingsView.swift
//  glbq
//
//  Created by Purvi Sancheti on 15/10/25.
//

import Foundation
import SwiftUI


struct SettingsView: View {
    
    var onBack: () -> Void
    
    var body: some View {
        VStack(spacing: ScaleUtility.scaledSpacing(0)) {
            VStack(spacing: ScaleUtility.scaledSpacing(25)) {
                
                HStack {
                    
                    HStack(spacing: ScaleUtility.scaledSpacing(14)) {
                        
                        Button {
                            onBack()
                        } label: {
                            Image(.backIcon)
                                .resizable()
                                .frame(width: ScaleUtility.scaledValue(24), height: ScaleUtility.scaledValue(24))
                        }
                        
                        
                        Text("Settings")
                            .font(FontManager.generalSansMediumFont(size: .scaledFontSize(22)))
                            .foregroundColor(Color.appBlack)
                    }
                    
                    Spacer()
                    
                }
                .padding(.horizontal, ScaleUtility.scaledSpacing(15))
                .padding(.top, ScaleUtility.scaledSpacing(65))
                
                
                TryProContainerView()
                
                SettingsCardsView()
            }
            
            Spacer()
            
        }
        .navigationBarHidden(true)
        .background {
            Image(.appBg)
                .resizable()
                .frame(maxWidth: .infinity,maxHeight: .infinity)
        }
        .ignoresSafeArea(.all)
    }
}
