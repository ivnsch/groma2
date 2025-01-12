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
    
    @State private var viewModel: ViewModel

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.sections) { item in
                    Section(header: HStack {
                        Text(item.date.description)
                        Spacer()
                    }) {
                        ForEach(item.boughtItems) { boughtItem in
                            HStack {
                                Text(boughtItem.name ?? "")
                                Spacer()
                                VStack {
                                    Text(boughtItem.quantity.description)
                                    Text(boughtItem.price.description)
                                }
                            }
                        }
                        .onDelete(perform: deleteItems)
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
    
    init(modelContext: ModelContext) {
        let viewModel = ViewModel(modelContext: modelContext)
        _viewModel = State(initialValue: viewModel)
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
//                modelContext.delete(items[index])
            }
            do {
                try modelContext.save()
            } catch {
                print("error saving: \(error)")
            }
        }
    }
}

