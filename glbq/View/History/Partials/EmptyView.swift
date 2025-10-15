//
//  EmptyView.swift
//  glbq
//
//  Created by Purvi Sancheti on 15/10/25.
//

import Foundation
import SwiftUI

struct EmptyView: View {
    var startDesign: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            
            Spacer()
                .frame(height: ScaleUtility.scaledValue(189))
            
            VStack(spacing: 0) {
                
                VStack(spacing: ScaleUtility.scaledSpacing(25)) {
                    
                    VStack(spacing: ScaleUtility.scaledSpacing(4)) {
                        
                        Image(.emptyIcon)
                            .resizable()
                            .frame(width: ScaleUtility.scaledValue(82), height: ScaleUtility.scaledValue(82))
                        
                        
                        // Cards Filled
                        Text("No Garden Designs Yet")
                            .font(FontManager.generalSansMediumFont(size: .scaledFontSize(14)))
                            .foregroundColor(Color.appBlack.opacity(0.5))
                    }
                    
                    Button {
                        startDesign()
                    } label: {
                        Text("Start Designing")
                            .font(FontManager.generalSansMediumFont(size: .scaledFontSize(18)))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.primaryApp)
                            .frame(width: ScaleUtility.scaledValue(213), height: ScaleUtility.scaledValue(52))
                            .background(Color.accent)
                            .cornerRadius(15)
                    }
                    
                }
            }
            
        }
    }
}
