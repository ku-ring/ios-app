import Foundation

/// - SeeAlso:  https://developer.apple.com/documentation/swift/asyncstream
class StockMonitor<Item> {
    var stockHandler: (([Item]) -> Void)?
    var errorHandler: ((Error) -> Void)?
    
    func startMonitoring() {
        
    }
    
    func stopMonitoring() {
        
    }
}

import Models

extension StockMonitor {
    /// ```swift
    /// enum CancelID { case noticeStocks }
    ///
    /// case .startMonitoring
    ///     return .run { send in
    ///         for try await notices in StockMonitor.noticeStocks {
    ///             await send(.fetchNotices(notices)
    ///         }
    ///     }
    ///     .cancellable(CancelID.noticeStocks)
    ///
    /// case .fetchNotices(let notices):
    ///     state.notices.append(contentsOf: notices)
    ///     return .none
    ///
    /// case .stopMonitoring
    ///     return .cancel(id: CancelID.noticeStocks)
    /// ```
    static var noticeStock: AsyncThrowingStream<[Notice], Error> {
        AsyncThrowingStream { continuation in
            let monitor = StockMonitor<Notice>()
            monitor.stockHandler = { notices in
                continuation.yield(notices)
            }
            monitor.errorHandler = { error in
                continuation.finish(throwing: error)
            }
            continuation.onTermination = { @Sendable _ in
                monitor.stopMonitoring()
            }
            monitor.startMonitoring()
        }
    }
}

/**
 ```swift
 struct State {
    let provider: NoticeProvider
    var notices: [Notice]
 
    init(provider: NoticeProvider, notices: [Notice] = []) {
        self.provider = provider
        self.notices = notices
    }
 }
 
 enum Action {
    case startStock
    case stopStock
    case fetchNotices
 }
 
 enum CancelID {
    case stock
 }
 
 @Dependency(\.noticesStock) var stock
 
 var body: some ReducerOf<Self> {
    Reduce { state, action in
        switch action {
        case .startStock:
            return .run { send in
                for try await (notices, providerID) in stock {
                    guard state.provider.id == providerID else { return }
                    await send(.fetchNotices(notices))
                }
            }
            .cancellable(CancelID.stock)
 
        case let .fetchNotices(notices):
            state.notices = notices
 
        case .stopStock:
            return .cancel(id: CancelID.stock)
        }
    }
 }
 ```
 */
