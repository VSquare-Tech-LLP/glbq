//
//  ProcessingView.swift
//  GLBQ
//
//  Created by Purvi Sancheti on 15/10/25.
//

import Foundation
import SwiftUI

struct ProcessingView: View {
    @ObservedObject var viewModel: GenerationViewModel
    var onBack: () -> Void
    var onAppear: () -> Void
    
    @State private var progress: Double = 0.0
    @State private var timer: Timer?
    @State private var allowNavigation: Bool = false
    
    private let maxProgress: Double = 0.9 // Stop at 90% until shouldReturnToRecreate is true
    
    var body: some View {
        VStack(spacing: 0) {
            
            VStack(spacing: ScaleUtility.scaledSpacing(20)) {
                
                Spacer()
                    .frame(height: isIPad ? ScaleUtility.scaledValue(425) : ScaleUtility.scaledValue(317))
                
                ZStack {
                    // Background circle
                    Circle()
                        .stroke(Color.appBlack.opacity(0.1), lineWidth: 4.09091)
                        .frame(width: ScaleUtility.scaledValue(89.45454), height: ScaleUtility.scaledValue(89.45454))
                    
                    // Progress circle (accent color)
                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(
                            Color.accent,
                            style: StrokeStyle(
                                lineWidth: 4.09091,
                                lineCap: .round
                            )
                        )
                        .frame(width: ScaleUtility.scaledValue(89.45454), height: ScaleUtility.scaledValue(89.45454))
                        .rotationEffect(.degrees(90)) // Start from top, go anti-clockwise
                        .rotation3DEffect(.degrees(180), axis: (x: 1, y: 0, z: 0)) // Flip to make it go anti-clockwise
                        .animation(.linear(duration: 1.0), value: progress)
                    
                    // Grass icon
                    Image(.grassIcon)
                        .resizable()
                        .frame(width: ScaleUtility.scaledValue(65.45454), height: ScaleUtility.scaledValue(65.45454))
                }
                .padding(.all, ScaleUtility.scaledSpacing(12.27))
                
                Text("Generating your Dream Garden")
                    .font(FontManager.generalSansMediumFont(size: .scaledFontSize(14)))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.appBlack.opacity(0.5))
                
            }
            
            Spacer()
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarHidden(true)
        .background {
            Image(.appBg)
                .resizable()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .ignoresSafeArea(.all)
        .navigationDestination(isPresented: $allowNavigation) {
            ResultView(viewModel: viewModel) { onBack() }
        }
        .onAppear {
            onAppear()
            startProgressTimer()
        }
        .onDisappear {
            stopProgressTimer()
        }
        .onChange(of: viewModel.shouldReturnToRecreate) { goBack in
            if goBack {
                // Complete the progress to 100% first
                withAnimation(.easeInOut(duration: 0.8)) {
                    progress = 1.0
                }
                // Wait for animation to complete, then navigate
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                    onBack()
                }
            }
        }
        .onChange(of: viewModel.shouldNavigateToResult) { shouldNavigate in
            if shouldNavigate && progress < 1.0 {
                // If trying to navigate but progress not complete, complete it first
                withAnimation(.easeInOut(duration: 0.8)) {
                    progress = 1.0
                }
                // Wait for animation to complete, then allow navigation
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                    allowNavigation = true
                }
            } else if shouldNavigate && progress >= 1.0 {
                // Progress already complete, navigate immediately
                allowNavigation = true
            }
        }
    }
    
    private func startProgressTimer() {
        progress = 0.0
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if progress < maxProgress {
                // Increment progress smoothly, slowing down as it approaches maxProgress
                let increment = (maxProgress - progress) * 0.1
                progress += max(increment, 0.02) // Minimum increment to keep moving
            }
        }
    }
    
    private func stopProgressTimer() {
        timer?.invalidate()
        timer = nil
    }
}
