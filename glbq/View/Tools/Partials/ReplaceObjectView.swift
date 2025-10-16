//
//  ReplaceObjectView.swift
//  glbq
//
//  Created by Purvi Sancheti on 14/10/25.
//

import Foundation
import SwiftUI
import PhotosUI

struct ReplaceObjectsView: View {
    @StateObject private var viewModel = GenerationViewModel()
    @StateObject private var keyboard = KeyboardResponder()
    
    var onBack: () -> Void
    let impactfeedback = UIImpactFeedbackGenerator(style: .medium)
    
    @State private var showUploadSheet = false
    @State private var navigateToProcessView = false
    
    @State private var showCameraPermissionAlert = false
    @State private var cameraDeniedOnce = false
    
    @State private var showCameraPickerMain = false
    @State private var showPhotoPickerMain = false
    
    @State private var selectedMainItem: PhotosPickerItem? = nil
    @State private var selectedMainUIImage: UIImage? = nil
    @State private var selectedMainImage: Image? = nil
    
    @State private var imageFrame: CGRect = .zero
    @State private var imageSize: CGSize = .zero
    
    @FocusState private var withFocused: Bool
    @State var objToReplaceText: String = ""
    @State var objToReplaceWithText: String = ""
    
    // Toast states
    @State private var showToast = false
    @State private var toastMessage = ""

    @State private var showValidationAlert = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                
                HeaderView(highPadding: true,title: "Replace Objects",onBack: {
                    onBack()
                })
                
                ScrollViewReader { scrollView in
                    ScrollView {
                        
                        Spacer()
                            .frame(height: ScaleUtility.scaledValue(20))
                        
                        VStack(spacing: ScaleUtility.scaledSpacing(20)) {
                  
                            
                            if let image = selectedMainUIImage {
                                imageCanvasView(selectedImage: image)
                                
                            } else {
                                
                                UploadContainer(
                                    title:"Upload Garden Photo",
                                    onClick: {
                                        showUploadSheet = true
                                    })
                                
                            }
                            
                            DescriptionCommonView(
                                title: "Describe Object to Replace",
                                subtitle: "E.g. Benches on the left",
                                descriptionText: $objToReplaceText,
                                isInputFocused: $withFocused
                            )
                            
                            DescriptionCommonView(
                                title: "Describe What to Replace with",
                                subtitle: "E.g. Swimming Pool",
                                descriptionText: $objToReplaceWithText,
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
                        navigateToProcessView = true
                    }
                    
                } label: {
                    Text("Replace Now")
                        .font(FontManager.generalSansMediumFont(size: .scaledFontSize(18)))
                        .multilineTextAlignment(.center)
                        .foregroundColor(!canProceed ?  Color.appBlack.opacity(0.2)  : Color.primaryApp)
                        .padding(.vertical,ScaleUtility.scaledSpacing(18))
                        .frame(maxWidth: .infinity)
                        .background(!canProceed ? Color.diableApp : Color.accent)
                        .cornerRadius(10)
                        .padding(.horizontal,ScaleUtility.scaledSpacing(15))
                        .padding(.bottom,ScaleUtility.scaledSpacing(40))
                }
//                .disabled(!canProceed)
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
        // MARK: - Navigation
        .navigationDestination(isPresented: $navigateToProcessView) {
            ProcessingView(
                viewModel: viewModel,
                onBack: {
              
                    if viewModel.shouldReturnToRecreate {
                        toastMessage = viewModel.errorMessage ?? "Unable to Process Prompt."
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
                        guard let image = selectedMainUIImage else {
                            viewModel.shouldReturnToRecreate = true
                            return
                        }

                        // Inside the ProcessingView onAppear Task
                        let prompt = PromptBuilder.buildObjectReplacementPrompt(
                            replace: objToReplaceText,
                            with: objToReplaceWithText,
                            gardenContext: nil,
                            keepBackground: true
                        )
                        
//                        viewModel.currentKind = .edited
                        viewModel.currentSource = "Replace Objects"
                        viewModel.currentPrompt = prompt
                        
                        let started = await viewModel.startDesignJob(image: image, prompt: prompt)

                        if started {
                            await viewModel.pollUntilReady()
                        } else {
                            viewModel.shouldReturnToRecreate = true
                        }
                    }
                }

            )
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
                isObjectSheet: true,
                showSheet: $showUploadSheet,
                onCameraTap: {
                    showUploadSheet = false

                    Task { @MainActor in
                        if await CameraAuth.requestIfNeeded() {
                            try? await Task.sleep(nanoseconds: 300_000_000)
                            showCameraPickerMain = true
                            
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
                        showPhotoPickerMain = true
                        
                    }
                }
            )
            .presentationDetents([.height( isIPad ? 434.81137 : 320)])
            .presentationCornerRadius(20)
            .presentationDragIndicator(.visible)
        }
        .alert("Missing Information", isPresented: $showValidationAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            if selectedMainUIImage == nil {
                Text("Please upload a garden photo to continue.")
            } else if objToReplaceText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                Text("Please describe the object you want to replace.")
            } else {
                Text("Please describe what you want to replace it with.")
            }
        }
        .fullScreenCover(isPresented: $showCameraPickerMain) {
            ImagePicker(sourceType: .camera) { image in
                selectedMainUIImage = image
                
            }
        }
        .photosPicker(isPresented: $showPhotoPickerMain, selection: $selectedMainItem, matching: .images)
        
    }
    
    private var canProceed: Bool {
        selectedMainUIImage != nil &&
        !objToReplaceText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !objToReplaceWithText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
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
        .frame(height: ScaleUtility.scaledValue(245))
    }
}

