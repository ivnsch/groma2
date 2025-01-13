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
    
    @Query(sort: [SortDescriptor(\BoughtItem.boughtDate, order: .reverse)])
    private var allItems: [BoughtItem]

    var sections: [HistorySection] {
      toSections(items: allItems)
    }
       
    var body: some View {
        NavigationStack {
            List {
                ForEach(sections) { section in
                    Section(header: HStack {
                        Text(section.date.description)
                        Spacer()
                    }) {
                        ForEach(section.boughtItems) { boughtItem in
                            HStack {
                                Text(boughtItem.name ?? "")
                                Spacer()
                                VStack {
                                    Text(boughtItem.quantity.description)
                                    Text(boughtItem.price.description)
                                }
                            }
                        }
                        .onDelete { indexSet in
                            deleteItem(section: section, at: indexSet)
                        }
                    }
                }
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
    
    private func deleteItem(section: HistorySection, at offsets: IndexSet) {
        for index in offsets {
            let boughtItem = section.boughtItems[index]
            modelContext.delete(boughtItem)
        }
        do {
            try modelContext.save()
        } catch {
            print("error saving: \(error)")
        }
    }
    
//    private func deleteItem(in sectionIndex: Int, at offsets: IndexSet) {
//        withAnimation {
//            let section = sections[sectionIndex]
//            print("will delete: " + sectionIndex.description + ", offsets: " + offsets.description)
//            for index in offsets {
//                let boughtItem = section.boughtItems[index]
//                modelContext.delete(boughtItem)
//                
//            }
//
//            do {
//                try modelContext.save()
//            } catch {
//                print("error saving: \(error)")
//            }
//        }
//    }
}


func toSections(items: [BoughtItem]) -> [HistorySection] {
    var sections = [HistorySection]()

    let groupedItems = groupItemsByDate(items: items)
    for (date, items) in groupedItems {
        sections.append(HistorySection(date: date, boughtItems: items))
    }
    
    sections.sort { $0.date > $1.date }
    return sections
}


@Model
class HistorySection {
    var date: Date
    var boughtItems: [BoughtItem]
    
    init (date: Date, boughtItems: [BoughtItem]) {
        self.date = date
        self.boughtItems = boughtItems
    }
}


func groupItemsByDate(items: [BoughtItem]) -> [Date: [BoughtItem]] {
    return Dictionary(grouping: items) { item in
        item.boughtDate ?? Date.distantPast
    }
}

