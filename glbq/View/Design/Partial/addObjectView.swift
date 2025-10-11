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
        Object(name: "Swimming Pool", selectedImage: "dummyImage1", unSelectedImage:"dummyImage2" ,prompt: "Decorative dance floor with LED patterns and party lighting, plain background, no people"),
        Object(name: "Furniture", selectedImage: "dummyImage1",  unSelectedImage:"dummyImage2" ,prompt: "Elegant event stage with steps, decorative backdrop, and soft lighting, plain background, no people"),
        Object(name: "Gazebo",   selectedImage: "dummyImage1",  unSelectedImage:"dummyImage2" ,prompt: "Colorful neon lights arranged decoratively on a wall, plain background, no people"),
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: ScaleUtility.scaledSpacing(10)) {
                Text("Add Objects (Optional)")
                    .font(FontManager.generalSansMediumFont(size: .scaledFontSize(18)))
                    .foregroundColor(Color.appBlack)
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
                                
                                Image(isSelected ? object.unSelectedImage : object.selectedImage)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: isIPad ?  ScaleUtility.scaledValue(198) :  ScaleUtility.scaledValue(132),
                                               height: isIPad ?  ScaleUtility.scaledValue(127)  : ScaleUtility.scaledValue(85))
                                        .overlay {
                                            if !isSelected {
                                                RoundedRectangle(cornerRadius: 10)
                                                    .inset(by: -0.5)
                                                    .stroke(.appBlack.opacity(0.2), lineWidth: 1)
                                            }
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
