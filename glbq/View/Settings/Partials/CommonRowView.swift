//
//  CommonRowView.swift
//  EveCraft
//
//  Created by Purvi Sancheti on 28/08/25.
//

import Foundation
import Foundation
import SwiftUI

struct CommonRowView: View {
    // MARK: - PROPERTIES
    @State var rowText: String
    @State var rowImage: String

    var body: some View {
        HStack(spacing: ScaleUtility.scaledSpacing(10)) {

                Image(rowImage)
                .resizable()
                .frame(width: isIPad ? 32 * ipadWidthRatio : 22,  height: isIPad ? 32 * ipadHeightRatio : 22)
            

               Text(rowText)
                  .font(FontManager.generalSansRegularFont(size: .scaledFontSize(14)))
                  .foregroundColor(Color.appBlack)
          
            Spacer()
        }
       
    
    }
}
