//
//  StyleTypeView.swift
//  glbq
//
//  Created by Purvi Sancheti on 15/10/25.
//




import Foundation
import SwiftUI

struct Style {
    let name: String
    let imageName: String
    let prompt: String
}

struct StyleTypeView: View {
    
    let selectionFeedback = UISelectionFeedbackGenerator()
    
    var isOptional: Bool
    
    @Binding var selectedStyle: String
    @Binding var text: String
    
    var styles: [Style] = [
        Style(name: "Luxury",
              imageName: "Luxury",
              prompt: "Elegant luxury event venue, chandeliers, gold accents, marble floor, stylish table setup, cinematic lighting, high-end design, professional photo"),
        
        Style(name: "Minimal",
              imageName: "Minimal",
              prompt: "Minimalist event venue, clean lines, simple tables, neutral colors, clutter-free, modern aesthetic, professional photo"),
        
        Style(name: "Playful",
            imageName: "Playful",
            prompt: "Playful party event venue, bright colors, balloons, confetti, fun décor, cheerful vibe, professional photo"),
        
        Style(name: "Romantic",
              imageName: "Romantic",
              prompt: "Romantic event venue, candles, roses, soft lighting, pastel colors, dreamy atmosphere, professional photo"),
        
        Style(name: "Bohemian",
            imageName: "Bohemian",
            prompt: "Bohemian event venue, earthy tones, macramé décor, floral accents, relaxed vibe, professional photo"),
        
        Style(name: "Vintage",
            imageName: "Vintage",
            prompt: "Vintage event venue, retro furniture, sepia tones, antique props, nostalgic aesthetic, professional photo"),
        
        Style(name: "Tropical",
            imageName: "Tropical",
            prompt: "Tropical event venue, palm leaves, bamboo furniture, tiki lights, beachy colors, sunny vibe, professional photo"),
        
        Style(name: "Cozy",
            imageName: "Cozy",
            prompt: "Cozy home event venue, warm lighting, wooden furniture, soft blankets, inviting atmosphere, professional photo"),
        
        Style(name: "Rustic",
            imageName: "Rustic",
            prompt: "Rustic event venue, barn wood tables, string lights, wildflowers, countryside charm, professional photo"),
        
        Style(name: "Artistic",
            imageName: "Artistic",
            prompt: "Artistic event venue, bold colors, abstract patterns, creative murals, modern art vibe, professional photo"),
        
    ]
    
    var body: some View {
        VStack {
            VStack(spacing: ScaleUtility.scaledSpacing(10)) {
                
                HStack {
                    Text(text)
                        .font(FontManager.generalSansMediumFont(size: .scaledFontSize(18)))
                        .foregroundColor(Color.appBlack)
                      
                       
                    if isOptional {
                        
                        Text("(Optional)")
                            .font(FontManager.generalSansRegularFont(size: .scaledFontSize(10)))
                            .foregroundColor(Color.appBlack.opacity(0.5))
                        
                    }
                }
                .frame(maxWidth: .infinity,alignment: .leading)
                .padding(.leading, ScaleUtility.scaledSpacing(15))
                
                ScrollView(.horizontal,showsIndicators: false) {
                    HStack(spacing: ScaleUtility.scaledSpacing(10)) {
                        
                        ForEach(Array(styles.enumerated()), id: \.offset) { index, style in
                            
//                            let isSelected = (selectedDesign == style.name)

//                            Button {
//                                selectionFeedback.selectionChanged()
//                                if isSelected  {
//                                    selectedDesign = ""
//                           
//                                }
//                                else {
//                                    selectedDesign = style.name
//                                }
//                                
//                            } label: {
//                                
//                                
//                             Image(style.imageName)
//                                .resizable()
//                                .aspectRatio(contentMode: .fill)
//                                .frame(width: isIPad ? ScaleUtility.scaledValue(120) : ScaleUtility.scaledValue(100),
//                                       height: isIPad ? ScaleUtility.scaledValue(75) :  ScaleUtility.scaledValue(65))
//                                .overlay(alignment: .bottom) {
//                                    Text(style.name)
//                                        .font(FontManager.hankenGrotesksemiBold(size: .scaledFontSize(12)))
//                                        .multilineTextAlignment(.center)
//                                        .foregroundColor(Color.primaryApp)
//                                        .padding(.bottom, ScaleUtility.scaledSpacing(4))
//                                }
//                                .overlay {
//                                    if selectedDesign == style.name {
//                                        RoundedRectangle(cornerRadius: 6.25)
//                                            .stroke(Color.accent, lineWidth: 3)
//                                            .frame(width:isIPad ?  ScaleUtility.scaledValue(120) : ScaleUtility.scaledValue(100),
//                                                   height: isIPad ?  ScaleUtility.scaledValue(75)  :  ScaleUtility.scaledValue(62))
//                                    }
//                                }
//                          
//                            }

                     
                        }
                    }
                    .padding(.horizontal, ScaleUtility.scaledSpacing(15))
                }
                .frame(height:  ScaleUtility.scaledValue(70))
            }
        }
    }
}
