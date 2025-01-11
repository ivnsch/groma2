//
//  ContentView.swift
//  groma_new
//
//  Created by Ivan Schuetz on 07.01.25.
//

import SwiftUI
import SwiftData

struct HistoryView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query private var items: [BoughtItem]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(items) { item in
                    HStack {
                        Text(item.name ?? "unnamed")
                        Spacer()
                        VStack {
                            Text(item.quantity.description)
                            Text(item.price.description)
                        }
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .scrollContentBackground(.hidden)
            .navigationTitle("History")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.yellow.opacity(0.6).ignoresSafeArea())
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
#endif
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
            do {
                try modelContext.save()
            } catch {
                print("error saving: \(error)")
            }
        }
    }
}

#Preview {
    HistoryView()
        .modelContainer(for: Item.self, inMemory: true)
}
