//
//  groma_newApp.swift
//  groma_new
//
//  Created by Ivan Schuetz on 07.01.25.
//

import SwiftUI
import SwiftData

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
        checkAndPopulateData(modelContext: sharedModelContainer.mainContext)
    }
    
    var body: some Scene {
        WindowGroup {
            TabView {
                Tab("Todo", systemImage: "tray.and.arrow.down.fill") {
                    TodoView(sharedModelContainer: sharedModelContainer)
                }
                Tab("Stats", systemImage: "tray.and.arrow.up.fill") {
                    StatsView(modelContext: sharedModelContainer.mainContext)
                }
                Tab("History", systemImage: "tray.and.arrow.up.fill") {
                    HistoryView()
                }
                Tab("More", systemImage: "tray.and.arrow.up.fill") {
                    MoreView()
                }
            }
            .accentColor(Color(red: 101 / 255, green: 67 / 255, blue: 33 / 255))
        }
        .modelContainer(sharedModelContainer)
    }
}
