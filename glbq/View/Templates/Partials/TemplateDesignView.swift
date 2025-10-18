//
//  TemplateDesignView.swift
//  glbq
//
//  Created by Purvi Sancheti on 14/10/25.
//

import Foundation
import Foundation
import SwiftUI
import PhotosUI

struct TemplateDesignView: View {
    
    @StateObject var userDefault = UserSettings()
    @EnvironmentObject var purchaseManager: PurchaseManager
    @EnvironmentObject var remoteConfigManager: RemoteConfigManager
    
    @StateObject private var ads = RewardedAdManager(adUnitID: "ca-app-pub-3997698054569290/2718681220")
    
    @StateObject private var viewModel = GenerationViewModel()
    
    @State var isShowPayWall: Bool = false
    @State var showLimitPopOver: Bool = false
    @State var showPopUp: Bool = false
    
    let impactfeedback = UIImpactFeedbackGenerator(style: .medium)
    @State private var navigateToProcessView = false
    
    @Binding var SelectedTemplate: String
    var onBack: () -> Void
    var index: Int
    
    @State private var showUploadSheet = false
    
    @State private var showCameraPermissionAlert = false
    @State private var cameraDeniedOnce = false

    @State private var showCameraPickerMain = false
    @State private var showPhotoPickerMain = false
    
    @State private var selectedMainItem: PhotosPickerItem? = nil
    @State private var selectedMainUIImage: UIImage? = nil
    @State private var selectedMainImage: Image? = nil
    
    @State private var imageFrame: CGRect = .zero
    @State private var imageSize: CGSize = .zero
    
    @State private var showToast = false
    @State private var toastMessage = ""
    
    @State private var showValidationAlert = false
    
