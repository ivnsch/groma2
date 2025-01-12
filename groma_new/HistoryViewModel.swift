import SwiftUI
import SwiftData

extension HistoryView {
    @Observable
    class ViewModel {
        var modelContext: ModelContext
        var sections = [HistorySection]()
        
        init(modelContext: ModelContext) {
            self.modelContext = modelContext
            fetchData()
        }

        func fetchData() {
            do {
                let descriptor = FetchDescriptor<BoughtItem>(sortBy: [SortDescriptor(\.name)])
                let items = try modelContext.fetch(descriptor)
                
                sections = toSections(items: items)
            } catch {
                print("Fetch failed")
            }
        }
    }
}

func toSections(items: [BoughtItem]) -> [HistorySection] {
    var sections = [HistorySection]()

    let groupedItems = groupItemsByDate(items: items)
    for (date, items) in groupedItems {
        sections.append(HistorySection(date: date, boughtItems: items))
    }
    
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


