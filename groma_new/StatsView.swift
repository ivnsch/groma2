//
//  ContentView.swift
//  groma_new
//
//  Created by Ivan Schuetz on 07.01.25.
//

import SwiftUI
import SwiftData
import Charts

struct ChartData: Identifiable, Equatable {
    let type: String
    let count: Int

    var id: String { return type }
}

struct StatsView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State private var viewModel: ViewModel
    
    var body: some View {
        NavigationStack {
//            List {
//                ForEach(viewModel.monthlyExpenses) { item in
//                    HStack {
//                        Text(item.month.description)
//                        Spacer()
//                        Text(item.spent)
//                    }
//                }
//            }
//            List {
//                ForEach(viewModel.itemAggregates) { item in
//                    HStack {
//                        Text(item.name)
//                        Spacer()
//                        VStack {
//                            Text(item.totalPrice.description)
//                            Text(item.totalQuantity.description)
//                        }
//                    }
//                }
//            }
      
            VStack {
                Picker("Select month", selection: $viewModel.selectedMonth) {
                    ForEach(viewModel.monthsForPicker, id: \.self) { month in
                        Text(toMonthName(month)).tag(month)
                    }
                }
                List {
                    ChartView(sections: viewModel.sections())
                        .listRowBackground(Theme.mainBg.ignoresSafeArea())

                    ForEach(viewModel.sections()) { section in
                        Section(header: HStack {
                            ListHeaderView(tag: section.header)
//                            ListHeaderView(section: section)
                        }) {
                            ForEach(section.items) { item in
                                ListItemView(item: item)
                            }
                        }
                        
//                        ListItemView(tag: section.header)
                    }
                }
            }
          
            .scrollContentBackground(.hidden)
            .navigationTitle("Stats")
            .navigationBarTitleDisplayMode(.inline)
            .background(Theme.mainBg.ignoresSafeArea())
            .onAppear() {
                self.viewModel.fetchData()
            }
        }
    }
    
    init(modelContext: ModelContext) {
        let viewModel = ViewModel(modelContext: modelContext)
        _viewModel = State(initialValue: viewModel)
    }
}

private struct ChartView: View {
    let sections: [BoughtItemsByTagSection]
    
    var body: some View {
        Chart(sections) { section in
            BarMark(x: .value("Price", section.header.totalPrice),
                    y: .value("Category", section.header.name))
            .foregroundStyle(by: .value("Type", section.header.name))
//            .annotation(position: .trailing) {
//                Text(String(section.header.totalPrice.description))
//                    .foregroundColor(Theme.secButtonBg)
//            }
        }
        .chartLegend(.hidden)
        .chartXAxis(.hidden)
        .chartYAxis {
            AxisMarks { _ in
                AxisValueLabel()
                    .foregroundStyle(Color.black)
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}


private struct ListHeaderView: View {
    let tag: BoughtItemsTagAggregate
    
    var body: some View {
        HStack {
            Text(tag.name)
            Spacer()
            VStack {
                Text(tag.totalPrice.description)
                Text(tag.totalQuantity.description)
            }
        }
    }
}

private struct ListItemView: View {
    let item: BoughtItem
    
    var body: some View {
        HStack {
            Text(item.name ?? "")
            Spacer()
            VStack {
                Text(item.quantity.description)
                Text(item.price.description)
            }
        }
    }
}
