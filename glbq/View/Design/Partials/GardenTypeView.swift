//
//  GardenTypeView.swift
//  glbq
//
//  Created by Purvi Sancheti on 11/10/25.
//

import Foundation
import SwiftUI

struct GardenType {
    let name: String
    let imageName: String
    let prompt: String
}

struct GardenTypeView: View {
    let selectionFeedback = UISelectionFeedbackGenerator()
    @Binding var selectedType: String
    var GardenTypes: [GardenType] = [
        
        GardenType(name: "House",
              imageName: "dummyImage1",
              prompt: "Create a beautiful front yard garden in front of a modern house with a lawn, flower beds, and a stone walkway leading to the entrance. No people."),
        
        GardenType(name: "Apartment",
              imageName: "dummyImage1",
              prompt: "Create a cozy apartment balcony garden with potted plants, hanging flowers, a small chair, and city views in the background. No people."),
        
        GardenType(name: "Office",
            imageName: "dummyImage1",
            prompt: "Create a clean office courtyard garden with trimmed plants, benches, modern planters, and glass building reflections around. No people."),
        
        GardenType(name: "Café",
            imageName: "dummyImage1",
            prompt: "Create a charming café outdoor garden with tables, string lights, potted flowers, and a warm, inviting atmosphere. No people."),
        
        GardenType(name: "Rooftop",
            imageName: "dummyImage1",
            prompt: "Create a stylish rooftop garden with wooden decking, lounge furniture, green plants, and a panoramic city skyline view. No people."),
        
        GardenType(name: "Resort",
            imageName: "dummyImage1",
            prompt: "Create a tropical resort garden with palm trees, a swimming pool, deck chairs, and a luxury vacation ambience. No people."),
        
        GardenType(name: "Park",
            imageName: "dummyImage1",
            prompt: "Create a spacious park landscape with open green lawns, trees, walking paths, benches, and sunlight filtering through leaves. No people."),
        
        GardenType(name: "Villa",
            imageName: "dummyImage1",
            prompt: "Create an elegant villa garden with a marble pathway, fountain in the center, trimmed hedges, and luxury outdoor furniture. No people."),
        
        GardenType(name: "Backyard",
            imageName: "dummyImage1",
            prompt: "Create a cozy backyard garden with grass, a wooden fence, patio furniture, and flower beds along the sides. No people."),
        
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: ScaleUtility.scaledSpacing(15)) {
                
                Text("Garden Type")
                    .font(FontManager.generalSansMediumFont(size: .scaledFontSize(18)))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, ScaleUtility.scaledSpacing(15))
                
                ScrollView(.horizontal,showsIndicators: false) {
                    
                    HStack(spacing: ScaleUtility.scaledSpacing(10)) {
                        
                        ForEach(Array(GardenTypes.enumerated()), id: \.offset) { index, type in
                            
                            let isSelected = (selectedType == type.name)
                            
                            VStack(spacing: ScaleUtility.scaledSpacing(5)) {
                                
                                Button(action: {
                                    selectionFeedback.selectionChanged()
                                    if isSelected  {
                                        selectedType = ""
                                        
                                    }
                                    else {
                                        selectedType = type.name
                                    }
                                }) {
                                    ZStack {
                                     
                                            RoundedRectangle(cornerRadius: 13)
                                                .frame(width: isIPad ?  ScaleUtility.scaledValue(210) : ScaleUtility.scaledValue(140),
                                                       height: isIPad ? ScaleUtility.scaledValue(139) : ScaleUtility.scaledValue(93))
                                                .foregroundColor(Color.clear)
                                                .background(selectedType == type.name ? Color.primaryApp : Color.clear)
                                                .overlay {
                                                    if selectedType == type.name {
                                                        RoundedRectangle(cornerRadius: 13)
                                                            .stroke(Color.accent, lineWidth: 5)
                                                            .frame(width: isIPad ?  ScaleUtility.scaledValue(210) : ScaleUtility.scaledValue(140),
                                                                   height: isIPad ? ScaleUtility.scaledValue(139) : ScaleUtility.scaledValue(93))
                                                    }
                                                    
                                                }
                                                .cornerRadius(13)
                                        
                                        
                                        Image(type.imageName)
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
                                
                                Text(type.name)
                                    .font( selectedType == type.name ? FontManager.generalSansMediumFont(size: .scaledFontSize(14)) : FontManager.generalSansRegularFont(size: .scaledFontSize(14)))
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
