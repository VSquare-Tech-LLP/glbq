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
    
    @EnvironmentObject var purchaseManager: PurchaseManager
    @EnvironmentObject var remoteConfigManager: RemoteConfigManager
    @EnvironmentObject var appOpenAdManager: AppOpenAdManager

    @State private var selectedTab: TabSelection = .templates
  
    let notificationFeedback = UINotificationFeedbackGenerator()
    let impactFeedback = UIImpactFeedbackGenerator(style: .light)
    let selectionFeedback = UISelectionFeedbackGenerator()

    @State var showPopUp: Bool = false
    @State var showLimitPopOver: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Group {
                    switch selectedTab {
                    case .templates:
                           TemplatesView(gardenDesigner: {
                               selectedTab = .design
                           }, designRecreator: {
                               selectedTab = .recreate
                           })
                    case .design:
                        DesignView(showPopUp: $showPopUp,showLimitPopOver: $showLimitPopOver)
                    case .recreate:
                           RecreateView(showPopUp: $showPopUp,showLimitPopOver: $showLimitPopOver)
                    case .tools:
                        ToolsView(designRecreator: {
                            selectedTab = .recreate
                        })
                    case .history:
                        HistoryView(startDesign: {
                            selectedTab = .design
                        })
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
                    .padding(.horizontal, isIPad ? ScaleUtility.scaledSpacing(80) : ScaleUtility.scaledSpacing(30))
                    .frame(maxWidth: .infinity)
                    .frame(height: ScaleUtility.scaledValue(90))
                    .background(Color.primaryApp)
                    .cornerRadius(15)
                    .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: -5)
                    .opacity(showPopUp == true || showLimitPopOver == true ? 0 : 1)
                
                }
            }
            .edgesIgnoringSafeArea(.bottom)
            .ignoresSafeArea(.keyboard)
            .onAppear {
                if !purchaseManager.hasPro && remoteConfigManager.showAds {
                    if appOpenAdManager.isAppload {
                        appOpenAdManager.showAdIfAvailable()
                        
                    }
                }
            }
            .onChange(of: appOpenAdManager.isAppload) { newValue in
                if !purchaseManager.hasPro && remoteConfigManager.showAds {
                    if newValue == true {
                            appOpenAdManager.showAdIfAvailable()
                          
                    }
                }
            }
        }
    }
}
