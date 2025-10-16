//
//  DesignView.swift
//  glbq
//
//  Created by Purvi Sancheti on 11/10/25.
//

import Foundation
import SwiftUI
import PhotosUI

struct DesignView: View {
    
    @StateObject private var viewModel = GenerationViewModel()
    let impactfeedback = UIImpactFeedbackGenerator(style: .medium)
    
    @State var selectedType: String = ""
    @State var selectedTheme: String = ""
    @State private var selectedObjects: Set<String> = []
    
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
    @State private var isGenerating = false

//    @State private var showCameraPickerInspiration = false
//    @State private var showPhotoPickerInspiration = false
//    @State private var selectedInspirationItem: PhotosPickerItem? = nil
//    @State private var selectedInspirationUIImage: UIImage? = nil
//    @State private var selectedInspirationImage: Image? = nil
    
    @State private var navigateToProcessView = false
    
    @State private var showValidationAlert = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
            
                    HStack {
                        
                        Text("Ai Garden Designer")
                            .font(FontManager.generalSansMediumFont(size: .scaledFontSize(22)))
                            .foregroundColor(Color.appBlack)
                        
                        Spacer()
                        
                        Image(.crownIcon)
                            .resizable()
                            .frame(width: ScaleUtility.scaledValue(24), height: ScaleUtility.scaledValue(24))
                            .padding(.all, ScaleUtility.scaledSpacing(9))
                            .background {
                                Circle()
                                    .fill(.primaryApp)
                            }
                    }
                    .padding(.horizontal, ScaleUtility.scaledSpacing(15))
                    .padding(.top, ScaleUtility.scaledSpacing(59))
                    
                
                
                ScrollView {
                    
                    Spacer()
                        .frame(height: ScaleUtility.scaledValue(15))
                    
                    
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
                   
                        
                        VStack(spacing: ScaleUtility.scaledSpacing(15)) {
                            
                            GardenTypeView(selectedType: $selectedType)
                            
                            DesignThemesView(text:"Design Theme",
                                             isOptional: false,
                                             selectedTheme: $selectedTheme)
                            
                            addObjectView(selectedObjects: $selectedObjects)
                        }
                    }
                    
                    Spacer()
                        .frame(height: ScaleUtility.scaledValue(200))
                    
                }
                
                Spacer()
            }
            
            
            ZStack {
                
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
                    .frame(height: ScaleUtility.scaledValue(100))
                    .allowsHitTesting(true)
              
                
                
                Button {
                    
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                        impactfeedback.impactOccurred()
                    }
                    // Check validation before proceeding
                    if canProceed {
                        navigateToProcessView = true
                    } else {
                        showValidationAlert = true
                    }
                    
                } label: {
                    Text("Create Now")
                        .font(FontManager.generalSansMediumFont(size: .scaledFontSize(18)))
                        .multilineTextAlignment(.center)
                        .foregroundColor(selectedMainUIImage == nil || selectedType.isEmpty || selectedTheme.isEmpty ? Color.appBlack.opacity(0.2) : Color.primaryApp)
                        .padding(.vertical,ScaleUtility.scaledSpacing(18))
                        .frame(maxWidth: .infinity)
                        .background(selectedMainUIImage == nil || selectedType.isEmpty || selectedTheme.isEmpty ?  Color.diableApp  : Color.accent)
                        .cornerRadius(10)
                        .padding(.horizontal,ScaleUtility.scaledSpacing(15))
                        .padding(.bottom, ScaleUtility.scaledSpacing(100))
                    
                }
//                .disabled(selectedMainUIImage == nil || selectedType.isEmpty || selectedTheme.isEmpty)
                .zIndex(1)
                
            }
            
        }
        .background {
            Image(.appBg)
                .resizable()
                .frame(maxWidth: .infinity,maxHeight: .infinity)
        }
        .ignoresSafeArea(.all)
        .alert("Missing Information", isPresented: $showValidationAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            if selectedMainUIImage == nil {
                Text("Please upload a garden photo to continue.")
            } else if selectedType.isEmpty {
                Text("Please select a garden type to continue.")
            } else {
                Text("Please select a design theme to continue.")
            }
        }
        .navigationDestination(isPresented: $navigateToProcessView) {
            ProcessingView(
                viewModel: viewModel,
                onBack: {
              
                    if viewModel.shouldReturnToRecreate {
                        toastMessage = viewModel.errorMessage ?? "Generation failed. Please try again."
//                        showPopUp = false
                        navigateToProcessView = false
                        isGenerating = false
                        withAnimation { showToast = true }
                
                        viewModel.shouldReturnToRecreate = false
                    }
                    else {
//                        showPopUp = false
                        navigateToProcessView = false
                        isGenerating = false
                    }
                },
                onAppear: {
                    Task {
                        guard let ui = selectedMainUIImage else {
                            isGenerating = false
                            viewModel.shouldReturnToRecreate = true
                            return
                        }
                        let prompt = PromptBuilder.buildPrompt(
                            typeName: selectedType,
                            themeName: selectedTheme,
                            objectNames: selectedObjects
                        )
                        
//                        viewModel.currentKind = .generated
                        viewModel.currentSource = "Ai Garden"
                        viewModel.currentPrompt = prompt
                        
                        let started = await viewModel.startDesignJob(image: ui, prompt: prompt)
                        if started {
                            await viewModel.pollUntilReady()
                        } else {
                            viewModel.shouldReturnToRecreate = true
                        }
                    }
                }
            )
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
    
    private var canProceed: Bool {
           selectedMainUIImage != nil && !selectedType.isEmpty && !selectedTheme.isEmpty
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
