//
//  SettingsCardsView.swift
//  EveCraft
//
//  Created by Purvi Sancheti on 28/08/25.
//

import Foundation
import SwiftUI

struct SettingsCardsView: View {
    @Environment(\.openURL) var openURL
    @EnvironmentObject var userDefault: UserSettings
    
    let notificationfeedback = UINotificationFeedbackGenerator()
    let impactfeedback = UIImpactFeedbackGenerator(style: .medium)
    let selectionfeedback = UISelectionFeedbackGenerator()
    
    
    @State private var isRateUsPressed = false
    @State private var isShareAppPressed = false
    @State private var isAboutAppPressed = false
    @State var isShowPayWall: Bool = false
    @State private var isContactUsPressed = false
    @State private var isSupportPressed = false
    @State private var isPrivacyPressed = false
    @State private var isTermsPressed = false
 

    var body: some View {
        
        // MARK: - FIRST CARD
        
        VStack(spacing: ScaleUtility.scaledSpacing(10)) {
            
            HStack {
                
                CommonRowView(rowText: "User ID", rowImage: "userIcon")
                
                Spacer()
                
                Text("XR" + userDefault.userId + "P")
                    .font(FontManager.generalSansRegularFont(size: .scaledFontSize(12)))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.appBlack)
            }
            .padding(.all, ScaleUtility.scaledSpacing(15))
            .background(.primaryApp)
            .cornerRadius(15)
            .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)
            .padding(.horizontal,ScaleUtility.scaledSpacing(20))
            
            // MARK: - SECOND CARD
            
