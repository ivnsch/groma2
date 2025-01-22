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
//            .foregroundStyle(by: .value("Type", section.header.name))
            .foregroundStyle(Theme.accentSec)
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
    let formattedPrice: String;

    init(tag: BoughtItemsTagAggregate) {
        self.tag = tag
        
        self.formattedPrice = {
            if let localCurrency = Locale.current.currency {
                tag.totalPrice.formatted(.currency(code: localCurrency.identifier))
            } else {
                tag.totalPrice.description
            }
        }()
    }
    
    var body: some View {
        HStack {
            Text(tag.name).bold().foregroundColor(Color.black)
            Text(tag.totalQuantity.description)
                .foregroundColor(Color.gray)
                .fontWeight(.light)
                .font(.system(size: 10))
                .foregroundColor(Color.black)
            Spacer()
            Text(formattedPrice).bold().foregroundColor(Color.black)
        }
    }
}

private struct ListItemView: View {
    let item: BoughtItem
    let formattedPrice: String;
    
    init(item: BoughtItem) {
        self.item = item
        
        self.formattedPrice = {
            if let localCurrency = Locale.current.currency {
                item.price.formatted(.currency(code: localCurrency.identifier))
            } else {
                item.price.description
            }
        }()
    }
    
    var body: some View {
        HStack {
            Text(item.name ?? "")
                .padding(.vertical, 0)
            Text(item.quantity.description)
                .foregroundColor(Color.gray)
                .fontWeight(.light)
                .font(.system(size: 13))
            Spacer()
            VStack {
                HStack {
                    Spacer() // Pushes text to the right
                    Text(formattedPrice)
                }
            }
        }
        .frame(height: 44)
    }
}
