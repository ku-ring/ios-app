//
//  OnboardingViewController.swift
//  Kuring
//
//  Created by Jaesung Lee on 2022/02/24.
//

import UIKit
import SwiftUI
import Combine

class OnboardingViewController: UIViewController {
    private var cancellable: AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let delegate = OnboardingViewDelegate()
        let controller = UIHostingController(rootView: OnboardingView(delegate: delegate))
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        addChild(controller)
        view.addSubview(controller.view)
        NSLayoutConstraint.activate([
            controller.view.topAnchor.constraint(equalTo: view.topAnchor),
            controller.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            controller.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            controller.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        cancellable = delegate.$onDismiss.sink { [weak self] _ in
            guard let self = self else { return }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    deinit {
        cancellable = nil
    }
}
