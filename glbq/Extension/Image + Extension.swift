//
//  Image + Extension.swift
//  NeoLed
//
//  Created by Purvi Sancheti on 24/09/25.
//

import Foundation
import SwiftUI
import UIKit


extension Image
{
    func resizeImage() -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
    
    func resizable(size: CGSize) -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: size.width, height: size.height)
    }
}


