//
//  TemplatesFilter.swift
//  glbq
//
//  Created by Purvi Sancheti on 14/10/25.
//

import Foundation
import Foundation
import SwiftUI

struct TemplatesFilter: View {
    let notificationFeedback = UINotificationFeedbackGenerator()
    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
    let selectionFeedback = UISelectionFeedbackGenerator()
    
    @Binding var selectedOption: String
    var templateOptions = ["Luxury",
                           "Home",
                           "Office",
                           "Hotel",
                           "Restaurant"]

    
    var body: some View {
        ScrollView(.horizontal,showsIndicators: false) {
            HStack(spacing: ScaleUtility.scaledSpacing(8)) {
                ForEach(Array(templateOptions.enumerated()), id: \.offset) { index, template in
                    Button {
                        selectionFeedback.selectionChanged()
                        selectedOption = template
                    } label: {
                        Text(template)
                            .font(selectedOption == template
                                  ? FontManager.generalSansMediumFont(size: .scaledFontSize(14))
                                  : FontManager.generalSansRegularFont(size: .scaledFontSize(14)))
                            .foregroundColor(selectedOption == template ? Color.primaryApp : Color.appBlack)
                            .padding(.vertical, ScaleUtility.scaledSpacing(8))
                            .padding(.horizontal, ScaleUtility.scaledSpacing(15))
                            .background {
                                selectedOption == template ? Color.accent : Color.primaryApp
                            }
                            .cornerRadius(10)
                
                    }
                    .buttonStyle(PlainButtonStyle())

                }
            }
            .padding(.horizontal, ScaleUtility.scaledSpacing(15))
  
        }
   
    }
}
