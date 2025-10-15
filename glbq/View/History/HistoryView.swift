//
//  HistoryView.swift
//  glbq
//
//  Created by Purvi Sancheti on 11/10/25.
//

import Foundation
import SwiftUI

struct HistoryView: View {
    
    var startDesign: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            
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
                        
                        
                        Button {
                            
                        } label: {
                            
                            Image(.filterIcon)
                                .resizable()
                                .frame(width: ScaleUtility.scaledValue(18), height: ScaleUtility.scaledValue(18))
                                .padding(ScaleUtility.scaledSpacing(10))
                                .background(.primaryApp)
                                .cornerRadius(10)
                        }
                        
                    }
                    
                    Spacer()
                    
                    Button {
                        
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
            
        
            EmptyView(startDesign: {
                startDesign()
            })
           
            
            Spacer()
            
        }
        .background {
            Image(.appBg)
                .resizable()
                .frame(maxWidth: .infinity,maxHeight: .infinity)
        }
        .ignoresSafeArea(.all)
    }
}
