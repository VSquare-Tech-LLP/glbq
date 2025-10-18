//
//  OnboardingView.swift
//  EveCraft
//
//  Created by Purvi Sancheti on 02/09/25.
//



import Foundation
import SwiftUI

struct OnboardingView: View {
    var imageName: String
    var title: String
    var screenIndex: Int
    @Binding var currentScreenIndex: Int
    
    // Animation state - Start COMPLETELY off screen
    @State private var leftLeafOffset: CGFloat = -400
    @State private var rightLeafOffset: CGFloat = 400
    @State private var textOpacity: Double = 0
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .top) {
                
                Text(title)
                    .font(FontManager.generalSansSemiboldFont(size: .scaledFontSize(32)))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.appBlack)
                    .padding(.top, ScaleUtility.scaledSpacing(20))
                
                HStack(spacing: 0) {
                    
                    Image(.leftGrassIcon)
                        .resizable()
                        .frame(width: isIPad ?  ScaleUtility.scaledValue(75) : ScaleUtility.scaledValue(51),
                               height:  isIPad ?  ScaleUtility.scaledValue(321) : ScaleUtility.scaledValue(214))
                    
                    Spacer()
                    
                    Image(.rightGrassIcon)
                        .resizable()
                        .frame(width: isIPad ?  ScaleUtility.scaledValue(75) : ScaleUtility.scaledValue(51),
                               height:  isIPad ?  ScaleUtility.scaledValue(321) : ScaleUtility.scaledValue(214))
                    
                }
                .offset(y: ScaleUtility.scaledSpacing(-20))
            }
            
            Spacer()
        }
        .overlay(alignment: .bottom) {
            
            ZStack {
                
                Image(imageName)
                    .resizable(size: CGSize(
                        width: isIPad ? 750 * ipadWidthRatio : ScaleUtility.scaledValue(375) ,
                        height: isIPad ? 1148 * ipadHeightRatio : ScaleUtility.scaledValue(612) ))
                    .offset(y: ScaleUtility.scaledSpacing(40))
                
                
                Image(.overlayImg)
                    .resizable()
                    .frame( height: isIPad ? 1148 * ipadHeightRatio : ScaleUtility.scaledValue(612))
                    .frame(maxWidth: .infinity)
                    .offset(y: ScaleUtility.scaledSpacing(40))
                
            }
        }
    }
}
