//
//  AddObjectsView.swift
//  glbq
//
//  Created by Purvi Sancheti on 14/10/25.
//

import Foundation
import PhotosUI
import SwiftUI



struct AddObjectsView: View {
    
    @StateObject var userDefault = UserSettings()
    @EnvironmentObject var purchaseManager: PurchaseManager
    @EnvironmentObject var remoteConfigManager: RemoteConfigManager
    
    @StateObject private var ads = RewardedAdManager(adUnitID: "ca-app-pub-3997698054569290/2718681220")
    
    @State var isShowPayWall: Bool = false
    @State var showLimitPopOver: Bool = false
    
    @StateObject private var keyboard = KeyboardResponder()
    @StateObject private var viewModel = GenerationViewModel()
    @State private var isGenerating = false
    @State private var navigateToProcessView = false
    
    @State private var showToast = false
    @State private var toastMessage = ""
    
    let impactfeedback = UIImpactFeedbackGenerator(style: .medium)
    
    @State private var showUploadSheet = false
    
    @State private var showCameraPermissionAlert = false
    @State private var cameraDeniedOnce = false
    
//    @State private var showCameraPickerReferenceAlert = false
//    @State private var showPhotoPickerReferenceAlert = false

    @State private var showCameraPickerMain = false
    @State private var showPhotoPickerMain = false
    
    @State private var showCameraPickerReference = false
    @State private var showPhotoPickerReference = false
    
    @State private var selectedMainItem: PhotosPickerItem? = nil
    @State private var selectedMainUIImage: UIImage? = nil
    @State private var selectedMainImage: Image? = nil
    
    @State private var selectedReferenceItem: PhotosPickerItem? = nil
    @State private var selectedReferenceUIImage: UIImage? = nil
    @State private var selectedReferenceImage: Image? = nil
    
    @State private var imageFrame: CGRect = .zero
    @State private var imageSize: CGSize = .zero
    
    @State private var activeUploadType: UploadType? = nil
    
    @FocusState private var withFocused: Bool
    @State var objToAddText: String = ""
    
    @State var showPopUp: Bool = false
    
    var onBack: () -> Void
    
