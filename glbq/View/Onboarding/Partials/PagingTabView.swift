//
//  PagingTabView.swift
//  EveCraft
//
//  Created by Purvi Sancheti on 02/09/25.
//


import Foundation
import SwiftUI


struct PagingTabView<Content: View>: View {
    @Binding var selectedIndex: Int
    let tabCount: Int
    let spacing: CGFloat
    let content: () -> Content
    var indicatorRequired: Bool = true
    var buttonAction: () -> Void
    
  
    let impactfeedback = UIImpactFeedbackGenerator(style: .light)

    
    var body: some View {
        ZStack(alignment:.bottom) {
            
            // TabView with Paging Style
            TabView(selection: $selectedIndex) {
                content()
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // Hide default dots
            
            //Custom Page Indicator
            
            VStack(spacing: ScaleUtility.scaledSpacing(15)) {
                
                HStack(spacing: ScaleUtility.scaledSpacing(10)) {
                    
                    HStack(spacing: ScaleUtility.scaledSpacing(3)) {
                        ForEach(0..<tabCount, id: \.self) { index in
                            Group {
                                if selectedIndex == index {
                                    Rectangle()
                                        .frame(width: isIPad
                                               ? ScaleUtility.scaledValue(14) * widthRatio
                                               : ScaleUtility.scaledValue(14),
                                               height:  isIPad
                                               ? ScaleUtility.scaledValue(6) * heightRatio
                                               : ScaleUtility.scaledValue(6))
                                        .foregroundColor(Color.accent)
                                        .cornerRadius(3)
                                    
                                } else {
                                    Circle()
                                        .frame(width: isIPad
                                               ? ScaleUtility.scaledValue(6) * widthRatio
                                               :  ScaleUtility.scaledValue(6),
                                               height: isIPad
                                               ? ScaleUtility.scaledValue(6) * heightRatio
                                               :  ScaleUtility.scaledValue(6))
                                        .foregroundColor(Color.appBlack.opacity(0.2))
                                }
                            }
                        }
                    }
                 
                    
                }
                .animation(.easeInOut, value: selectedIndex)
                .frame(maxWidth: .infinity)
                .opacity(indicatorRequired ? 1 : 0)
                
                
                Button(action: {
                    impactfeedback.impactOccurred()
                    buttonAction()
                    print("Button Clicked")
            
                })
                {
                    Text("Continue")
                      .font(FontManager.generalSansMediumFont(size: .scaledFontSize(18)))
                      .multilineTextAlignment(.center)
                      .foregroundColor(.white)
                      .frame(height: ScaleUtility.scaledValue(60))
                      .frame(maxWidth: .infinity)
                      .background(Color.accent)
                      .cornerRadius(15)
                      .padding(.horizontal, ScaleUtility.scaledSpacing(15))
                      .zIndex(1)

                }
                .zIndex(1)
                
            }
            .padding(.bottom, isSmallDevice ? ScaleUtility.scaledSpacing(20) : ScaleUtility.scaledSpacing(40))
            

        }
        .background(Color.primaryApp)
        .edgesIgnoringSafeArea(.all)
    }
}

