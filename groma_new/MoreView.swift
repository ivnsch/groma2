//
//  ContentView.swift
//  groma_new
//
//  Created by Ivan Schuetz on 07.01.25.
//

import SwiftUI
import SwiftData

struct MoreView: View {
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    NavigationLink {
                        AboutView()
                    } label: {
                        Text("About")
                    }
                    NavigationLink {
                        FeedbackView()
                    } label: {
                        Text("Feedback")
                    }
                }
                .scrollContentBackground(.hidden)
            }
#if os(macOS)
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
#endif
            .toolbar {
            }
            .navigationTitle("More")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.yellow.opacity(0.6).ignoresSafeArea())
        }
    }
}
