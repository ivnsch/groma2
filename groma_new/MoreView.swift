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
                        Text("Community")
                    }
//                    NavigationLink {
//                        ToolsView()
//                    } label: {
//                        Text("Tools")
//                    }
                }
                .scrollContentBackground(.hidden)
            }
#if os(macOS)
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
#endif
            .toolbar {
            }
            .navigationTitle("More")
#if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
#endif
            .background(Theme.mainBg.ignoresSafeArea())
        }
    }
}
