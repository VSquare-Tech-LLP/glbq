//
//  TemplatesView.swift
//  glbq
//
//  Created by Purvi Sancheti on 11/10/25.
//

import Foundation
import SwiftUI


struct TemplatesView: View {
    
    @State var selectedOption: String = "Luxury"
    
    @State private var navigateToTemplateDesign = false
    @State private var selectedTemplate = ""
    @State private var selectedTemplateIndex = 0
    
    var gardenDesigner: () -> Void
    var designRecreator: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            
            VStack(spacing: ScaleUtility.scaledSpacing(15)) {
                
                TopView(gardenDesigner: {
                    gardenDesigner()
                }, designRecreator: {
                    designRecreator()
                })
                
                TemplatesFilter(selectedOption: $selectedOption)
                
                
            }
            
            ScrollView {
                
                Spacer()
                    .frame(height: ScaleUtility.scaledValue(14.5))
                
                let totalImages = 8
                
                // Loop through images 2 per row
                ForEach(0..<totalImages, id: \.self) { index in
                    if index % 2 == 0 { // start of a row
                        HStack(spacing: ScaleUtility.scaledSpacing(9)) {
                            // First image
                            TemplateImageView(imageName: "\(selectedOption)\(index+1)", index: index) {
                                selectedTemplate = selectedOption
                                selectedTemplateIndex = index
                                navigateToTemplateDesign = true
                            }
                            
                            // Second image if exists
                            if index + 1 < totalImages {
                                TemplateImageView(imageName: "\(selectedOption)\(index+2)", index: index+1) {
                                    selectedTemplate = selectedOption
                                    selectedTemplateIndex = index + 1
                                    navigateToTemplateDesign = true
                                }
                            } else {
                                Spacer() // to align layout if odd number
                            }
                        }
                        .padding(.horizontal, ScaleUtility.scaledSpacing(15))
                    }
                }
                
                Spacer()
                    .frame(height: ScaleUtility.scaledValue(100))
            }
            
            
            
            
            Spacer()
            
        }
        .background {
            Image(.appBg)
                .resizable()
                .frame(maxWidth: .infinity,maxHeight: .infinity)
        }
        .ignoresSafeArea(.all)
        .navigationDestination(isPresented: $navigateToTemplateDesign) {
            TemplateDesignView(
                SelectedTemplate: $selectedTemplate,
                onBack: { navigateToTemplateDesign = false },
                index: selectedTemplateIndex
            )
        }
    }
}
