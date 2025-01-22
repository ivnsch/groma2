//
//  groma_newApp.swift
//  groma_new
//
//  Created by Ivan Schuetz on 07.01.25.
//

import SwiftUI
import SwiftData
import CoreData

@main
struct groma_newApp: App {
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

    init() {
        setupNotificationObserver()
    }

    mutating func setupNotificationObserver() {
        NotificationCenter.default.addObserver(
            forName: NSPersistentCloudKitContainer.eventChangedNotification,
            object: nil,
            queue: OperationQueue.main) { [self] notification in
                Task { @MainActor in
                    checkAndPopulateData(modelContext: sharedModelContainer.mainContext)
                }
            }
    }

    var body: some Scene {
        WindowGroup {
            TabView {
                TodoView(sharedModelContainer: sharedModelContainer)
                    .tabItem {
                        Label("Todo", systemImage: "tray.and.arrow.down.fill")
                    }
                StatsView(modelContext: sharedModelContainer.mainContext)
                    .tabItem {
                        Label("Stats", systemImage: "tray.and.arrow.up.fill")
                    }
                HistoryView()
                    .tabItem {
                        Label("History", systemImage: "tray.and.arrow.up.fill")
                    }
                MoreView()
                    .tabItem {
                        Label("More", systemImage: "tray.and.arrow.up.fill")
                    }
            }
            .accentColor(Theme.tabAccent)
            .preferredColorScheme(.light)

        }
        
        .modelContainer(sharedModelContainer)
    }
}
