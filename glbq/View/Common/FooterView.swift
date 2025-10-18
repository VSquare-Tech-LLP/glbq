//
//
//
//  Created by Purvi Sancheti on 16/10/25.
//

import Foundation
import Foundation
import SwiftUI

struct FooterView: View {
    
    var onSave: () -> Void
    var onShare: () -> Void
    @Binding var generatedImage: UIImage?
    @Binding var buttonDisabled: Bool
    var body: some View {
        VStack(spacing: ScaleUtility.scaledSpacing(10)) {
            
            Button {
                onSave()
            } label: {
                HStack(spacing: ScaleUtility.scaledSpacing(5)) {
                    
                    Image(.downloadIcon)
                        .resizable()
                        .frame(width: ScaleUtility.scaledValue(24), height: ScaleUtility.scaledValue(24))
                    
                    Text("Save to Gallery")
                        .font(FontManager.generalSansMediumFont(size: .scaledFontSize(18)))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.primaryApp)
                    
                }
                .frame(height: ScaleUtility.scaledValue(60))
                .frame(maxWidth: .infinity)
                .background(Color.accent)
                .cornerRadius(15)
                .padding(.horizontal, ScaleUtility.scaledSpacing(15))
            }
            
            if let img = generatedImage {
                ShareLink(
                    item: ShareablePhoto(uiImage: img),
                    preview: SharePreview( "GLBQ Image", image: Image(uiImage: img))
                ) {
                    HStack(spacing: ScaleUtility.scaledSpacing(5)) {
                        
                        Image(.shareIcon)
                            .resizable()
                            .frame(width: ScaleUtility.scaledValue(24), height: ScaleUtility.scaledValue(24))
                        
                        Text("Share")
                            .font(FontManager.generalSansMediumFont(size: .scaledFontSize(18)))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.appBlack)
                    }
                    .frame(height: ScaleUtility.scaledValue(60))
                    .frame(maxWidth: .infinity)
                    .background(Color.accent.opacity(0.2))
                    .cornerRadius(15)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.accent, lineWidth: 1)
                    )
                    .padding(.horizontal, ScaleUtility.scaledSpacing(15))
                }
            }
            else {
                Button {
                    onShare()
                } label: {
                    HStack(spacing: ScaleUtility.scaledSpacing(5)) {
                        
                        Image(.shareIcon)
                            .resizable()
                            .frame(width: ScaleUtility.scaledValue(24), height: ScaleUtility.scaledValue(24))
                        
                        Text("Share")
                            .font(FontManager.generalSansMediumFont(size: .scaledFontSize(18)))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.appBlack)
                    }
                    .frame(height: ScaleUtility.scaledValue(60))
                    .frame(maxWidth: .infinity)
                    .background(Color.accent.opacity(0.2))
                    .cornerRadius(15)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.accent, lineWidth: 1)
                    )
                    .padding(.horizontal, ScaleUtility.scaledSpacing(15))
                }
            }
            
        }
    }
}
