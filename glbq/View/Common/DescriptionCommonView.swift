//
//  DescriptionCommonView.swift
//  EveCraft
//
//  Created by Purvi Sancheti on 29/08/25.
//
// DescriptionCommonView.swift

import SwiftUI

struct DescriptionCommonView: View {
    var title: String
    var subtitle: String
    @Binding var descriptionText: String
    @FocusState.Binding var isInputFocused: Bool
    
    // MARK: - Character limit
    private let characterLimit = 1000
    
    // MARK: - Computed properties
    private var remainingCharacters: Int {
        characterLimit - descriptionText.count
    }
    
    private var isNearLimit: Bool {
        remainingCharacters <= 100
    }

    var body: some View {
        VStack(alignment: .leading, spacing: ScaleUtility.scaledSpacing(10)) {
            
            Text(title)
                .font(FontManager.generalSansMediumFont(size: .scaledFontSize(18)))
                .foregroundColor(Color.appBlack)
            
            ZStack(alignment: .bottomTrailing) {
                
                ZStack(alignment: .topLeading) {
          
                    if descriptionText.isEmpty {
                        Text(subtitle)
                            .font(FontManager.generalSansRegularFont(size: .scaledFontSize(14)))
                            .foregroundColor(Color.appBlack.opacity(0.5))
                    }
                    
                    // Always present the editor
                    CustomTextEditor(text: $descriptionText)
                        .font(FontManager.generalSansRegularFont(size: .scaledFontSize(14)))
                        .focused($isInputFocused)
                        .scrollContentBackground(.hidden)
                        .background(.clear)
                        .foregroundColor(Color.appBlack)
                        .offset(x: ScaleUtility.scaledSpacing(-3), y: ScaleUtility.scaledSpacing(-7))
                        .frame(height: ScaleUtility.scaledValue(56))
                }
                

                if descriptionText.count == 1000 {
                    Text("Character limit reached (1000)")
                        .font(FontManager.generalSansRegularFont(size: .scaledFontSize(10)))
                        .foregroundColor(.red)
                        .transition(.opacity)
                        .offset(x:ScaleUtility.scaledSpacing(-10),y:ScaleUtility.scaledSpacing(8))
                }
                
            }
            .padding(.leading, ScaleUtility.scaledSpacing(15))
            .frame(height: ScaleUtility.scaledValue(83))
            .frame(maxWidth: .infinity)
            .background(Color.primaryApp) // <- ensure the dot is here
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.appBlack.opacity(0.25), lineWidth: 1)
            )
            
            
        }
        .padding(.horizontal, ScaleUtility.scaledSpacing(15))
    }
}
