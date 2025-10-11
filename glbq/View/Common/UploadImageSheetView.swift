//
//  UploadImageSheetView.swift
//  glbq
//
//  Created by Purvi Sancheti on 11/10/25.
//

import Foundation
import SwiftUI

struct UploadImageSheetView: View {
    @Binding var showSheet: Bool
    var onCameraTap: () -> Void
    var onGalleryTap: () -> Void

    var body: some View {
        
        VStack(spacing: ScaleUtility.scaledSpacing(20)) {
            
                HStack(spacing: ScaleUtility.scaledSpacing(5)) {
                    
                    Image(.checkIcon)
                        .resizable()
                        .frame(width: ScaleUtility.scaledValue(22), height: ScaleUtility.scaledValue(22))
                    
                    Text("Good Photo Examples")
                        .font(FontManager.generalSansMediumFont(size: .scaledFontSize(18)))
                        .foregroundColor(Color.appBlack)
                }
                .frame(maxWidth: .infinity,alignment: .leading)
  
                
                HStack(spacing: ScaleUtility.scaledSpacing(4)) {
                    
                    Image(.reference1)
                        .resizable()
                        .frame(width:  isIPad ? ScaleUtility.scaledValue(163) : ScaleUtility.scaledValue(109),
                               height:  isIPad ? ScaleUtility.scaledValue(114) : ScaleUtility.scaledValue(76))
                    
                    Image(.reference2)
                        .resizable()
                        .frame(width:  isIPad ? ScaleUtility.scaledValue(163) : ScaleUtility.scaledValue(109),
                               height:  isIPad ? ScaleUtility.scaledValue(114) : ScaleUtility.scaledValue(76))
                    
                    Image(.reference3)
                        .resizable()
                        .frame(width:  isIPad ? ScaleUtility.scaledValue(163) : ScaleUtility.scaledValue(109),
                               height:  isIPad ? ScaleUtility.scaledValue(114) : ScaleUtility.scaledValue(76))
                }
                
                
                
                
                HStack(spacing: ScaleUtility.scaledSpacing(25)) {
                    
                    Button {
                        onCameraTap()
                        
                    } label: {
                        VStack(spacing: ScaleUtility.scaledSpacing(2)) {
                            Image(.cameraIcon)
                                .resizable()
                                .frame(width: ScaleUtility.scaledValue(42), height: ScaleUtility.scaledValue(42))
                            
                            Text("Camera")
                                .font(FontManager.generalSansRegularFont(size: .scaledFontSize(16)))
                                .kerning(0.32)
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color.appBlack)
                        }
                        .padding(.vertical,ScaleUtility.scaledSpacing(21))
                        .frame(maxWidth: .infinity)
                        .background(Color.primaryApp)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.accent, lineWidth: 1)
                        )
                    }
                    
                    Button {
                        onGalleryTap()
                        
                    } label: {
                        VStack(spacing: ScaleUtility.scaledSpacing(2)) {
                            Image(.galleryIcon)
                                .resizable()
                                .frame(width: ScaleUtility.scaledValue(42), height: ScaleUtility.scaledValue(42))
                            
                            Text("Gallery")
                                .font(FontManager.generalSansRegularFont(size: .scaledFontSize(16)))
                                .kerning(0.32)
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color.appBlack)
                        }
                        .padding(.vertical,ScaleUtility.scaledSpacing(21))
                        .frame(maxWidth: .infinity)
                        .background(Color.primaryApp)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.accent, lineWidth: 1)
                        )
                    }
                }
            
        }
        .padding(.horizontal,ScaleUtility.scaledSpacing(20))
        .padding(.top,ScaleUtility.scaledSpacing(15))
   
    }
}
