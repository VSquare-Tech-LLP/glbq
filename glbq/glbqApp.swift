//
//  glbqApp.swift
//  glbq
//
//  Created by Purvi Sancheti on 11/10/25.
//

import SwiftUI

@main
struct glbqApp: App {
    @StateObject private var userSettings = UserSettings()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userSettings)
        }
    }
}