    var body: some View {
            
        ZStack {
            
//            Image(.appBg)
//                .resizable()
//                .frame(maxWidth: .infinity,maxHeight: .infinity)
//                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                
                VStack(spacing: ScaleUtility.scaledSpacing(20)) {
                    
                    HeaderView(highPadding: false,title: SelectedTemplate,onBack: {
                        onBack()
                    })
                    
                    if isIPad {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(Color.clear)
                            .frame(maxWidth: .infinity)
                            .frame(height: isBigIpadDevice ? ScaleUtility.scaledValue(290) : ScaleUtility.scaledValue(350))
                            .background {
                                Image(SelectedTemplate+"\(index + 1)")
                                    .resizable()
                                    .frame(height:  isBigIpadDevice ? ScaleUtility.scaledValue(290) : ScaleUtility.scaledValue(350))
                                    .contentShape(RoundedRectangle(cornerRadius: 10))
                                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                            }
                            .padding(.horizontal, ScaleUtility.scaledSpacing(15))
                    } else {
                        Image(SelectedTemplate+"\(index + 1)")
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity)
                            .frame(height: ScaleUtility.scaledValue(245))
                            .contentShape(RoundedRectangle(cornerRadius: 15))
                            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                            .padding(.horizontal, ScaleUtility.scaledSpacing(15))
                    }
                    
//                    selectedTemplate(selectedImage: SelectedTemplate)
                    
                    VStack(spacing: ScaleUtility.scaledSpacing(15)) {
                        
                        Text("Add Reference Garden Photo")
                            .font(FontManager.generalSansMediumFont(size: .scaledFontSize(18)))
                            .foregroundColor(Color.appBlack)
                            .frame(maxWidth: .infinity,alignment: .leading)
                            .padding(.leading, ScaleUtility.scaledValue(15))
                        
                        if let image = selectedMainUIImage {
                            imageCanvasView(selectedImage: image)
                            
                        } else {
                            
                            UploadContainer(
                                title:"Upload Garden Photo",
                                onClick: {
                                    showUploadSheet = true
                                })
                            
                        }
                    }
           
                }
                
                Spacer()
                
                
                Button {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                        impactfeedback.impactOccurred()
                    }
                    if selectedMainUIImage == nil {
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
                    Text("Try this Template")
                        .font(FontManager.generalSansMediumFont(size: .scaledFontSize(18)))
                        .multilineTextAlignment(.center)
                        .foregroundColor(selectedMainUIImage == nil ? Color.appBlack.opacity(0.2) : Color.primaryApp)
                        .padding(.vertical,ScaleUtility.scaledSpacing(18))
                        .frame(maxWidth: .infinity)
                        .background( selectedMainUIImage == nil ? Color.diableApp : Color.accent)
                        .cornerRadius(15)
                    
                    
                }
                .zIndex(1)
                .padding(.bottom, ScaleUtility.scaledSpacing(25))
                .padding(.horizontal,ScaleUtility.scaledSpacing(15))
            }
        }
        .navigationBarHidden(true)
        .background {
            Image(.appBg)
                .resizable()
                .frame(maxWidth: .infinity,maxHeight: .infinity)
                .ignoresSafeArea(.all)
        }
        .alert(isPresented: $showToast) {
            Alert(
                title: Text("Error"),
                message: Text(toastMessage),
                dismissButton: .default(Text("OK")) {
                    showToast = false
                }
            )
        }
        .fullScreenCover(isPresented: $isShowPayWall) {
            
            PaywallView(isInternalOpen: true) {
                showPopUp = false
                isShowPayWall = false
            } purchaseCompletSuccessfullyAction: {
                showPopUp = false
                isShowPayWall = false
            }
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
                    // Optional: mirror DesignView’s graceful failure handling
                    if viewModel.shouldReturnToRecreate {
                        toastMessage = viewModel.errorMessage ?? "Generation failed. Please try again."
//                        showPopUp = false
                        navigateToProcessView = false
                        withAnimation { showToast = true }
            
                        viewModel.shouldReturnToRecreate = false
                    }
                    else {
//                        showPopUp = false
                        navigateToProcessView = false
                    }
                },
                onAppear: {
                    Task {
                        // 1) Guard inputs
                        guard
                            let ui = selectedMainUIImage,
                            let reference = UIImage(named: SelectedTemplate + "\(index + 1)")
                        else {
                            viewModel.shouldReturnToRecreate = true
                            return
                        }

                        // 2) Build the prompt via PromptBuilder
                        let description =
                        """
                        Transform the provided venue photo to match the style and decorations of the selected template image. Keep the venue architecture intact while applying the template’s color scheme, decorative elements, lighting style, and overall aesthetic. High quality, professional photo. No text or logos. No people.
                        """
                        let prompt = PromptBuilder.buildTextPrompt(
                            description: description,
                            designName: nil,
                            objectNames: [] // add any template-specific objects if you like
                        )

                        // 3) Prime view model metadata (mirrors DesignView)
//                        viewModel.currentKind = .generated
                        viewModel.currentSource = "Templates"
                        viewModel.currentPrompt = prompt

                        // 4) Kick off the job, then poll
                        let started = await viewModel.startJob(venueImage: ui, referenceImage: reference)
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
                Text("Please upload a garden photo to continue.")
        }
        .onChange(of: selectedMainItem) { _, newItem in
            guard let newItem else { return }
            Task {
                if let data = try? await newItem.loadTransferable(type: Data.self),
                   let ui = UIImage(data: data) {
                    selectedMainUIImage = ui
                    selectedMainImage = Image(uiImage: ui)
                }
            }
        }
        .alert("Camera Access Needed", isPresented: $showCameraPermissionAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Open Settings") { if let url = URL(string: UIApplication.openSettingsURLString) { UIApplication.shared.open(url) } }
        } message: {
            Text("Please enable Camera access in Settings to take a photo.")
        }
        .sheet(isPresented: $showUploadSheet) {
            UploadImageSheetView(
                isObjectSheet: false,
                showSheet: $showUploadSheet,
                onCameraTap: {
                    showUploadSheet = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        showCameraPickerMain = true
                    }
                },
                onGalleryTap: {
                    showUploadSheet = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        showPhotoPickerMain = true
                        
                    }
                }
            )
              .presentationDetents([.height(320)])
            .presentationCornerRadius(20)
            .presentationDragIndicator(.visible)
        }
        .fullScreenCover(isPresented: $showCameraPickerMain) {
            ImagePicker(sourceType: .camera) { image in
                selectedMainUIImage = image
                
            }
        }
        .photosPicker(isPresented: $showPhotoPickerMain, selection: $selectedMainItem, matching: .images)
    }
    
    
    private func selectedTemplate(selectedImage: String) -> some View {
        GeometryReader { geometry in
            ZStack {
                Image(selectedImage+"\(index + 1)")
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(15)
            }
            .frame(width: geometry.size.width, height: min(geometry.size.height, ScaleUtility.scaledValue(245)))
            
        }
        .frame(height: ScaleUtility.scaledValue(245))
        
    }
    
    private func imageCanvasView(selectedImage: UIImage) -> some View {
        GeometryReader { geometry in
            ZStack(alignment: .topTrailing) {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .background(
                        GeometryReader { imageGeometry -> Color in
                            let frame = imageGeometry.frame(in: .local)
                            DispatchQueue.main.async {
                                self.imageFrame = frame
                                self.imageSize = selectedImage.size
                            }
                            return Color.clear
                        }
                    )
                    .cornerRadius(15)
                
                        //Remove Image
                        Button{
                            selectedMainUIImage = nil

                        }label: {
                            Image(.crossIcon4)
                                .resizable()
                                .frame(
                                    width: ScaleUtility.scaledValue(12),
                                    height: ScaleUtility.scaledValue(12)
                                )
                                .padding(ScaleUtility.scaledSpacing(9))
                                .background {
                                    Circle()
                                        .fill(Color.appBlack.opacity(0.5))
                                }
                                .overlay(
                                    Circle()
                                        .stroke(Color.appBlack.opacity(0.2), lineWidth: 1)
                                )
                        
                        }
                            .offset(x: ScaleUtility.scaledSpacing(-10), y: ScaleUtility.scaledSpacing(10))
                            .zIndex(1)
                    
            }
            .frame(width: geometry.size.width, height: min(geometry.size.height, ScaleUtility.scaledValue(245)))
        }
        .padding(.horizontal, ScaleUtility.scaledSpacing(15))
        .frame(height: isIPad ? ScaleUtility.scaledValue(368) : ScaleUtility.scaledValue(245))
    }
    
}
