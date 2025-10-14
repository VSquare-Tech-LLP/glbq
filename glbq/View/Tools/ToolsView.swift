//
//  ToolsCardView.swift
//  glbq
//
//  Created by Purvi Sancheti on 14/10/25.
//

import Foundation
import SwiftUI

struct ToolsView: View {
    var designRecreator: () -> Void
    @State var selectedTool: String = ""
    
    @State var isDreamGardenDesigner: Bool = false
    @State var isObjectReplacer: Bool = false
    @State var isObjectRemover: Bool = false
    @State var isAddObject: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            
            HStack {
                
                Text("Tools")
                    .font(FontManager.generalSansMediumFont(size: .scaledFontSize(22)))
                    .foregroundColor(Color.appBlack)
                
                Spacer()
                
                Image(.crownIcon)
                    .resizable()
                    .frame(width: ScaleUtility.scaledValue(24), height: ScaleUtility.scaledValue(24))
                    .padding(.all, ScaleUtility.scaledSpacing(9))
                    .background{
                        Circle()
                            .fill(.primaryApp)
                    }
                 
            }
            .padding(.horizontal, ScaleUtility.scaledSpacing(15))
            .padding(.top, ScaleUtility.scaledSpacing(59))
            
            
            ToolsCardView(selectedTool: $selectedTool,onClick: {
                switch selectedTool {
                  case "Dream Garden":
                    return isDreamGardenDesigner = true
                case "Replace Objects":
                    return isObjectReplacer = true
                case "Remove Objects":
                    return isObjectRemover = true
                case "Add Objects":
                    return isAddObject = true
                case "AI Garden Recreator":
                    return designRecreator()
                default:
                    isDreamGardenDesigner = false
                    isObjectReplacer = false
                    isObjectRemover = false
                    isAddObject = false
                }
            })
            
            Spacer()
        }
        .background {
            Image(.appBg)
                .resizable()
                .frame(maxWidth: .infinity,maxHeight: .infinity)
        }
        .ignoresSafeArea(.all)
        .navigationDestination(isPresented: $isDreamGardenDesigner) {
            DreamGardenView(onBack: {
                isDreamGardenDesigner = false
            })
        }
        .navigationDestination(isPresented: $isObjectReplacer) {
            ReplaceObjectsView(onBack: {
                isObjectReplacer = false
            })
        }
        .navigationDestination(isPresented: $isObjectRemover) {
            RemoveObjectsView(onBack: {
                isObjectRemover = false
            })
        }
        .navigationDestination(isPresented: $isAddObject) {
            AddObjectsView(onBack: {
                isAddObject = false
            })
        }
    }
}
