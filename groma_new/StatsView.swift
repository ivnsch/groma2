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
        List {
            ForEach(viewModel.monthlyExpenses) { item in
                HStack {
                    Text(item.month.description)
                    Spacer()
                    Text(item.spent)
                }
            }
        }
    }
    
    init(modelContext: ModelContext) {
        let viewModel = ViewModel(modelContext: modelContext)
        _viewModel = State(initialValue: viewModel)
    }
}

