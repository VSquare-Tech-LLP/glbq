//
//  UploadContainer.swift
//  glbq
//
//  Created by Purvi Sancheti on 11/10/25.
//

import Foundation
import SwiftUI

struct UploadContainer: View {
    
    var onClick: () -> Void
    @State private var uploadButtonPressed = false
    
    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
    
    var body: some View {
        Button {
            impactFeedback.impactOccurred()
            onClick()
        } label: {
            VStack(spacing: ScaleUtility.scaledSpacing(9)) {
                Image(.uploadIcon)
                    .resizable()
                    .frame(width: ScaleUtility.scaledValue(50), height: ScaleUtility.scaledValue(50))
                    .opacity(0.9)
                
                Text("Upload Garden Photo")
                    .font(FontManager.generalSansRegularFont(size: .scaledFontSize(16)))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.accent)
                    .frame(maxWidth: .infinity, alignment: .top)
                
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, ScaleUtility.scaledSpacing(81))
            .background(.primaryApp)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .inset(by: -0.5)
                    .stroke(Color.appBlack.opacity(0.25), style: StrokeStyle(lineWidth: 1, dash: [4, 4]))
            )
            .padding(.horizontal, ScaleUtility.scaledSpacing(15))
        }
    }
}
