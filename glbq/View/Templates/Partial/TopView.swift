//
//  TopView.swift
//  glbq
//
//  Created by Purvi Sancheti on 11/10/25.
//

import Foundation
import SwiftUI

struct Tool {
    let name: String
    let imageName: String
}

struct TopView: View {
    
    var tools: [Tool] = [
        Tool(name: "AI Garden Designer", imageName: "aiGardenIcon"),
        Tool(name: "Add Objects", imageName: "addObjectIcon"),
        Tool(name: "Remove Objects", imageName: "removeObjectcon"),
        Tool(name: "Replace Objects", imageName: "replaceObjectIcon"),
        Tool(name: "AI Garden Recreator", imageName: "gardenRecreatorIcon"),
    ]
    
    @State var isAddObject: Bool = false
    @State var isObjectRemover: Bool = false
    @State var isObjectReplacer: Bool = false


    var gardenDesigner: () -> Void
    var designRecreator: () -> Void

    
    let notificationFeedback = UINotificationFeedbackGenerator()
    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
    let selectionFeedback = UISelectionFeedbackGenerator()
    
    var body: some View {
        VStack(spacing: 0) {
            
            ZStack(alignment:.top) {
                
                Image(.topBg)
                    .resizable()
                    .frame(maxWidth: .infinity)
                    .frame(height: ScaleUtility.scaledValue(235))
                
                
                VStack(spacing: ScaleUtility.scaledSpacing(15)) {
                    
                    HStack {
                        
                        Text("GLBQ")
                            .font(FontManager.generalSansSemiboldFont(size: .scaledFontSize(24)))
                            .foregroundColor(Color.primaryApp)
                        
                        Spacer()
                        
                        HStack(spacing: ScaleUtility.scaledSpacing(10)) {
                            
                            Image(.crownIcon)
                                .resizable()
                                .frame(width: ScaleUtility.scaledValue(24), height: ScaleUtility.scaledValue(24))
                                .padding(.all, ScaleUtility.scaledSpacing(9))
                                .background{
                                    Circle()
                                        .fill(.primaryApp.opacity(0.1))
                                }
                                .overlay(
                                    Circle()
                                        .stroke(.primaryApp.opacity(0.2), lineWidth: 1)
                                )
                            
                            
                            
                            Image(.settingsIcon)
                                .resizable()
                                .frame(width: ScaleUtility.scaledValue(24), height: ScaleUtility.scaledValue(24))
                                .padding(.all, ScaleUtility.scaledSpacing(9))
                                .background{
                                    Circle()
                                        .fill(.primaryApp.opacity(0.1))
                                }
                                .overlay(
                                    Circle()
                                        .stroke(.primaryApp.opacity(0.2), lineWidth: 1)
                                )
                            
                        }
                        
                    }
                    .padding(.horizontal, ScaleUtility.scaledSpacing(15))
                    .padding(.top, ScaleUtility.scaledSpacing(59))
                    
                    
                    ScrollView(.horizontal,showsIndicators: false) {
                        HStack(spacing: ScaleUtility.scaledSpacing(10)) {
                            ForEach(Array(tools.enumerated()), id: \.offset) { index, tool in
                                
                                Button {
                                    selectionFeedback.selectionChanged()
                                    switch tool.name {
                                    case "AI Garden Designer":
                                        return gardenDesigner()
                                    case "Add Objects":
                                        return isObjectRemover = true
                                    case "Object Replacer":
                                        return isObjectReplacer = true
                                    case "Remove Objects":
                                        return isObjectRemover = true
                                    case "AI Garden Recreator":
                                        return designRecreator()

                                    default:
                                        return
                                    }
                                } label: {
                                    
                                    VStack(spacing: ScaleUtility.scaledSpacing(4)) {
                                        
                                        Image(tool.imageName)
                                            .resizable()
                                            .frame(width: ScaleUtility.scaledValue(42), height:  ScaleUtility.scaledValue(42))
                                        
                                        Text(tool.name)
                                            .font(FontManager.generalSansMediumFont(size: .scaledFontSize(12)))
                                            .foregroundColor(.white)
                                        
                                        
                                    }
                                    .frame(width: ScaleUtility.scaledValue(132), height: ScaleUtility.scaledValue(85))
                                    .background(Color.primaryApp.opacity(0.1))
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .inset(by: 0.5)
                                            .stroke(.primaryApp.opacity(0.2), lineWidth: 1)
                                    )
                                }
                            }
                        }
                        .padding(.horizontal, ScaleUtility.scaledSpacing(15))
                    }
                    
                    
                }
                
            }
            
            
        }
    }
}
