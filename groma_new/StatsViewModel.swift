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
        var itemAggregates = [BoughtItemAggregate]()

        init(modelContext: ModelContext) {
            self.modelContext = modelContext
            fetchData()
        }

        func fetchData() {
            do {
                let descriptor = FetchDescriptor<BoughtItem>(sortBy: [SortDescriptor(\.name)])
                let items = try modelContext.fetch(descriptor)
                
                monthlyExpenses = toMonthlyExpenses(items: items)
                itemAggregates = toAllTimeExpensesByItem(items: items)
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

func toAllTimeExpensesByItem(items: [BoughtItem]) -> [BoughtItemAggregate] {
    var aggregates = [BoughtItemAggregate]()

    let groupedItems = Dictionary(grouping: items) { item in
        item.name ?? ""
    };
    
    for (name, items) in groupedItems {
        let totalPrice = items.map(\.price).reduce(0, +);
        let totalQuantity = items.map(\.quantity).reduce(0, +);
        aggregates.append(BoughtItemAggregate(totalQuantity: totalQuantity, totalPrice: totalPrice, name: name))
    }
    
    aggregates.sort(by: { $0.totalPrice > $1.totalPrice })
    return aggregates
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

@Model
class BoughtItemAggregate {
    var totalQuantity: Int
    var totalPrice: Float
    var name: String
    
    init(totalQuantity: Int, totalPrice: Float, name: String) {
        self.totalQuantity = totalQuantity
        self.totalPrice = totalPrice
        self.name = name
    }
}

func groupItemsByMonth(items: [BoughtItem]) -> [Int: [BoughtItem]] {
    let calendar = Calendar.current
    return Dictionary(grouping: items) { item in
        // note that we assume months unique, i.e. we'll delete data older than a year (or less) TODO enforce
        calendar.component(.month, from: item.boughtDate ?? Date.distantPast)
    }
}

func groupItemsByName(items: [BoughtItem]) -> [String: [BoughtItem]] {
    return Dictionary(grouping: items) { item in
        item.name ?? ""
    }
}

