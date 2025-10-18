//
//  QuestionsView.swift
//  EveCraft
//
//  Created by Purvi Sancheti on 02/09/25.
//

import Foundation
import SwiftUI

struct UserQuestion {
    let name: String
    let image: String
}

struct QuestionsView: View {

    @Binding var selectedOptions: Set<String>
    
    var UserQuestions: [UserQuestion] = [
        UserQuestion(name: "Apply Design Templates", image: "widgetsIcon"),
        UserQuestion(name: "Create Custom Designs", image: "stickIcon"),
        UserQuestion(name: "Recreate from Reference", image: "regenerateIcon"),
        UserQuestion(name: "Edit Garden Photos", image: "editIcon"),
        UserQuestion(name: "Turn Imagination to Life", image: "lampIcon"),
        UserQuestion(name: "Try It All", image: "starIcon"),
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            
            ZStack(alignment: .top) {
                
                
                VStack(spacing: ScaleUtility.scaledSpacing(37)) {
                    VStack(spacing: ScaleUtility.scaledSpacing(10)) {
                        
                        Text("How do you plan to\nuse this app?")
                            .font(FontManager.generalSansSemiboldFont(size: .scaledFontSize(32)))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color.appBlack)
                        
                        
                        Text("You can choose multiple")
                            .font(FontManager.generalSansRegularFont(size: .scaledFontSize(20)))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color.appBlack)
                    }
                    .padding(.top, ScaleUtility.scaledSpacing(54))
                    
                    VStack(spacing: ScaleUtility.scaledSpacing(10)) {
                        ForEach(Array(UserQuestions.enumerated()), id: \.offset) { _, question in
                            let isSelected = selectedOptions.contains(question.name)
                            
                            HStack {
                                
                                HStack(spacing: ScaleUtility.scaledSpacing(10)) {
                                    
                                    Image(question.image)
                                        .frame(width: 22, height: 22)
                                    
                                    Text(question.name)
                                        .font(FontManager.generalSansRegularFont(size: .scaledFontSize(15)))
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Color.appBlack)
                                }
                                
                                Spacer()
                                
                                // Checkbox with checkmark
                                ZStack {
                                    RoundedRectangle(cornerRadius: 5)
                                        .foregroundColor(Color.clear)
                                        .background(
                                            RoundedRectangle(cornerRadius: 5)
                                                .fill(isSelected ? Color.accent : Color.checkBoxFill)
                                        )
                                        .frame(width: 22, height: 22)
                                    
                                    if isSelected {
                                        Image(systemName: "checkmark")
                                            .font(.system(size: 12, weight: .bold))
                                            .foregroundColor(.white)
                                    }
                                }
                            }
                            .padding(.horizontal, ScaleUtility.scaledSpacing(20))
                            .frame(maxWidth: .infinity)
                            .frame(height: ScaleUtility.scaledValue(50))
                            .background(Color.primaryApp)
                            .cornerRadius(15)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(isSelected ? Color.accent : Color.clear, lineWidth: 1)
                            )
                            .padding(.horizontal, ScaleUtility.scaledSpacing(15))
                            .onTapGesture {
                                // Toggle selection
                                if isSelected {
                                    selectedOptions.remove(question.name)
                                } else {
                                    selectedOptions.insert(question.name)
                                }
                            }
                        }
                    }
                }
                
                
                HStack(spacing: 0) {
                    
                    Image(.leftGrassIcon)
                        .resizable()
                        .frame(width: isIPad ?  ScaleUtility.scaledValue(75) : ScaleUtility.scaledValue(51),
                               height:  isIPad ?  ScaleUtility.scaledValue(321) : ScaleUtility.scaledValue(214))
                    
                    Spacer()
                    
                    Image(.rightGrassIcon)
                        .resizable()
                        .frame(width: isIPad ?  ScaleUtility.scaledValue(75) : ScaleUtility.scaledValue(51),
                               height:  isIPad ?  ScaleUtility.scaledValue(321) : ScaleUtility.scaledValue(214))
                    
                }
                .offset(y: ScaleUtility.scaledSpacing(22))
                
                
            }
            
            Spacer()
            
        }
        .ignoresSafeArea(.all)
    }
    
}
