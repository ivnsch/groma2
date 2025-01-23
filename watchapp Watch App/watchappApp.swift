//
//  watchappApp.swift
//  watchapp Watch App
//
//  Created by Ivan Schuetz on 22.01.25.
//

import SwiftUI
import SwiftData

@main
struct watchapp_Watch_AppApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            TodoItem.self, CartItem.self, BoughtItem.self, PredefItem.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
