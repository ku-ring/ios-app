//
//  CampusViewController.swift
//  Kuring
//
//  Created by Jaesung Lee on 2022/05/06.
//

import SwiftUI
import Combine


class CampusViewController: UIHostingController<CampusHomeView> {

    required init?(coder: NSCoder) {
        super.init(coder: coder,rootView: CampusHomeView())
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
