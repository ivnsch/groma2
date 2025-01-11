//
//  StatsViewModel.swift
//  groma_new
//
//  Created by Ivan Schuetz on 10.01.25.
//
import SwiftUI
import SwiftData

extension StatsView {
    @Observable
    class ViewModel {
        var modelContext: ModelContext
        var monthlyExpenses = [MonthlyExpensesItem]()

        init(modelContext: ModelContext) {
            self.modelContext = modelContext
            fetchData()
        }

        func fetchData() {
            do {
                let descriptor = FetchDescriptor<BoughtItem>(sortBy: [SortDescriptor(\.name)])
                let items = try modelContext.fetch(descriptor)
                
                monthlyExpenses = toMonthlyExpenses(items: items)
            } catch {
                print("Fetch failed")
            }
        }
    }
}

func toMonthlyExpenses(items: [BoughtItem]) -> [MonthlyExpensesItem] {
    var monthlyExpenses = [MonthlyExpensesItem]()

    // group by month
    let groupedItems = groupItemsByMonth(items: items)
    for (month, items) in groupedItems {
        let totalPrice = items.map(\.price).reduce(0, +);
        monthlyExpenses.append(MonthlyExpensesItem(month: month, spent: totalPrice.description))
    }
    
    return monthlyExpenses
}


@Model
class MonthlyExpensesItem {
    var month: Int
    var spent: String
    
    init(month: Int, spent: String) {
        self.month = month
        self.spent = spent
    }
}

func groupItemsByMonth(items: [BoughtItem]) -> [Int: [BoughtItem]] {
    let calendar = Calendar.current
    return Dictionary(grouping: items) { item in
        // note that we assume months unique, i.e. we'll delete data older than a year (or less) TODO enforce
        calendar.component(.month, from: item.boughtDate ?? Date.distantPast)
    }
}
