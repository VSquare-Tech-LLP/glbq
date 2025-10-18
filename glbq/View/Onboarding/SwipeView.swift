//
//  SwipeView.swift
//  EveCraft
//
//  Created by Purvi Sancheti on 02/09/25.
//


import Foundation
import SwiftUI

struct SwipeView: View {
    
    @State private var currentIndex = 0  // Keep as @State
    @State private var shownextScreen = false
    let totalScreens = 8
    var showPaywall: () -> Void
    @State private var selectedOptions: Set<String> = []
    
    var body: some View {
        PagingTabView(selectedIndex: $currentIndex, tabCount: totalScreens, spacing: 0) {
            Group {
                
                WelcomeView()
                    .tag(0)
                
                OnboardingView(imageName: "intro1",
                               title: "Apply Beautiful\n Preset Styles",
                               screenIndex: 1,
                               currentScreenIndex: $currentIndex)
                    .tag(1)
                
                OnboardingView(imageName: "intro2",
                               title: "Design Any\nType of Garden",
                               screenIndex: 2,
                               currentScreenIndex: $currentIndex)
                    .tag(2)
                
                OnboardingView(imageName: "intro3",
                               title: "Turn Inspiration\ninto Reality",
                               screenIndex: 3,
                               currentScreenIndex: $currentIndex)
                    .tag(3)
                
                OnboardingView(imageName: "intro4",
                               title: "Powerful AI\nEditing Tools",
                               screenIndex: 4,
                               currentScreenIndex: $currentIndex)
                .tag(4)
                
                OnboardingView(imageName: "intro5",
                               title: "Bring Your\nImagination to Life",
                               screenIndex: 5,
                               currentScreenIndex: $currentIndex)
                .tag(5)
                
                RatingView()
                    .tag(6)
                
                QuestionsView(selectedOptions: $selectedOptions)
                    .tag(7)
                
            }
        } buttonAction: {
            handleButtonPress()
        }
        .animation(.easeInOut(duration: 0.3), value: currentIndex)
    }
    
    private func handleButtonPress() {
        if currentIndex == 7 {
            showPaywall()
        }
        else {
            self.currentIndex += 1
        }
    }
}
