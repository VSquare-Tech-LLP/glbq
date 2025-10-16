//
//  RecreateView.swift
//  glbq
//
//  Created by Purvi Sancheti on 11/10/25.
//

import Foundation
import SwiftUI
import PhotosUI


enum UploadType { case main, reference }


struct RecreateView: View {
    
    @StateObject private var viewModel = GenerationViewModel()
    
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
    
    @State var isObjectSheet: Bool = false
    
    @State var navigateToProcessView: Bool = false
    
    @State private var isRecreateLoading = false
    @State private var showToast = false
    @State private var toastMessage = ""
    
    @State private var showValidationAlert = false
    
    var body: some View {
        
     ZStack(alignment: .bottom) {
            
            VStack(spacing: 0) {
                
                HStack {
                    
                    Text("Recreate from Reference")
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
                        .frame(height: ScaleUtility.scaledValue(25))
                    
                    VStack(spacing: ScaleUtility.scaledSpacing(20)) {
                        
                        if let image = selectedMainUIImage {
                            imageCanvasView(selectedImage: image,onRemove: {
                                selectedMainUIImage = nil
                            })
                            
                        } else {
                            
                            UploadContainer(
                                title:"Upload Garden Photo",
                                onClick: {
                                    isObjectSheet = false
                                    activeUploadType = .main  // ✅ Set the type!
                                    showUploadSheet = true
                                   
                                })
                            
                        }
                        
                        // Text
                        Text("Add Reference Garden Photo")
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
                                    isObjectSheet = true
                                    activeUploadType = .reference  // ✅ Set the type!
                                    showUploadSheet = true
                                  
                                })
                            
                        }
                        
                        
                    }
                    
                    Spacer()
                        .frame(height: ScaleUtility.scaledValue(200))
                    
                }
                
                
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
                    if canProceed && !isRecreateLoading {
                        navigateToProcessView = true
                    } else if !isRecreateLoading {
                        showValidationAlert = true
                    }
                } label: {
                    Text("Recreate")
                        .font(FontManager.generalSansMediumFont(size: .scaledFontSize(18)))
                        .multilineTextAlignment(.center)
                        .foregroundColor(selectedMainUIImage == nil || selectedReferenceImage == nil || isRecreateLoading ?  Color.appBlack.opacity(0.2) :  Color.primaryApp)
                        .padding(.vertical,ScaleUtility.scaledSpacing(18))
                        .frame(maxWidth: .infinity)
                        .background(selectedMainUIImage == nil || selectedReferenceImage == nil || isRecreateLoading ? Color.diableApp : Color.accent)
                        .cornerRadius(10)
                        .padding(.horizontal,ScaleUtility.scaledSpacing(15))
                        .padding(.bottom, ScaleUtility.scaledSpacing(100))
                    
                }
                .zIndex(1)
//                .disabled(selectedMainUIImage == nil || selectedReferenceImage == nil || isRecreateLoading)
            }
            
        }
        .background {
            Image(.appBg)
                .resizable()
                .frame(maxWidth: .infinity,maxHeight: .infinity)
        }
        .ignoresSafeArea(.all)
        .alert(isPresented: $showToast) {
            Alert(
                title: Text("Error"),
                message: Text(toastMessage),
                dismissButton: .default(Text("OK")) {
                    showToast = false
                }
            )
        }
        // NAV → ProcessingView (passes the same viewModel)
        .navigationDestination(isPresented: $navigateToProcessView) {
            ProcessingView(viewModel: viewModel,
            onBack: {
         
                // if ProcessingView sent us back due to an error, show a toast
                if viewModel.shouldReturnToRecreate {
                    toastMessage = viewModel.errorMessage ?? "Generation failed. Please try again."
//                    showPopUp = false
                    navigateToProcessView = false
                    isRecreateLoading = false
                    withAnimation { showToast = true }
           
                    viewModel.shouldReturnToRecreate = false
                }
                else {
//                    showPopUp = false
                    navigateToProcessView = false
                    isRecreateLoading = false
                }
            },  onAppear: {
                Task {
                    guard let venue = selectedMainUIImage,
                          let reference = selectedReferenceUIImage else {
                        // no images? bounce back
                        isRecreateLoading = false
                        viewModel.shouldReturnToRecreate = true
                        return
                    }
                    
                    viewModel.currentSource = "Recreate"
                    viewModel.currentPrompt = "Transform the provided garden photo using the reference garden's design, landscaping, and plant arrangements. Keep the original garden's space and structure intact while applying the reference garden's style, plants, and layout."
                    
                    let started = await viewModel.startJob(venueImage: venue, referenceImage: reference)
                    if started {
                        await viewModel.pollUntilReady()
                    } else {
                        // start failed → send us back and show toast
                        viewModel.shouldReturnToRecreate = true
                    }
                }
            })
        }
        .alert("Missing Information", isPresented: $showValidationAlert) {
             Button("OK", role: .cancel) { }
         } message: {
             if selectedMainUIImage == nil {
                 Text("Please upload a garden photo to continue.")
             } else {
                 Text("Please upload a reference garden photo to continue.")
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
                isObjectSheet: $isObjectSheet,
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
        .fullScreenCover(isPresented: $showCameraPickerReference) {
            ImagePicker(sourceType: .camera) { image in
                selectedReferenceUIImage = image
     
            }
        }
        .photosPicker(isPresented: $showPhotoPickerReference, selection: $selectedReferenceItem, matching: .images)
    }
    
    private var canProceed: Bool {
        selectedMainUIImage != nil && selectedReferenceUIImage != nil
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
        .frame(height: ScaleUtility.scaledValue(245))
    }
}
