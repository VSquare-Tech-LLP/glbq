//
//  glbqApp.swift
//  glbq
//
//  Created by Purvi Sancheti on 11/10/25.
//

import SwiftUI
import Firebase
import GoogleMobileAds

@main
struct glbqApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    let persistenceController = PersistenceController.shared
 
    @StateObject private var purchaseManager = PurchaseManager()
    @StateObject var remoteConfigManager = RemoteConfigManager()
    @StateObject private var userSettings = UserSettings()
    @StateObject private var timerManager = TimerManager()
    @StateObject var appOpenAdManager = AppOpenAdManager()
    
    init() {
          FirebaseApp.configure()
          MobileAds.shared.start(completionHandler: nil)
      }
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    if !purchaseManager.hasPro {
                        appOpenAdManager.loadAd()
                    }
                }
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(timerManager)
                .environmentObject(purchaseManager)
                .environmentObject(remoteConfigManager)
                .environmentObject(userSettings)
                .environmentObject(appOpenAdManager)
        }
    }
}
