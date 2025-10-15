//
//  DreamGardenView.swift
//  glbq
//
//  Created by Purvi Sancheti on 14/10/25.
//

import Foundation
import SwiftUI

struct DreamGardenView: View {
    @StateObject private var viewModel = GenerationViewModel()
    @State private var isGenerating = false
    @State private var navigateToProcessView = false
    @State var showPopUp: Bool = false
    
    let impactfeedback = UIImpactFeedbackGenerator(style: .medium)
    
    var onBack: () -> Void
    @FocusState private var searchFocused: Bool
    
    @State var description: String = ""
    @State var selectedTheme: String = ""
    @State private var selectedObjects: Set<String> = []
    @State private var showToast = false
    @State private var toastMessage = ""
    
    var body: some View {
        KeyboardAvoidingView {
            VStack(spacing: 0) {
                
                VStack(spacing: ScaleUtility.scaledSpacing(20)) {
                    
                    HeaderView(highPadding: true,title: "Dream Garden Designer",onBack: {
                        onBack()
                    })
                    
                    DescriptionView(description: $description, isInputFocused: $searchFocused)
                    
                    DesignThemesView(text:"Design Theme",
                                     isOptional: true,
                                     selectedTheme: $selectedTheme)
                    
                    addObjectView(selectedObjects: $selectedObjects)
                }
                
                Spacer()
                
                Button {
                    navigateToProcessView = true
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                        impactfeedback.impactOccurred()
                    }
                } label: {
                    Text("Design Now")
                        .font(FontManager.generalSansMediumFont(size: .scaledFontSize(18)))
                        .multilineTextAlignment(.center)
                        .foregroundColor(description == "" ? Color.appBlack.opacity(0.2) : Color.primaryApp)
                        .padding(.vertical,ScaleUtility.scaledSpacing(18))
                        .frame(maxWidth: .infinity)
                        .background(description == "" ? Color.diableApp : Color.accent)
                        .cornerRadius(15)
                        .padding(.horizontal,ScaleUtility.scaledSpacing(15))
                        .padding(.bottom,ScaleUtility.scaledSpacing(40))
                }
                .disabled(description == "")
                
            }
        }
        .navigationBarHidden(true)
        .background {
            Image(.appBg)
                .resizable()
                .frame(maxWidth: .infinity,maxHeight: .infinity)
        }
        .ignoresSafeArea(.all)
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
                    } else {
                        showPopUp = false
                        navigateToProcessView = false
                        isGenerating = false
                    }
                },
                onAppear: {
                    Task {
                        let prompt = PromptBuilder.buildTextPrompt(
                            description: description,
                            designName: selectedTheme.isEmpty ? nil : selectedTheme,
                            objectNames: selectedObjects
                        )
                        
//                        viewModel.currentKind = .generated
                        viewModel.currentSource = "DreamEventDesignerView"
                        viewModel.currentPrompt = prompt
                        
                        let started = await viewModel.startTextJob(prompt: prompt)
                        if started {
                            await viewModel.pollUntilReady()
                        } else {
                            viewModel.shouldReturnToRecreate = true
                        }
                    }
                }
            )
        }
        
    }
}
