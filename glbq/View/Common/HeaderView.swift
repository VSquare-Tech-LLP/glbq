//
//  HeaderView.swift
//  glbq
//
//  Created by Purvi Sancheti on 14/10/25.
//

import Foundation
import SwiftUI

struct HeaderView: View {
    var highPadding: Bool
    var title: String
    var onBack: () -> Void
    @EnvironmentObject var purchaseManager: PurchaseManager
    @State var isShowPayWall: Bool = false
 
    var body: some View {
        
        ZStack(alignment: .trailing) {
            HStack {
                HStack(spacing: ScaleUtility.scaledSpacing(14)) {
                    Button {
                        onBack()
                    } label: {
                        
                        Image(.backIcon)
                            .resizable()
                            .frame(width: ScaleUtility.scaledValue(24), height: ScaleUtility.scaledValue(24))
                        
                        // Text
                        Text(title)
                            .font(FontManager.generalSansMediumFont(size: .scaledFontSize(22)))
                            .foregroundColor(Color.appBlack)
                    }
                }
                
                Spacer()
           
            }
            
            Button {
                isShowPayWall = true
            } label: {
                Image(.crownIcon)
                    .resizable()
                    .frame(width: ScaleUtility.scaledValue(24), height: ScaleUtility.scaledValue(24))
                    .padding(.all, ScaleUtility.scaledSpacing(9))
                    .background {
                        Circle()
                            .fill(Color.primaryApp)
                    }
            }
        }
        .padding(.horizontal, ScaleUtility.scaledSpacing(15))
        .padding(.top, highPadding ?  ScaleUtility.scaledSpacing(59) : ScaleUtility.scaledSpacing(15))
        .fullScreenCover(isPresented: $isShowPayWall) {
            PaywallView(isInternalOpen: true) {
                isShowPayWall = false
            } purchaseCompletSuccessfullyAction: {
                isShowPayWall = false
            }
        }
    }
}
