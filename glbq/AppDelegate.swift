//
//  AppDelegate.swift
//  EveCraft
//
//  Created by Purvi Sancheti on 01/09/25.
//

import Foundation
import UIKit
import IQKeyboardManagerSwift
import GoogleMobileAds

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        
        // MARK: - Notification Center Delegate Setup
        UNUserNotificationCenter.current().delegate = self
        MobileAds.shared.start()
        // MARK: - Keyboard Setup
        IQKeyboardManager.shared.isEnabled = false
        IQKeyboardManager.shared.enableAutoToolbar = true // enables "Done" button
        IQKeyboardManager.shared.resignOnTouchOutside = true // tap outside to dismiss
        IQKeyboardManager.shared.toolbarConfiguration.tintColor = UIColor.black
        
    

        return true
    }
    
}
