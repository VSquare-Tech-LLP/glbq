//
//  FontManager.swift
//  EveCraft
//
//  Created by Purvi Sancheti on 26/08/25.
//

import Foundation
import SwiftUI

struct FontManager {

    static var generalSansBoldFont = "GeneralSans-Bold"
    static var generalSansSemiboldFont = "GeneralSans-Semibold"
    static var generalSansMediumFont = "GeneralSans-Medium"
    static var generalSansRegularFont = "GeneralSans-Regular"
      
    static func generalSansBoldFont(size: CGFloat) -> Font {
        .custom(generalSansBoldFont, size: size)
    }
    static func generalSansSemiboldFont(size: CGFloat) -> Font {
        .custom(generalSansSemiboldFont, size: size)
    }
    static func generalSansMediumFont(size: CGFloat) -> Font {
        .custom(generalSansMediumFont, size: size)
    }
    static func generalSansRegularFont(size: CGFloat) -> Font {
        .custom(generalSansRegularFont, size: size)
    }
    
}
