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
    
    @StateObject private var viewModel = GenerationViewModel()
    
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
                    
                    selectedTemplate(selectedImage: SelectedTemplate)
                    
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
                        navigateToProcessView = true
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
            .presentationDetents([.height( isIPad ? 434.81137 : 320)])
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
            .frame(width: geometry.size.width, height: min(geometry.size.height, ScaleUtility.scaledValue(245)))
        }
        .padding(.horizontal, ScaleUtility.scaledSpacing(15))
        .frame(height: ScaleUtility.scaledValue(245))
    }
    
}
