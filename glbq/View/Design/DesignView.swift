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

//    @State private var showCameraPickerInspiration = false
//    @State private var showPhotoPickerInspiration = false
//    @State private var selectedInspirationItem: PhotosPickerItem? = nil
//    @State private var selectedInspirationUIImage: UIImage? = nil
//    @State private var selectedInspirationImage: Image? = nil
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                VStack(spacing: ScaleUtility.scaledSpacing(15)) {
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
                    .padding(.top, ScaleUtility.scaledSpacing(62))
                    
                }
                
                ScrollView {
                    
                    Spacer()
                        .frame(height: ScaleUtility.scaledValue(15))
                    
                    
                    VStack(spacing: ScaleUtility.scaledSpacing(20)) {
                        
                        if let image = selectedMainImage {
                            ImageCard(image: image) {
                                selectedMainImage = nil
                                selectedMainUIImage = nil
                            }
                        } else {
                            
                            UploadContainer(onClick: {
                                showUploadSheet = true
                            })
                            
                        }
                   
                        
                        VStack(spacing: ScaleUtility.scaledSpacing(15)) {
                            
                            GardenTypeView(selectedType: $selectedType)
                            
                            DesignThemesView(selectedTheme: $selectedTheme)
                            
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
                    .frame(height: 100)
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
                        .padding(.bottom, ScaleUtility.scaledSpacing(100))
                    
                }
                .zIndex(1)
                
            }
            
        }
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
            .presentationDetents([.height( isIPad ? 434.81137 : 334.81137)])
            .presentationCornerRadius(25)
            .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $showCameraPickerMain) {
            CameraPicker(image: $selectedMainImage, uiImage: $selectedMainUIImage)
        }
        .photosPicker(isPresented: $showPhotoPickerMain, selection: $selectedMainItem, matching: .images)
    }
}
