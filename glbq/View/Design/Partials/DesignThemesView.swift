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
    var text: String
    var isOptional: Bool
    @Binding var selectedTheme: String
    var DesignThemes: [DesignTheme] = [
        
        DesignTheme(name: "Modern",
              imageName: "dummyImage1",
              prompt: "Create a sleek modern garden with clean geometric paths, minimal plants, stone tiles, and stylish outdoor furniture in neutral tones. No people."),
        
        DesignTheme(name: "Luxury",
              imageName: "dummyImage1",
              prompt: "Create an elegant luxury garden with a central pool, marble flooring, sculpted hedges, warm lighting, and premium lounge seating. No people."),
        
        DesignTheme(name: "Cozy",
            imageName: "dummyImage1",
            prompt: "Create a warm cozy garden with wooden furniture, soft string lights, potted flowers, and a comfortable, homey atmosphere. No people."),
        
        DesignTheme(name: "Asian",
            imageName: "dummyImage1",
            prompt: "Create a serene Asian garden with bamboo, stone lanterns, a koi pond, and a small wooden bridge surrounded by greenery. No people."),
        
        DesignTheme(name: "Tropical",
            imageName: "dummyImage1",
            prompt: "Create a vibrant tropical garden with palm trees, colorful flowers, wooden decking, and a sunny island resort vibe. No people."),
        
        DesignTheme(name: "Minimal",
            imageName: "dummyImage1",
            prompt: "Create a clean minimal garden with simple stone pathways, sparse plants, neutral tones, and open space for calm balance. No people."),
        
        DesignTheme(name: "Rustic",
            imageName: "dummyImage1",
            prompt: "Create a charming rustic garden with wooden fences, wildflowers, a stone path, and natural textures for a countryside feel. No people."),
        
        DesignTheme(name: "Classic",
            imageName: "dummyImage1",
            prompt: "Create a timeless classic garden with symmetrical hedges, a central fountain, elegant benches, and neatly trimmed greenery. No people."),
        
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: ScaleUtility.scaledSpacing(15)) {
                
                HStack(spacing: 5) {
                    Text(text)
                        .font(FontManager.generalSansMediumFont(size: .scaledFontSize(18)))
                        .foregroundColor(.black)
                        
                    
                    if isOptional {
                        
                        Text("(optional)")
                            .font(FontManager.generalSansMediumFont(size: .scaledFontSize(15)))
                            .foregroundColor(Color.appBlack.opacity(0.5))
                        
                    }
                    
                    Spacer()
                  
                }
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
                                  
                                            RoundedRectangle(cornerRadius: 13)
                                            .frame(width: isIPad ?  ScaleUtility.scaledValue(210) : ScaleUtility.scaledValue(140),
                                                   height: isIPad ? ScaleUtility.scaledValue(139) : ScaleUtility.scaledValue(93))
                                                .foregroundColor(Color.clear)
                                                .background(selectedTheme == theme.name ? Color.primaryApp : Color.clear)
                                                .overlay {
                                                    if selectedTheme == theme.name {
                                                        RoundedRectangle(cornerRadius: 13)
                                                            .stroke(Color.accent, lineWidth: 3)
                                                            .stroke(Color.accent, lineWidth: 5)
                                                            .frame(width: isIPad ?  ScaleUtility.scaledValue(210) : ScaleUtility.scaledValue(140),
                                                                   height: isIPad ? ScaleUtility.scaledValue(139) : ScaleUtility.scaledValue(93))
                                                    }
                                                    
                                                }
                                                .cornerRadius(13)
                                        
                                        
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
