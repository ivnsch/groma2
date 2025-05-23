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
    
    @State private var showingConfirmDelete = false
#if os(iOS)
    @State private var editMode: EditMode = EditMode.inactive
#endif
    @Query(sort: [SortDescriptor(\BoughtItem.boughtDate, order: .reverse)])
    private var allItems: [BoughtItem]

    let dateFormatter: DateFormatter
    
    @State var errorData: MyErrorData?

    init() {
        dateFormatter = DateFormatter()
        // year seems overkill - user unlikely to scroll back that much
        dateFormatter.dateFormat = "EEEE, dd MMM HH:mm"
//        dateFormatter.dateFormat = "EEEE, dd MMM yyyy HH:mm"
        dateFormatter.locale = Locale.current // Uses the device's locale
        dateFormatter.timeZone = TimeZone.current
    }
    var sections: [HistorySection] {
      toSections(items: allItems)
    }
       
    var body: some View {
        NavigationStack {
            VStack {
#if os(iOS)
                if $editMode.wrappedValue == .active {
                   Text("Editing Mode Activated")
                       .padding()
                       .background(Theme.mainBg)
                       .cornerRadius(8)
               }
#endif
                if sections.isEmpty {
                   EmptyView(message: "No items bought yet.")
               }
               List {
                    ForEach(sections) { section in
                        Section(header: HStack {
                            ListHeaderView(section: section, dateFormatter: dateFormatter)
                        }) {
                            ForEach(section.boughtItems) { boughtItem in
                                ListItemView(boughtItem: boughtItem)
                            }
                            .onDelete { indexSet in
                                let f = {
                                    try deleteItem(section: section, at: indexSet)
                                }
                                do {
                                    try f()
                                } catch {
                                    self.errorData = MyErrorData(error: .save, retry: f)
                                }
                            }
                        }
                    }
                    .onDelete(perform: { _ in  })
                    .onMove(perform: { _, _ in  })
                }
            }
            .scrollContentBackground(.hidden)
            .navigationTitle("History")
            .errorAlert(error: $errorData)
#if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
#endif
            .background(Theme.mainBg.ignoresSafeArea())
            .toolbar {
                Button("Clear") {
                    showingConfirmDelete = true
                }
            }
            .confirmationDialog("Delete all history?", isPresented: $showingConfirmDelete) {
                Button("Yes, delete") {
                    let f = {
                        try deleteAllItems()
                    }
                    do {
                        try f()
                    } catch {
                        self.errorData = MyErrorData(error: .save, retry: f)
                    }
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("This will delete all your history and stats")
            }
        }
#if os(iOS)
        .environment(\.editMode, $editMode)
#endif
    }
    
    private func deleteAllItems() throws {
        for item in allItems {
            modelContext.delete(item)
        }
        try modelContext.save()
    }
    
    private func deleteItem(section: HistorySection, at offsets: IndexSet) throws {
        for index in offsets {
            let boughtItem = section.boughtItems[index]
            modelContext.delete(boughtItem)
        }
        try modelContext.save()
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

private struct ListItemView: View {
    let boughtItem: BoughtItem
    let formattedPrice: String;
    
    init(boughtItem: BoughtItem) {
        self.boughtItem = boughtItem
        
        self.formattedPrice = {
            if let localCurrency = Locale.current.currency {
                boughtItem.price.formatted(.currency(code: localCurrency.identifier))
            } else {
                boughtItem.price.description
            }
        }()
    }
    
    var body: some View {
        HStack {
            Text(boughtItem.name ?? "")
            Text(boughtItem.quantity.description)
                .foregroundColor(Color.gray)
                .fontWeight(.light)
                .font(.system(size: 10))
                .foregroundColor(Color.black)
            Spacer()
            VStack {
                Text(formattedPrice)
            }
        }
    }
}

private struct ListHeaderView: View {
    let section: HistorySection
    let dateFormatter: DateFormatter
   
    init(section: HistorySection, dateFormatter: DateFormatter) {
        self.section = section
        self.dateFormatter = dateFormatter
    }
    
    var body: some View {
        HStack {
            Text(dateFormatter.string(from: section.date))
            Spacer()
        }
    }
}

