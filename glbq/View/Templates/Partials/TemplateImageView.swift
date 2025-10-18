//
//  TemplateImageView.swift
//  glbq
//
//  Created by Purvi Sancheti on 14/10/25.
//

import Foundation
import SwiftUI

struct TemplateImageView: View {
    let imageName: String
    let index: Int
    let onTap: () -> Void
    
    let impactFeedback = UIImpactFeedbackGenerator(style: .light)
    
    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFill()
            .frame(width: isIPad ? ScaleUtility.scaledValue(355) : ScaleUtility.scaledValue(165),
                   height: (index / 2) % 2 == index % 2 ? isIPad ? ScaleUtility.scaledValue(267) : ScaleUtility.scaledValue(178) : isIPad ? ScaleUtility.scaledValue(234) : ScaleUtility.scaledValue(156))
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.25), radius: 4.7, x: 0, y: 4)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.appBlack.opacity(0.2), lineWidth: 1)
            )
            .onTapGesture {
                impactFeedback.impactOccurred()
                onTap()
            }
    }
}
