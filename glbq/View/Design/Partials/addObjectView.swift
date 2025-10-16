//
//  addObjectView.swift
//  glbq
//
//  Created by Purvi Sancheti on 11/10/25.
//

import Foundation
import SwiftUI

struct Object {
    let name: String
    let selectedImage: String
    let unSelectedImage: String
    let prompt: String
}

struct addObjectView: View {
    let selectionFeedback = UISelectionFeedbackGenerator()
   
    // ⬇️ Multi-select: bind to a Set of names
    @Binding var selectedObjects: Set<String>
    
    var Objects: [Object] = [
        Object(name: "Pool", selectedImage: "dummyImage1", unSelectedImage:"dummyImage2" ,prompt: "Create a realistic swimming pool with clean water, simple tiling, and a plain neutral background. No people."),
        Object(name: "Furniture", selectedImage: "dummyImage1",  unSelectedImage:"dummyImage2" ,prompt: "Create elegant outdoor furniture including a chair and table with a clean, minimal background. No people."),
        Object(name: "Gazebo",   selectedImage: "dummyImage1",  unSelectedImage:"dummyImage2" ,prompt: "Create a beautiful wooden gazebo with detailed structure and a plain background. No people."),
        Object(name: "Fountain", selectedImage: "dummyImage1", unSelectedImage:"dummyImage2" ,prompt: "Create a classic water fountain with clear details and a simple, clean background. No people."),
        Object(name: "Pathway", selectedImage: "dummyImage1", unSelectedImage:"dummyImage2" ,prompt: "Create a stone or tile garden pathway viewed from above with a plain neutral background. No people."),
        Object(name: "Trees", selectedImage: "dummyImage1", unSelectedImage:"dummyImage2" ,prompt: "Create a realistic tree with full green foliage and a clean white background. No people."),
        Object(name: "Lights", selectedImage: "dummyImage1", unSelectedImage:"dummyImage2" ,prompt: "Create decorative garden lights or lanterns with a clear, minimal background. No people."),
        Object(name: "Firepit", selectedImage: "dummyImage1", unSelectedImage:"dummyImage2" ,prompt: "Create a modern outdoor firepit with clean lines and a simple, plain background. No people."),
        Object(name: "Bench", selectedImage: "dummyImage1", unSelectedImage:"dummyImage2" ,prompt: "Create a wooden or metal garden bench centered with a clean, minimal background. No people."),
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: ScaleUtility.scaledSpacing(10)) {
                
                HStack(spacing: ScaleUtility.scaledSpacing(5)) {
                    
                    Text("Add Objects")
                        .font(FontManager.generalSansMediumFont(size: .scaledFontSize(18)))
                        .foregroundColor(Color.appBlack)
                        
                    Text("(optional)")
                        .font(FontManager.generalSansMediumFont(size: .scaledFontSize(15)))
                        .foregroundColor(Color.appBlack.opacity(0.5))
                        
                    
                    Spacer()
                  
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, ScaleUtility.scaledSpacing(15))
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: isIPad ?   ScaleUtility.scaledSpacing(20) : ScaleUtility.scaledSpacing(10)) {
                        
                        ForEach(Array(Objects.enumerated()), id: \.offset) { _, object in
                            let isSelected = selectedObjects.contains(object.name)
                            
                            Button {
                                selectionFeedback.selectionChanged()
                                // Toggle selection
                                if isSelected {
                                    selectedObjects.remove(object.name)
                                } else {
                                    selectedObjects.insert(object.name)
                                }
                            } label: {
                                
                                VStack(spacing: ScaleUtility.scaledSpacing(5)) {
                                    
                                    ZStack(alignment: .topTrailing) {
                                        
                                        Image(isSelected ? object.selectedImage  : object.unSelectedImage)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: isIPad ?  ScaleUtility.scaledValue(198) :  ScaleUtility.scaledValue(132),
                                                   height: isIPad ?  ScaleUtility.scaledValue(127)  : ScaleUtility.scaledValue(85))
                                            .overlay {
                                                if isSelected {
                                                    RoundedRectangle(cornerRadius: 10)
                                                        .inset(by: -0.5)
                                                        .stroke(.appBlack.opacity(0.2), lineWidth: 1)
                                                }
                                            }
                                        
                                        if isSelected {
                                            
                                            Button(action: {
                                                selectedObjects.remove(object.name)
                                            }) {
                                                
                                                Image(.crossIcon3)
                                                    .frame(width: ScaleUtility.scaledValue(7.6), height: ScaleUtility.scaledValue(7.6))
                                                    .padding(.all, ScaleUtility.scaledSpacing(5.7))
                                                    .background {
                                                        Circle()
                                                            .fill(.appBlack.opacity(0.5))
                                                        
                                                    }
                                                    .cornerRadius(19)
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 19)
                                                            .stroke(.primaryApp.opacity(0.4), lineWidth: 0.63333)
                                                    )
                                                    .padding(.all, ScaleUtility.scaledSpacing(5))
                                            }
                                            .zIndex(1)
                                        }
                                    }
                                    
                                    Text(object.name)
                                        .font(FontManager.generalSansRegularFont(size: .scaledFontSize(14)))
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Color.appBlack.opacity(0.5))
                            
                                    
                                }
                                
                            }
                        }
                    }
                    .padding(.horizontal, ScaleUtility.scaledSpacing(15))
                }
                
            }
           
            
        }
    }
}
