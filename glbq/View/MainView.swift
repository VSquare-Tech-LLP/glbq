//
//  MainView.swift
//  glbq
//
//  Created by Purvi Sancheti on 11/10/25.
//

import Foundation
import SwiftUI

enum TabSelection: Hashable {
    case templates
    case design
    case recreate
    case tools
    case history
}

struct MainView: View {

    @State private var selectedTab: TabSelection = .templates
  
    let notificationFeedback = UINotificationFeedbackGenerator()
    let impactFeedback = UIImpactFeedbackGenerator(style: .light)
    let selectionFeedback = UISelectionFeedbackGenerator()

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Group {
                    switch selectedTab {
                    case .templates:
                           TemplatesView()
                    case .design:
                           DesignView()
                    case .recreate:
                           RecreateView()
                    case .tools:
                           ToolsView()
                    case .history:
                           HistoryView()
                    }
                }
                .frame(maxWidth:.infinity)
                .transition(.opacity)
                
                VStack(spacing: 0) {
                    Spacer()
                    
                    HStack {
                        Button {
                            impactFeedback.impactOccurred()
                            selectedTab = .templates
                        } label: {
                            
                            VStack(spacing: ScaleUtility.scaledSpacing(6)) {
                                Image(.templatesIcon)
                                    .renderingMode(.template)
                                    .resizable()
                                    .frame(width: ScaleUtility.scaledValue(24), height: ScaleUtility.scaledValue(24))

                                
                                Text("Templates")
                                    .font(FontManager.generalSansMediumFont(size: .scaledFontSize(10)))
                                    .multilineTextAlignment(.center)
                                  
                            }
                            .foregroundColor(selectedTab == .templates ? Color.accent : Color.appBlack.opacity(0.25))
                        }
                        
                        
                        Spacer()
                        
                        Button {
                            impactFeedback.impactOccurred()
                            selectedTab = .design
                        } label: {
                            VStack(spacing: ScaleUtility.scaledSpacing(6)) {
                                Image(.designIcon)
                                    .renderingMode(.template)
                                    .resizable()
                                    .frame(width: ScaleUtility.scaledValue(26), height: ScaleUtility.scaledValue(26))
                                
                                Text("Design")
                                    .font(FontManager.generalSansMediumFont(size: .scaledFontSize(10)))
                                    .multilineTextAlignment(.center)
                                  
                            }
                            .foregroundColor(selectedTab == .design ? Color.accent : Color.appBlack.opacity(0.25))
                        }
                        
                        Spacer()
                        
                        Button {
                            impactFeedback.impactOccurred()
                            selectedTab = .recreate
                        } label: {
                            VStack(spacing: ScaleUtility.scaledSpacing(6)) {
                                Image(.recreateIcon)
                                    .renderingMode(.template)
                                    .resizable()
                                    .frame(width: ScaleUtility.scaledValue(26), height: ScaleUtility.scaledValue(26))
                                
                                Text("Recreate")
                                    .font(FontManager.generalSansMediumFont(size: .scaledFontSize(10)))
                                    .multilineTextAlignment(.center)
                           
                            }
                            .foregroundColor(selectedTab == .recreate ? Color.accent : Color.appBlack.opacity(0.25))
                        }
                        
                        Spacer()
                        
                        Button {
                            impactFeedback.impactOccurred()
                            selectedTab = .tools
                        } label: {
                            VStack(spacing: ScaleUtility.scaledSpacing(6)) {
                                Image(.toolsIcon)
                                    .renderingMode(.template)
                                    .resizable()
                                    .frame(width: ScaleUtility.scaledValue(24), height: ScaleUtility.scaledValue(24))
                                
                                Text("Tools")
                                    .font(FontManager.generalSansMediumFont(size: .scaledFontSize(10)))
                                    .multilineTextAlignment(.center)
                                   
                            }
                            .foregroundColor(selectedTab == .tools ? Color.accent : Color.appBlack.opacity(0.25))
                        }
                        
                        Spacer()
                        
                        Button {
                            impactFeedback.impactOccurred()
                            selectedTab = .history
                        } label: {
                            VStack(spacing: ScaleUtility.scaledSpacing(6)) {
                                Image(.historyIcon)
                                    .renderingMode(.template)
                                    .resizable()
                                    .frame(width: ScaleUtility.scaledValue(24), height: ScaleUtility.scaledValue(24))
                                
                                Text("History")
                                    .font(FontManager.generalSansMediumFont(size: .scaledFontSize(10)))
                                    .multilineTextAlignment(.center)
                              
                            }
                            .foregroundColor(selectedTab == .history ? Color.accent : Color.appBlack.opacity(0.25))
                        }

                    }
                    .padding(.bottom,isSmalliphone ? ScaleUtility.scaledSpacing(10) : ScaleUtility.scaledSpacing(15))
                    .padding(.horizontal, ScaleUtility.scaledSpacing(30))
                    .frame(maxWidth: .infinity)
                    .frame(height: ScaleUtility.scaledValue(90))
                    .background(Color.primaryApp)
                    .cornerRadius(15)
                    .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: -5)
                
                }
            }
            .edgesIgnoringSafeArea(.bottom)
            .ignoresSafeArea(.keyboard)
        }
    }
}
