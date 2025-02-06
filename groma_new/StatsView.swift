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
                if viewModel.sections().isEmpty {
                    EmptyView(message: "No stats yet.\nBuy some items to see stats!")
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
#if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
#endif
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
    
    let max: Float
    
    @State private var progress: Float = 0

    init(sections: [BoughtItemsByTagSection]) {
        self.sections = sections
        max = sections.map(\.header.totalPrice).max() ?? 0
    }

    var body: some View {
        Chart(sections) { section in
            BarMark(x: .value("Price", section.header.totalPrice * progress),
                    y: .value("Category", section.header.name))
            .foregroundStyle(Theme.accentSec)
            .position(by: .value("Alignment", 0))

        }
        .chartLegend(.hidden)
        .chartXAxis(.hidden)
        .chartXScale(domain: .automatic(dataType: Float.self, modifyInferredDomain: { $0 = [0, max] }))
        .chartYAxis {
            AxisMarks { _ in
                AxisValueLabel()
                    .foregroundStyle(Color.black)
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .onAppear {
            animateChart()
        }
    }
    
    private func animateChart() {
      progress = 0
      withAnimation(.easeOut(duration: 1.0)) {
          progress = 1
      }
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
    }
}
