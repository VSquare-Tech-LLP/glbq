//
//  KeyboardAvoidingView.swift
//  EveCraft
//
//  Created by Purvi Sancheti on 29/08/25.
//

import Foundation
// Add this helper view to handle keyboard properly
import SwiftUI
import Combine

struct KeyboardAvoidingView<Content: View>: View {
    let content: Content
    @State private var keyboardHeight: CGFloat = 0
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        GeometryReader { geometry in
            content
                .frame(width: geometry.size.width, height: geometry.size.height)
                .clipped()
        }
        .ignoresSafeArea(.keyboard)
        .onReceive(Publishers.keyboardHeight) { keyboardHeight in
            // Don't adjust for keyboard - keep content fixed
            self.keyboardHeight = 0
        }
    }
}

// Extension to monitor keyboard
extension Publishers {
    static var keyboardHeight: AnyPublisher<CGFloat, Never> {
        let willShow = NotificationCenter.default.publisher(for: UIApplication.keyboardWillShowNotification)
            .map { notification -> CGFloat in
                (notification.userInfo?[UIApplication.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0
            }
        
        let willHide = NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification)
            .map { _ -> CGFloat in 0 }
        
        return MergeMany(willShow, willHide)
            .eraseToAnyPublisher()
    }
}
