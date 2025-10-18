//
//  DreamGardenView.swift
//  glbq
//
//  Created by Purvi Sancheti on 14/10/25.
//

import Foundation
import SwiftUI

struct DreamGardenView: View {
    @StateObject var userDefault = UserSettings()
    @EnvironmentObject var purchaseManager: PurchaseManager
    @EnvironmentObject var remoteConfigManager: RemoteConfigManager
    
    @StateObject private var ads = RewardedAdManager(adUnitID: "ca-app-pub-3997698054569290/2718681220")
    
    @State var isShowPayWall: Bool = false
    @State var showLimitPopOver: Bool = false

    
    @StateObject private var viewModel = GenerationViewModel()
    @State private var isGenerating = false
    @State private var navigateToProcessView = false
    @State var showPopUp: Bool = false
    
    let impactfeedback = UIImpactFeedbackGenerator(style: .medium)
    
    var onBack: () -> Void
    @FocusState private var searchFocused: Bool
    
    @State var description: String = ""
    @State var selectedTheme: String = ""
    @State private var selectedObjects: Set<String> = []
    @State private var showToast = false
    @State private var toastMessage = ""
    
    @State private var showValidationAlert = false
    
    var body: some View {
        KeyboardAvoidingView {
            VStack(spacing: 0) {
                
                VStack(spacing: ScaleUtility.scaledSpacing(20)) {
                    
                    HeaderView(highPadding: true,title: "Dream Garden Designer",onBack: {
                        onBack()
                    })
                    
                    DescriptionView(description: $description, isInputFocused: $searchFocused)
                    
                    DesignThemesView(text:"Design Theme",
                                     isOptional: true,
                                     selectedTheme: $selectedTheme)
                    
                    addObjectView(selectedObjects: $selectedObjects)
                }
                
                Spacer()
                
                Button {
                    
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                        impactfeedback.impactOccurred()
                    }
                    if description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        showValidationAlert = true
                    } else {
                        userDefault.resetIfNeeded()
                        let dailyLimit = remoteConfigManager.dailyLimit
                        let extensionLimit = remoteConfigManager.extendedLimit
                        let totalAllowed = purchaseManager.hasPro ? dailyLimit + (extensionLimit * userDefault.extensionPurchasesToday)
                        : remoteConfigManager.freeConvertion + remoteConfigManager.maximumRewardAd
                        
                        if userDefault.dailyGeneratedImages >= totalAllowed {
                            if purchaseManager.hasPro {
                                showLimitPopOver = true
                            } else {
                                isShowPayWall = true
                            }
                            return
                        }
                        else {
                            
                            if !purchaseManager.hasPro && remoteConfigManager.showAds {
                                
                                if userDefault.freeImageGenerated < remoteConfigManager.freeConvertion {
                                    
                                    navigateToProcessView = true
                                    userDefault.freeImageGenerated += 1
                                    userDefault.dailyGeneratedImages += 1
                                }
                                else if userDefault.freeImageGenerated == remoteConfigManager.freeConvertion && userDefault.rewardAdsImageGenerated >= remoteConfigManager.maximumRewardAd{
                                    isShowPayWall = true
                                }
                                else {
                                    showPopUp = true
                                }
                            }
                            else if !purchaseManager.hasPro && remoteConfigManager.temporaryAdsClosed {
                                if userDefault.rewardAdsImageGenerated >= remoteConfigManager.maximumRewardAd {
                                    isShowPayWall = true
                                }
                                else {
                                    
                                    userDefault.rewardAdsImageGenerated += 1
                                    userDefault.dailyGeneratedImages += 1
                                    navigateToProcessView = true
                                }
                            }
                            else {
                                userDefault.dailyGeneratedImages += 1
                                navigateToProcessView = true
                            }
                            
                        }
                    }
                } label: {
                    Text("Design Now")
                        .font(FontManager.generalSansMediumFont(size: .scaledFontSize(18)))
                        .multilineTextAlignment(.center)
                        .foregroundColor(description == "" ? Color.appBlack.opacity(0.2) : Color.primaryApp)
                        .padding(.vertical,ScaleUtility.scaledSpacing(18))
                        .frame(maxWidth: .infinity)
                        .background(description == "" ? Color.diableApp : Color.accent)
                        .cornerRadius(15)
                        .padding(.horizontal,ScaleUtility.scaledSpacing(15))
                        .padding(.bottom,ScaleUtility.scaledSpacing(40))
                }
//                .disabled(description == "")
                
            }
        }
        .navigationBarHidden(true)
        .background {
            Image(.appBg)
                .resizable()
                .frame(maxWidth: .infinity,maxHeight: .infinity)
        }
        .ignoresSafeArea(.all)
        .fullScreenCover(isPresented: $isShowPayWall) {
            
            PaywallView(isInternalOpen: true) {
                showPopUp = false
                isShowPayWall = false
            } purchaseCompletSuccessfullyAction: {
                showPopUp = false
                isShowPayWall = false
            }
        }
        .alert(isPresented: $showToast) {
            Alert(
                title: Text("Error"),
                message: Text("Unable to process. Try again with different prompt or image."),
                dismissButton: .default(Text("OK")) {
                    showToast = false
                }
            )
        }
        .task {
            // Preload ad only when sheet is presented
            //                AnalyticsManager.shared.log(.magicDesigner)
            if !purchaseManager.hasPro {
                await ads.load()
            }
        }
        .overlay {
            if showPopUp {
                ZStack {
                    Color.appBlack.opacity(0.7).ignoresSafeArea(.all)
                        .ignoresSafeArea(.all)
                        .transition(.opacity)
                        .onTapGesture {
                            // tap outside to close (optional)
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                showPopUp = false
                            }
                        }
                    
                    AdsAlertView {
                        isShowPayWall = true
//                        AnalyticsManager.shared.log(.getPremiumFromAlert)
                        
                    } watchAds: {
//                        AnalyticsManager.shared.log(.watchanAd)
                        ads.showOrProceed(
                            onReward: { _ in
                                navigateToProcessView = true
                                userDefault.rewardAdsImageGenerated += 1
                                userDefault.dailyGeneratedImages += 1
                            },
                            proceedAnyway: {
                                navigateToProcessView = true
                                userDefault.rewardAdsImageGenerated += 1
                                userDefault.dailyGeneratedImages += 1
                            }
                        )
                    } closeAction: {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                            showPopUp = false
                        }
                    }
                    .transition(.asymmetric(
                        insertion: .scale(scale: 0.95).combined(with: .opacity),
                        removal: .scale(scale: 0.85).combined(with: .opacity)
                    ))
                    .zIndex(1) // keep it above the dimmer
                    
                    
                }
             
            }
        }
        .overlay(
            LimitReachedView(
                isVisible: $showLimitPopOver,
                dailyCap: remoteConfigManager.dailyLimit,
                additionalQuota: remoteConfigManager.extendedLimit,
                extensionProduct: purchaseManager.findProduct(for: .limitExtension),
                triggeredByLimit: true
            )
            .environmentObject(purchaseManager)
            .environmentObject(userDefault)
            .environmentObject(remoteConfigManager)
        )
        .navigationDestination(isPresented: $navigateToProcessView) {
            ProcessingView(
                viewModel: viewModel,
                onBack: {
           
                    if viewModel.shouldReturnToRecreate {
                        toastMessage = viewModel.errorMessage ?? "Generation failed. Please try again."
                        showPopUp = false
                        navigateToProcessView = false
                        isGenerating = false
                        withAnimation { showToast = true }
                 
                        viewModel.shouldReturnToRecreate = false
                    } else {
                        showPopUp = false
                        navigateToProcessView = false
                        isGenerating = false
                    }
                },
                onAppear: {
                    Task {
                        let prompt = PromptBuilder.buildTextPrompt(
                            description: description,
                            designName: selectedTheme.isEmpty ? nil : selectedTheme,
                            objectNames: selectedObjects
                        )
                        
//                        viewModel.currentKind = .generated
                        viewModel.currentSource = "Dream Garden"
                        viewModel.currentPrompt = prompt
                        
                        let started = await viewModel.startTextJob(prompt: prompt)
                        if started {
                            await viewModel.pollUntilReady()
                        } else {
                            viewModel.shouldReturnToRecreate = true
                        }
                    }
                }
            )
        }
        .alert("Missing Information", isPresented: $showValidationAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Please describe your dream garden in the description box to continue.")
        }
        
    }
}
