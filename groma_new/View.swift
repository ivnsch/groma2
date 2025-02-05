import SwiftUI

extension Binding where Value == Bool {
    init<T>(value: Binding<T?>) {
        self.init {
            value.wrappedValue != nil
        } set: { newValue in
            if !newValue {
                value.wrappedValue = nil
            }}
    }
}

    
extension View {
    func errorAlert(error errorData: Binding<MyErrorData?>) -> some View {
        let message = errorData.wrappedValue?.error.toErrorMessage() ?? "Unknown error"
        
        return alert("Error", isPresented: Binding(value: errorData), actions: {
            Button("Cancel") {
                errorData.wrappedValue = nil
            }
            Button("Retry") {
                let ed = errorData.wrappedValue
                do {
                    errorData.wrappedValue = nil
                    try ed?.retry?()
                } catch {
                    // this is a bit weird logic and might rewrite in the future
                    // it just reassigns the original error to current error if there's an error
                    // not clean because current error could be different
                    // but less complicated, because we'd need to write new logic to handle possible new errors
                    // returning different errors in a row is relatively unlikely and
                    // the handling "retry" anyway is the same, so doesn't seem worth it to do needed changes for accurate solution
                    // Note: we need a delay here since otherwise the alert doesn't show up again
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        errorData.wrappedValue = ed
                    }
                }
            }
        }, message: {Text(message)})
    }
}
