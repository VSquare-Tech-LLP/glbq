//
//  ToolsView.swift
//  glbq
//
//  Created by Purvi Sancheti on 11/10/25.
//

import Foundation
import SwiftUI

struct Card {
    let title: String
    let subtitle: String
    
}

struct ToolsCardView: View {
    
    let impactFeedback = UIImpactFeedbackGenerator(style: .light)
    
    @Binding var selectedTool: String
    
    var onClick: () -> Void
    
    var Cards: [Card] = [
        Card(title: "Add Objects",
             subtitle: "Insert new garden elements"),
        
        Card(title: "Remove Objects",
             subtitle: "Remove Unwanted Garden Parts"),
        
        Card(title: "Replace Objects",
             subtitle: "Swap items with ease"),
        
        Card(title: "Dream Garden",
             subtitle: "Create your perfect design"),
        
        Card(title: "AI Garden Recreator",
             subtitle: "Recreate with AI precision"),
        
    ]
    
    var body: some View {
        VStack(spacing: ScaleUtility.scaledSpacing(15)) {
            // First row - 2 cards
            HStack(spacing: ScaleUtility.scaledSpacing(15)) {
                cardView(card: Cards[0], index: 0)
                cardView(card: Cards[1], index: 1)
            }
            .padding(.horizontal, ScaleUtility.scaledSpacing(15))
            
            // Second row - 2 cards
            HStack(spacing: ScaleUtility.scaledSpacing(15)) {
                cardView(card: Cards[2], index: 2)
                cardView(card: Cards[3], index: 3)
            }
            .padding(.horizontal, ScaleUtility.scaledSpacing(15))
            
            // Third row - 1 full-width card
            cardView(card: Cards[4], index: 4, isFullWidth: true)
                .padding(.horizontal, ScaleUtility.scaledSpacing(15))
        }
        .padding(.top, ScaleUtility.scaledSpacing(23))
    }
    
    @ViewBuilder
    private func cardView(card: Card, index: Int, isFullWidth: Bool = false) -> some View {
        Button {
            impactFeedback.impactOccurred()
            selectedTool = card.title
            onClick()
        } label: {
            VStack(spacing: ScaleUtility.scaledSpacing(5)) {
                
                Image("toolCard\(index + 1)")
                    .resizable()
                    .frame(width: ScaleUtility.scaledValue(48), height: ScaleUtility.scaledValue(48))
                
                Text(card.title)
                    .font(FontManager.generalSansMediumFont(size: .scaledFontSize(14)))
                    .foregroundColor(Color.appBlack)
                
                Text(card.subtitle)
                    .font(FontManager.generalSansRegularFont(size: .scaledFontSize(10)))
                    .foregroundColor(Color.appBlack)
                
            }
            .frame(maxWidth: .infinity)
            .frame(width: isFullWidth ? nil : ScaleUtility.scaledValue(165),
                   height: ScaleUtility.scaledValue(165))
            .background(Color.primaryApp)
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)

        }

    }
}
