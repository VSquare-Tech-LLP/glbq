//
//  AdsAlertView.swift
//  EveCraft
//
//  Created by Purvi Sancheti on 04/09/25.
//

import Foundation
import SwiftUI

struct AdsAlertView: View {
    
    @State private var isPayButtonPressed = false
    @State private var isWatchAdsButtonPressed = false
    @State private var isCrossButtonPressed = false
    let impactfeedback = UIImpactFeedbackGenerator(style: .light)
    var needPremium: () -> Void
    var watchAds: () -> Void
    var closeAction: () -> Void
    
    var body: some View {
        VStack {
         
            VStack(spacing: ScaleUtility.scaledSpacing(24)) {
                    
                    VStack(spacing: ScaleUtility.scaledSpacing(12)) {
                        
                        
                        HStack(spacing: ScaleUtility.scaledSpacing(48)) {
                            
                            Spacer()
                            
                            Text("Proceed to Design")
                                .font(FontManager.generalSansSemiboldFont(size: .scaledFontSize(18)))
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color.appBlack)
                            
                            
                            Button {
                                impactfeedback.impactOccurred()
                                closeAction()
                            } label: {
                                Image(.crossIcon4)
                                    .resizable()
                                    .frame(width: ScaleUtility.scaledValue(13.09091), height: ScaleUtility.scaledValue(13.09091))
                                    .padding(.all, ScaleUtility.scaledSpacing(5.45))
                                    .background{
                                        Circle()
                                            .fill(Color.black.opacity(0.16))
                                            .opacity(0.5)
                                    }
                            }
                       
                            
                        }
                        
                        Text("Watch an ad or get Pro plan\nto skip ads forever.")
                          .font(FontManager.generalSansMediumFont(size: .scaledFontSize(16)))
                          .multilineTextAlignment(.center)
                          .foregroundColor(Color.appBlack)
                          .opacity(0.5)
                
                        
                    }
                    
                    VStack(spacing: ScaleUtility.scaledSpacing(14)) {
                        
                        
                        Button {
                            impactfeedback.impactOccurred()
                            needPremium()
                        } label: {
                            HStack(spacing: ScaleUtility.scaledSpacing(18)) {
                                Image(.crownIcon2)
                                    .resizable()
                                    .frame(width: ScaleUtility.scaledValue(20), height: ScaleUtility.scaledValue(20))
                                
                                Text("Get Premium")
                                    .font(FontManager.generalSansMediumFont(size: .scaledFontSize(16)))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color.primaryApp)
                                
                            }
                            .padding(.vertical,ScaleUtility.scaledSpacing(15))
                            .frame(maxWidth:.infinity)
                            .background(Color.accent)
                            .cornerRadius(10)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        
                        
                        Button {
                            impactfeedback.impactOccurred()
                            watchAds()
                        } label: {
                            HStack(spacing: ScaleUtility.scaledSpacing(16)) {
                                Image(.watchAdsIcon)
                                    .resizable()
                                    .frame(width: ScaleUtility.scaledValue(20), height: ScaleUtility.scaledValue(20))
                                
                                Text("Watch an Ad")
                                    .font(FontManager.generalSansMediumFont(size: .scaledFontSize(16)))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color.appBlack)
                                
                            }
                            .frame(maxWidth:.infinity)
                            .padding(.vertical,ScaleUtility.scaledSpacing(15))
                            .frame(maxWidth:.infinity)
                            .background(Color.accent.opacity(0.3))
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.accent, lineWidth: 1)
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        
                    }
                    
                }
     
        
        }
        .padding(.all,ScaleUtility.scaledSpacing(15))
        .background(Color.primaryApp)
        .cornerRadius(20)
        .padding(.horizontal, isIPad ? ScaleUtility.scaledSpacing(154) : ScaleUtility.scaledSpacing(24))
    }
}
