//
//  HistoryTopView.swift
//  GLBQ
//
//  Created by Purvi Sancheti on 16/10/25.
//

import Foundation
import SwiftUI

struct HistoryTopView: View {
    
    @Binding var selectedFilter: String
    @Binding var isDropdownOpen: Bool
    @Binding var sortNewestFirst: Bool
    @Binding var showFilterSheet: Bool
    @Binding var showDeleteAllAlert: Bool
    
    var body: some View {
        VStack(spacing: ScaleUtility.scaledSpacing(15)) {
            
            HStack {
                
                Text("History")
                    .font(FontManager.generalSansMediumFont(size: .scaledFontSize(22)))
                    .foregroundColor(Color.appBlack)
                
                Spacer()
                
                Image(.crownIcon)
                    .frame(width: ScaleUtility.scaledValue(24), height: ScaleUtility.scaledValue(24))
                    .padding(.all, ScaleUtility.scaledSpacing(9))
                    .background {
                        Circle()
                            .fill(Color.primaryApp)
                    }
            }
            .padding(.top, ScaleUtility.scaledSpacing(59))
            
            
            HStack {
                
                HStack(spacing: ScaleUtility.scaledSpacing(5)) {
                    
                    
                    Button {
                        isDropdownOpen = true
                    } label: {
                        
                        HStack(spacing: ScaleUtility.scaledSpacing(5)) {
                            
                            Image(.sortIcon)
                                .resizable()
                                .frame(width: ScaleUtility.scaledValue(18), height: ScaleUtility.scaledValue(18))
                            
                            
                            Text("Sort by")
                                .font(FontManager.generalSansRegularFont(size: .scaledFontSize(14)))
                                .foregroundColor(.appBlack)
                        }
                        .padding(ScaleUtility.scaledSpacing(10))
                        .frame(height: ScaleUtility.scaledValue(38))
                        .background(.primaryApp)
                        .cornerRadius(10)
                    }
                    .popoverView(isPresented: $isDropdownOpen ,
                                 popOverSize: CGSize(width: isIPad ? ScaleUtility.scaledSpacing(174) : ScaleUtility.scaledSpacing(113),
                                                     height: isIPad ? ScaleUtility.scaledSpacing(90) : ScaleUtility.scaledSpacing(74)),
                                 popoverOffsetX: ScaleUtility.scaledSpacing(-15),
                                 popoverIpadOffsetX:  ScaleUtility.scaledSpacing(-15),
                                 popoverOffsetY: ScaleUtility.scaledSpacing(40),
                                 popoverIpadOffsetY: ScaleUtility.scaledSpacing(30),
                                 popoverContent: {
                        
                        VStack(spacing: ScaleUtility.scaledSpacing(6)) {
                            Button {
                                sortNewestFirst = true
                                isDropdownOpen = false
                            } label: {
                                Text("Newest First")
                                    .font(FontManager.generalSansRegularFont(size: .scaledFontSize(14)))
                                    .foregroundColor(Color.appBlack)
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            Rectangle()
                                .foregroundColor(Color.appBlack.opacity(0.1))
                                .frame(maxWidth: .infinity)
                                .frame(height: ScaleUtility.scaledValue(1))
                            
                            Button {
                                sortNewestFirst = false
                                isDropdownOpen = false
                            } label: {
                                Text("Oldest First")
                                    .font(FontManager.generalSansRegularFont(size: .scaledFontSize(14)))
                                    .foregroundColor(Color.appBlack)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .padding(.vertical, ScaleUtility.scaledSpacing(12))
                        .padding(.horizontal, ScaleUtility.scaledSpacing(6))
                        
                    })
                    
                    
                    Button {
                        showFilterSheet = true
                    } label: {
                        
                        ZStack(alignment: .topTrailing) {
                            
                            Image(.filterIcon)
                                .resizable()
                                .frame(width: ScaleUtility.scaledValue(18), height: ScaleUtility.scaledValue(18))
                                .padding(ScaleUtility.scaledSpacing(10))
                                .background(.primaryApp)
                                .cornerRadius(10)
                            
                            if selectedFilter != "Reset" {

                                Image(.dotIcon)
                                    .resizable()
                                    .frame(width: ScaleUtility.scaledValue(10), height: ScaleUtility.scaledValue(10))
                            }
                  
                        }
                            
                    }
                    
                }
                
                Spacer()
                
                Button {
                    showDeleteAllAlert = true
                } label: {
                    
                    HStack(spacing: ScaleUtility.scaledSpacing(5)) {
                        
                        Image(.deleteIcon)
                            .resizable()
                            .frame(width: ScaleUtility.scaledValue(18), height: ScaleUtility.scaledValue(18))
                        
                        
                        Text("Delete all")
                            .font(FontManager.generalSansRegularFont(size: .scaledFontSize(14)))
                            .foregroundColor(.appBlack)
                        
                    }
                    .padding(ScaleUtility.scaledSpacing(10))
                    .frame(height: ScaleUtility.scaledValue(38))
                    .background(Color.appLightRed)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .inset(by: 0.5)
                            .stroke(Color.appRed, lineWidth: 1)
                    )
                    
                }

                
            }
        }
        .padding(.horizontal, ScaleUtility.scaledSpacing(15))
    }
}
