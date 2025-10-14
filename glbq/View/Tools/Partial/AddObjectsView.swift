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
    @StateObject private var keyboard = KeyboardResponder()
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
    
    var onBack: () -> Void
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
                                imageCanvasView(selectedImage: image)
                                
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
                                imageCanvasView(selectedImage: image)
                                
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
                    
                } label: {
                    Text("Create Now")
                        .font(FontManager.generalSansMediumFont(size: .scaledFontSize(18)))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.primaryApp)
                        .padding(.vertical,ScaleUtility.scaledSpacing(18))
                        .frame(maxWidth: .infinity)
                        .background(Color.accent)
                        .cornerRadius(10)
                        .padding(.horizontal,ScaleUtility.scaledSpacing(15))
                        .padding(.bottom,ScaleUtility.scaledSpacing(40))
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
            .presentationCornerRadius(25)
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
