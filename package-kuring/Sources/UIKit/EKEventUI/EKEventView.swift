import UIKit
import EventKit
import EventKitUI
import SwiftUI

public struct EKEventView: UIViewControllerRepresentable {
    
    @Environment(\.dismiss) var dismiss
    
    public let eventStore: EKEventStore
    public let event: EKEvent
    
    public init(
        eventStore: EKEventStore,
        event: EKEvent
    ) {
        self.eventStore = eventStore
        self.event = event
    }
    
    public func makeUIViewController(context: Context) -> some UIViewController {
        let eventEditViewController = EKEventEditViewController()
        eventEditViewController.editViewDelegate = context.coordinator
        eventEditViewController.eventStore = eventStore
        eventEditViewController.event = event
        
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
