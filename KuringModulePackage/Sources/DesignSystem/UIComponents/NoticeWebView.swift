//
//  ShareSheet.swift
//  Kuring
//
//  Created by Hamlit Jason on 2022/05/21.
//

import UIKit
import SwiftUI
import CoreServices
import LinkPresentation

public extension View {
    /**
     관련`ActivityItem`이 존재할 때, 해당하는 activity sheet를 보여줍니다.
     
     - Parameters:
       - item: activity에 사용할 아이템입니다.
       - onComplete: sheet가 dimiss되었을 때, 결과과 호출됩니다.
     */
    func activitySheet(_ item: Binding<ActivityItem?>, permittedArrowDirections: UIPopoverArrowDirection = .any, onComplete: UIActivityViewController.CompletionWithItemsHandler? = nil) -> some View {
        background(ActivityView(item: item, permittedArrowDirections: permittedArrowDirections, onComplete: onComplete))
    }
}

// MARK: - ActivityView

struct ActivityView: UIViewControllerRepresentable {

    @Binding var item: ActivityItem?
    var permittedArrowDirections: UIPopoverArrowDirection
    var completion: UIActivityViewController.CompletionWithItemsHandler?

    init(
        item: Binding<ActivityItem?>,
        permittedArrowDirections: UIPopoverArrowDirection,
        onComplete: UIActivityViewController.CompletionWithItemsHandler? = nil
    ) {
        _item = item
        self.permittedArrowDirections = permittedArrowDirections
        self.completion = onComplete
    }

    func makeUIViewController(context: Context) -> ActivityViewControllerWrapper {
        ActivityViewControllerWrapper(
            item: $item,
            permittedArrowDirections: permittedArrowDirections,
            completion: completion
        )
    }

    func updateUIViewController(_ controller: ActivityViewControllerWrapper, context: Context) {
        controller.item = $item
        controller.completion = completion
        controller.updateState()
    }

}

// MARK: - ActivityViewControllerWrapper

final class ActivityViewControllerWrapper: UIViewController {

    var item: Binding<ActivityItem?>
    var permittedArrowDirections: UIPopoverArrowDirection
    var completion: UIActivityViewController.CompletionWithItemsHandler?

    init(
        item: Binding<ActivityItem?>,
        permittedArrowDirections: UIPopoverArrowDirection,
        completion: UIActivityViewController.CompletionWithItemsHandler?)
    {
        self.item = item
        self.permittedArrowDirections = permittedArrowDirections
        self.completion = completion
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        updateState()
    }

    func updateState() {
        let isActivityPresented = presentedViewController != nil

        if item.wrappedValue != nil {
            if !isActivityPresented {
                let controller = UIActivityViewController(
                    activityItems: item.wrappedValue?.items ?? [],
                    applicationActivities: item.wrappedValue?.activities
                )
                
                controller.excludedActivityTypes = item.wrappedValue?.excludedTypes
                controller.popoverPresentationController?.permittedArrowDirections = permittedArrowDirections
                controller.popoverPresentationController?.sourceView = view
                
                controller.completionWithItemsHandler = { [weak self] (activityType, success, items, error) in
                    self?.item.wrappedValue = nil
                    self?.completion?(activityType, success, items, error)
                }
                
                present(controller, animated: true, completion: nil)
            }
        }
    }

}

// MARK: - ActivityItem

/// `activitySheet` modifier 를 통해 `ActivityView`를 띄울 때 사용하는 activity
public struct ActivityItem {
    var items: [Any]
    var activities: [UIActivity]
    var excludedTypes: [UIActivity.ActivityType]
    
    /// - Parameters:
    ///   - items: `UIActivityViewController` 를 통해 공유할 아이템
    ///   - activities: 시트에 포함시키고자 하는 커스텀 `UIActivity`
    public init(
        items: Any...,
        activities: [UIActivity] = [],
        excludedTypes: [UIActivity.ActivityType] = []
    ) {
        self.items = items
        self.activities = activities
        self.excludedTypes = excludedTypes
    }
}
