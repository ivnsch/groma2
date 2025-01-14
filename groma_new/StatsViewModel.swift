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
        var itemAggregates = [BoughtItemsTagAggregate]()
        
        var sections = [BoughtItemsByTagSection]()

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
                
                sections = toAllTimeSectionsByTag(items: items)
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

func toAllTimeExpensesByItem(items: [BoughtItem]) -> [BoughtItemsTagAggregate] {
    var aggregates = [BoughtItemsTagAggregate]()

    let groupedItems = Dictionary(grouping: items) { item in
        item.name ?? ""
    };
    
    for (name, items) in groupedItems {
        let totalPrice = items.map(\.price).reduce(0, +);
        let totalQuantity = items.map(\.quantity).reduce(0, +);
        aggregates.append(BoughtItemsTagAggregate(totalQuantity: totalQuantity, totalPrice: totalPrice, name: name))
    }
    
    aggregates.sort(by: { $0.totalPrice > $1.totalPrice })
    return aggregates
}

func toAllTimeSectionsByTag(items: [BoughtItem]) -> [BoughtItemsByTagSection] {
    var sections = [BoughtItemsByTagSection]()

    var tagsWithItems = Dictionary<String, [BoughtItem]>();
    for item in items {
        let updatedItems = tagsWithItems[item.tag] ?? []
        tagsWithItems[item.tag] = updatedItems + [item]
    }

    for (tag, items) in tagsWithItems {
        let totalPrice = items.map(\.price).reduce(0, +);
        let totalQuantity = items.map(\.quantity).reduce(0, +);
        let aggregate = BoughtItemsTagAggregate(totalQuantity: totalQuantity, totalPrice: totalPrice, name: tag)
        sections.append(BoughtItemsByTagSection(header: aggregate, items: items))
    }
    
    sections.sort { $0.header.totalPrice > $1.header.totalPrice }
    return sections
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
class BoughtItemsByTagSection {
    var header: BoughtItemsTagAggregate
    var items: [BoughtItem]
    
    init(header: BoughtItemsTagAggregate, items: [BoughtItem]) {
        self.header = header
        self.items = items
    }
}

@Model
class BoughtItemsTagAggregate {
    var totalQuantity: Int
    var totalPrice: Float
    var name: String
    
    init(totalQuantity: Int, totalPrice: Float, name: String) {
        self.totalQuantity = totalQuantity
        self.totalPrice = totalPrice
        self.name = name
    }
}

@Model
class BoughtTagAggregate {
    var totalQuantity: Int
    var totalPrice: Float
    var name: String // tag name
    
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

