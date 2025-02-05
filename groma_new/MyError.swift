enum MyError: Error {
    case invalidState(String)
    case save
}

extension MyError {
    func toErrorMessage() -> String {
        switch self {
        case .save: return "Couldn't save state"
        case .invalidState(let message): return "Unknown error: \(message)"
        }
    }
}

struct MyErrorData {
    let error: MyError
    let retry: (() throws -> Void)?
}
