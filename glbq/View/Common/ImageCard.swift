//
//  ImageCard.swift
//  glbq
//
//  Created by Purvi Sancheti on 11/10/25.
//

import Foundation
import SwiftUI

struct ImageCard: View {
    let image: Image
    var onRemove: () -> Void
    let notificationFeedback = UINotificationFeedbackGenerator()
    var body: some View {
        // Base image card
        image
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity)
            .frame(height: ScaleUtility.scaledValue(245))
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .overlay(
                alignment: .topTrailing
            ) {
                Button(action:{
                    notificationFeedback.notificationOccurred(.success)
                    onRemove()
                
                }) {
                    Image(.crossIcon2)
                        .resizable()
                        .frame(
                            width: ScaleUtility.scaledValue(12),
                            height: ScaleUtility.scaledValue(12)
                        )
                        .padding(ScaleUtility.scaledSpacing(6))
                        .background {
                            Circle()
                                .fill(Color.appBlack.opacity(0.5))
                        }
                        .overlay(
                            Circle()
                                .stroke(Color.primaryApp.opacity(0.2), lineWidth: 1)
                        )
                
                }
                .padding(.top,ScaleUtility.scaledSpacing(15))
                .padding(.trailing,ScaleUtility.scaledSpacing(15))
            }
            // optional subtle border to match your style
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .strokeBorder(Color.accent, lineWidth: 1)
            )
            .padding(.horizontal, ScaleUtility.scaledSpacing(15))
    }
}
