//
//  Bundle+.swift
//  DesignSystem
//
//  Created by 🏝️ GeonWoo Lee on 2023/08/09.
//  Copyright © 2023 Team.Kuring. All rights reserved.
//

import Foundation

private class CurrentBundleFinder { }

extension Foundation.Bundle {
    static var commonModule: Bundle = {
        let bundleName = "KuringCommons_KuringCommons"
        let candidates = [
            /* Bundle should be present here when the package is linked into an App. */
            Bundle.main.resourceURL,
            /* Bundle should be present here when the package is linked into a framework. */
            Bundle(for: CurrentBundleFinder.self).resourceURL,
            /* For command-line tools. */
            Bundle.main.bundleURL,
            /* Bundle should be present here when running previews from a different package (this is the path to "…/Debug-iphonesimulator/"). */
            Bundle(for: CurrentBundleFinder.self).resourceURL?.deletingLastPathComponent().deletingLastPathComponent(),
        ]
        for candidate in candidates {
            let bundlePath = candidate?.appendingPathComponent(bundleName + ".bundle")
            if let bundle = bundlePath.flatMap(Bundle.init(url:)) {
                return bundle
            }
        }
        fatalError("unable to find bundle named \(bundleName)")
    }()
}

