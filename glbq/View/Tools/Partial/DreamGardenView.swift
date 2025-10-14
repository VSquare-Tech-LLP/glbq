//
//  DreamGardenView.swift
//  glbq
//
//  Created by Purvi Sancheti on 14/10/25.
//

import Foundation
import SwiftUI

struct DreamGardenView: View {
    var onBack: () -> Void
    var body: some View {
        VStack(spacing: 0) {
            
            HeaderView(highPadding: true,title: "Dream Garden Designer",onBack: {
                onBack()
            })
            
            Spacer()
        }
        .navigationBarHidden(true)
        .background {
            Image(.appBg)
                .resizable()
                .frame(maxWidth: .infinity,maxHeight: .infinity)
        }
        .ignoresSafeArea(.all)
        
    }
}
