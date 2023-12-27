import Foundation

public struct Feedback: Codable, Equatable {
    public var content: String
    
    public init(content: String) {
        self.content = content
    }
}
