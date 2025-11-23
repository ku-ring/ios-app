//
//  View.onChangedDebounce.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 10/22/25.
//

import SwiftUI

struct DebouncedAsyncChangeModifier<Value: Equatable>: ViewModifier {
    let target: Value
    let delay: TimeInterval
    let action: (Value) async -> Void

    @State private var task: Task<Void, Never>?

    func body(content: Content) -> some View {
        content
            .onChange(of: target) { newValue in
                task?.cancel()
                task = Task { @MainActor in
                    try? await Task.sleep(for: .seconds(delay))
                    if Task.isCancelled { return }
                    await action(newValue)
                }
            }
            .onDisappear {
                task?.cancel()
            }
    }
}

extension View {
    public func onChangeDebounced<Value: Equatable>(
        of value: Value,
        delay: TimeInterval = 0.5,
        perform action: @escaping (Value) async -> Void
    ) -> some View {
        modifier(DebouncedAsyncChangeModifier(target: value, delay: delay, action: action))
    }
}
