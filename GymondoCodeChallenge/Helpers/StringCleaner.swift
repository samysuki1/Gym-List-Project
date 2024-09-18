import Foundation

extension String {

    func removeHTML() -> String {
       return self.replacingOccurrences(of: "<[^>]+>", with: "", options: String.CompareOptions.regularExpression, range: nil)
    }

    func removeLine() -> String {
       return self.replacingOccurrences(of: "\n", with: " ", options: String.CompareOptions.regularExpression, range: nil)
    }
}