            VStack(spacing: ScaleUtility.scaledSpacing(12)) {
                
           
                Button {
                    impactfeedback.impactOccurred()
                    if let url = URL(string: AppConstant.ratingPopupURL) {
                        openURL(url)
                    }
                } label: {
                    CommonRowView(rowText: "Rate Us", rowImage: "rateUsIcon")
                }
                .buttonStyle(PlainButtonStyle())
                .scaleEffect(isRateUsPressed ? 0.95 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.5), value: isRateUsPressed)
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in
                            withAnimation {
                                isRateUsPressed = true
                            }
                        }
                        .onEnded { _ in
                            withAnimation {
                                isRateUsPressed = false
                            }
                        }
                )  
                
                Rectangle()
                    .foregroundColor(Color.appBlack.opacity(0.1))
                    .frame(maxWidth: .infinity)
                    .frame(height: ScaleUtility.scaledValue(1))
                
                ShareLink(item: URL(string: AppConstant.shareAppIDURL)!)
                {
                    CommonRowView(rowText: "Share App", rowImage: "shareIcon2")
                }
                .scaleEffect(isShareAppPressed ? 0.95 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.5), value: isShareAppPressed)
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in
                            withAnimation {
                                isShareAppPressed = true
                            }
                        }
                        .onEnded { _ in
                            withAnimation {
                                isShareAppPressed = false
                            }
                        }
                )
                
                Rectangle()
                    .foregroundColor(Color.appBlack.opacity(0.1))
                    .frame(maxWidth: .infinity)
                    .frame(height: ScaleUtility.scaledValue(1))
                
                Button(action: {
                    impactfeedback.impactOccurred()
                    let url = URL(string: AppConstant.aboutAppURL)!
                    openURL(url)
                }) {
                    HStack {
                        
                        CommonRowView(rowText: "About App", rowImage: "aboutIcon")
                        
                        Text("Version \(Bundle.appVersion)")
                            .font(FontManager.generalSansRegularFont(size: .scaledFontSize(12)))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color.appBlack.opacity(0.5))
                        
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .scaleEffect(isAboutAppPressed ? 0.95 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.5), value: isAboutAppPressed)
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in
                            withAnimation {
                                isAboutAppPressed = true
                            }
                        }
                        .onEnded { _ in
                            withAnimation {
                                isAboutAppPressed = false
                            }
                        }
                )
                
            }
            .padding(.all,ScaleUtility.scaledSpacing(15))
            .background(Color.primaryApp)
            .cornerRadius(15)
            .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)
            .padding(.horizontal,ScaleUtility.scaledSpacing(20))
            
            // MARK: - THIRD CARD
            
            VStack(spacing: ScaleUtility.scaledSpacing(12)) {
                
                Button(action: {
                    impactfeedback.impactOccurred()
                    let url = URL(string: AppConstant.contactUSURL)!
                    openURL(url)
                }) {
                    CommonRowView(rowText: "Contact Us", rowImage: "contactIcon")
                }
                .buttonStyle(PlainButtonStyle())
                .scaleEffect(isContactUsPressed ? 0.95 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.5), value: isContactUsPressed)
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in
                            withAnimation {
                                isContactUsPressed = true
                            }
                        }
                        .onEnded { _ in
                            withAnimation {
                                isContactUsPressed = false
                            }
                        }
                )
                
                Rectangle()
                    .foregroundColor(Color.appBlack.opacity(0.1))
                    .frame(maxWidth: .infinity)
                    .frame(height: ScaleUtility.scaledValue(1.5))
                
                Button(action: {
                    impactfeedback.impactOccurred()
                    let url = URL(string: AppConstant.supportURL)!
                    openURL(url)
                }) {
                    CommonRowView(rowText: "Support", rowImage: "supportIcon")
                }
                .buttonStyle(PlainButtonStyle())
                .scaleEffect(isSupportPressed ? 0.95 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.5), value: isSupportPressed)
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in
                            withAnimation {
                                isSupportPressed = true
                            }
                        }
                        .onEnded { _ in
                            withAnimation {
                                isSupportPressed = false
                            }
                        }
                )
                
                
                Rectangle()
                    .foregroundColor(Color.appBlack.opacity(0.1))
                    .frame(maxWidth: .infinity)
                    .frame(height: ScaleUtility.scaledValue(1.5))
                
                Button(action: {
                    impactfeedback.impactOccurred()
                    let url = URL(string: AppConstant.privacyURL)!
                    openURL(url)
                }) {
                    
                    CommonRowView(rowText: "Privacy Policies", rowImage: "privacyIcon")
                }
                .buttonStyle(PlainButtonStyle())
                .scaleEffect(isPrivacyPressed ? 0.95 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.5), value: isPrivacyPressed)
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in
                            withAnimation {
                                isPrivacyPressed = true
                            }
                        }
                        .onEnded { _ in
                            withAnimation {
                                isPrivacyPressed = false
                            }
                        }
                )
                
                
                Rectangle()
                    .foregroundColor(Color.appBlack.opacity(0.1))
                    .frame(maxWidth: .infinity)
                    .frame(height: ScaleUtility.scaledValue(1.5))
                
                Button(action: {
                    impactfeedback.impactOccurred()
                    let url = URL(string: AppConstant.termsAndConditionURL)!
                    openURL(url)
                }) {
                    CommonRowView(rowText: "Terms & Conditions", rowImage: "termsIcon")
                }
                .buttonStyle(PlainButtonStyle())
                .scaleEffect(isTermsPressed ? 0.95 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.5), value: isTermsPressed)
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in
                            withAnimation {
                                isTermsPressed = true
                            }
                        }
                        .onEnded { _ in
                            withAnimation {
                                isTermsPressed = false
                            }
                        }
                )
                
            }
            .padding(.all,ScaleUtility.scaledSpacing(15))
            .background(Color.primaryApp)
            .cornerRadius(15)
            .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)
            .padding(.horizontal,ScaleUtility.scaledSpacing(20))
            
        }
        .padding(.top,ScaleUtility.scaledSpacing(20))
    }
}
extension Bundle {
    static var appVersion: String {
        (main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "-"
    }
    static var buildNumber: String {
        (main.infoDictionary?["CFBundleVersion"] as? String) ?? "-"
    }
}