    @State private var showValidationAlert = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            VStack(spacing: 0) {
                
                HeaderView(highPadding: true,title: "Add Objects",onBack: {
                    onBack()
                })
                
                
                ScrollViewReader { scrollView in
                    ScrollView {
                        
                        Spacer()
                            .frame(height: ScaleUtility.scaledValue(20))
                        
                        VStack(spacing: ScaleUtility.scaledSpacing(20)) {
                            
                            if let image = selectedMainUIImage {
                                imageCanvasView(selectedImage: image,onRemove: {
                                    selectedMainUIImage = nil
                                })
                                
                            } else {
                                
                                UploadContainer(
                                    title:"Upload Garden Photo",
                                    onClick: {
                                        activeUploadType = .main  // ✅ Set the type!
                                        showUploadSheet = true
                                    })
                                
                            }
                            
                            // Text
                            Text("Add Photo of the Object to add")
                                .font(FontManager.generalSansMediumFont(size: .scaledFontSize(18)))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity,alignment: .leading)
                                .padding(.leading, ScaleUtility.scaledValue(15))
                            
                            if let image = selectedReferenceUIImage {
                                imageCanvasView(selectedImage: image,onRemove: {
                                    selectedReferenceUIImage = nil
                                })
                                
                            } else {
                                
                                UploadContainer(
                                    title:"Upload Reference Photo",
                                    onClick: {
                                        activeUploadType = .reference  // ✅ Set the type!
                                        showUploadSheet = true
                                    })
                                
                            }
                            
                            
                            DescriptionCommonView(
                                title: "Describe Object to add",
                                subtitle: "Upload above or describe object and placement here..",
                                descriptionText: $objToAddText,
                                isInputFocused: $withFocused
                            )
                            
                        }
                        
                        if keyboard.currentHeight > 0 {
                            Spacer()
                                .frame(height: ScaleUtility.scaledValue(380))
                        }
                        else {
                            Spacer()
                                .frame(height: ScaleUtility.scaledValue(150))
                        }
                        
                        Color.clear
                            .frame(maxWidth: .infinity)
                            .frame(height: ScaleUtility.scaledValue(1))
                            .id("ScrollToBottom")
                        
                    }
                    .onChange(of: keyboard.currentHeight) { height in
                        if height > 0 {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                withAnimation(.easeOut(duration: 0.25)) {
                                    scrollView.scrollTo("ScrollToBottom", anchor: .bottom)
                                }
                            }
                        }
                    }
                }
            }
            
            Spacer()
            
            
            ZStack(alignment: .bottom) {
                
                Rectangle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.black.opacity(0.8),
                                Color.black.opacity(0.4),
                                Color.black.opacity(0.0)
                            ]),
                            startPoint: .bottom,
                            endPoint: .top
                        )
                    )
                    .frame(maxWidth: .infinity)
                    .frame(height: 170)
                    .allowsHitTesting(true)
                
                
                
                
                Button {
                   
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                        impactfeedback.impactOccurred()
                    }
                    if !canProceed {
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
                    Text("Create Now")
                        .font(FontManager.generalSansMediumFont(size: .scaledFontSize(18)))
                        .multilineTextAlignment(.center)
                        .foregroundColor(!canProceed ?  Color.appBlack.opacity(0.2)  : Color.primaryApp)
                        .padding(.vertical,ScaleUtility.scaledSpacing(18))
                        .frame(maxWidth: .infinity)
                        .background(!canProceed ? Color.diableApp : Color.accent)
                        .cornerRadius(10)
                        .padding(.horizontal,ScaleUtility.scaledSpacing(15))
                        .padding(.bottom,ScaleUtility.scaledSpacing(40))
//                        .disabled(!canProceed)
                }
            }
            .zIndex(1)
        
      
        }
        .navigationBarHidden(true)
        .background {
            Image(.appBg)
                .resizable()
                .frame(maxWidth: .infinity,maxHeight: .infinity)
        }
        .ignoresSafeArea(.all)
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
                    }
                    else {
                        showPopUp = false
                        navigateToProcessView = false
                        isGenerating = false
                    }
                },
                onAppear: {
                    Task {
                        guard let venue = selectedMainUIImage else {
                            viewModel.shouldReturnToRecreate = true
                            return
                        }

                        // Build prompt from either text or “using object image”
                        let prompt = PromptBuilder.buildAddObjectsPrompt(
                            objectDescription: objToAddText.isEmpty ? nil : objToAddText,
                            venueContext: nil,
                            keepBackground: true
                        )
                        
//                        viewModel.currentKind = .edited
                        viewModel.currentSource = "Add Objects"
                        viewModel.currentPrompt = prompt

                        let started = await viewModel.startAddObjectJob(
                            venue: venue,
                            object: selectedReferenceUIImage,          // nil if text-only path
                            prompt: prompt
                        )
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
            if selectedMainUIImage == nil {
                Text("Please upload a garden photo to continue.")
            } else {
                Text("Either upload object photo to add or describe it in the description box.")
            }
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
        .onChange(of: selectedReferenceItem) { _, newItem in
            guard let newItem else { return }
            Task {
                if let data = try? await newItem.loadTransferable(type: Data.self),
                   let ui = UIImage(data: data) {
                    selectedReferenceUIImage = ui
                    selectedReferenceImage = Image(uiImage: ui)
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
                isObjectSheet: true,
                showSheet: $showUploadSheet,
                onCameraTap: {
                    showUploadSheet = false
                    Task { @MainActor in
                        if await CameraAuth.requestIfNeeded() {
                            try? await Task.sleep(nanoseconds: 300_000_000)
                            if activeUploadType == .main {
                                showCameraPickerMain = true  // ✅ Fixed!
                            }
                            else if activeUploadType == .reference {
                                showCameraPickerReference = true  // ✅ Fixed!
                            }
                        } else {
                            cameraDeniedOnce = (CameraAuth.status() != .notDetermined)
                            try? await Task.sleep(nanoseconds: 300_000_000)
                            showCameraPermissionAlert = true
                        }
                    }
                },
                onGalleryTap: {
                    showUploadSheet = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        if activeUploadType == .main {
                            showPhotoPickerMain = true  // ✅ Fixed!
                        }
                        else if activeUploadType == .reference {
                            showPhotoPickerReference = true  // ✅ Fixed!
                        }
                    }
                }
            )
            .presentationDetents([.height( 320)])
            .presentationCornerRadius(20)
            .presentationDragIndicator(.visible)
        }
        .fullScreenCover(isPresented: $showCameraPickerMain) {
            ImagePicker(sourceType: .camera) { image in
                selectedMainUIImage = image
     
            }
        }
        .photosPicker(isPresented: $showPhotoPickerMain, selection: $selectedMainItem, matching: .images)
        .fullScreenCover(isPresented: $showCameraPickerReference) {
            ImagePicker(sourceType: .camera) { image in
                selectedReferenceUIImage = image
     
            }
        }
        .photosPicker(isPresented: $showPhotoPickerReference, selection: $selectedReferenceItem, matching: .images)
    }
    
    private var canProceed: Bool {
        selectedMainUIImage != nil &&
        (selectedReferenceUIImage != nil || !objToAddText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
    }

    
    private func imageCanvasView(selectedImage: UIImage,onRemove: @escaping () -> Void) -> some View {
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
                            onRemove()
                            
                        }label: {
                            Image(.crossIcon2)
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
            .frame(width: geometry.size.width, height: min(geometry.size.height, ScaleUtility.scaledValue(345)))
        }
        .padding(.horizontal, ScaleUtility.scaledSpacing(15))
        .frame(height: isIPad ? ScaleUtility.scaledValue(368) : ScaleUtility.scaledValue(245))
    }
}
