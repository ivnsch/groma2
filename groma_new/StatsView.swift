//
//  ContentView.swift
//  groma_new
//
//  Created by Ivan Schuetz on 07.01.25.
//

import SwiftUI
import SwiftData

struct StatsView: View {
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        Text("TODO")
    }
}


#Preview {
    StatsView()
        .modelContainer(for: Item.self, inMemory: true)
}
