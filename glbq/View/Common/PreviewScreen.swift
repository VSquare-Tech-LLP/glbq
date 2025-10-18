//
//  PreviewScreen.swift
//  GLBQ
//
//  Created by Purvi Sancheti on 16/10/25.
//

import Foundation
import SwiftUI
import Photos


struct PreviewScreen: View {

    let image: UIImage
    let record: ImageRecord?
    let onDelete: () -> Void
    var onBack: () -> Void
    
    @State private var showDeleteAlert = false
    @State private var showShareSheet = false
    @State private var saveMessage: String = ""
    @State private var showSaveAlert = false
    
    @State private var showToast = false
    @State private var toastMessage = ""
    
    @State private var showPermissionAlert = false
    @State private var permissionDeniedOnce = false
    
    let notificationFeedback = UINotificationFeedbackGenerator()
    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
    
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: ScaleUtility.scaledSpacing(25)) {
                
                HStack(spacing: ScaleUtility.scaledSpacing(14)) {
                    Button {
                        onBack()
                    } label: {
                        Image(.backIcon)
                            .resizable()
                            .frame(width: ScaleUtility.scaledValue(24), height: ScaleUtility.scaledValue(24))
                    }
                    
                    Text("Result Preview")
                        .font(FontManager.generalSansMediumFont(size: .scaledFontSize(22)))
                        .foregroundColor(Color.appBlack)
                }
                .frame(maxWidth: .infinity,alignment: .leading)
                .padding(.leading, ScaleUtility.scaledSpacing(15))
                .padding(.top, ScaleUtility.scaledSpacing(64))
                
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(20)
                    .padding(.horizontal, ScaleUtility.scaledSpacing(15))
                    .frame(minHeight: isIPad ?  ScaleUtility.scaledValue(645) : ScaleUtility.scaledValue(345))
                
                VStack(spacing: ScaleUtility.scaledSpacing(10)) {
                    // Save to Gallery Button
                    Button {
                        impactFeedback.impactOccurred()
                        saveImageToGallery()
//                        AnalyticsManager.shared.log(.saveToGallery)
                    } label: {
                        HStack(spacing: ScaleUtility.scaledSpacing(5)) {
                            Image(.downloadIcon)
                                .resizable()
                                .frame(width: ScaleUtility.scaledValue(24), height: ScaleUtility.scaledValue(24))
                            
                            Text("Save to Gallery")
                                .font(FontManager.generalSansMediumFont(size: .scaledFontSize(18)))
                                .foregroundColor(Color.primaryApp)
                        }
                        .frame(height: ScaleUtility.scaledValue(60))
                        .frame(maxWidth: .infinity)
                        .background(Color.accent)
                        .cornerRadius(15)
                    }
                    .padding(.horizontal, ScaleUtility.scaledSpacing(15))
                    
                    HStack(spacing: ScaleUtility.scaledSpacing(11)) {
                        
                        // Delete Button
                        Button {
                            notificationFeedback.notificationOccurred(.warning)
                            showDeleteAlert = true
                        } label: {
                            HStack(spacing: ScaleUtility.scaledSpacing(5)) {
                                Image(.deleteIcon)
                                    .resizable()
                                    .frame(width: ScaleUtility.scaledValue(24), height: ScaleUtility.scaledValue(24))
                                
                                Text("Delete")
                                    .font(FontManager.generalSansMediumFont(size: .scaledFontSize(14)))
                                    .foregroundColor(Color.appBlack)
                            }
                            .frame(height: ScaleUtility.scaledValue(60))
                            .frame(maxWidth: .infinity)
                            .background(Color.accent.opacity(0.2))
                            .cornerRadius(15)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.accent, lineWidth: 1)
                            )
                        }
                        
                        ShareLink(
                            item: ShareablePhoto(uiImage: image),
                            preview: SharePreview("GLBQ Image", image: Image(uiImage: image))
                        ) {
                            HStack {
                                Image(.shareIcon)
                                    .resizable()
                                    .frame(width: ScaleUtility.scaledValue(24), height: ScaleUtility.scaledValue(24))
                                
                                Text("Share")
                                    .font(FontManager.generalSansMediumFont(size: .scaledFontSize(14)))
                                    .foregroundColor(Color.appBlack)
                            }
                            .frame(height: ScaleUtility.scaledValue(60))
                            .frame(maxWidth: .infinity)
                            .background(Color.accent.opacity(0.2))
                            .cornerRadius(15)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.accent, lineWidth: 1)
                            )
                        }
                    }
                    .padding(.horizontal, ScaleUtility.scaledSpacing(15))
                }
            }
            
            Spacer()
        }
        .navigationBarHidden(true)
        .background {
            Image(.appBg)
                .resizable()
                .frame(maxWidth: .infinity,maxHeight: .infinity)
        }
        .ignoresSafeArea(.all)
        .alert("Delete Image", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) {
            }
            Button("Delete", role: .destructive) {
                notificationFeedback.notificationOccurred(.success)
//                AnalyticsManager.shared.log(.deleteOne)
                onDelete()
                onBack()
            }
        } message: {
            Text("Are you sure you want to delete this image from history?")
        }
        .alert(isPresented: $showPermissionAlert) {
            Alert(
                title: Text("Photo Library Permission Denied"),
                message: Text("You need to enable photo library access to save the image. Would you like to open Settings?"),
                primaryButton: .default(Text("Open Settings")) {
                    notificationFeedback.notificationOccurred(.success)
                    if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(appSettings)
                    }
                },
                secondaryButton: .cancel()
            )
        }
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(items: [image])
        }
        .overlay(alignment:.bottom){
            Group {
                // Toast message when image is saved
                if showToast {
                    VStack {
                        Text(toastMessage)
                            .font(FontManager.generalSansRegularFont(size: .scaledFontSize(13)))
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black.opacity(0.7))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .transition(.scale)  // ✅ Smooth animation
                    }
                    .offset(y: isIPad ? ScaleUtility.scaledSpacing(-250) : ScaleUtility.scaledSpacing(-150))  // ✅ Adjust position
                }
                
            }
        }
    }
    
    private func saveImageToGallery() {
        
        PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
            switch status {
            case .authorized, .limited:
                // Save the already-available UIImage
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAsset(from: image)
                }) { success, error in
                    DispatchQueue.main.async {
                        if success {
                            toastMessage = "Image saved to gallery!"
                            showToast = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { showToast = false }
                        } else {
                            toastMessage = "Failed to save image."
                            showToast = true
                        }
                    }
                }
                
            case .denied, .restricted:
                DispatchQueue.main.async {
                    if !permissionDeniedOnce {
                        permissionDeniedOnce = true
                        showPermissionAlert = true
                    } else {
                        toastMessage = "Permission denied. Enable Photos access in Settings."
                        showToast = true
                    }
                }
                
            case .notDetermined:
                // The request above will prompt; nothing else to do here.
                break
                
            @unknown default:
                DispatchQueue.main.async {
                    toastMessage = "Unable to save due to unexpected permission state."
                    showToast = true
                }
            }
        }
    }
    
}


// Share Sheet for iOS
struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
