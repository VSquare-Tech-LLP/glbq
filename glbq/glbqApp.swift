//
//  glbqApp.swift
//  glbq
//
//  Created by Purvi Sancheti on 11/10/25.
//

import SwiftUI
import Firebase

@main
struct glbqApp: App {
    let persistenceController = PersistenceController.shared
 
    @StateObject private var purchaseManager = PurchaseManager()
    @StateObject var remoteConfigManager = RemoteConfigManager()
    @StateObject private var userSettings = UserSettings()
    @StateObject private var timerManager = TimerManager()
    
    init() {
          FirebaseApp.configure()
//          MobileAds.shared.start(completionHandler: nil)
      }
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(timerManager)
                .environmentObject(purchaseManager)
                .environmentObject(remoteConfigManager)
                .environmentObject(userSettings)
        }
    }
}
