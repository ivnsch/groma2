//
//  ContentView.swift
//  groma_new
//
//  Created by Ivan Schuetz on 07.01.25.
//

import SwiftUI
import SwiftData

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
            List {
                ForEach(viewModel.itemAggregates) { item in
                    HStack {
                        Text(item.name)
                        Spacer()
                        VStack {
                            Text(item.totalPrice.description)
                            Text(item.totalQuantity.description)
                        }
                    }
                }
            }
            .navigationTitle("Stats")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    init(modelContext: ModelContext) {
        let viewModel = ViewModel(modelContext: modelContext)
        _viewModel = State(initialValue: viewModel)
    }
}

