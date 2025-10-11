//
//  DesignThemesView.swift
//  glbq
//
//  Created by Purvi Sancheti on 11/10/25.
//

import Foundation
import SwiftUI

struct DesignTheme {
    let name: String
    let imageName: String
    let prompt: String
}

struct DesignThemesView: View {
    
    let selectionFeedback = UISelectionFeedbackGenerator()
    @Binding var selectedTheme: String
    var DesignThemes: [DesignTheme] = [
        
        DesignTheme(name: "Luxury",
              imageName: "dummyImage1",
              prompt: "A birthday party with balloons, one cake on a table, seating area, fairy lights, confetti, and a lively, joyful atmosphere in a modern venue, professional photo"),
        
        DesignTheme(name: "Modern",
              imageName: "dummyImage1",
              prompt: "A romantic wedding venue with floral arches, elegant aisle décor, candlelit tables, chandeliers, fairy lights, and a sunset backdrop, cinematic lighting, high realism"),
        
        DesignTheme(name: "Asian",
            imageName: "dummyImage1",
            prompt: "Anniversary celebration with candlelit dinner table, roses, soft golden lighting, champagne glasses, cozy seating for a couple, elegant and warm atmosphere"),
        
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: ScaleUtility.scaledSpacing(15)) {
                
                Text("Design Theme")
                    .font(FontManager.generalSansMediumFont(size: .scaledFontSize(18)))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, ScaleUtility.scaledSpacing(15))
                
                ScrollView(.horizontal,showsIndicators: false) {
                    
                    HStack(spacing: ScaleUtility.scaledSpacing(10)) {
                        
                        ForEach(Array(DesignThemes.enumerated()), id: \.offset) { index, theme in
                            
                            let isSelected = (selectedTheme == theme.name)
                            
                            VStack(spacing: ScaleUtility.scaledSpacing(5)) {
                                
                                Button(action: {
                                    selectionFeedback.selectionChanged()
                                    if isSelected  {
                                        selectedTheme = ""
                                        
                                    }
                                    else {
                                        selectedTheme = theme.name
                                    }
                                }) {
                                    ZStack {
                                        if selectedTheme == theme.name {
                                            RoundedRectangle(cornerRadius: 13)
                                                .frame(width: isIPad ?  ScaleUtility.scaledValue(207) : ScaleUtility.scaledValue(138),
                                                       height: isIPad ? ScaleUtility.scaledValue(136) : ScaleUtility.scaledValue(91))
                                                .foregroundColor(Color.clear)
                                                .background(Color.primaryApp)
                                                .overlay {
                                                    RoundedRectangle(cornerRadius: 13)
                                                        .stroke(Color.accent, lineWidth: 3)
                                                        .frame(width: isIPad ?  ScaleUtility.scaledValue(207) : ScaleUtility.scaledValue(138),
                                                               height: isIPad ? ScaleUtility.scaledValue(136) : ScaleUtility.scaledValue(91))
                                                    
                                                }
                                                .cornerRadius(13)
                                        }
                                        
                                        Image(theme.imageName)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: isIPad ?  ScaleUtility.scaledValue(198) :  ScaleUtility.scaledValue(132),
                                                   height: isIPad ?  ScaleUtility.scaledValue(127)  : ScaleUtility.scaledValue(85))
                                            .overlay {
                                                RoundedRectangle(cornerRadius: 10)
                                                    .inset(by: -0.5)
                                                    .stroke(.appBlack.opacity(0.2), lineWidth: 1)
                                            }
                                        
                                    }
                                    
                                }
                                
                                Text(theme.name)
                                    .font( selectedTheme == theme.name ? FontManager.generalSansMediumFont(size: .scaledFontSize(14)) : FontManager.generalSansRegularFont(size: .scaledFontSize(14)))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color.appBlack)
                            }
                            
                        }
                    }
                    .padding(.horizontal, ScaleUtility.scaledSpacing(15))
                    
                }
                
            }
         
        }
    }
}
