//
//  glbqApp.swift
//  glbq
//
//  Created by Purvi Sancheti on 11/10/25.
//

import SwiftUI

@main
struct glbqApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject private var userSettings = UserSettings()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(userSettings)
        }
    }
}
