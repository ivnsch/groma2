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
            Item.self, CartItem.self
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
            TabView {
                Tab("Todo", systemImage: "tray.and.arrow.down.fill") {
                    TodoView()
                }
                Tab("Cart", systemImage: "tray.and.arrow.up.fill") {
                    CartView()
                }
                Tab("Stats", systemImage: "tray.and.arrow.up.fill") {
                    StatsView()
                }
            }
        }
        .modelContainer(sharedModelContainer)
    }
}
