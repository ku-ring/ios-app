//
//  EKEventView.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 8/15/25.
//

import UIKit
import Caches
import SwiftUI
import EventKit
import EventKitUI
import Dependencies

public struct EKEventView: UIViewControllerRepresentable {

    @Environment(\.dismiss) var dismiss

    @Dependency(\.noticeEKEventStore) var noticeEKEventStore

    public init() { }

    public func makeUIViewController(context: Context) -> some UIViewController {
        let eventEditViewController = EKEventEditViewController()
        let getEvent = noticeEKEventStore.getEvent()
        
        if let ekEvent = getEvent.event {
            eventEditViewController.eventStore = getEvent.store
            eventEditViewController.event = getEvent.event
        }
        eventEditViewController.editViewDelegate = context.coordinator
        
        return eventEditViewController
    }

    public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}

    public func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    public class Coordinator: NSObject, EKEventEditViewDelegate {
        let parent: EKEventView

        init(_ parent: EKEventView) {
            self.parent = parent
        }

        public func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
            parent.dismiss()
        }
    }
}
