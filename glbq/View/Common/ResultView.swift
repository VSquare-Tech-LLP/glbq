//
//  ResultView.swift
//  GLBQ
//
//  Created by Purvi Sancheti on 15/10/25.
//

import Foundation
import SwiftUI
import PhotosUI
import UIKit
import Kingfisher

struct ResultView: View {
    @ObservedObject var viewModel: GenerationViewModel
    var onBack: () -> Void
    
    @State private var imageAspect: CGFloat? = nil
    @State private var showToast = false
    @State private var toastMessage = ""

    @State private var showPermissionAlert = false
    @State private var permissionDeniedOnce = false
    @State var generatedImage: UIImage?
    @State var buttonDisabled: Bool = true
    
    var body: some View {
        VStack(spacing: 0) {
            
            VStack(spacing: ScaleUtility.scaledSpacing(20)) {
                
                HStack(spacing: ScaleUtility.scaledSpacing(14)) {
                    Button {
                        onBack()
                    } label: {
                        Image(.backIcon)
                            .resizable()
                            .frame(width: ScaleUtility.scaledValue(24), height: ScaleUtility.scaledValue(24))
                    }
                    
                    Text("Result")
                        .font(FontManager.generalSansMediumFont(size: .scaledFontSize(22)))
                        .foregroundColor(Color.appBlack)
                }
                .frame(maxWidth: .infinity,alignment: .leading)
                .padding(.leading, ScaleUtility.scaledSpacing(15))
                .padding(.top, ScaleUtility.scaledSpacing(64))
                
                
                
                // Fixed container with consistent sizing like ImagePreview
                if let urlStr = viewModel.resultData?.bestImageURL,
                   let url = URL(string: urlStr) {
                    
                    KFImage(url)
                        .placeholder {
                            ZStack {
                                Rectangle()
                                    .fill(Color.appBlack.opacity(0.2))
                                    .cornerRadius(10)
                                
                                ProgressView()
                                    .tint(Color.primaryApp)
                            }
                        }
                        .onSuccess { result in
                            let uiImage = result.image
                            generatedImage = uiImage
                            buttonDisabled = false
                        }
                        .resizable()
                        .scaledToFit() // This ensures proper aspect ratio within the container
                        .cornerRadius(10)
                        .padding(.horizontal, ScaleUtility.scaledSpacing(15)) // Same as ImagePreview
                        .frame(minHeight: isIPad ?  ScaleUtility.scaledValue(645) : ScaleUtility.scaledValue(400))
                } else {
                    Text("No result found yet.")
                        .foregroundColor(.secondary)
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
        .overlay(alignment:.bottom){
            Group {
                if showToast {
                    VStack {
                        Text(toastMessage)
                            .font(FontManager.generalSansRegularFont(size: .scaledFontSize(13)))
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black.opacity(0.7))
                            .cornerRadius(10)
                            .transition(.scale)
                    }
                    .offset(y: isIPad ? ScaleUtility.scaledSpacing(-250) : ScaleUtility.scaledSpacing(-150))
                }
            }
        }
        .alert(isPresented: $showPermissionAlert) {
            Alert(
                title: Text("Photo Library Permission Denied"),
                message: Text("You need to enable photo library access to save the image. Would you like to open Settings?"),
                primaryButton: .default(Text("Open Settings")) {
                    if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(appSettings)
                    }
                },
                secondaryButton: .cancel()
            )
        }
    }
}
