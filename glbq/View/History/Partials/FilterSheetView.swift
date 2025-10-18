//
//  FilterSheetView.swift
//  GLBQ
//
//  Created by Purvi Sancheti on 16/10/25.
//


import Foundation
import SwiftUI

struct FilterSheetView: View {
    @Binding var selectedFilter: String
    @Binding var showSheet: Bool
    
    private let filterOptions = [
        "Templates",
        "Ai Garden",
        "Recreate",
        "Add Objects",
        "Remove Objects",
        "Replace Objects",
        "Dream Garden",
        "Reset"
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            
            // Drag indicator
            RoundedRectangle(cornerRadius: 2.5)
                .background(Color.accent)
                .foregroundColor(Color.clear)
                .frame(width: ScaleUtility.scaledValue(56), height: ScaleUtility.scaledValue(3))
                .padding(.top, isIPad ?  ScaleUtility.scaledSpacing(20) : ScaleUtility.scaledSpacing(40))
            
            Spacer()
                .frame(height: ScaleUtility.scaledSpacing(10))
            
            // Filter options
            ForEach(Array(filterOptions.enumerated()), id: \.offset) { index, option in
                Button {
                    selectedFilter = option
                    showSheet = false
                } label: {
                    Text(option)
                        .font(selectedFilter == option
                              ? FontManager.generalSansMediumFont(size: .scaledFontSize(16))
                              : FontManager.generalSansRegularFont(size: .scaledFontSize(16)))
                        .foregroundColor(
                            option == "Reset"
                                ? Color.appRed2
                                : selectedFilter == option ? Color.accent : Color.appBlack
                        )
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, ScaleUtility.scaledSpacing(15))
                }
                
                // Divider (except after last item)
                if index < filterOptions.count - 1 {
                    Rectangle()
                        .foregroundColor(Color.appBlack.opacity(0.1))
                        .frame(maxWidth: .infinity)
                        .frame(height: ScaleUtility.scaledValue(1))
                }
            }
            
            Spacer()
                .frame(height: ScaleUtility.scaledSpacing(20))
        }
        .padding(.horizontal, ScaleUtility.scaledSpacing(15))
    }
}
