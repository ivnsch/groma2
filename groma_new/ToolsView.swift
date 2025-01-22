import SwiftUI
import SwiftData

struct ToolsView: View {
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationStack {
            VStack {
                Button("Clear all data") {
                    clearAllDataLogError()
                }
            }
#if os(macOS)
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
#endif
            .toolbar {
            }
            .navigationTitle("Feedback")
#if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
#endif
            .background(Theme.mainBg.ignoresSafeArea())
        }
    }
    
    private func clearAllDataLogError() {
        do {
            try clearAllData()
        } catch {
            print("error clearing all data: " + error.localizedDescription)
        }
    }
    
    private func clearAllData() throws {
        let predefDescriptor = FetchDescriptor<PredefItem>()
        let predefItems = try modelContext.fetch(predefDescriptor)
        for item in predefItems {
            modelContext.delete(item)
        }
        
        let todoDescriptor = FetchDescriptor<TodoItem>()
        let todoItems = try modelContext.fetch(todoDescriptor)
        for item in todoItems {
            modelContext.delete(item)
        }
        
        let cartDescriptor = FetchDescriptor<CartItem>()
        let cartItems = try modelContext.fetch(cartDescriptor)
        for item in cartItems {
            modelContext.delete(item)
        }
        
        let historyDescriptor = FetchDescriptor<BoughtItem>()
        let historyItems = try modelContext.fetch(historyDescriptor)
        for item in historyItems {
            modelContext.delete(item)
        }
        
        try modelContext.save()

    }


}

