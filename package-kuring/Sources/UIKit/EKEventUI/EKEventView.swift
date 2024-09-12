import UIKit
import EventKit
import EventKitUI
import SwiftUI

struct EKEventView: UIViewControllerRepresentable {
    
    @Environment(\.dismiss) var dismiss
    
    let eventStore: EKEventStore
    let event: EKEvent
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let eventEditViewController = EKEventEditViewController()
        eventEditViewController.editViewDelegate = context.coordinator
        eventEditViewController.eventStore = eventStore
        eventEditViewController.event = event
        
        return eventEditViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, EKEventEditViewDelegate {
        let parent: EKEventView
        
        init(_ parent: EKEventView) {
            self.parent = parent
        }
        
        func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
            parent.dismiss()
        }
    }
    
}
